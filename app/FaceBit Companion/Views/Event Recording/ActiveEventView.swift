//
//  ActiveEventView.swift
//  FaceBit Companion
//
//  Created by blaine on 2/1/21.
//

import SwiftUI

struct ActiveEventView: View {
    @Binding var activeEvent: Event?
    
    var body: some View {
        VStack(spacing: 16.0) {
            Text("Recording Event")
                .font(.largeTitle)
            if var event = activeEvent {
                Text("Start Date: \(event.startDate)")
                    .font(.body)
                Button(action: { endEvent(event: &event) }, label: {
                    Text("End Event")
                })
            }
        }
    }
    
    private func endEvent(event: inout Event) {
        do { try event.end() } catch {
            PersistanceLogger.error("Cannot update event \(error.localizedDescription)")
        }
        
        defer {
            activeEvent = nil
        }
        
        guard let endDate = event.endDate,
              let eventId = event.id else { return }
        
        do {
            try AppDatabase.shared.dbWriter.write { (db) in
                try db.execute(
                    sql: """
                        UPDATE \(TimeSeriesMeasurement.databaseTableName)
                        SET event_id = :eventId
                        WHERE date >= :startDate
                        AND date <= :endDate;
                    """,
                    arguments: [
                        "eventId": eventId,
                        "startDate": event.startDate,
                        "endDate": endDate
                    ]
                )
            }
        } catch {
            PersistanceLogger.error("Cannot update time series records: \(error.localizedDescription)")
        }
    }
}

struct ActiveEventView_Previews: PreviewProvider {
    @State static var activeEvent: Event? = nil
    
    static var previews: some View {
        ActiveEventView(activeEvent: $activeEvent)
    }
}

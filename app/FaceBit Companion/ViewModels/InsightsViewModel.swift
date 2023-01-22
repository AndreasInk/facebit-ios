//
//  InsightsViewModel.swift
//  FaceBit Companion
//
//  Created by Andreas Ink on 1/22/23.
//

import SwiftUI

class InsightsViewModel: ObservableObject {
    @Published var events: [Event] = Event.demo()
    @Published var insights: [InsightData] = []
    
    init() {
        do {
            try populateInsights([.weekOfYear])
        } catch {
        }
    }
    func populateInsights(_ dateComponets: Set<Calendar.Component>) throws {
        insights.append(InsightData(title: "Mask Events",
                                    description: "Learn of patterns in your mask wearing, the frequency of coughing, talking, or deep breathing",
                                    data: events,
                                    research: .demo,
                                    type: .BarChart))
        let coughingEvents = events.filter({ $0.eventType == .cough })
        insights.append(InsightData(title: "Coughing Events",
                                    description: "Learn of patterns in your mask wearing, the frequency of coughing, talking, or deep breathing",
                                    data: coughingEvents,
                                    research: .demo,
                                    type: .LineChart))
    }
}

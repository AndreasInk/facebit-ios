//
//  InsightDetailView.swift
//  FaceBit Companion
//
//  Created by Andreas Ink on 1/22/23.
//

import SwiftUI
import Charts

@available(iOS 16.0, *)
struct InsightDetailView: View {
    @State var insight: InsightData
    var body: some View {
        ScrollView {
            switch insight.type {
            case .LineChart:
                Chart(insight.data) { data in
                    LineMark(x: .value("", data.startDate),
                             y: .value(data.eventType.readableString, data.eventType.readableString))
                }
            case .BarChart:
                
                Chart(insight.data) { data in
                    BarMark(x: .value("", data.eventType.readableString),
                            y: .value("Event Count", 1))
                    .foregroundStyle(by: .value("", data.eventType.readableString))
                }
                .chartForegroundStyleScale(range: Color.primaries)
                .chartLegend(.visible)
                .chartXAxis(.hidden)
                .padding()
                
                
                
                
                
            default:
                EmptyView()
            }
            ResearchCardView(insight: insight)
            Spacer(minLength: 75)
        }
    }
}

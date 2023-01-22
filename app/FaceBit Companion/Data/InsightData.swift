//
//  InsightData.swift
//  FaceBit Companion
//
//  Created by Andreas Ink on 1/22/23.
//

import SwiftUI

// A model that store insight cards
struct InsightData: Identifiable {
    let id = UUID()
    var title: String
    var description: String
    var showHelp: Bool = false
    var data: [Event] = []
    var research: Research?
    var type: InsightType = .LineChart
    
}
// Show helpful research related to the insight
struct Research: Identifiable {
    let id = UUID()
    var title: String
    var description: String
    var link: String
    var imageLink: String
}
extension Research {
    static let demo = Research(title: "FaceBit: Smart Face Masks Platform", description: "The COVID-19 pandemic has dramatically increased the use of face masks across the world. Face masks are passive devices, however, and cannot alert the user in case of improper fit or mask degradation.", link: "https://dl.acm.org/doi/10.1145/3494991", imageLink: "https://facebit.health/images/facebit_web_figure.png")
}
enum InsightType {
    case LineChart
    case BarChart
    case RangeChart
}
// Demo data for insights
extension InsightData {
    static let demo = [
        InsightData(title: "Daily Respiratory Rate",
                    description: "Respiratory rate is a helpful metric for monitoring disease"),
        InsightData(title: "Daily Heart Rate",
                    description: "Heart rate is a helpful metric for monitoring disease"),
        InsightData(title: "Wear Time",
                    description: "Respiratory rate is a helpful metric for monitoring disease"),
        InsightData(title: "Enviromental Audio Exposure and Wear Time",
                    description: "Enviromental Audio Exposure can be used to measure the amount of times in a crowd, wearing a mask in a crowded enviroment reduces exposures")
    ]
}

// Demo data for Events
extension Event {
    static let demo = {
        var events = [Event]()
        let pastDates: [Date] = [.yesterday, .lastWeek, .twoWeeksAgo, .threeWeeksAgo]
        for _ in 0...1000 {
            events.append(Event(eventType: EventType.allCases.randomElement()!, startDate: pastDates.randomElement()!))
        }
        return events
    }
}
extension Date {
    static let lastWeek = Date().addingTimeInterval(-86400 * 7)
    static let yesterday = Date().addingTimeInterval(-86400)
    static let twoWeeksAgo = Date().addingTimeInterval(-86400 * 14)
    static let threeWeeksAgo = Date().addingTimeInterval(-86400 * 21)
}

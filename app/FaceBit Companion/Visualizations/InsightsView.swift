//
//  InsightsView.swift
//  FaceBit Companion
//
//  Created by Andreas Ink on 1/22/23.
//

import SwiftUI
import Charts

@available(iOS 16.0, *)
struct InsightsView: View {
    @StateObject var insightsViewModel = InsightsViewModel()
    
    var body: some View {
        NavigationStack {
            TabView {
                ForEach(insightsViewModel.insights, id: \.id) { insight in
                    InsightDetailView(insight: insight)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            .navigationTitle("Insights")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

@available(iOS 16.0, *)
struct InsightsView_Previews: PreviewProvider {
    static var previews: some View {
        InsightsView()
    }
}

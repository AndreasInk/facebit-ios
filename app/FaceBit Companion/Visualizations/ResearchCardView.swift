//
//  ResearchCardView.swift
//  FaceBit Companion
//
//  Created by Andreas Ink on 1/22/23.
//

import SwiftUI

@available(iOS 15.0, *)
struct ResearchCardView: View {
    let insight: InsightData
    var body: some View {
        HStack {
            if let research = insight.research {
                
                
                AsyncImage(url: URL(string: research.imageLink)!, scale: 1) { image in
                    image.image?.resizable()
                }
                
                    .frame(width: 200, height: 200)
                    .scaledToFit()
                Text(research.title)
                    .font(.headline)
                Text(research.description)
                    .font(.headline)
            }
            
        }
    }
}

@available(iOS 15.0, *)
struct ResearchCardView_Previews: PreviewProvider {
    static var previews: some View {
        ResearchCardView(insight: .demo.first!)
    }
}

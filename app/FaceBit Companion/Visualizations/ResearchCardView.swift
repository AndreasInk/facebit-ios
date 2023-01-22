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
        if let research = insight.research {
            Link(destination: URL(string: research.link)!) {
                
                HStack {
                    
                    VStack(alignment: .leading) {
                        Text(research.title)
                            .font(.headline)
                        Text(research.description)
                            .font(.caption)
                            .padding([.top, .trailing])
                    }
                    .padding()
                    .multilineTextAlignment(.leading)
                    AsyncImage(url: URL(string: research.imageLink)!, scale: 1) { image in
                        image.image?
                            .resizable()
                            .padding(.leading)
                    }
                    
                    .frame(width: 90, height: 90)
                    .scaledToFit()
                }
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.primaryWhite)
                        .shadow(color: .primaryWhite.opacity(0.4), radius: 10)
                        .padding()
                }
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

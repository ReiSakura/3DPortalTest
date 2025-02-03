/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A view, used as an attachment, that gives information about a point of interest.
*/

import SwiftUI
import RealityKit

public struct LearnMoreView: View {

    let name: String
    let description: String
    
    @State private var showingMoreInfo = false
    @Namespace private var animation
    
    private var titleFont: Font {
        .system(size: 48, weight: .semibold)
    }
    
    private var descriptionFont: Font {
        .system(size: 36, weight: .regular)
    }
    
    public var body: some View {
        VStack {
            ZStack(alignment: .center) {
                if !showingMoreInfo {
                    Text(name)
                        .matchedGeometryEffect(id: "Name", in: animation)
                        .font(titleFont)
                        .padding()
                }
                
                if showingMoreInfo {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(name)
                            .matchedGeometryEffect(id: "Name", in: animation)
                            .font(titleFont)
                        
                        Text(description)
                            .font(descriptionFont)
                        }
                    }
                }
            }
            .frame(width: 408)
            .padding(24)
            .background(Color.red)
            .glassBackgroundEffect()
            .onTapGesture {
                withAnimation(.spring) {
                    showingMoreInfo.toggle()
                    }
                }
            }
        }


#Preview {
    RealityView { content, attachments in
        if let entity = attachments.entity(for: "z") {
            content.add(entity)
        }
    } attachments: {
        Attachment(id: "z") {
            LearnMoreView(name: "TV",
                          description: "idk its tv")
        }
    }
}

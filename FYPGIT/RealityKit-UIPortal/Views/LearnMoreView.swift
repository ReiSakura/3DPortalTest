import SwiftUI
import RealityKit

public struct LearnMoreView: View {
    let name: String
    let description: String
    let position: SIMD3<Float>
    let rotation: simd_quatf

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
}

#Preview {
    RealityView { content, attachments in
        if let entity = attachments.entity(for: "tvInfo") {
            entity.position = SIMD3<Float>(1.0, 1.5, 0.0)  // Example position
            entity.orientation = simd_quatf(angle: .pi / 4, axis: SIMD3<Float>(0, 1, 0)) // Example rotation
            content.add(entity)
        }
    } attachments: {
        Attachment(id: "tvInfo") {
            LearnMoreView(
                name: "TV",
                description: "It's a TV",
                position: SIMD3<Float>(1.0, 1.5, 0.0),
                rotation: simd_quatf(angle: .pi / 4, axis: SIMD3<Float>(0, 1, 0))
            )
        }
    }
}

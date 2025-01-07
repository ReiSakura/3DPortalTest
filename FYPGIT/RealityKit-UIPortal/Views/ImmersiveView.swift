/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The app's immersive view.
*/

import SwiftUI
import RealityKit

/// An immersive view that contains the box environment.
struct ImmersiveView: View {
    @Environment(AppModel.self) private var appModel
    /// The average human height in metres.
    let avgHeight: Float = 0

    var body: some View {
        RealityView { content in
            // Create the box environment on the root entity.
            let root = Entity()
            let rotation = simd_quatf(angle: .pi / 2, axis: SIMD3<Float>(0, 1, 0))
            root.transform.rotation = rotation

            // Set the y-axis position to the average human height.
            root.position.y += avgHeight

            // Load the environment using the selected model name.
            do {
                try await createEnvironment(on: root, modelName: appModel.selectedModelName)
            } catch {
                print("Failed to load environment: \(error.localizedDescription)")
            }

            content.add(root)

            // Reposition the root so it has a similar placement
            // as when someone views it from the portal.
            root.position.z -= 1.0
        }
    }
}

/// Updated createEnvironment function to accept a modelName
func createEnvironment(on root: Entity, modelName: String) async throws {
    /// The root entity for the box environment.
    let assetRoot = try await Entity(named: modelName)
    await root.addChild(assetRoot)
}

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
                createEnvironmentButtons(for: appModel.selectedModelName, on: root)
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
@MainActor
func createEnvironment(on root: Entity, modelName: String) async throws {
    // Load the environment root entity asynchronously.
    let assetRoot = try await Entity(named: modelName)

    // Add the environment to the root entity.
    root.addChild(assetRoot)
}

/// Creates buttons specific to the environment and positions them.
@MainActor
func createEnvironmentButtons(for environment: String, on parent: Entity) {
    // Example configuration for environments
    let buttonConfigurations: [String: [(position: SIMD3<Float>, label: String)]] = [
        "HiveScene": [
            (position: SIMD3<Float>(-0.5, 0.0, 0.0), label: "Left Button"),
            (position: SIMD3<Float>(0.5, 0.0, 0.0), label: "Right Button")
        ],
        "FypLabScene": [
            // position for tv
            (position: SIMD3<Float>(-1.0, 1.5, -1.0), label: "TV"),
            // position for bicycle
            (position: SIMD3<Float>(-1.0, 0.5, 0.0), label: "Bicycle"),
            // position for robot
            (position: SIMD3<Float>(2.0, 0.5, -0.8), label: "Robot")
        ]
    ]

    guard let buttons = buttonConfigurations[environment] else { return }

    for buttonConfig in buttons {
        let buttonEntity = createButton(label: buttonConfig.label)
        buttonEntity.position = buttonConfig.position
        parent.addChild(buttonEntity)
    }
}

/// Creates a button entity with a given label.
@MainActor
func createButton(label: String) -> Entity {
    let buttonEntity = Entity()
    let text = ModelEntity(mesh: .generateText(
        label,
        extrusionDepth: 0.01,
        font: .systemFont(ofSize: 0.1),
        containerFrame: .zero,
        alignment: .center,
        lineBreakMode: .byWordWrapping
    ))
    text.position = SIMD3<Float>(0, 0.05, 0)
    buttonEntity.addChild(text)

    let buttonMesh = ModelEntity(
        mesh: .generateBox(size: SIMD3<Float>(0.2, 0.1, 0.1)),
        materials: [SimpleMaterial(color: .gray, isMetallic: false)]
    )
    buttonEntity.addChild(buttonMesh)
    return buttonEntity
}

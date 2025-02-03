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
        RealityView { content, attachments in
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
            
            if let entity = attachments.entity(for: "z") {
                entity.position.x = -1.0
                entity.position.y = 1.5
                entity.position.z = -1.0
                content.add(entity)
            }

            // Reposition the root so it has a similar placement
            // as when someone views it from the portal.
            root.position.z -= 1.0
            
        } attachments: {
            Attachment(id: "z") {
                LearnMoreView(name: "Phoenix Lake",
                              description: "Lake · Northern California",
                              imageNames: ["Landscape_2_Sunset"],
                              trail: nil
                              //viewModel: ViewModel()
                )
            }
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
    let buttonConfigurations: [String: [(position: SIMD3<Float>, label: String, rotation: simd_quatf)]] = [
        "HiveScene": [
            (position: SIMD3<Float>(-4.0, 1.5, 0.0), label: "Study Corner", rotation: simd_quatf(angle: .pi / 2, axis: SIMD3<Float>(0, 1, 0))),
            (position: SIMD3<Float>(0.5, 1.5, 0.0), label: "Hive", rotation: simd_quatf(angle: -.pi / 12, axis: SIMD3<Float>(0, 1, 0)))
                ],
        "FypLabScene": [
            // TV facing forward
            (position: SIMD3<Float>(-1.0, 1.5, -1.0), label: "TV", rotation: simd_quatf(angle: .pi / 4, axis: SIMD3<Float>(0, 1, 0))),
            // Bicycle facing sideways
            (position: SIMD3<Float>(-1.0, 0.5, 0.0), label: "Bicycle", rotation: simd_quatf(angle: .pi / 4, axis: SIMD3<Float>(0, 1, 0))),
            // Robot facing diagonally
            (position: SIMD3<Float>(2.0, 0.5, -0.8), label: "Robot", rotation: simd_quatf(angle: -.pi / 4, axis: SIMD3<Float>(0, 1, 0)))
        ]
    ]

    guard let buttons = buttonConfigurations[environment] else { return }

        for buttonConfig in buttons {
            let buttonEntity = createButton(label: buttonConfig.label)
            buttonEntity.position = buttonConfig.position
            buttonEntity.orientation = buttonConfig.rotation // Apply fixed rotation
            parent.addChild(buttonEntity)
        }
}


/// Creates a forward-facing big red button with a dark metallic holder and a label.
@MainActor
func createButton(label: String) -> Entity {
    let buttonEntity = Entity()

    // Create the cylinder (button base)
    let buttonMesh = ModelEntity(
        mesh: .generateCylinder(height: 0.03, radius: 0.05), // Correct parameter order
        materials: [SimpleMaterial(color: .red, roughness: 0.2, isMetallic: true)] // Glossy, metallic red
    )
    // Rotate the cylinder to face forward
    buttonMesh.orientation = simd_quatf(angle: -.pi / 2, axis: SIMD3<Float>(1, 0, 0))
    buttonEntity.addChild(buttonMesh)

    // Create the cuboid holder
    let holderMesh = ModelEntity(
        mesh: .generateCylinder(height: 0.03, radius: 0.07),
        materials: [SimpleMaterial(color: .lightGray, roughness: 0.7, isMetallic: true)] // Metallic dark gray
    )
    // Position the holder behind the cylinder
    holderMesh.position = SIMD3<Float>(0, 0, -0.03)
    holderMesh.orientation = simd_quatf(angle: -.pi / 2, axis: SIMD3<Float>(1, 0, 0))
    buttonEntity.addChild(holderMesh)

    // Add the label in front of the button
    let text = ModelEntity(mesh: .generateText(
        label,
        extrusionDepth: 0.01,
        font: .systemFont(ofSize: 0.1),
        containerFrame: .zero,
        alignment: .center,
        lineBreakMode: .byWordWrapping
    ))
    text.position = SIMD3<Float>(0, 0, 0.15) // Place text in front of the button
    text.model?.materials = [SimpleMaterial(color: .white, isMetallic: false)] // White label
    buttonEntity.addChild(text)
        
    return buttonEntity
}


/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The app's immersive view.
*/

import SwiftUI
import RealityKit
import AVFoundation

/// An immersive view that contains the box environment.
struct ImmersiveView: View {
    @Environment(AppModel.self) private var appModel
    
    @State private var player: AVAudioPlayer?
    //@State private var audioController: AudioPlaybackController?
    
    /// The average human height in meters.
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
            } catch {
                print("Failed to load environment: \(error.localizedDescription)")
            }

            content.add(root)

            // Load attachment entities dynamically
            for attachmentID in getAttachmentIDs(for: appModel.selectedModelName) {
                if let entity = attachments.entity(for: attachmentID.id) {
                    entity.position = attachmentID.position
                    entity.orientation = attachmentID.rotation
                    content.add(entity)
                }
            }

            // Reposition the root so it has a similar placement
            // as when someone views it from the portal.
            root.position.z -= 1.0
            

            //            let ambientAudioEntity = entity.findEntity(named: "ChannelAudio")
            //
            //            guard let resource = try? await AudioFileResource(named: "Forest_Sounds.wav") else {
            //                fatalError("Unable to find audio file Forest_Sounds.wav")
            //            }
            //
            //            audioController = ambientAudioEntity?.prepareAudio(resource)
            //            audioController?.play()
            //
                        playSound()
            
        } attachments: {
            ForEach(getAttachmentIDs(for: appModel.selectedModelName), id: \.id) { attachment in
                Attachment(id: attachment.id) {
                    LearnMoreView(
                        name: attachment.name,
                        description: attachment.description,
                        position: attachment.position,
                        rotation: attachment.rotation
                    )
                }
            }
        }
    }
    
    @MainActor
    func playSound() {
        guard let path = Bundle.main.path(forResource: "Forest_Sounds", ofType:"wav") else {
            return }
        let url = URL(fileURLWithPath: path)

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

/// A struct to hold attachment details.
struct AttachmentInfo {
    let id: String
    let name: String
    let description: String
    let position: SIMD3<Float>
    let rotation: simd_quatf
}

/// Retrieves the attachment configurations for each environment.
func getAttachmentIDs(for environment: String) -> [AttachmentInfo] {
    switch environment {
    case "HiveScene":
        return [
            AttachmentInfo(
                id: "studyCornerInfo",
                name: "Study Corner",
                description: "A quiet place to focus.",
                position: SIMD3<Float>(0.0, 1.5, 2.5),
                rotation: simd_quatf(angle: .pi / 1, axis: SIMD3<Float>(0, 1, 0))
            ),
            AttachmentInfo(
                id: "hiveInfo",
                name: "Hive",
                description: "A collaborative workspace.",
                position: SIMD3<Float>(1.0, 1.5, -1.0),
                rotation: simd_quatf(angle: .pi / 180, axis: SIMD3<Float>(0, 1, 0))
            )
        ]
    case "FypLabScene":
        return [
            AttachmentInfo(
                id: "bicycleInfo",
                name: "Bicycle",
                description: "A two-wheeled vehicle.",
                position: SIMD3<Float>(0.0, 0.5, 0.0),
                rotation: simd_quatf(angle: .pi * 3 / 4, axis: SIMD3<Float>(0, 1, 0))
            ),
            AttachmentInfo(
                id: "robotInfo",
                name: "Robot",
                description: "An autonomous machine.",
                position: SIMD3<Float>(-0.8, 0.8, -2.5),
                rotation: simd_quatf(angle: .pi / 4, axis: SIMD3<Float>(0, 1, 0))
            ),
            AttachmentInfo(
                id: "tvInfo",
                name: "Immersive Technology project",
                description: "A screen for media.",
                position: SIMD3<Float>(-1.5, 1.5, -0.5),
                rotation: simd_quatf(angle: .pi * 3 / 4, axis: SIMD3<Float>(0, 1, 0))
            )
        ]
    default:
        return []
    }
}


//@ViewBuilder
//func getViewForEnvironment(_ environment: String) -> some View {
//    switch environment {
//    case "HiveScene":
//        StudyCornerView() // Custom SwiftUI view for this space
//        LearnMoreView(name: "test", description: "test desc")
//    case "FypLabScene":
//        EquipmentDetailsView() // Custom SwiftUI view for this space
//        LearnMoreView(name: "Bicycle", description: "Tis a bike.")
//    default:
//        DefaultInfoView() // A fallback view
//    }
//}


/// Updated createEnvironment function to accept a modelName
@MainActor
func createEnvironment(on root: Entity, modelName: String) async throws {
    // Load the environment root entity asynchronously.
    let assetRoot = try await Entity(named: modelName)

    // Add the environment to the root entity.
    root.addChild(assetRoot)
}

//@MainActor
//struct DefaultInfoView: View {
//    var body: some View {
//        VStack {
//            Text("Default Info")
//                .font(.title)
//                .bold()
//            Text("This is default view.")
//                .padding()
//        }
//        .frame(width: 300, height: 200)
//        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12))
//    }
//}
//
//
//@MainActor
//struct StudyCornerView: View {
//    var body: some View {
//        VStack {
//            Text("Study Corner")
//                .font(.title)
//                .bold()
//            Text("This is a quiet space for studying with comfortable seating and ample lighting.")
//                .padding()
//        }
//        .frame(width: 300, height: 200)
//        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12))
//    }
//}
//
//@MainActor
//struct EquipmentDetailsView: View {
//    var body: some View {
//        VStack {
//            Text("FYP Lab")
//                .font(.title)
//                .bold()
//            Text("This lab contains various pieces of equipment for final-year projects, including a 3D printer and robotic kits.")
//                .padding()
//        }
//        .frame(width: 300, height: 200)
//        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12))
//    }
//}


///// Creates buttons specific to the environment and positions them.
//@MainActor
//func createEnvironmentButtons(for environment: String, on parent: Entity) {
//    // Example configuration for environments
//    let buttonConfigurations: [String: [(position: SIMD3<Float>, label: String, rotation: simd_quatf)]] = [
//        "HiveScene": [
//            (position: SIMD3<Float>(-4.0, 1.5, 0.0), label: "Study Corner", rotation: simd_quatf(angle: .pi / 2, axis: SIMD3<Float>(0, 1, 0))),
//            (position: SIMD3<Float>(0.5, 1.5, 0.0), label: "Hive", rotation: simd_quatf(angle: -.pi / 12, axis: SIMD3<Float>(0, 1, 0)))
//                ],
//                "FypLabScene": [
//                    // TV facing forward
//                    (position: SIMD3<Float>(-1.0, 1.5, -1.0), label: "TV", rotation: simd_quatf(angle: .pi / 4, axis: SIMD3<Float>(0, 1, 0))),
//                    // Bicycle facing sideways
//                    (position: SIMD3<Float>(-1.0, 0.5, 0.0), label: "Bicycle", rotation: simd_quatf(angle: .pi / 4, axis: SIMD3<Float>(0, 1, 0))),
//                    // Robot facing diagonally
//                    (position: SIMD3<Float>(2.0, 0.5, -0.8), label: "Robot", rotation: simd_quatf(angle: -.pi / 4, axis: SIMD3<Float>(0, 1, 0)))
//                ]
//    ]
//
//    guard let buttons = buttonConfigurations[environment] else { return }
//
//        for buttonConfig in buttons {
//            let buttonEntity = createButton(label: buttonConfig.label)
//            buttonEntity.position = buttonConfig.position
//            buttonEntity.orientation = buttonConfig.rotation // Apply fixed rotation
//            parent.addChild(buttonEntity)
//        }
//}
//
//
///// Creates a forward-facing big red button with a dark metallic holder and a label.
//@MainActor
//func createButton(label: String) -> Entity {
//    let buttonEntity = Entity()
//
//    // Create the cylinder (button base)
//    let buttonMesh = ModelEntity(
//        mesh: .generateCylinder(height: 0.03, radius: 0.05), // Correct parameter order
//        materials: [SimpleMaterial(color: .red, roughness: 0.2, isMetallic: true)] // Glossy, metallic red
//    )
//    // Rotate the cylinder to face forward
//    buttonMesh.orientation = simd_quatf(angle: -.pi / 2, axis: SIMD3<Float>(1, 0, 0))
//    buttonEntity.addChild(buttonMesh)
//
//    // Create the cuboid holder
//    let holderMesh = ModelEntity(
//        mesh: .generateCylinder(height: 0.03, radius: 0.07),
//        materials: [SimpleMaterial(color: .lightGray, roughness: 0.7, isMetallic: true)] // Metallic dark gray
//    )
//    // Position the holder behind the cylinder
//    holderMesh.position = SIMD3<Float>(0, 0, -0.03)
//    holderMesh.orientation = simd_quatf(angle: -.pi / 2, axis: SIMD3<Float>(1, 0, 0))
//    buttonEntity.addChild(holderMesh)
//
//    // Add the label in front of the button
//    let text = ModelEntity(mesh: .generateText(
//        label,
//        extrusionDepth: 0.01,
//        font: .systemFont(ofSize: 0.1),
//        containerFrame: .zero,
//        alignment: .center,
//        lineBreakMode: .byWordWrapping
//    ))
//    text.position = SIMD3<Float>(0, 0, 0.15) // Place text in front of the button
//    text.model?.materials = [SimpleMaterial(color: .white, isMetallic: false)] // White label
//    buttonEntity.addChild(text)
//
//    return buttonEntity
//}


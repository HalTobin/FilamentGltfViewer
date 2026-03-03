import Foundation
import FilamentGltfViewer

enum ModelPlaceholder {
    
    static let boxUrl: URL = Bundle.main.url(
        forResource: "BoxAnimated",
        withExtension: "glb",
        subdirectory: "Scene"
    )!

    static let helmetUrl: URL = Bundle.main.url(
        forResource: "DamagedHelmet",
        withExtension: "glb",
        subdirectory: "Scene"
    )!

    static let models: [FilamentModel] = [
        FilamentModel(
            url: boxUrl,
            name: "box",
            scale: 0.2,
            offset: ModelOffset(x: 0.0, y: 0.0, z: -1.0)
        ),
        FilamentModel(
            url: helmetUrl,
            name: "helmet",
            scale: 0.5
        )
    ]
    
}

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
            name: "box"
        ),
        FilamentModel(
            url: helmetUrl,
            name: "helmet"
        )
    ]
    
}

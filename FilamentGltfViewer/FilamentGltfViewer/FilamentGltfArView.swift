import UIKit
import SwiftUI

public struct FilamentGltfArView: UIViewControllerRepresentable {
    
    private let scene: FilamentScene
    private let model: FilamentModel?
    private let onModelTap: (FilamentModel?) -> Void
    
    public init(
        scene: FilamentScene,
        model: FilamentModel?,
        onModelTap: @escaping (FilamentModel?) -> Void = { model in }
    ) {
        self.scene = scene
        self.model = model
        self.onModelTap = onModelTap
    }
    
    public func makeUIViewController(context: Context) -> UIViewController {
        let viewController = FILARSwiftViewController(
            scene: scene,
            onModelTap: { onModelTap($0) }
        )
        if let safeModel = model {
            viewController.load(safeModel)
        }
        return viewController
    }
    
    public func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if let viewController = uiViewController as? FILSwiftViewController {
            viewController.unloadModel()
            if let safeModel = model {
                viewController.load(safeModel)
            }
        }
    }
    
}

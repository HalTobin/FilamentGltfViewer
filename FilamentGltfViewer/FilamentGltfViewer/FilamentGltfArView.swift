import UIKit
import SwiftUI

public struct FilamentGltfArView: UIViewControllerRepresentable {
    
    private let scene: FilamentScene
    private let model: FilamentModel?
    private let onModelTap: (FilamentModel?) -> Void
    
    @Binding var takeSnapshot: Bool
    private let onSnapshotCaptured: ((UIImage) -> Void)?
    
    private let onModelVisibilityUpdate: ((Bool) -> Void)?
    
    public init(
        scene: FilamentScene,
        model: FilamentModel?,
        onModelTap: @escaping (FilamentModel?) -> Void = { model in },
        takeSnapshot: Binding<Bool> = .constant(false),
        onSnapshotCaptured: ((UIImage) -> Void)? = nil,
        onModelVisibilityUpdate: ((Bool) -> Void)? = nil
    ) {
        self.scene = scene
        self.model = model
        self.onModelTap = onModelTap
        self._takeSnapshot = takeSnapshot
        self.onSnapshotCaptured = onSnapshotCaptured
        self.onModelVisibilityUpdate = onModelVisibilityUpdate
    }
    
    /*public func makeUIViewController(context: Context) -> UIViewController {
        let viewController = FILARSwiftViewController(
            scene: scene,
            onModelTap: { onModelTap($0) }
        )
        viewController.onModelVisibilityUpdate = { isVisible in
            DispatchQueue.main.async {
                self.onModelVisibilityUpdate?(isVisible)
            }
        }
        
        if let safeModel = model {
            viewController.load(safeModel)
        }
        return viewController
    }*/
    
    public func makeUIViewController(context: Context) -> UIViewController {
        #if targetEnvironment(simulator)
        return createUnsupportedFallbackViewController()
        #else
        let viewController = FILARSwiftViewController(
            scene: scene,
            onModelTap: { onModelTap($0) }
        )
        viewController.onModelVisibilityUpdate = { isVisible in
            DispatchQueue.main.async {
                self.onModelVisibilityUpdate?(isVisible)
            }
        }
        
        if let safeModel = model {
            viewController.load(safeModel)
        }
        return viewController
        #endif
    }
    
    public func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        guard let viewController = uiViewController as? FILARSwiftViewController else { return }
        viewController.unloadModel()
        if let safeModel = model {
            viewController.load(safeModel)
        }
        
        if takeSnapshot {
            DispatchQueue.main.async {
                if let image = viewController.captureSnapshot() {
                    onSnapshotCaptured?(image)
                }
                takeSnapshot = false
            }
        }
    }
    
}

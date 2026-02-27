import SwiftUI
import FilamentGltfViewer

struct ModelView: View {
    @State private var modelSelectionSheet: Bool = false
    @State private var currentModel: FilamentModel? = ModelPlaceholder.models.first
    
    @State private var mode: ViewerMode = ViewerMode.classical
    
    @State private var captureSnapshot: Bool = false
    
    private let models = ModelPlaceholder.models
    
    var body: some View {
        ZStack(alignment: .top) {
            
            let scene = FilamentScene(
                envSkyboxPath: EnvironmentLight.skybox,
                envIblPath: EnvironmentLight.ibl
            )
            ZStack {
                switch (mode) {
                case .classical: FilamentGltfView(
                    scene: scene,
                    model: currentModel,
                    onModelTap: { model in
                        print("onTap(): \(model?.name ?? "nil")")
                    }
                )
                case .ar: ZStack(alignment: .bottom) {
                    FilamentGltfArView(
                        scene: scene,
                        model: currentModel,
                        onModelTap: { model in
                            print("onTap(): \(model?.name ?? "nil")")
                        },
                        takeSnapshot: $captureSnapshot,
                        onSnapshotCaptured: { image in
                            print("Image captured!")
                            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                        }
                    )
                    snapshotButton
                        .padding(.bottom, 36)
                }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            .sheet(isPresented: $modelSelectionSheet) {
                ModelSelector(
                    models: models,
                    currentModel: currentModel,
                    onChange: { url in
                        self.currentModel = url
                        withAnimation { modelSelectionSheet = false }
                    }
                )
            }
            
            HStack {
                Button(
                    "Select a model",
                    systemImage: "arkit",
                    action: {
                        withAnimation { modelSelectionSheet = true }
                    }
                )
                .padding()
                .buttonStyle(.borderedProminent)
                
                Spacer()
                
                Button(
                    "Viewer Mode",
                    systemImage: mode.systemImage,
                    action: changeViewerMode
                )
                .padding()
                .buttonStyle(.borderedProminent)
                .labelStyle(.iconOnly)
            }
            .padding(.top, 6)
            
        }
    }
    
    private var snapshotButton: some View {
        Button(
            action: { captureSnapshot = true },
            label: {
                ZStack(alignment: .center) {
                    Circle()
                        .foregroundColor(.white)
                        .frame(width: 70, height: 70)
                    Image(systemName: "camera.shutter.button.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35, height: 35)
                        .foregroundColor(.black)
                        .padding(.bottom, 6)
                }
            }
        )
        .labelStyle(.iconOnly)
        .contentShape(Circle())
        .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 3)
    }
    
    private func changeViewerMode() {
        mode = (mode == .classical) ? .ar : .classical
    }
    
}

enum ViewerMode {
    case classical
    case ar
}

extension ViewerMode {
    var systemImage: String {
        return switch self {
        case .classical: "cube.transparent.fill"
        case .ar: "arkit"
        }
    }
}

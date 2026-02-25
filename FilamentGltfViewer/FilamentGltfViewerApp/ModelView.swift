import SwiftUI
import FilamentGltfViewer

struct ModelView: View {
    @State var modelSelectionSheet: Bool = false
    @State var currentModel: FilamentModel? = ModelPlaceholder.models.first
    
    @State var mode: ViewerMode = ViewerMode.classical
    
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
                case .ar: FilamentGltfArView(
                    scene: scene,
                    model: currentModel,
                    onModelTap: { model in
                        print("onTap(): \(model?.name ?? "nil")")
                    }
                )
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

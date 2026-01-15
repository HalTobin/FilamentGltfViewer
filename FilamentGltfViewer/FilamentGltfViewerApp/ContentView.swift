import SwiftUI
import FilamentGltfViewer

struct ContentView: View {
    
    @State var modelSelectionSheet: Bool = false
    @State var currentModel: FilamentModel? = ModelPlaceholder.models.first
    
    private let models = ModelPlaceholder.models
    
    var body: some View {
        ZStack(alignment: .top) {
            
            let scene = FilamentScene(
                envSkyboxPath: EnvironmentLight.skybox,
                envIblPath: EnvironmentLight.ibl
            )
            FilamentGltfView(
                scene: scene,
                model: currentModel,
                onModelTap: { model in
                    print("onTap(): \(model?.name ?? "nil")")
                }
            )
            .ignoresSafeArea()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
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
            
            Button(
                "Select a model",
                systemImage: "arkit",
                action: {
                    withAnimation { modelSelectionSheet = true }
                }
            )
            .padding()
            .buttonStyle(.borderedProminent)
            
        }
        .ignoresSafeArea()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    ContentView()
}

import SwiftUI
import FilamentGltfViewer

struct ModelSelector: View {
    let models: [FilamentModel]
    let currentModel: FilamentModel?
    let onChange: (FilamentModel?) -> Void
    
    var body: some View {
        List {
            ForEach(models.indices, id: \.self) { index in
                Button(
                    action: { self.onChange(self.models[index]) }
                ) {
                    HStack {
                        Text(self.models[index].name)
                        if (self.models[index] == self.currentModel) {
                            Spacer()
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
            Button(
                role: .destructive,
                action: { self.onChange(nil) }
            ) {
                Text("None")
            }
        }
    }
    
}

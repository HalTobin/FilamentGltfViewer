import SwiftUI

struct ContentView: View {
    @State var showViewer: Bool = false
    
    var body: some View {
        NavigationStack {
            Button(
                "Show viewer",
                action: { showViewer = true }
            )
            .buttonStyle(.borderedProminent)
            .navigationDestination(isPresented: $showViewer) {
                ModelView()
            }
        }
    }
    
}

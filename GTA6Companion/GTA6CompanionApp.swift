import SwiftUI

@main
struct GTA6CompanionApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

private struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Image(systemName: "car.side.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(.orange)

                Text("GTA6 Companion")
                    .font(.title.bold())

                Text("Your companion app is ready to build.")
                    .foregroundStyle(.secondary)
            }
            .padding()
            .navigationTitle("Home")
        }
    }
}
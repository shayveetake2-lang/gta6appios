import SwiftUI

@main
struct GTA6CompanionApp: App {
    @StateObject private var rootViewModel = RootViewModel()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(rootViewModel)
                .preferredColorScheme(.dark)
        }
    }
}

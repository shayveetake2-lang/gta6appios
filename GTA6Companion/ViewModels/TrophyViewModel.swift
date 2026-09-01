import Foundation

@MainActor
class TrophyViewModel: ObservableObject {
    @Published var trophies: [Trophy] = []
    @Published var currentPlatform: Platform = .playStation
    @Published var isLoading = false
    
    func switchPlatform(_ platform: Platform) async {
        currentPlatform = platform
        await loadTrophies()
    }
    
    func loadTrophies() async {
        isLoading = true
        try? await Task.sleep(nanoseconds: 500_000_000)
        self.trophies = [
            Trophy(id: "1", name: "First Blood", description: "Complete the first mission", icon: URL(string: "https://example.com/icon.png")!, rarity: "Common", platform: currentPlatform, earned: true, unlockedDate: Date(), progress: 100)
        ]
        isLoading = false
    }
}

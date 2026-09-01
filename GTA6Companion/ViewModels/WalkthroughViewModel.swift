import Foundation

@MainActor
class WalkthroughViewModel: ObservableObject {
    @Published var walkthroughs: [Walkthrough] = []
    @Published var isLoading = false
    
    func loadWalkthroughs() async {
        isLoading = true
        // Mock data
        try? await Task.sleep(nanoseconds: 500_000_000)
        self.walkthroughs = [
            Walkthrough(id: "1", title: "The Beginning", description: "First mission walkthrough", difficulty: .easy, steps: [WalkthroughStep(id: "s1", stepNumber: 1, title: "Go to hotel", description: "Drive to the Ocean View Hotel", tips: ["Avoid cops"])], collectibles: [], estimatedTime: 600, author: User(id: "1", username: "tommy", email: "", avatar: nil, joinDate: Date(), bio: nil, postCount: 0, trophyCount: 0, contributedGuides: 0), rating: 5.0, reviews: 1, bookmarked: false)
        ]
        isLoading = false
    }
}

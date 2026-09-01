import Foundation

@MainActor
class ForumViewModel: ObservableObject {
    @Published var threads: [ForumThread] = []
    @Published var isLoading = false
    
    func loadForumThreads() async {
        isLoading = true
        try? await Task.sleep(nanoseconds: 500_000_000)
        self.threads = [
            ForumThread(id: "1", title: "Is the map really that big?", author: User(id: "1", username: "gamer123", email: "", avatar: nil, joinDate: Date(), bio: nil, postCount: 0, trophyCount: 0, contributedGuides: 0), content: "I heard it is 2x GTA V.", category: "Discussion", timestamp: Date(), replies: [], views: 100, pinned: false)
        ]
        isLoading = false
    }
}

import Foundation

@MainActor
class FeedViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func fetchPosts(category: PostCategory? = nil) async {
        isLoading = true
        errorMessage = nil
        
        do {
            var path = "/api/posts?page=0"
            if let cat = category {
                path += "&category=\(cat.rawValue)"
            }
            
            // In a real app we would call APIClient
            // let response: PostResponse = try await APIClient.shared.request(path: path)
            // self.posts = response.posts
            
            // Mock data for now since backend is mock
            try await Task.sleep(nanoseconds: 500_000_000)
            self.posts = [
                Post(id: "1", author: User(id: "1", username: "tommyV", email: "tommy@vc.com", avatar: nil, joinDate: Date(), bio: nil, postCount: 0, trophyCount: 0, contributedGuides: 0), content: "Welcome back to Vice City!", category: .news, timestamp: Date(), likes: 42, comments: 5, shares: 2, liked: false)
            ]
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func createPost(content: String, category: PostCategory) async -> Bool {
        // Implementation
        let newPost = Post(id: UUID().uuidString, author: User(id: "1", username: "tommyV", email: "", avatar: nil, joinDate: Date(), bio: nil, postCount: 0, trophyCount: 0, contributedGuides: 0), content: content, category: category, timestamp: Date(), likes: 0, comments: 0, shares: 0, liked: false)
        posts.insert(newPost, at: 0)
        return true
    }
    
    func likePost(_ post: Post) {
        if let index = posts.firstIndex(where: { $0.id == post.id }) {
            posts[index].liked.toggle()
            posts[index].likes += posts[index].liked ? 1 : -1
        }
    }
}

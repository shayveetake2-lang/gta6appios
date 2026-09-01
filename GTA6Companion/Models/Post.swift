import Foundation

enum PostCategory: String, Codable, CaseIterable {
    case news = "NEWS"
    case guide = "GUIDES"
    case discussion = "DISCUSSIONS"
}

struct Post: Codable, Identifiable, Equatable {
    let id: String
    let author: User
    let content: String
    let category: PostCategory
    let timestamp: Date
    var likes: Int
    var comments: Int
    var shares: Int
    var liked: Bool
}

struct PostResponse: Codable {
    let posts: [Post]
    let total: Int
    let page: Int
}

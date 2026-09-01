import Foundation

struct Reply: Codable, Identifiable, Equatable {
    let id: String
    let author: User
    let content: String
    let timestamp: Date
    var likes: Int
    var liked: Bool
}

struct ForumThread: Codable, Identifiable, Equatable {
    let id: String
    let title: String
    let author: User
    let content: String
    let category: String
    let timestamp: Date
    let replies: [Reply]
    let views: Int
    let pinned: Bool
}

struct ForumThreadResponse: Codable {
    let threads: [ForumThread]
    let total: Int
    let page: Int
}

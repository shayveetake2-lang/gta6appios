import Foundation

struct User: Codable, Identifiable, Equatable {
    let id: String
    let username: String
    let email: String
    let avatar: URL?
    let joinDate: Date
    let bio: String?
    let postCount: Int
    let trophyCount: Int
    let contributedGuides: Int
}

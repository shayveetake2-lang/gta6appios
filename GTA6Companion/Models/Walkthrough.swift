import Foundation

enum Difficulty: String, Codable, CaseIterable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
}

struct WalkthroughStep: Codable, Identifiable, Equatable {
    let id: String
    let stepNumber: Int
    let title: String
    let description: String
    let tips: [String]
}

struct Collectible: Codable, Identifiable, Equatable {
    let id: String
    let name: String
    let description: String
    let location: String
    let latitude: Double
    let longitude: Double
    let collected: Bool
}

struct Walkthrough: Codable, Identifiable, Equatable {
    let id: String
    let title: String
    let description: String
    let difficulty: Difficulty
    let steps: [WalkthroughStep]
    let collectibles: [Collectible]
    let estimatedTime: TimeInterval
    let author: User
    let rating: Double
    let reviews: Int
    var bookmarked: Bool
}

struct WalkthroughResponse: Codable {
    let walkthroughs: [Walkthrough]
    let total: Int
    let page: Int
}

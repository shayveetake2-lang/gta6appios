import Foundation

enum Platform: String, Codable, CaseIterable {
    case steam = "Steam"
    case playStation = "PlayStation"
    case xbox = "Xbox"
}

struct Trophy: Codable, Identifiable, Equatable {
    let id: String
    let name: String
    let description: String
    let icon: URL
    let rarity: String
    let platform: Platform
    let earned: Bool
    let unlockedDate: Date?
    let progress: Double?
}

struct TrophyResponse: Codable {
    let trophies: [Trophy]
    let total: Int
    let earned: Int
}

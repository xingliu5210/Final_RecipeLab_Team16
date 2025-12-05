import Foundation
import FirebaseFirestore

struct Recipe: Identifiable, Codable {
    @DocumentID var id: String?
    let title: String
    let imageUrl: String
    let cookingTime: Int8
    let ingredients: [String]
    let steps: [String]
    let userName: String
    let creationTime: Timestamp
    let userImageUrl: String
    let likedBy: [String: Bool?]

    var creationTimeAgo: String {
        let date = creationTime.dateValue()
        let interval = Date().timeIntervalSince(date)
        let minutes = Int(interval / 60)
        if minutes < 1 { return "just now" }
        if minutes < 60 { return "\(minutes)m ago" }
        let hours = minutes / 60
        if hours < 24 { return "\(hours)h ago" }
        let days = hours / 24
        return "\(days)d ago"
    }
}

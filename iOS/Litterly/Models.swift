import Foundation

struct LitterEntry: Codable, Identifiable, Hashable {
    var id: UUID = UUID()
    var catName: String
    var changed: Bool
    var bathroomCount: Int
    var date: Date = Date()
    var notes: String = ""
}

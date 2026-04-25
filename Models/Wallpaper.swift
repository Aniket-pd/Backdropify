import Foundation

struct Wallpaper: Identifiable, Codable, Hashable {
    var id: String?
    var name: String
    var url: String

    var transitionID: String {
        if let id, !id.isEmpty {
            return id
        }

        return "\(name)|\(url)"
    }

    static func == (lhs: Wallpaper, rhs: Wallpaper) -> Bool {
        lhs.transitionID == rhs.transitionID &&
        lhs.name == rhs.name &&
        lhs.url == rhs.url
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(transitionID)
        hasher.combine(name)
        hasher.combine(url)
    }
}

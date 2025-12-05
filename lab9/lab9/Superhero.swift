import Foundation

struct Superhero: Codable {
    let id: Int
    let name: String
    let powerstats: Powerstats
    let appearance: Appearance
    let biography: Biography
    let work: Work
    let connections: Connections
    let images: Images
}

struct Powerstats: Codable {
    let intelligence: Int?
    let strength: Int?
    let speed: Int?
    let durability: Int?
    let power: Int?
    let combat: Int?
}

struct Appearance: Codable {
    let gender: String?
    let race: String?
    let height: [String]?
    let weight: [String]?
}

struct Biography: Codable {
    let fullName: String?
    let publisher: String?
    let alignment: String?
}

struct Work: Codable {
    let occupation: String?
    let base: String?
}

struct Connections: Codable {
    let groupAffiliation: String?
    let relatives: String?
}

struct Images: Codable {
    let lg: String?
}

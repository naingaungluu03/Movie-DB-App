// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let actorDetailResponse = try? newJSONDecoder().decode(ActorDetailResponse.self, from: jsonData)

import Foundation

// MARK: - ActorDetailResponse
struct ActorDetailResponse: Codable {
    let birthday, knownForDepartment: String?
    let deathday: String?
    let id: Int?
    let name: String?
    let alsoKnownAs: [String]?
    let gender: Int?
    let biography: String?
    let popularity: Double?
    let placeOfBirth, profilePath: String?
    let adult: Bool?
    let imdbID: String?
    let homepage: String?

    enum CodingKeys: String, CodingKey {
        case birthday
        case knownForDepartment = "known_for_department"
        case deathday, id, name
        case alsoKnownAs = "also_known_as"
        case gender, biography, popularity
        case placeOfBirth = "place_of_birth"
        case profilePath = "profile_path"
        case adult
        case imdbID = "imdb_id"
        case homepage
    }
    
    static func empty() -> ActorDetailResponse {
        return ActorDetailResponse(birthday: nil, knownForDepartment: nil, deathday: nil, id: nil, name: nil, alsoKnownAs: nil, gender: nil, biography: nil, popularity: nil, placeOfBirth: nil, profilePath: nil, adult: nil, imdbID: nil, homepage: nil)
    }
}

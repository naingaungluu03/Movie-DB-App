// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let seriesCreditResponse = try? newJSONDecoder().decode(SeriesCreditResponse.self, from: jsonData)

import Foundation

// MARK: - SeriesCreditResponse
struct SeriesCreditResponse: Codable {
    let cast, crew: [CreditTvShow]?
    let id: Int?
    
    static func empty() -> SeriesCreditResponse {
        return SeriesCreditResponse(cast: [], crew: [], id: nil)
    }
}

// MARK: - Cast
struct CreditTvShow: Codable {
    let name, originalName: String?
    let originCountry: [String]?
    let backdropPath: String?
    let firstAirDate: String?
    let id, voteCount: Int?
    let posterPath: String?
    let genreIDS: [Int]?
    let originalLanguage: String?
    let voteAverage: Double?
    let overview: String?
    let popularity: Double?
    let character, creditID: String?
    let episodeCount: Int?
    let department, job: String?

    enum CodingKeys: String, CodingKey {
        case name
        case originalName = "original_name"
        case originCountry = "origin_country"
        case backdropPath = "backdrop_path"
        case firstAirDate = "first_air_date"
        case id
        case voteCount = "vote_count"
        case posterPath = "poster_path"
        case genreIDS = "genre_ids"
        case originalLanguage = "original_language"
        case voteAverage = "vote_average"
        case overview, popularity, character
        case creditID = "credit_id"
        case episodeCount = "episode_count"
        case department, job
    }
    
    public func toMovieResult() -> MovieResult {
        return MovieResult(adult: false, backdropPath: self.backdropPath, genreIDS: self.genreIDS, id: self.id, originalLanguage: self.originalLanguage, originalTitle: self.originalName, overview: self.overview, popularity: self.popularity, posterPath: self.posterPath, releaseDate: self.firstAirDate, title: self.name, name: self.name, originalName: self.originalName, video: false, voteAverage: self.voteAverage, voteCount: self.voteCount)
    }
}

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let upcomingMovieList = try? newJSONDecoder().decode(UpcomingMovieList.self, from: jsonData)

import Foundation

// MARK: - UpcomingMovieList
struct MovieListResponse: Codable {
    let dates: Dates?
    let page: Int?
    let results: [MovieResult]?
    let totalPages, totalMovies: Int?

    enum CodingKeys: String, CodingKey {
        case dates, page, results
        case totalPages = "total_pages"
        case totalMovies = "total_movies"
    }
    
    static func empty() -> MovieListResponse {
        return MovieListResponse(dates: nil, page: nil, results: nil, totalPages: nil, totalMovies: nil)
    }
}

// MARK: - Dates
struct Dates: Codable {
    let maximum, minimum: String?
}

// MARK: - Movie
struct MovieResult: Codable, Hashable {
    let adult: Bool?
    let backdropPath: String?
    let genreIDS: [Int]?
    let id: Int?
    let originalLanguage: String?
    let originalTitle, overview: String?
    let popularity: Double?
    let posterPath, releaseDate, title, name, originalName: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video,name
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case originalName = "original_name"
    }
}

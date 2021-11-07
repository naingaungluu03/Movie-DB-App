// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let seriesDetailResponse = try? newJSONDecoder().decode(SeriesDetailResponse.self, from: jsonData)

import Foundation

// MARK: - SeriesDetailResponse
struct SeriesDetailResponse: Codable {
    let backdropPath: String?
    let createdBy: [CreatedBy]?
    let episodeRunTime: [Int]?
    let firstAirDate: String?
    let genres: [GenreVO]?
    let homepage: String?
    let id: Int?
    let inProduction: Bool?
    let languages: [String]?
    let lastAirDate: String?
    let lastEpisodeToAir: Episode?
    let name: String?
    let nextEpisodeToAir: Episode?
    let networks: [Network]?
    let numberOfEpisodes, numberOfSeasons: Int?
    let originCountry: [String]?
    let originalLanguage, originalName, overview: String?
    let popularity: Double?
    let posterPath: String?
    let productionCompanies: [ProductionCompany]?
    let productionCountries: [ProductionCountry]?
    let seasons: [Season]?
    let spokenLanguages: [SpokenLanguage]?
    let status, tagline, type: String?
    let voteAverage: Double?
    let voteCount: Int?

    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case createdBy = "created_by"
        case episodeRunTime = "episode_run_time"
        case firstAirDate = "first_air_date"
        case genres, homepage, id
        case inProduction = "in_production"
        case languages
        case lastAirDate = "last_air_date"
        case lastEpisodeToAir = "last_episode_to_air"
        case name
        case nextEpisodeToAir = "next_episode_to_air"
        case networks
        case numberOfEpisodes = "number_of_episodes"
        case numberOfSeasons = "number_of_seasons"
        case originCountry = "origin_country"
        case originalLanguage = "original_language"
        case originalName = "original_name"
        case overview, popularity
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case seasons
        case spokenLanguages = "spoken_languages"
        case status, tagline, type
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    
    func toMovieDetailResponse() -> MovieDetailVO {
        return MovieDetailVO(
            adult: false,
            backdropPath: self.backdropPath,
            belongsToCollection: nil,
            budget: nil,
            genres: genres,
            homepage: homepage,
            id: id,
            imdbID: nil,
            originalLanguage: originalLanguage,
            originalTitle: originalName,
            overview: overview,
            popularity: popularity,
            posterPath: posterPath,
            productionCompanies: productionCompanies,
            productionCountries: productionCountries,
            releaseDate: nil,
            revenue: nil,
            runtime: nil,
            spokenLanguages: spokenLanguages,
            status: status,
            tagline: tagline,
            title: nil,
            type: type,
            video: nil,
            voteAverage: voteAverage,
            voteCount: voteCount,
            createdBy: createdBy,
            episodeRunTime: episodeRunTime,
            firstAirDate: firstAirDate,
            inProduction: inProduction,
            languages: languages,
            lastAirDate: lastAirDate,
            lastEpisodeToAir: lastEpisodeToAir,
            name: name,
            nextEpisodeToAir: nextEpisodeToAir,
            networks: networks,
            numberOfEpisodes: numberOfEpisodes,
            numberOfSeasons: numberOfSeasons,
            originCountry: originCountry,
            originalName: originalName,
            seasons: seasons)
    }
}

// MARK: - CreatedBy
struct CreatedBy: Codable {
    let id: Int?
    let creditID, name: String?
    let gender: Int?
    let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case id
        case creditID = "credit_id"
        case name, gender
        case profilePath = "profile_path"
    }
}


// MARK: - LastEpisodeToAir
struct Episode: Codable {
    let airDate: String?
    let episodeNumber, id: Int?
    let name, overview, productionCode: String?
    let seasonNumber: Int?
    let stillPath: String?
    let voteAverage: Double?
    let voteCount: Int?

    enum CodingKeys: String, CodingKey {
        case airDate = "air_date"
        case episodeNumber = "episode_number"
        case id, name, overview
        case productionCode = "production_code"
        case seasonNumber = "season_number"
        case stillPath = "still_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

// MARK: - Network
struct Network: Codable {
    let name: String?
    let id: Int?
    let logoPath: String?
    let originCountry: String?

    enum CodingKeys: String, CodingKey {
        case name, id
        case logoPath = "logo_path"
        case originCountry = "origin_country"
    }
}


// MARK: - Season
struct Season: Codable {
    let airDate: String?
    let episodeCount, id: Int?
    let name, overview, posterPath: String?
    let seasonNumber: Int?

    enum CodingKeys: String, CodingKey {
        case airDate = "air_date"
        case episodeCount = "episode_count"
        case id, name, overview
        case posterPath = "poster_path"
        case seasonNumber = "season_number"
    }
}

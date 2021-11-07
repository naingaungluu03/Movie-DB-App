// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let movieDetailVO = try? newJSONDecoder().decode(MovieDetailVO.self, from: jsonData)

import Foundation
import CoreData

// MARK: - MovieDetailVO
struct MovieDetailVO: Codable {
    let adult: Bool?
    let backdropPath: String?
    let belongsToCollection: Collection?
    let budget: Int?
    let genres: [GenreVO]?
    let homepage: String?
    let id: Int?
    let imdbID, originalLanguage, originalTitle, overview: String?
    let popularity: Double?
    let posterPath: String?
    let productionCompanies: [ProductionCompany]?
    let productionCountries: [ProductionCountry]?
    let releaseDate: String?
    let revenue, runtime: Int?
    let spokenLanguages: [SpokenLanguage]?
    let status, tagline, title, type: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
    let createdBy: [CreatedBy]?
    let episodeRunTime: [Int]?
    let firstAirDate: String?
    let inProduction: Bool?
    let languages: [String]?
    let lastAirDate: String?
    let lastEpisodeToAir: Episode?
    let name: String?
    let nextEpisodeToAir: Episode?
    let networks: [Network]?
    let numberOfEpisodes, numberOfSeasons: Int?
    let originCountry: [String]?
    let originalName : String?
    let seasons: [Season]?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case createdBy = "created_by"
        case episodeRunTime = "episode_run_time"
        case firstAirDate = "first_air_date"
        case inProduction = "in_production"
        case languages
        case lastAirDate = "last_air_date"
        case lastEpisodeToAir = "last_episode_to_air"
        case name, type
        case nextEpisodeToAir = "next_episode_to_air"
        case networks
        case numberOfEpisodes = "number_of_episodes"
        case numberOfSeasons = "number_of_seasons"
        case originCountry = "origin_country"
        case seasons
        case belongsToCollection = "belongs_to_collection"
        case budget, genres, homepage, id
        case imdbID = "imdb_id"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case originalName = "original_name"
        case overview, popularity
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case releaseDate = "release_date"
        case revenue, runtime
        case spokenLanguages = "spoken_languages"
        case status, tagline, title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    
    func toSeriesDetailResponse() -> SeriesDetailResponse {
        return SeriesDetailResponse(
            backdropPath: self.backdropPath,
            createdBy: self.createdBy,
            episodeRunTime: self.episodeRunTime,
            firstAirDate: self.firstAirDate,
            genres: self.genres,
            homepage: self.homepage,
            id: self.id,
            inProduction: self.inProduction,
            languages: self.languages,
            lastAirDate: self.lastAirDate,
            lastEpisodeToAir: self.lastEpisodeToAir,
            name: self.name,
            nextEpisodeToAir: self.nextEpisodeToAir,
            networks: self.networks,
            numberOfEpisodes: self.numberOfEpisodes,
            numberOfSeasons: self.numberOfSeasons,
            originCountry: self.originCountry,
            originalLanguage: self.originalLanguage,
            originalName: self.originalName,
            overview: self.overview,
            popularity: self.popularity,
            posterPath: self.posterPath,
            productionCompanies: self.productionCompanies,
            productionCountries: self.productionCountries,
            seasons: self.seasons,
            spokenLanguages: self.spokenLanguages,
            status: self.status,
            tagline: self.tagline,
            type: self.type,
            voteAverage: self.voteAverage,
            voteCount: self.voteCount)
    }
    
    func toMovieEntity(context : NSManagedObjectContext) -> MovieEntity {
        let entity = MovieEntity(context: context)
        entity.adult = adult ?? false
        entity.backdropPath = backdropPath
        entity.budget = Int64(budget ?? 0)
        entity.homepage = homepage
        entity.id = Int64(id ?? 0)
        entity.imdbID = imdbID
        entity.originalLanguage = originalLanguage
        entity.originalTitle = originalTitle
        entity.overview = overview
        entity.popularity = popularity ?? 0
        entity.posterPath = posterPath
        entity.releaseDate = releaseDate
        entity.revenue = Int64(revenue ?? 0)
        entity.runtime = Int64(runtime ?? 0)
        entity.status = status
        entity.tagline = tagline
        entity.title = title
        entity.video = video ?? false
        entity.voteCount = Int64(voteCount ?? 0)
        entity.voteAverage = voteAverage ?? 0
        entity.numberOfEpisodes = Int64(numberOfEpisodes ?? 0)
        entity.numberOfSeasons = Int64(numberOfSeasons ?? 0)
        return entity
    }
    
}

// MARK: - ProductionCompany
struct ProductionCompany: Codable {
    let id: Int?
    let logoPath: String?
    let name, originCountry: String?

    enum CodingKeys: String, CodingKey {
        case id
        case logoPath = "logo_path"
        case name
        case originCountry = "origin_country"
    }
}

// MARK: - ProductionCountry
struct ProductionCountry: Codable {
    let iso3166_1, name: String?

    enum CodingKeys: String, CodingKey {
        case iso3166_1 = "iso_3166_1"
        case name
    }
}

// MARK: - SpokenLanguage
struct SpokenLanguage: Codable {
    let englishName, iso639_1, name: String?

    enum CodingKeys: String, CodingKey {
        case englishName = "english_name"
        case iso639_1 = "iso_639_1"
        case name
    }
}


// MARK: - BelongsToCollection
struct Collection: Codable {
    let id: Int?
    let name, posterPath, backdropPath: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
    }
}

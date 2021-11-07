//
//  MovieEntityExtensions.swift
//  Hello World
//
//  Created by Harry Jason on 21/08/2021.
//

import Foundation
extension MovieEntity {
    func toMovieResult() -> MovieResult {
        var genreIdList = [Int]()
        if let genreList = self.genres as? Set<GenreEntity> {
            genreIdList = genreList.map({ genre in
                return Int(genre.id)
            })
        }
        return MovieResult(
            adult: adult,
            backdropPath: backdropPath,
            genreIDS: genreIdList,
            id: Int(id),
            originalLanguage: originalLanguage,
            originalTitle: originalTitle,
            overview: overview,
            popularity: popularity,
            posterPath: posterPath,
            releaseDate: releaseDate,
            title: title,
            name: name,
            originalName: originalName,
            video: video,
            voteAverage: voteAverage,
            voteCount: Int(voteCount)
        )
    }
    
    func toMovieDetailVO() -> MovieDetailVO {
        var genresList = [GenreVO]()
        if let genreEntities = self.genres as? Set<GenreEntity> {
            genresList = genreEntities.map({ genre in
                return GenreVO(id: Int(genre.id), name: genre.name ?? "", isSelected: false)
            })
        }
        let collection = Collection(
            id: Int(belongsToCollection?.id ?? 0),
            name: belongsToCollection?.name,
            posterPath: belongsToCollection?.posterPath,
            backdropPath: belongsToCollection?.backdropPath
        )
        var productionCompanyList = [ProductionCompany]()
        if let productionCompanies = productionCompanies as? Set<ProductionCompanyEntity> {
            productionCompanyList = productionCompanies.map({ company in
                return ProductionCompany(
                    id: Int(company.id),
                    logoPath: company.logoPath,
                    name: company.name,
                    originCountry: company.originCountry
                )
            })
        }
        
        var productionCountryList = [ProductionCountry]()
        if let productionCountries = productionCountry as? Set<ProductionCountryEntity> {
            productionCountryList = productionCountries.map({ country in
                return ProductionCountry(iso3166_1: country.iso3166_1, name: country.name)
            })
        }
        
        var spokenLangugageList = [SpokenLanguage]()
        if let spokenLanguages = spokenLanguages as? Set<SpokenLanguageEntity> {
            spokenLangugageList = spokenLanguages.map({ language in
                return SpokenLanguage(englishName: language.englishName, iso639_1: language.iso639_1, name: language.name)
            })
        }
        
        return MovieDetailVO(
            adult: adult,
            backdropPath: backdropPath,
            belongsToCollection: collection,
            budget: Int(budget),
            genres: genresList,
            homepage: homepage,
            id: Int(id),
            imdbID: imdbID,
            originalLanguage: originalLanguage,
            originalTitle: originalTitle,
            overview: overview,
            popularity: popularity,
            posterPath: posterPath,
            productionCompanies: productionCompanyList,
            productionCountries: productionCountryList,
            releaseDate: releaseDate,
            revenue: Int(revenue),
            runtime: Int(runtime),
            spokenLanguages: spokenLangugageList,
            status: status,
            tagline: tagline,
            title: title,
            type: nil,
            video: video,
            voteAverage: voteAverage,
            voteCount: Int(voteCount),
            createdBy: [],
            episodeRunTime: [],
            firstAirDate: firstAirDate,
            inProduction: nil,
            languages: [],
            lastAirDate: lastAirDate,
            lastEpisodeToAir: nil,
            name: name,
            nextEpisodeToAir: nil,
            networks: nil,
            numberOfEpisodes: Int(numberOfEpisodes),
            numberOfSeasons: Int(numberOfSeasons),
            originCountry: [],
            originalName: originalName,
            seasons: nil)
    }
}

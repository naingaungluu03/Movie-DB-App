//
//  RxMovieRepository.swift
//  Hello World
//
//  Created by Harry Jason on 26/09/2021.
//

import Foundation
import RxSwift
import RxCoreData
import CoreData

protocol RxMovieRepository {
    func getDetail (id : Int) -> Observable<MovieDetailVO>
    func saveDetail (_ detail : MovieDetailVO)
    func saveList(groupType : MovieSeriesGroupType, data : MovieListResponse)
    func saveSimilarContent(id: Int , data : [MovieResult])
    func getSimilarContent(id : Int) -> Observable<[MovieResult]>
    func saveCast(id: Int , data : [Cast])
    func getCast(id: Int) -> Observable<[Cast]>
    func getMoviesByPage(pageNo page : Int) -> Observable<[MovieResult]>
    func getMoviesPageCount() -> Observable<Int>
}

class RxMovieRepositoryImpl : BaseRepository , RxMovieRepository {
    
    static var sharedRepository = RxMovieRepositoryImpl()

    let genreRepository = GenreRepositoryImpl.sharedGenreRepository
    
    let contentRepositor = ContentTypeRepositoryImpl.shared
    
    private let pageSize = 20
    
    private override init() { }
    
    
    func getDetail (id : Int) -> Observable<MovieDetailVO> {
        return coreData.context.rx.entities(fetchRequest: getMovieDetailFetchRequestById(id: id))
            .compactMap{ $0 }
            .compactMap { movies in
                return movies.first?.toMovieDetailVO()
            }
    }
    
    func saveDetail (_ detail : MovieDetailVO) {
        let entity = detail.toMovieEntity(context: coreData.context)
        
        let belongsToCollectionEntity = CollectionEntity(context: coreData.context)
        belongsToCollectionEntity.id = Int64(detail.belongsToCollection?.id ?? 0)
        belongsToCollectionEntity.backdropPath = detail.belongsToCollection?.backdropPath
        belongsToCollectionEntity.name = detail.belongsToCollection?.name
        belongsToCollectionEntity.posterPath = detail.belongsToCollection?.posterPath
        entity.belongsToCollection = belongsToCollectionEntity
        
        detail.productionCountries?.forEach({ country in
            let countryEntity = ProductionCountryEntity(context: coreData.context)
            countryEntity.iso3166_1 = country.iso3166_1
            countryEntity.name = country.name
            entity.addToProductionCountry(countryEntity)
        })
        
        detail.productionCompanies?.forEach({ company in
            let companyEntity = ProductionCompanyEntity(context: coreData.context)
            companyEntity.id = Int64(company.id ?? 0)
            companyEntity.name = company.name
            companyEntity.logoPath = company.logoPath
            companyEntity.originCountry = company.originCountry
            entity.addToProductionCompanies(companyEntity)
        })
        
        detail.spokenLanguages?.forEach({ language in
            let spokenLanguageEntity = SpokenLanguageEntity(context: coreData.context)
            spokenLanguageEntity.name = language.name
            spokenLanguageEntity.iso639_1 = language.iso639_1
            spokenLanguageEntity.englishName = language.name
            entity.addToSpokenLanguages(spokenLanguageEntity)
        })
        
        coreData.saveContext()
    }
    
    func saveList(groupType : MovieSeriesGroupType, data : MovieListResponse) {
        data.results?.forEach({ movieResult in
            let entity = MovieEntity(context: coreData.context)
            entity.id = Int64(movieResult.id ?? 0)
            entity.name = movieResult.name
            entity.adult = movieResult.adult ?? false
            entity.backdropPath = movieResult.backdropPath
            entity.originalLanguage = movieResult.originalLanguage ?? ""
            entity.originalTitle = movieResult.originalTitle
            entity.originalName = movieResult.originalName
            entity.overview = movieResult.overview
            entity.popularity = movieResult.popularity ?? 0
            entity.posterPath = movieResult.posterPath
            entity.releaseDate = movieResult.releaseDate
            entity.title = movieResult.title
            entity.video = movieResult.video ?? false
            entity.voteAverage = movieResult.voteAverage ?? 0
            entity.voteCount = Int64(movieResult.voteCount ?? 0)
            let belongsToEntity = contentRepositor.getBelongsToTypeEntity(type: groupType)
            entity.addToBelongsToType(belongsToEntity)
            genreRepository.getGenreEntities { genres in
                genres.forEach { genre in
                    entity.addToGenres(genre)
                }
            }
        })
        
        coreData.saveContext()
    }
    
    func saveSimilarContent(id: Int , data : [MovieResult]) {
        do {
            let movieEntity = try coreData.context.fetch(getMovieDetailFetchRequestById(id: id))
            
            if let movie = movieEntity.first {
                data.forEach { similarMovie in
                    let entity = MovieEntity(context: coreData.context)
                    entity.id = Int64(similarMovie.id ?? 0)
                    entity.name = similarMovie.name
                    entity.adult = similarMovie.adult ?? false
                    entity.backdropPath = similarMovie.backdropPath
                    entity.originalLanguage = similarMovie.originalLanguage ?? ""
                    entity.originalTitle = similarMovie.originalTitle
                    entity.originalName = similarMovie.originalName
                    entity.overview = similarMovie.overview
                    entity.popularity = similarMovie.popularity ?? 0
                    entity.posterPath = similarMovie.posterPath
                    entity.releaseDate = similarMovie.releaseDate
                    entity.title = similarMovie.title
                    entity.video = similarMovie.video ?? false
                    entity.voteAverage = similarMovie.voteAverage ?? 0
                    entity.voteCount = Int64(similarMovie.voteCount ?? 0)
                    genreRepository.getGenreEntities { genres in
                        genres.forEach { genre in
                            entity.addToGenres(genre)
                        }
                    }
                    movie.addToSimilarMovies(entity)
                }
                coreData.saveContext()
            }
            
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func getSimilarContent(id : Int) -> Observable<[MovieResult]> {
        return coreData.context.rx.entities(fetchRequest: getMovieDetailFetchRequestById(id: id))
            .compactMap { $0.first?.similarMovies as? Set<MovieEntity> } // Filter out Results
            .map { similarMovieList in
                similarMovieList.map({ similarMovie in
                    similarMovie.toMovieResult()
                })
            }
    }
    
    func saveCast(id: Int , data : [Cast]) {
        do {
            
            let movieEntity = try coreData.context.fetch(getMovieDetailFetchRequestById(id: id))
            
            if let movie = movieEntity.first {
                data.forEach({ cast in
                    let entity = ActorEntity(context: coreData.context)
                    entity.id = Int64(cast.castID ?? 0)
                    entity.name = cast.name
                    entity.adult = cast.adult ?? false
                    entity.gender = Int64(cast.gender ?? 0)
                    entity.knownForDepartment = cast.knownForDepartment ?? ""
                    entity.originalName = cast.originalName
                    entity.popularity = cast.popularity ?? 0
                    entity.profilePath = cast.profilePath
                    entity.character = cast.character
                    entity.creditId = cast.creditID
                    entity.order = Int64(cast.order ?? 0)
                    entity.department = cast.department ?? ""
                    entity.job = cast.job
                    movie.addToCasts(entity)
                    coreData.saveContext()
                })
            }
            
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func getCast(id: Int) -> Observable<[Cast]> {
        return coreData.context.rx.entities(fetchRequest: getMovieDetailFetchRequestById(id: id))
            .compactMap { $0.first?.casts as? Set<ActorEntity> } // Filter out movie Result
            .map { casts in
                casts.map { cast in
                    cast.toCast()
                }.sorted(by: { first, second in
                    return first.popularity ?? 0 > second.popularity ?? 0
                })
            }
    }
    
    func getMoviesByPage(pageNo page : Int) -> Observable<[MovieResult]> {
        let fetchRequest : NSFetchRequest = MovieEntity.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "voteAverage", ascending: false),
        ]
        
        fetchRequest.fetchLimit = pageSize
        fetchRequest.fetchOffset = (pageSize * page) - pageSize
     
        return coreData.context.rx.entities(fetchRequest: fetchRequest)
            .map { movies in
                movies.map { $0.toMovieResult()}
            }
    }
    
    func getMoviesPageCount() -> Observable<Int> {
        let belongsToType = self.contentRepositor.getBelongsToTypeEntity(type: .MOVIE_TOP_RATED)
        if let movieCount = belongsToType.movies?.count {
            return Observable.just(movieCount / pageSize)
        }
        return Observable.just(0)
    }

    func getMovieDetailFetchRequestById(id: Int) -> NSFetchRequest<MovieEntity>  {
        coreData.context.reset()
        let fetchRequest : NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", NSNumber(integerLiteral: id))
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "popularity", ascending: false)
        ]
        
        return fetchRequest
    }

}

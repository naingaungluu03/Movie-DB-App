//
//  MovieRepository.swift
//  Hello World
//
//  Created by Harry Jason on 21/08/2021.
//

import Foundation
import CoreData

protocol MovieRepository {
    func getDetail (id : Int , completion : @escaping (MovieDetailVO?) -> Void )
    func saveDetail (_ detail : MovieDetailVO)
    func saveList(groupType : MovieSeriesGroupType, data : MovieListResponse)
    func saveSimilarContent(id: Int , data : [MovieResult])
    func getSimilarContent(id : Int , completion : @escaping ([MovieResult]) -> Void)
    func saveCast(id: Int , data : [Cast])
    func getCast(id: Int , completion: @escaping ([Cast]) -> Void)
    func getMoviesByPage(pageNo page : Int , completion : @escaping ([MovieResult]) -> Void)
    func getMoviesPageCount(completion : (Int) -> Void)
}

class MovieRepositoryImpl : BaseRepository, MovieRepository {
    
    
    static var sharedMovieRepository = MovieRepositoryImpl()

    let genreRepository = GenreRepositoryImpl.sharedGenreRepository
    
    let contentRepositor = ContentTypeRepositoryImpl.shared
    
    private let pageSize = 20
    
    private override init() { }
    
    func getDetail(id: Int, completion: @escaping (MovieDetailVO?) -> Void) {
        do {
            let movieEntity = try coreData.context.fetch(getMovieDetailFetchRequestById(id: id))
            
            if let movie = movieEntity.first {
                completion(movie.toMovieDetailVO())
            }
        } catch {
            fatalError("Can't find Data")
        }
    }
    
    func saveDetail(_ detail: MovieDetailVO) {
        
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
    
    func saveList(groupType : MovieSeriesGroupType, data: MovieListResponse) {
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
    
    func saveSimilarContent(id: Int, data: [MovieResult]) {
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
    
    func getSimilarContent(id: Int, completion: @escaping ([MovieResult]) -> Void) {
        do {
            
            let movieEntity = try self.coreData.context.fetch(getMovieDetailFetchRequestById(id: id))
            
            if let movie = movieEntity.first {
                if let similarMovieList = movie.similarMovies as? Set<MovieEntity> {
                    completion(
                        similarMovieList.map({ similarMovie in
                            similarMovie.toMovieResult()
                        })
                    )
                }
            }
            
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func saveCast(id: Int, data: [Cast]) {
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
    
    func getCast(id: Int, completion: @escaping ([Cast]) -> Void) {
        
        do {
            
            let movieEntity = try self.coreData.context.fetch(getMovieDetailFetchRequestById(id: id))
            
            if let movie = movieEntity.first {
                if let casts = movie.casts {
                    completion(
                        casts.map { cast in
                            return (cast as! ActorEntity).toCast()
                        }.sorted(by: { first, second in
                            return first.popularity ?? 0 > second.popularity ?? 0
                        })
                    )
                }
            }
            
        } catch {
            fatalError(error.localizedDescription)
        }
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
    
    
    func getMoviesByPage(pageNo page: Int = 1, completion: @escaping ([MovieResult]) -> Void) {
        let fetchRequest : NSFetchRequest = MovieEntity.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "voteAverage", ascending: false),
        ]
        
        fetchRequest.fetchLimit = pageSize
        fetchRequest.fetchOffset = (pageSize * page) - pageSize
        
        do {
            let actorList = try coreData.context.fetch(fetchRequest)
            completion(actorList.map { return $0.toMovieResult()})
            
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func getMoviesPageCount(completion : (Int) -> Void) {
        let belongsToType = contentRepositor.getBelongsToTypeEntity(type: .MOVIE_TOP_RATED)
            if let movieCount = belongsToType.movies?.count {
                completion(movieCount / pageSize)
        }

    }
    
}

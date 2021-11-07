//
//  ActorRepository.swift
//  Hello World
//
//  Created by Harry Jason on 21/08/2021.
//

import Foundation
import CoreData

protocol ActorRepository {
 
    func getList(page : Int , completion : @escaping ([ActorInfoResponse]) -> Void)
    func saveList(list : [ActorInfoResponse])
    func saveDetails(data : ActorDetailResponse)
    func getDetails(id : Int , completion : @escaping (ActorDetailResponse?) -> Void)
    func getTotalPageActorList(completion : @escaping (Int) -> Void)
    func saveTvShowsByActor(_ id : Int , data : [MovieResult])
    func getTvShowsByActor(_ id : Int , completion : @escaping ([MovieResult]) -> Void)
}

class ActorRepositoryImpl : BaseRepository , ActorRepository {
    
    static var sharedActorRepository = ActorRepositoryImpl()
    
    private var pageSize : Int = 20
    
    private override init() { }

    func getList(page: Int, completion: @escaping ([ActorInfoResponse]) -> Void) {
        let fetchRequest : NSFetchRequest = ActorEntity.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "popularity", ascending: false),
        ]
        
        fetchRequest.fetchLimit = pageSize
        fetchRequest.fetchOffset = (pageSize * page) - pageSize
        
        do {
            let actorList = try coreData.context.fetch(fetchRequest)
            completion(actorList.map { return $0.toActorInfoResponse()})
            
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func saveList(list: [ActorInfoResponse]) {
        list.forEach({ actor in
            let entity = ActorEntity(context: coreData.context)
            entity.id = Int64(actor.id ?? 0)
            entity.name = actor.name
            entity.adult = actor.adult ?? false
            entity.gender = Int64(actor.gender ?? 0)
            entity.knownForDepartment = actor.knownForDepartment ?? ""
            entity.popularity = actor.popularity ?? 0
            entity.profilePath = actor.profilePath
        })
        coreData.saveContext()
    }
    
    func saveDetails(data: ActorDetailResponse) {
        let entity = ActorEntity(context: coreData.context)
        entity.id = Int64(data.id ?? 0)
        entity.imdbId = data.imdbID ?? ""
        entity.name = data.name ?? ""
        entity.adult = data.adult ?? false
        entity.gender = Int64(data.gender ?? 0)
        entity.knownForDepartment = data.knownForDepartment ?? ""
        entity.popularity = data.popularity ?? 0
        entity.profilePath = data.profilePath
        entity.biography = data.biography ?? ""
        entity.placeOfBirth = data.placeOfBirth
        coreData.saveContext()
    }
    
    func getDetails(id: Int, completion: @escaping (ActorDetailResponse?) -> Void) {
        let fetchRequest : NSFetchRequest = ActorEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", NSNumber(integerLiteral: id))
        
        do {
            let actorList = try coreData.context.fetch(fetchRequest)
            if let actor = actorList.first {
                completion(actor.toActorDetailResponse())
            }
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func getTotalPageActorList(completion: @escaping (Int) -> Void) {
        let fetchRequest : NSFetchRequest = ActorEntity.fetchRequest()
        do {
            let count = try coreData.context.count(for: fetchRequest)
            completion(count / pageSize)
        } catch {
            print("\(#function) , \(error.localizedDescription)")
        }
    }
    
    func saveTvShowsByActor(_ id : Int ,data : [MovieResult] ) {
        let fetchRequest : NSFetchRequest<ActorEntity> = getActorDetailFetchRequestById(id: id)
        
        do {
            let results = try coreData.context.fetch(fetchRequest)
            if let actor = results.first {
                data.forEach { movie in
                    let entity = movieResultToMovieEntity(movie: movie)
                    actor.addToKnownFor(entity)
                }
                coreData.saveContext()
            }
        } catch {
            print("\(#function) , \(error.localizedDescription)")
        }
    }
    
    
    func getTvShowsByActor(_ id : Int , completion : @escaping ([MovieResult]) -> Void) {
        
        let fetchRequest : NSFetchRequest<ActorEntity> = getActorDetailFetchRequestById(id: id)
        
        do {
            let results = try coreData.context.fetch(fetchRequest)
            if let actor = results.first {
                if let tvShowByActor = actor.knownFor as? Set<MovieEntity> {
                    completion(
                        tvShowByActor.map { movie in
                            movie.toMovieResult()
                        }.sorted(by: { firstMovie, secondMovie in
                            return firstMovie.voteAverage ?? 0 > secondMovie.voteAverage ?? 0
                        })
                    )
                }
            }
            
        } catch {
            print("\(#function) , \(error.localizedDescription)")
        }
    }
    
    private func getActorDetailFetchRequestById(id : Int) -> NSFetchRequest<ActorEntity> {
        let fetchRequest : NSFetchRequest<ActorEntity> = ActorEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", NSNumber(integerLiteral: id))
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "popularity", ascending: false)
        ]
        
        return fetchRequest
    }
    
    private func movieResultToMovieEntity(movie : MovieResult) -> MovieEntity {
        let entity = MovieEntity(context: coreData.context)
        entity.id = Int64(movie.id ?? 0)
        entity.name = movie.name
        entity.adult = movie.adult ?? false
        entity.backdropPath = movie.backdropPath
        entity.originalLanguage = movie.originalLanguage ?? ""
        entity.originalTitle = movie.originalTitle
        entity.originalName = movie.originalName
        entity.overview = movie.overview
        entity.popularity = movie.popularity ?? 0
        entity.posterPath = movie.posterPath
        entity.releaseDate = movie.releaseDate
        entity.title = movie.title
        entity.video = movie.video ?? false
        entity.voteAverage = movie.voteAverage ?? 0
        entity.voteCount = Int64(movie.voteCount ?? 0)
        GenreRepositoryImpl.sharedGenreRepository.getGenreEntities { genres in
            genres.forEach { genre in
                entity.addToGenres(genre)
            }
        }
        return entity
    }
        
    
}

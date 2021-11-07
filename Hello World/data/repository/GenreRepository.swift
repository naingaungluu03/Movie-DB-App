//
//  GenreRepository.swift
//  Hello World
//
//  Created by Harry Jason on 21/08/2021.
//

import Foundation
import CoreData

protocol GenreRepository {
    func save(_ data  : MovieGenreList)
    func get(completion: @escaping ([MovieGenre]) -> Void)
    func getGenreEntities(completion: @escaping ([GenreEntity]) -> Void)
}

class GenreRepositoryImpl : BaseRepository , GenreRepository {
    
    static var sharedGenreRepository = GenreRepositoryImpl()
    
    private override init() { }

        
    func save(_ data: MovieGenreList) {
        data.genres.forEach { genre in
            let entity = GenreEntity(context: coreData.context)
            entity.id = Int64(genre.id)
            entity.name = genre.name
        }
        coreData.saveContext()
    }
    
    func get(completion: @escaping ([MovieGenre]) -> Void) {
        let fetchRequest : NSFetchRequest<GenreEntity> = GenreEntity.fetchRequest()
        
        do {
            let genreList = try coreData.context.fetch(fetchRequest)
            
            completion(
                genreList.map { genreEntity in
                    genreEntity.toMovieGenre()
                }
            )
            
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func getGenreEntities(completion: @escaping ([GenreEntity]) -> Void) {
        let fetchRequest : NSFetchRequest<GenreEntity> = GenreEntity.fetchRequest()
        
        do {
            let genreList = try coreData.context.fetch(fetchRequest)
            
            completion(genreList)
            
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
}

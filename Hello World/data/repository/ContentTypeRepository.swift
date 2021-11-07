//
//  ContentTypeRepository.swift
//  Hello World
//
//  Created by Harry Jason on 21/08/2021.
//

import Foundation
import CoreData

protocol ContentTypeRepository {
    func save(name : String) -> BelongsToTypeEntity
    func getMoviesOrSeries(type : MovieSeriesGroupType, completion : @escaping ([MovieResult]) -> Void)
    func getBelongsToTypeEntity(type : MovieSeriesGroupType) -> BelongsToTypeEntity
}

class ContentTypeRepositoryImpl : BaseRepository , ContentTypeRepository {
    
    static let shared : ContentTypeRepository = ContentTypeRepositoryImpl()
    
    private var contentMap = [String : BelongsToTypeEntity]()
    
    private override init() {
        super.init()
        initializeData()
    }
    
    private func initializeData() {
        //Check Existing Data from database
        let fetchRequest : NSFetchRequest<BelongsToTypeEntity> = BelongsToTypeEntity.fetchRequest()
        
        do {
            let dataSource = try self.coreData.context.fetch(fetchRequest)
            
            if dataSource.isEmpty {
                MovieSeriesGroupType.allCases.forEach {
                    save(name: $0.rawValue)
                }
            } else {
                dataSource.forEach {
                    if let key = $0.name {
                        contentMap[key] = $0
                    }
                }
                
            }
            
        } catch {
            print(error)
        }
        
    }
    
    @discardableResult
    func save(name: String) -> BelongsToTypeEntity {
        let entity = BelongsToTypeEntity(context: coreData.context)
        entity.name = name
        
        contentMap[name] = entity
        
        coreData.saveContext()
        
        return entity
    }
    
    func getMoviesOrSeries(type: MovieSeriesGroupType, completion: @escaping ([MovieResult]) -> Void) {
        
        if let entity = contentMap[type.rawValue],
           let movies = entity.movies,
           let itemSet = movies as? Set<MovieEntity>
        {
            completion(
                Array(
                    itemSet.sorted(by: { firstItem, secondItem in
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        let firstDate = dateFormatter.date(from: firstItem.releaseDate ?? "") ?? Date()
                        let secondDate = dateFormatter.date(from: secondItem.releaseDate ?? "") ?? Date()
                        return firstDate.compare(secondDate) == .orderedDescending
                    })
                ).map({ movieEntity in
                    movieEntity.toMovieResult()
                })
            )
            
        } else {
            completion([MovieResult]())
        }
        
    }
    
    func getBelongsToTypeEntity(type: MovieSeriesGroupType) -> BelongsToTypeEntity {
        if let entity = contentMap[type.rawValue] {
            return entity
        } else {
            return save(name: type.rawValue)
        }
    }
    
    
}

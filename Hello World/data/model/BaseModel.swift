//
//  BaseModel.swift
//  Hello World
//
//  Created by Harry Jason on 21/08/2021.
//

import Foundation
class BaseModel : NSObject {
    
    let networkAgent = AlamofireNetworkAgent.shared
    let rxNetworkAgent = RxNetworkAgent.shared
    
    let movieRepository = MovieRepositoryImpl.sharedMovieRepository
    let rxMovieRepository = RxMovieRepositoryImpl.sharedRepository
    let genreRepository = GenreRepositoryImpl.sharedGenreRepository
    let actorRepository = ActorRepositoryImpl.sharedActorRepository
    let contentTypeRepository = ContentTypeRepositoryImpl.shared
}

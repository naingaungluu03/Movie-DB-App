//
//  ActorModel.swift
//  Hello World
//
//  Created by Harry Jason on 21/08/2021.
//

import Foundation
protocol ActorModel {
    var totalPageActorList : Int { get set }
    
    func getPopularPeople(pageNo page: Int, onComplete : @escaping (MovieDbResult<[ActorInfoResponse]>) -> Void)
    func getActorDetails(_ id: Int, onComplete : @escaping (MovieDbResult<ActorDetailResponse>) -> Void)
    func getTVShowsByActor(_ id : Int , onComplete : @escaping (MovieDbResult<[MovieResult]>) -> Void)
    func getActorList(pageNo page: Int, onComplete : @escaping (MovieDbResult<ActorListResponse>) -> Void)
}

class ActorModelImpl : BaseModel , ActorModel {

    private override init() {}
    
    static let sharedModel = ActorModelImpl()
        
    var totalPageActorList: Int = 1
    
    func getPopularPeople(pageNo page: Int, onComplete: @escaping (MovieDbResult<[ActorInfoResponse]>) -> Void) {
        var networkResult = [ActorInfoResponse]()
        networkAgent.getActorList(pageNo: page) { response in
            switch response {
            case .success(let data) :
                networkResult = data.results ?? []
                self.actorRepository.saveList(list: networkResult)
                self.totalPageActorList = data.totalPages ?? 1
            case .failure(let error) :
                print(error)
            }
        }
        
        self.actorRepository.getList(page: page) { result in
            onComplete(.success(result))
        }
        
        if networkResult.isEmpty {
            self.actorRepository.getTotalPageActorList { totalPage in
                self.totalPageActorList = totalPage
            }
        }
    }
    
    func getActorDetails(_ id: Int, onComplete: @escaping (MovieDbResult<ActorDetailResponse>) -> Void) {
        networkAgent.getActorDetailsById(actorId: id) { response in
            switch response {
            case .success(let result):
                self.actorRepository.saveDetails(data: result)
            case .failure(let error):
                print(error)
            }
            
            self.actorRepository.getDetails(id: id) { response in
                if let data = response {
                    onComplete(.success(data))
                }
            }
        }
        
    }
    
    func getActorList(pageNo page: Int = 1, onComplete : @escaping (MovieDbResult<ActorListResponse>) -> Void) {
        networkAgent.getActorList(pageNo: page) { response in
            var totalPages = 0
            switch response {
            case .success(let actorList):
                totalPages = actorList.totalPages ?? 0
                self.actorRepository.saveList(list: actorList.results ?? [])
                self.totalPageActorList = actorList.totalPages ?? 1
            case .failure(let error):
                onComplete(.failure(error))
            }
            self.actorRepository.getList(page: page) { actorResponse in
                onComplete(.success(
                    ActorListResponse(
                        dates: nil,
                        page: page,
                        results: actorResponse,
                        totalPages: totalPages,
                        totalMovies: nil
                    )
                ))
            }
        }
    }
    
    func getTVShowsByActor(_ id : Int , onComplete : @escaping (MovieDbResult<[MovieResult]>) -> Void) {
        networkAgent.getTvCreditsByActor(actorId : id) { result in
            switch result {
            case .success(let creditsResponse) :
                let tvShows = creditsResponse.cast?.map { tvShow in
                    return tvShow.toMovieResult()
                }
                self.actorRepository.saveTvShowsByActor(id, data: tvShows ?? [])
            case .failure(let error) :
                print(error)
            }
            self.actorRepository.getTvShowsByActor(id) { result in
                onComplete(.success(result))
            }
        }
    }
    
}

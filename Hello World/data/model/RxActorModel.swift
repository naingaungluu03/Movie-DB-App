//
//  RxActorModel.swift
//  Hello World
//
//  Created by Harry Jason on 26/09/2021.
//

import Foundation
import RxSwift
protocol RxActorModel {
    var totalPageActorList : Int { get set }
    
    func getPopularPeople(pageNo page: Int) -> Observable<[ActorInfoResponse]>
    func getActorDetails(_ id: Int) -> Observable<ActorDetailResponse>
    func getTVShowsByActor(_ id : Int) -> Observable<[MovieResult]>
    func getActorList(pageNo page: Int) -> Observable<ActorListResponse>
}
class RxActorModelImpl : BaseModel , RxActorModel {
    
    private override init() {}
    
    static let sharedModel = RxActorModelImpl()
        
    var totalPageActorList: Int = 1
    
    private let rxActorRepository = RxActorRepositoryImpl.shared
    
    func getPopularPeople(pageNo page: Int) -> Observable<[ActorInfoResponse]> {
        
//        if networkResult.isEmpty {
//            self.actorRepository.getTotalPageActorList { totalPage in
//                self.totalPageActorList = totalPage
//            }
//        }
        
        return rxNetworkAgent.getActorList(pageNo: page)
            .do { data in
                self.rxActorRepository.saveList(list: data.results ?? [])
            }
            .catchErrorJustReturn(ActorListResponse.empty())
            .flatMap { _ -> Observable<[ActorInfoResponse]> in
                return self.rxActorRepository.getList(page: page)
            }
    }
    
    func getActorDetails(_ id: Int) -> Observable<ActorDetailResponse> {
        return rxNetworkAgent.getActorDetailsById(actorId: id)
            .do { data in
                self.rxActorRepository.saveDetails(data: data)
            }
            .catchErrorJustReturn(ActorDetailResponse.empty())
            .flatMap { _ -> Observable<ActorDetailResponse> in
                return self.rxActorRepository.getDetails(id: id)
            }
    }
    
    func getTVShowsByActor(_ id : Int) -> Observable<[MovieResult]> {

        return rxNetworkAgent.getTvCreditsByActor(actorId : id)
            .do { data in
                let tvShows = data.cast?.map { tvShow in
                    return tvShow.toMovieResult()
                }
                self.rxActorRepository.saveTvShowsByActor(id, data: tvShows ?? [])
            }
            .catchErrorJustReturn(SeriesCreditResponse.empty())
            .flatMap { _ -> Observable<[MovieResult]> in
                return self.rxActorRepository.getTvShowsByActor(id)
            }
    }
    
    func getActorList(pageNo page: Int) -> Observable<ActorListResponse> {
        var totalPages = 0
        return rxNetworkAgent.getActorList(pageNo: page)
            .do { data in
                totalPages = data.totalPages ?? 0
                self.rxActorRepository.saveList(list: data.results ?? [])
                self.totalPageActorList = data.totalPages ?? 1
            }
            .catchErrorJustReturn(ActorListResponse.empty())
            .flatMap { _ -> Observable<[ActorInfoResponse]> in
                return self.rxActorRepository.getList(page: page)
            }
            .map { actorList in
                ActorListResponse(dates: nil,
                    page: page,
                    results: actorList,
                    totalPages: totalPages,
                    totalMovies: nil
                )
            }
    }
    
}

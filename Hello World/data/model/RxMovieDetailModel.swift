//
//  RxMovieDetailModel.swift
//  Hello World
//
//  Created by Harry Jason on 26/09/2021.
//

import Foundation
import RxSwift

protocol RxMovieDetailModel {
    func getMovieTrailers(id : Int) -> Observable<MovieTrailerResponse>
    func getSimilarMovies(id : Int) -> Observable<[MovieResult]>
    func getMovieCreditById(id : Int ) -> Observable<[Cast]>
    func getMovieDetailById(id : Int) -> Observable<MovieDetailVO>
    func getSeriesDetailById(id : Int) -> Observable<SeriesDetailResponse>
}

class RxMovieDetailModelImpl : BaseModel , RxMovieDetailModel {
    
    static let sharedModel = RxMovieDetailModelImpl()
        
    private override init() {}
    
    func getMovieTrailers(id : Int) -> Observable<MovieTrailerResponse>{
        return rxNetworkAgent.getMovieTrailersById(id)
    }
    
    func getSimilarMovies(id : Int) -> Observable<[MovieResult]>{
        return rxNetworkAgent.getSimilarMoviesById(id)
            .do { data in
                self.rxMovieRepository.saveSimilarContent(id: id, data: data.results ?? [])
            }.flatMap { response -> Observable<[MovieResult]> in
                return self.rxMovieRepository.getSimilarContent(id: id)
            }
    }
    
    func getMovieCreditById(id : Int ) -> Observable<[Cast]> {
        return rxNetworkAgent.getMovieCreditsById(id)
            .do { data in
                self.rxMovieRepository.saveCast(id: id, data: data.cast ?? [])
            }.flatMap { _ -> Observable<[Cast]> in
                return self.rxMovieRepository.getCast(id: id)
            }
    }
    
    func getMovieDetailById(id : Int) -> Observable<MovieDetailVO> {
        return rxNetworkAgent.getMovieDetailById(id)
            .do { data in
                self.rxMovieRepository.saveDetail(data)
            }.flatMap { _ -> Observable<MovieDetailVO> in
                self.rxMovieRepository.getDetail(id: id)
            }
    }
    
    func getSeriesDetailById(id : Int) -> Observable<SeriesDetailResponse> {
        return rxNetworkAgent.getSeriesDetailById(id)
            .do { data in
                self.rxMovieRepository.saveDetail(data.toMovieDetailResponse())
            }.flatMap { _ in
                self.rxMovieRepository.getDetail(id: id)
            }
            .map { $0.toSeriesDetailResponse()}
    }
    
}

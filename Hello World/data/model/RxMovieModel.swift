//
//  RxMovieModel.swift
//  Hello World
//
//  Created by Harry Jason on 26/09/2021.
//

import Foundation
import RxSwift

protocol RxMovieModel {
    func getUpcomingMovieList() -> Observable<[MovieResult]>
    func getPopularMovieList() -> Observable<[MovieResult]>
    func getPopularSeriesList() -> Observable<[MovieResult]>
    func getGenreList() -> Observable<MovieGenreList>
    func getTopRatedMovieList(pageNo page : Int) -> Observable<MovieListResponse>
}
class RxMovieModelImpl : BaseModel, RxMovieModel {
        
    let rxContentTypeRepository = RxContentTypeRepositoryImpl.shared
    
    static let shared = RxMovieModelImpl()
    override private init() {}
    
    func getPopularMovieList() -> Observable<[MovieResult]> {
        return rxNetworkAgent.getPopularMovieList()
            .do { data in
                self.rxMovieRepository.saveList(groupType: .MOVIE_POPULAR, data: data)
            }
            .catchErrorJustReturn(MovieListResponse.empty())
            .flatMap { _ -> Observable<[MovieResult]>  in
                return self.rxContentTypeRepository.getMoviesOrSeries(type: .MOVIE_POPULAR)
            }
    }
    
    func getUpcomingMovieList() -> Observable<[MovieResult]> {
        rxNetworkAgent.getUpcomingMovieList().do { data in
            self.rxMovieRepository.saveList(groupType: .MOVIE_UPCOMING, data: data)
        }
        return self.rxContentTypeRepository.getMoviesOrSeries(type: .MOVIE_UPCOMING)
    }
    
    func getPopularSeriesList() -> Observable<[MovieResult]> {
        return rxNetworkAgent.getPopularSeriesList()
            .do { data in
                self.rxMovieRepository.saveList(groupType: .SERIES_POPULAR, data: data)
            }
            .catchErrorJustReturn(MovieListResponse.empty())
            .flatMap { response -> Observable<[MovieResult]> in
                return self.rxContentTypeRepository.getMoviesOrSeries(type: .SERIES_POPULAR)
            }
    }
    
    func getGenreList() -> Observable<MovieGenreList> {
        return rxNetworkAgent.getGenreList()
            .do { data in
                self.genreRepository.save(data)
            }
            .catchErrorJustReturn(MovieGenreList.empty())
            .flatMap { response -> Observable<MovieGenreList> in
                return Observable.create { (observer) -> Disposable in
                    self.genreRepository.get { genres in
                        observer.onNext(MovieGenreList(genres: genres))
                        observer.onCompleted()
                    }
                    return Disposables.create()
                }
            }
    }
    
    func getTopRatedMovieList(pageNo page: Int) -> Observable<MovieListResponse> {
        var totalPages = 0
        return rxNetworkAgent.getTopRatedMovieList(pageNo: page)
            .do { data in
                totalPages = data.totalPages ?? 0
                self.rxMovieRepository.saveList(groupType: .MOVIE_TOP_RATED, data: data)
            }
            .catchErrorJustReturn(MovieListResponse.empty())
            .flatMap { response -> Observable<MovieListResponse> in
                let moviesObservable = self.rxMovieRepository.getMoviesByPage(pageNo: page)
                let pageCountObservable = self.rxMovieRepository.getMoviesPageCount()
                return Observable.combineLatest(moviesObservable , pageCountObservable)
                    .map { (movies, count) in
                        MovieListResponse(
                            dates: nil,
                            page: page,
                            results: movies,
                            totalPages: totalPages,
                            totalMovies: nil
                        )
                    }
            }
    }
    
    
}

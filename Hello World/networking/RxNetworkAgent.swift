//
//  RxNetworkAgent.swift
//  Hello World
//
//  Created by Harry Jason on 11/09/2021.
//

import Foundation
import RxSwift
import Alamofire
import RxAlamofire

protocol RxMovieDbNetworkAgent {
    func getUpcomingMovieList() -> Observable<MovieListResponse>
    func getPopularMovieList() -> Observable<MovieListResponse>
    func getPopularSeriesList() -> Observable<MovieListResponse>
    func getGenreList() -> Observable<MovieGenreList>
    func getTopRatedMovieList(pageNo page : Int) -> Observable<MovieListResponse>
    func getActorList(pageNo page: Int) -> Observable<ActorListResponse>
    func getActorDetailsById(actorId id: Int) -> Observable<ActorDetailResponse>
    func getTvCreditsByActor(actorId id: Int) -> Observable<SeriesCreditResponse>
    func getMovieDetailById(_ id : Int) -> Observable<MovieDetailVO>
    func getSeriesDetailById(_ id : Int) -> Observable<SeriesDetailResponse>
    func getMovieCreditsById(_ id : Int) -> Observable<MovieCreditsResponse>
    func getSimilarMoviesById(_ id : Int) -> Observable<MovieListResponse>
    func getMovieTrailersById(_ id : Int) -> Observable<MovieTrailerResponse>
    func searchMovies(query : String , pageNo page: Int) -> Observable<MovieListResponse>
}

class RxNetworkAgent : RxMovieDbNetworkAgent {
    
    static let shared = RxNetworkAgent()
    
    private init() {}
    
    func getPopularMovieList() -> Observable<MovieListResponse>{
        
        return RxAlamofire
            .requestDecodable(MovieDbURL.popularMovies(1))
            .flatMap { item ->  Observable<MovieListResponse> in
                Observable.just(item.1)
            }
    }
    
    func getUpcomingMovieList() -> Observable<MovieListResponse> {
        return RxAlamofire
            .requestDecodable(MovieDbURL.upcomingMovies(1))
            .flatMap { item -> Observable<MovieListResponse> in
                Observable.just(item.1)
            }
    }
    
    func getPopularSeriesList() -> Observable<MovieListResponse> {
        return RxAlamofire
            .requestDecodable(MovieDbURL.popularTVSeries)
            .flatMap { item ->  Observable<MovieListResponse> in
                Observable.just(item.1)
            }
    }
    
    func getGenreList() -> Observable<MovieGenreList> {
        return RxAlamofire
            .requestDecodable(MovieDbURL.movieGenres)
            .flatMap { item ->  Observable<MovieGenreList> in
                Observable.just(item.1)
            }
    }
    
    func getTopRatedMovieList(pageNo page: Int) -> Observable<MovieListResponse> {
        return RxAlamofire
            .requestDecodable(MovieDbURL.topRatedMovies(page))
            .flatMap { item ->  Observable<MovieListResponse> in
                Observable.just(item.1)
            }
    }
    
    func getActorList(pageNo page: Int) -> Observable<ActorListResponse> {
        return RxAlamofire
            .requestDecodable(MovieDbURL.popularActors(page))
            .flatMap { item ->  Observable<ActorListResponse> in
                Observable.just(item.1)
            }
    }
    
    func getActorDetailsById(actorId id: Int) -> Observable<ActorDetailResponse> {
        return RxAlamofire
            .requestDecodable(MovieDbURL.actorDetails(id))
            .flatMap { item ->  Observable<ActorDetailResponse> in
                Observable.just(item.1)
            }
    }
    
    func getTvCreditsByActor(actorId id: Int) -> Observable<SeriesCreditResponse> {
        return RxAlamofire
            .requestDecodable(MovieDbURL.actorTvCredits(id))
            .flatMap { item ->  Observable<SeriesCreditResponse> in
                Observable.just(item.1)
            }
    }
    
    func getMovieDetailById(_ id: Int) -> Observable<MovieDetailVO> {
        return RxAlamofire
            .requestDecodable(MovieDbURL.movieDetails(id))
            .flatMap { item ->  Observable<MovieDetailVO> in
                Observable.just(item.1)
            }
    }
    
    func getSeriesDetailById(_ id: Int) -> Observable<SeriesDetailResponse> {
        return RxAlamofire
            .requestDecodable(MovieDbURL.seriesDetails(id))
            .flatMap { item ->  Observable<SeriesDetailResponse> in
                Observable.just(item.1)
            }
    }
    
    func getMovieCreditsById(_ id: Int) -> Observable<MovieCreditsResponse> {
        return RxAlamofire
            .requestDecodable(MovieDbURL.movieActors(id))
            .flatMap { item ->  Observable<MovieCreditsResponse> in
                Observable.just(item.1)
            }
    }
    
    func getSimilarMoviesById(_ id: Int) -> Observable<MovieListResponse> {
        return RxAlamofire
            .requestDecodable(MovieDbURL.similarMovie(id))
            .flatMap { item ->  Observable<MovieListResponse> in
                Observable.just(item.1)
            }
    }
    
    func getMovieTrailersById(_ id: Int) -> Observable<MovieTrailerResponse> {
        return RxAlamofire
            .requestDecodable(MovieDbURL.trailerVideo(id))
            .flatMap { item ->  Observable<MovieTrailerResponse> in
                Observable.just(item.1)
            }
    }
    
    func searchMovies(query : String , pageNo page: Int) -> Observable<MovieListResponse> {
        return RxAlamofire
            .requestDecodable(MovieDbURL.searchMovie(page, query))
            .flatMap { response -> Observable<MovieListResponse> in
                return Observable.just(response.1)
            }
    }
    
}

//
//  UrlSessionNetworkAgent.swift
//  Hello World
//
//  Created by Harry Jason on 17/07/2021.
//

import Foundation

class UrlSessionNetworkAgent : MovieDbNetworkAgentProtocol {
   
    private init() {}
    
    static let shared = UrlSessionNetworkAgent()
    
    func getUpcomingMovieList(onComplete: @escaping (MovieDbResult<MovieListResponse>) -> Void) {
        let baseUrl = URL(string: "\(NetworkConstants.BASE_URL)/movie/upcoming?api_key=mwa")!
        
        var urlRequest = URLRequest(url: baseUrl)
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            let data = try! JSONDecoder().decode(MovieListResponse.self, from: data!)
            onComplete(.success(data))
        }.resume()
    }
    
    func getPopularMovieList(onComplete: @escaping (MovieDbResult<MovieListResponse>) -> Void) {
        
    }
    
    func getPopularSeriesList(onComplete: @escaping (MovieDbResult<MovieListResponse>) -> Void) {
        
    }
    
    func getGenreList(onComplete: @escaping (MovieDbResult<MovieGenreList>) -> Void) {
        
    }
    
    func getTopRatedMovieList(pageNo page: Int = 1, onComplete: @escaping (MovieDbResult<MovieListResponse>) -> Void) {
        
    }
    
    func getActorList(pageNo page: Int = 1, onComplete: @escaping (MovieDbResult<ActorListResponse>) -> Void) {
        
    }
    
    func getActorDetailsById(actorId id: Int, onComplete: @escaping (MovieDbResult<ActorDetailResponse>) -> Void) {
        
    }
    
    func getTvCreditsByActor(actorId id: Int, onComplete: @escaping (MovieDbResult<SeriesCreditResponse>) -> Void) {
        
    }
    
    func getMovieDetailById(_ id: Int, onComplete: @escaping (MovieDbResult<MovieDetailVO>) -> Void) {
        
    }
    
    func getSeriesDetailById(_ id: Int, onComplete: @escaping (MovieDbResult<SeriesDetailResponse>) -> Void) {
        
    }
    
    func getMovieCreditsById(_ id: Int, onComplete: @escaping (MovieDbResult<MovieCreditsResponse>) -> Void) {
        
    }
    
    func getSimilarMoviesById(_ id: Int, onComplete: @escaping (MovieDbResult<MovieListResponse>) -> Void) {
        
    }
    
    func getMovieTrailersById(_ id: Int, onComplete: @escaping (MovieDbResult<MovieTrailerResponse>) -> Void) {
        
    }
    
    func searchMovie(query: String, pageNo page: Int = 1, onComplete: @escaping (MovieDbResult<MovieListResponse>) -> Void) {
        
    }
    
    
}

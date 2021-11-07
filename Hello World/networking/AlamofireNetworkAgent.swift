//
//  Network.swift
//  Hello World
//
//  Created by Harry Jason on 26/06/2021.
//

import Foundation
import Alamofire

protocol MovieDbNetworkAgentProtocol {
    func getUpcomingMovieList(onComplete : @escaping (MovieDbResult<MovieListResponse>) -> Void)
    func getPopularMovieList(onComplete : @escaping (MovieDbResult<MovieListResponse>) -> Void)
    func getPopularSeriesList(onComplete : @escaping (MovieDbResult<MovieListResponse>) -> Void)
    func getGenreList(onComplete : @escaping (MovieDbResult<MovieGenreList>) -> Void)
    func getTopRatedMovieList(pageNo page : Int, onComplete : @escaping (MovieDbResult<MovieListResponse>) -> Void)
    func getActorList(pageNo page: Int, onComplete : @escaping (MovieDbResult<ActorListResponse>) -> Void)
    func getActorDetailsById(actorId id: Int, onComplete : @escaping (MovieDbResult<ActorDetailResponse>) -> Void)
    func getTvCreditsByActor(actorId id: Int, onComplete : @escaping (MovieDbResult<SeriesCreditResponse>) -> Void)
    func getMovieDetailById(_ id : Int ,onComplete : @escaping (MovieDbResult<MovieDetailVO>) -> Void)
    func getSeriesDetailById(_ id : Int ,onComplete : @escaping (MovieDbResult<SeriesDetailResponse>) -> Void)
    func getMovieCreditsById(_ id : Int , onComplete : @escaping (MovieDbResult<MovieCreditsResponse>) -> Void)
    func getSimilarMoviesById(_ id : Int ,onComplete : @escaping (MovieDbResult<MovieListResponse>) -> Void)
    func getMovieTrailersById(_ id : Int , onComplete : @escaping (MovieDbResult<MovieTrailerResponse>) -> Void)
    func searchMovie(query : String , pageNo page: Int, onComplete : @escaping (MovieDbResult<MovieListResponse>) -> Void)
}

struct AlamofireNetworkAgent : MovieDbNetworkAgentProtocol{
    static let shared = AlamofireNetworkAgent()
    
    private init() {}
    
    func getUpcomingMovieList(onComplete : @escaping (MovieDbResult<MovieListResponse>) -> Void){
        /*
            Url
            HTTP Method
            Headers
            Body
         */
        let url = MovieDbURL.upcomingMovies(1)
        AF.request(url)
            .responseDecodable(of: MovieListResponse.self) { response in
                switch response.result {
                case .success(let upcomingMovies):
                    onComplete(.success(upcomingMovies))
                case .failure(let error):
                    onComplete(.failure(handleError(response, error, CommonMovieDBError.self)))
                
                }
            }
    }
    

    func getPopularMovieList(onComplete : @escaping (MovieDbResult<MovieListResponse>) -> Void){
        let url = MovieDbURL.popularMovies(1)
        AF.request(url)
            .responseDecodable(of: MovieListResponse.self) { response in
                switch response.result {
                case .success(let popularMovies):
                    onComplete(.success(popularMovies))
                case .failure(let error):
                    onComplete(.failure(handleError(response, error, CommonMovieDBError.self)))
                
                }
            }
    }
    
    func getPopularSeriesList(onComplete : @escaping (MovieDbResult<MovieListResponse>) -> Void){
        let url = MovieDbURL.popularTVSeries
        AF.request(url)
            .responseDecodable(of: MovieListResponse.self) { response in
                switch response.result {
                case .success(let popularMovies):
                    onComplete(.success(popularMovies))
                case .failure(let error):
                    onComplete(.failure(handleError(response, error, CommonMovieDBError.self)))
                
                }
            }
    }
    
    func getGenreList(onComplete : @escaping (MovieDbResult<MovieGenreList>) -> Void){
        let url = MovieDbURL.movieGenres
        AF.request(url)
            .responseDecodable(of: MovieGenreList.self) { response in
                switch response.result {
                case .success(let genreList):
                    onComplete(.success(genreList))
                case .failure(let error):
                    onComplete(.failure(handleError(response, error, CommonMovieDBError.self)))
                }
            }
    }
    
    func getTopRatedMovieList(pageNo page : Int = 1 , onComplete : @escaping (MovieDbResult<MovieListResponse>) -> Void){
        let url = MovieDbURL.topRatedMovies(page)
        AF.request(url)
            .responseDecodable(of: MovieListResponse.self) { response in
                switch response.result {
                case .success(let popularMovies):
                    onComplete(.success(popularMovies))
                case .failure(let error):
                    onComplete(.failure(handleError(response, error, CommonMovieDBError.self)))
                }
            }
    }
    
    func getActorList(pageNo page: Int = 1, onComplete : @escaping (MovieDbResult<ActorListResponse>) -> Void){
        let url = MovieDbURL.popularActors(page)
        AF.request(url)
            .responseDecodable(of: ActorListResponse.self) { response in
                switch response.result {
                case .success(let actorList):
                    onComplete(.success(actorList))
                case .failure(let error):
                    onComplete(.failure(handleError(response, error, CommonMovieDBError.self)))
                }
            }
    }
    
    
    func getActorDetailsById(actorId id: Int, onComplete : @escaping (MovieDbResult<ActorDetailResponse>) -> Void){
        let url = MovieDbURL.actorDetails(id)
        AF.request(url)
            .responseDecodable(of: ActorDetailResponse.self) { response in
                switch response.result {
                case .success(let actorDetails):
                    onComplete(.success(actorDetails))
                case .failure(let error):
                    onComplete(.failure(handleError(response, error, CommonMovieDBError.self)))
                }
            }
    }
    
    func getTvCreditsByActor(actorId id: Int, onComplete : @escaping (MovieDbResult<SeriesCreditResponse>) -> Void){
        let url = MovieDbURL.actorTvCredits(id)
        AF.request(url)
            .responseDecodable(of: SeriesCreditResponse.self) { response in
                switch response.result {
                case .success(let credits):
                    onComplete(.success(credits))
                case .failure(let error):
                    onComplete(.failure(handleError(response, error, CommonMovieDBError.self)))
                }
            }
    }
    
    func getMovieDetailById(_ id : Int ,onComplete : @escaping (MovieDbResult<MovieDetailVO>) -> Void){
        let url = MovieDbURL.movieDetails(id)
        AF.request(url)
            .responseDecodable(of: MovieDetailVO.self) { response in
                switch response.result {
                case .success(let movieDetail):
                    onComplete(.success(movieDetail))
                case .failure(let error):
                    onComplete(.failure(handleError(response, error, CommonMovieDBError.self)))
                }
            }
    }
    
    func getSeriesDetailById(_ id : Int ,onComplete : @escaping (MovieDbResult<SeriesDetailResponse>) -> Void){
        let url = MovieDbURL.seriesDetails(id)
        AF.request(url)
            .responseDecodable(of: SeriesDetailResponse.self) { response in
                switch response.result {
                case .success(let movieDetail):
                    onComplete(.success(movieDetail))
                case .failure(let error):
                    onComplete(.failure(handleError(response, error, CommonMovieDBError.self)))
                }
            }
    }
    
    func getMovieCreditsById(_ id : Int , onComplete : @escaping (MovieDbResult<MovieCreditsResponse>) -> Void){
        let url = MovieDbURL.movieActors(id)
        AF.request(url)
            .responseDecodable(of: MovieCreditsResponse.self) { response in
                switch response.result {
                case .success(let credits):
                    onComplete(.success(credits))
                case .failure(let error):
                    onComplete(.failure(handleError(response, error, CommonMovieDBError.self)))
                }
            }
    }
    
    func getSimilarMoviesById(_ id : Int ,onComplete : @escaping (MovieDbResult<MovieListResponse>) -> Void){
        let url = MovieDbURL.similarMovie(id)
        AF.request(url)
            .responseDecodable(of: MovieListResponse.self) { response in
                switch response.result {
                case .success(let movieList):
                    onComplete(.success(movieList))
                case .failure(let error):
                    onComplete(.failure(handleError(response, error, CommonMovieDBError.self)))
                }
            }
    }
    
    func getMovieTrailersById(_ id : Int , onComplete : @escaping (MovieDbResult<MovieTrailerResponse>) -> Void) {
        let url = MovieDbURL.trailerVideo(id)
        AF.request(url)
            .responseDecodable(of: MovieTrailerResponse.self) { response in
                switch response.result {
                case .success(let trailerList):
                    onComplete(.success(trailerList))
                case .failure(let error):
                    onComplete(.failure(handleError(response, error, CommonMovieDBError.self)))
                }
            }
    }
    
    func searchMovie(query : String , pageNo page: Int = 1, onComplete : @escaping (MovieDbResult<MovieListResponse>) -> Void){
        let url = MovieDbURL.searchMovie(page, query)
        AF.request(url)
            .responseDecodable(of: MovieListResponse.self) { response in
                switch response.result {
                case .success(let movieList):
                    onComplete(.success(movieList))
                case .failure(let error):
                    onComplete(.failure(handleError(response, error, CommonMovieDBError.self)))
                }
            }
    }
    
    
    fileprivate func handleError<T , E : MovieDbErrorModel> (
        _ response : DataResponse<T , AFError>,
        _ error : (AFError),
        _ errorBodyType : E.Type
    ) -> String {
        
        var responseBody : String = ""
        
        var serverErrorMessage : String?
        
        var errorBody : E?
        
        if let responseData = response.data {
            responseBody = String(data: responseData, encoding: .utf8) ?? "Empty Response Body"
            
            errorBody = try? JSONDecoder().decode(errorBodyType, from: responseData)
            serverErrorMessage = errorBody?.message
        }
        
        //Debug Info
        let responseCode = response.response?.statusCode ?? 0
        let sourcePath = response.request?.url?.absoluteString ?? "No Url"
        
        print(
            """
            ===========================
            URL
            -> \(sourcePath)
            
            Status
            -> \(responseCode)
            
            Body
            -> \(responseBody)
            
            Underlying Error
            -> \(error.underlyingError!)
            
            Error Description
            -> \(error.errorDescription)
            
            =============================
            """
        )
        
        return serverErrorMessage ?? error.errorDescription ?? "undefined"
    }
    
    
    
}

protocol MovieDbErrorModel : Decodable {
    var message : String {get}
}

class CommonMovieDBError : MovieDbErrorModel {
    var message: String {
        return statusMessage
    }
    
    let statusMessage : String
    let statusCode : Int
    
    enum CodingKeys : String , CodingKey {
        case statusMessage = "status_message"
        case statusCode = "status_code"
    }

    
}

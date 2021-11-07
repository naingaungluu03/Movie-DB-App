//
//  MovieDetailModel.swift
//  Hello World
//
//  Created by Harry Jason on 22/08/2021.
//

import Foundation
protocol MovieDetailModel {
    func getMovieTrailers(id : Int , completion : @escaping (MovieDbResult<MovieTrailerResponse>) -> Void)
    func getSimilarMovies(id : Int , completion : @escaping (MovieDbResult<[MovieResult]>) -> Void)
    func getMovieCreditById(id : Int , completion : @escaping (MovieDbResult<[Cast]>) -> Void)
    func getMovieDetailById(id : Int , completion : @escaping (MovieDbResult<MovieDetailVO>) -> Void)
    func getSeriesDetailById(id : Int , completion : @escaping (MovieDbResult<SeriesDetailResponse>) -> Void)
}

class MovieDetailModelImpl : BaseModel , MovieDetailModel {
    
    static let sharedModel = MovieDetailModelImpl()
        
    private override init() {}
    
    func getMovieTrailers(id: Int, completion: @escaping (MovieDbResult<MovieTrailerResponse>) -> Void) {
        networkAgent.getMovieTrailersById(id, onComplete: completion)
    }
    
    func getSimilarMovies(id: Int, completion: @escaping (MovieDbResult<[MovieResult]>) -> Void) {
        networkAgent.getSimilarMoviesById(id) { response in
            switch response {
            case .success(let movieListResponse) :
                self.movieRepository.saveSimilarContent(id: id, data: movieListResponse.results ?? [])
            case .failure(let error):
                completion(.failure(error))
            }
            
            self.movieRepository.getSimilarContent(id: id) { result in
                completion(.success(result))
            }
        }
    }
    
    func getMovieCreditById(id: Int, completion: @escaping (MovieDbResult<[Cast]>) -> Void) {
        networkAgent.getMovieCreditsById(id) { response in
            switch response {
            case .success(let creditListResponse) :
                self.movieRepository.saveCast(id: id, data: creditListResponse.cast ?? [])
            case .failure(let error):
                completion(.failure(error))
            }
            
            self.movieRepository.getCast(id: id) { castList in
                completion(.success(castList))
            }
        }
    }
    
    func getMovieDetailById(id: Int, completion: @escaping (MovieDbResult<MovieDetailVO>) -> Void) {
        networkAgent.getMovieDetailById(id) { response in
            switch response {
            case .success(let result) :
                self.movieRepository.saveDetail(result)
            case .failure(let error) :
                completion(.failure(error))
            }
            
            self.movieRepository.getDetail(id: id) { detail in
                if let detail = detail {
                    completion(.success(detail))
                }
            }
        }
    }
    
    func getSeriesDetailById(id: Int, completion: @escaping (MovieDbResult<SeriesDetailResponse>) -> Void) {
        networkAgent.getSeriesDetailById(id) { response in
            switch response {
            case .success(let result) :
                self.movieRepository.saveDetail(result.toMovieDetailResponse())
            case .failure(let error) :
                completion(.failure(error))
            }
            
            self.movieRepository.getDetail(id: id) { detail in
                if let detail = detail {
                    completion(.success(detail.toSeriesDetailResponse()))
                }
            }
        }
    }
    
}

//
//  MovieModel.swift
//  Hello World
//
//  Created by Harry Jason on 21/08/2021.
//

import Foundation
import RxSwift

protocol MovieModel {
    func getUpcomingMovieList(onComplete : @escaping (MovieDbResult<MovieListResponse>) -> Void)
    func getPopularMovieList(onComplete : @escaping (MovieDbResult<MovieListResponse>) -> Void)
    func getPopularSeriesList(onComplete : @escaping (MovieDbResult<MovieListResponse>) -> Void)
    func getGenreList(onComplete : @escaping (MovieDbResult<MovieGenreList>) -> Void)
    func getTopRatedMovieList(pageNo page : Int, onComplete : @escaping (MovieDbResult<MovieListResponse>) -> Void)
}

class MovieModelImpl : BaseModel , MovieModel {
    
    static let sharedModel = MovieModelImpl()
    
    func getUpcomingMovieList(onComplete: @escaping (MovieDbResult<MovieListResponse>) -> Void) {
        networkAgent.getUpcomingMovieList { response in
            switch response {
            case .success(let movieResults):
                self.movieRepository.saveList(groupType: .MOVIE_UPCOMING, data: movieResults)
            case .failure(let error):
                onComplete(.failure(error))
            }
            self.contentTypeRepository.getMoviesOrSeries(type: .MOVIE_UPCOMING) { movieResults in
                onComplete(.success(
                    MovieListResponse(
                        dates: nil,
                        page: nil,
                        results: movieResults,
                        totalPages: nil,
                        totalMovies: nil
                    )
                ))
            }
        }
    }
    
    func getPopularMovieList(onComplete: @escaping (MovieDbResult<MovieListResponse>) -> Void) {
        networkAgent.getPopularMovieList { response in
            switch response {
            case .success(let movieResults):
                self.movieRepository.saveList(groupType: .MOVIE_POPULAR, data: movieResults)
            case .failure(let error):
                onComplete(.failure(error))
            }
            self.contentTypeRepository.getMoviesOrSeries(type: .MOVIE_POPULAR) { movieResults in
                onComplete(.success(
                    MovieListResponse(
                        dates: nil,
                        page: nil,
                        results: movieResults,
                        totalPages: nil,
                        totalMovies: nil
                    )
                ))
            }
        }
    }
    
    func getPopularSeriesList(onComplete: @escaping (MovieDbResult<MovieListResponse>) -> Void) {
        networkAgent.getPopularSeriesList { response in
            switch response {
            case .success(let movieResults):
                self.movieRepository.saveList(groupType: .SERIES_POPULAR, data: movieResults)
            case .failure(let error):
                onComplete(.failure(error))
            }
            self.contentTypeRepository.getMoviesOrSeries(type: .SERIES_POPULAR) { movieResults in
                onComplete(.success(
                    MovieListResponse(
                        dates: nil,
                        page: nil,
                        results: movieResults,
                        totalPages: nil,
                        totalMovies: nil
                    )
                ))            }
        }
    }
    
    func getGenreList(onComplete: @escaping (MovieDbResult<MovieGenreList>) -> Void) {
        
        networkAgent.getGenreList { response in
            switch response {
            case .success(let genreList):
                self.genreRepository.save(genreList)
            case .failure(let error):
                onComplete(.failure(error))
            }
            self.genreRepository.get { genres in
                onComplete(.success(MovieGenreList(genres: genres)))
            }
        }
    }
    
    func getTopRatedMovieList(pageNo page: Int = 1, onComplete: @escaping (MovieDbResult<MovieListResponse>) -> Void) {
        networkAgent.getTopRatedMovieList { response in
            var totalPages = 0
            switch response {
            case .success(let movieResults):
                totalPages = movieResults.totalPages ?? 0
                self.movieRepository.saveList(groupType: .MOVIE_TOP_RATED, data: movieResults)
            case .failure(let error):
                onComplete(.failure(error))
            }
            self.movieRepository.getMoviesByPage(pageNo: page) { movies in
                self.movieRepository.getMoviesPageCount { count in
                    onComplete(.success(
                        MovieListResponse(
                            dates: nil,
                            page: page,
                            results: movies,
                            totalPages: totalPages,
                            totalMovies: nil
                        )
                    ))
                }
            }
        }
    }
    
}

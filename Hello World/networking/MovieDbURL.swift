//
//  MovieDbUrl.swift
//  Hello World
//
//  Created by Harry Jason on 17/07/2021.
//

import Foundation
import Alamofire

enum MovieDbURL : URLRequestConvertible {
    
    func asURLRequest() throws -> URLRequest {
        return URLRequest(url: url)
    }

    
    case searchMovie(_ page : Int , _ query : String)
    case actorTvCredits(_ id : Int)
    case actorImages(_ id : Int)
    case actorDetails(_ id : Int)
    case trailerVideo(_ id : Int)
    case similarMovie(_ id : Int)
    case movieActors(_ id : Int)
    case movieDetails(_ id : Int)
    case seriesDetails(_ id : Int)
    case popularActors(_ pageNo : Int)
    case topRatedMovies(_ pageNo : Int)
    case movieGenres
    case popularTVSeries
    case upcomingMovies(_ pageNo : Int)
    case popularMovies(_ pageNo : Int)
    
    private var baseUrl : String {
        return NetworkConstants.BASE_URL
    }
    
    func asURL() throws -> URL {
        return url
    }
    
    var url : URL {
        
        let urlComponents = NSURLComponents(string: baseUrl.appending(apiPath))
        
        if urlComponents?.queryItems == nil {
            urlComponents?.queryItems = []
        }
        
        urlComponents?.queryItems?.append(contentsOf: [URLQueryItem(name: "api_key", value: NetworkConstants.API_KEY)])
        
        return urlComponents?.url! ?? URL(fileURLWithPath: "")
    }
    
    private var apiPath : String {
        switch self {

        case .searchMovie(let page, let query):
            return "/search/movie?page=\(page)&query=\(query)"
        case .actorTvCredits(let id):
            return "/person/\(id)/tv_credits"
        case .actorImages(let id):
            return "/person/\(id)/images"
        case .actorDetails(let id):
            return "/person/\(id)"
        case .trailerVideo(let id):
            return "/movie/\(id)/videos"
        case .similarMovie(let id):
            return "/movie/\(id)/similar"
        case .movieActors(let id):
            return "/movie/\(id)/credits"
        case .movieDetails(let id):
            return "/movie/\(id)"
        case .seriesDetails(let id):
            return "/tv/\(id)"
        case .popularActors(let pageNo):
            return "/person/popular?page=\(pageNo)"
        case .topRatedMovies(let pageNo):
            return "/movie/top_rated?page=\(pageNo)"
        case .movieGenres:
            return "/genre/movie/list"
        case .popularTVSeries:
            return "/tv/popular"
        case .upcomingMovies(let pageNo):
            return "/movie/upcoming?page=\(pageNo)"
        case .popularMovies(let pageNo):
            return "/movie/popular?page=\(pageNo)"
        }
    }
    
    
}

//
//  ActorListResponse.swift
//  Hello World
//
//  Created by Harry Jason on 27/06/2021.
//

import Foundation

struct ActorListResponse: Codable {
    let dates: Dates?
    let page: Int?
    let results: [ActorInfoResponse]?
    let totalPages, totalMovies: Int?

    enum CodingKeys: String, CodingKey {
        case dates, page, results
        case totalPages = "total_pages"
        case totalMovies = "total_movies"
    }
    
    static func empty() -> ActorListResponse {
        return ActorListResponse(dates: nil, page: nil, results: [], totalPages: nil, totalMovies: nil)
    }
}

public struct ActorInfoResponse : Codable {
    let adult : Bool?
    let gender : Int?
    let id : Int?
    let knownFor : [MovieResult]?
    let knownForDepartment : String?
    let name : String?
    let popularity : Double?
    let profilePath : String?
    
    enum CodingKeys: String , CodingKey {
        case adult
        case gender
        case id
        case knownFor = "known_for"
        case knownForDepartment = "known_for_department"
        case name
        case popularity
        case profilePath = "profile_path"
    }
}

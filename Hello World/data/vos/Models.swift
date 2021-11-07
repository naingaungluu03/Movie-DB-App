//
//  Models.swift
//  Hello World
//
//  Created by Harry Jason on 26/06/2021.
//

import Foundation

struct LoginRequest : Codable {
    var username : String
    var password : String
    var requestToken : String
    
    enum CodingKeys : String , CodingKey {
        case username = "username"
        case password = "password"
        case requestToken = "request_token"
    }
}

struct LoginFailedResponse : Codable {
    let success : Bool?
    let statusCode : Int?
    let statusMessage : String?
    
    enum CodingKeys : String, CodingKey {
        case success = "success"
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
    
}

struct TokenResponse : Codable {
    let success : Bool?
    let expiresAt : String?
    let requestToken : String?
    
    enum CodingKeys : String, CodingKey {
        case success = "success"
        case expiresAt = "expires_at"
        case requestToken = "request_token"
    }
}

struct LoginSuccessResponse : Codable {
    let success : Bool?
    let expiresAt : String?
    let requestToken : String?
    
    enum CodingKeys : String, CodingKey {
        case success = "success"
        case expiresAt = "expires_at"
        case requestToken = "request_token"
    }
}


struct MovieGenre : Codable {
    var id : Int
    var name : String
    var otherProperty : String?
    
    enum CodingKeys : String , CodingKey {
        case id
        case name = "name"
        case otherProperty = "other_property"
    }
    
    func convertToGenreVO() -> GenreVO{
        return GenreVO(id: self.id, name: self.name, isSelected: false)
    }
}

struct MovieGenreList : Codable {
    let genres : [MovieGenre]
    
    static func empty() -> MovieGenreList {
        return MovieGenreList(genres: [])
    }
}

//
//  NetworkConstants.swift
//  Hello World
//
//  Created by Harry Jason on 26/06/2021.
//

import Foundation

struct NetworkConstants {
    static let moviedbUserName  = "naingaungluu"
    static let moviedbPassword = "luuluu09"
    static let API_KEY = "05b8332210465ec6f39d7d2b30b4d4a9"
    static let BASE_URL = "https://api.themoviedb.org/3"
    static let BASE_IMAGE_URL = "https://image.tmdb.org/t/p/original"
    static let BASE_THUMBNAIL_URL = "https://image.tmdb.org/t/p/w500"
}

enum MovieDbResult<T> {
    case success(T)
    case failure(String)
}

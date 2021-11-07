//
//  GenreEntityExtensions.swift
//  Hello World
//
//  Created by Harry Jason on 21/08/2021.
//

import Foundation
extension GenreEntity {
    func toMovieGenre() -> MovieGenre {
        return MovieGenre(id: Int(self.id), name: self.name ?? "", otherProperty: nil)
    }
}

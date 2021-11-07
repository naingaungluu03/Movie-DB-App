//
//  ActorEntityExtensions.swift
//  Hello World
//
//  Created by Harry Jason on 22/08/2021.
//

import Foundation
extension ActorEntity {
    func toActorDetailResponse() -> ActorDetailResponse {
        return ActorDetailResponse(
            birthday: "",
            knownForDepartment: self.knownForDepartment,
            deathday: "",
            id: Int(self.id),
            name: self.name,
            alsoKnownAs: [self.originalName ?? ""],
            gender: Int(self.gender),
            biography: self.biography,
            popularity: self.popularity,
            placeOfBirth: self.placeOfBirth,
            profilePath: self.profilePath,
            adult: self.adult,
            imdbID: self.imdbId,
            homepage: self.homePage
        )
    }
    
    func toActorInfoResponse() -> ActorInfoResponse {
        return ActorInfoResponse(
            adult: self.adult,
            gender: Int(self.gender),
            id: Int(self.id),
            knownFor: nil,
            knownForDepartment: self.knownForDepartment,
            name: self.name,
            popularity: self.popularity,
            profilePath: self.profilePath
        )
    }
    
    func toCast() -> Cast {
        return Cast(
            adult: self.adult,
            gender: Int(self.gender),
            id: Int(self.id),
            knownForDepartment: self.knownForDepartment,
            name: self.name,
            originalName: self.originalName,
            popularity: self.popularity,
            profilePath: self.profilePath,
            castID: Int(self.id),
            character: self.character,
            creditID: self.creditId,
            order: Int(self.order),
            department: self.department,
            job: self.job
        )
    }
}

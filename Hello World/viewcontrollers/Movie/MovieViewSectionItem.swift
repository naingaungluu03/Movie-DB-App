//
//  MovieViewSectionItem.swift
//  Hello World
//
//  Created by Harry Jason on 25/09/2021.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

enum SectionItem {
    case upcomingMoviesSection(item : [MovieResult])
    case popularMoviesSection(item : [MovieResult])
    case popularSeriesSection(item : [MovieResult])
    case movieShowtimeSection
    case movieGenresSection(item : [MovieGenre])
    case showcaseMoviesSection(items : [MovieResult])
    case bestActorInfoSection(items : [ActorInfoResponse])
}

enum HomeMovieSectionModel : SectionModelType {
    
    init(original : HomeMovieSectionModel , items : [SectionItem]) {
        switch original {
        case .movieResult(let results):
            self = .movieResult(items: results)
        case .actorResult(let results):
            self = .actorResult(items: results)
        case .genreResult(let results):
            self = .genreResult(items: results)
        }
    }
    
    typealias Item = SectionItem
    
    var items : [SectionItem] {
        switch self {
        case .movieResult(let items):
            return items
        case .actorResult(let items):
            return items
        case .genreResult(let items):
            return items
        }
    }
    
    case movieResult(items : [SectionItem])
    case actorResult(items : [SectionItem])
    case genreResult(items : [SectionItem])
}

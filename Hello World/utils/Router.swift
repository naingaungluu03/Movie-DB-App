//
//  Router.swift
//  Hello World
//
//  Created by Harry Jason on 22/05/2021.
//

import Foundation
import UIKit
enum StoryBoardName : String {
    case MAIN = "Main"
    case LaunchScreen = "LaunchScreen"
    case Authentication = "Authentication"
    case BasicUIComponents = "BasicUIComponents"
}

extension UIStoryboard {
    static func mainStoryBoard() -> UIStoryboard {
        UIStoryboard(name: StoryBoardName.MAIN.rawValue, bundle: nil)
    }
}

extension UIViewController {
    func navigateToMovieDetailViewController(movieId id : Int){
        guard let viewController = UIStoryboard.mainStoryBoard().instantiateViewController(identifier: MovieDetailViewController.identifier)
        as? MovieDetailViewController else {
            return
        }
        viewController.modalPresentationStyle = .fullScreen
        viewController.modalTransitionStyle = .flipHorizontal
        viewController.movieId = id
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    func navigateToSeriesDetailViewController(movieId id : Int){
        let viewController = SeriesDetailsViewController()
        viewController.modalPresentationStyle = .fullScreen
        viewController.modalTransitionStyle = .flipHorizontal
        viewController.movieId = id
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    func navigateToSeeAllShowcase(){
        let viewController = SeeAllShowcasesViewController()
        viewController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    func navigateToSeeAllActors(){
        let viewController = SeeAllActorsViewController()
        viewController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    func navigateToSearchViewController() {
        let viewController = RxSearchViewController()
        viewController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    func navigateToActorDetails(actorId id : Int){
        let viewController = ActorDetailsViewController()
        viewController.modalPresentationStyle = .fullScreen
        viewController.actorId = id
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

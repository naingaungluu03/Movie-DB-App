//
//  MovieViewController.swift
//  Hello World
//
//  Created by Harry Jason on 08/05/2021.
//

import UIKit
import RxSwift
import RxDataSources

class MovieViewController: UIViewController , MovieItemDelegate {
    
    @IBOutlet weak var tableViewMovies: UITableView!
    @IBAction func onTapSearch(_ sender: Any) {
        navigateToSearchViewController()
    }
    
    let requestToken = "5a626cd458c4b5a12a90f8f3cdaa018d6b9a8c84"
    
    //MARK: Observables
    let observablePopularMovies = RxMovieModelImpl.shared.getPopularMovieList()
    let observableUpcomingMovie = RxMovieModelImpl.shared.getUpcomingMovieList()
    let observableUpcomingSeries = RxMovieModelImpl.shared.getPopularSeriesList()
    let observableGenreList = RxMovieModelImpl.shared.getGenreList()
    let observableShowcaseList = RxMovieModelImpl.shared.getTopRatedMovieList(pageNo: 1)
    let observableActorList = RxActorModelImpl.sharedModel.getActorList(pageNo: 1)
    
    //MARK: Models & Agents
    private let networkingAgent = AlamofireNetworkAgent.shared
    private let movieModel = MovieModelImpl.sharedModel
    private let actorModel = RxActorModelImpl.sharedModel
    
    //MARK: State Objects
    var genreList : MovieGenreList?
    var upcomingMovieList : [MovieResult]?
    var popularMovieList : [MovieResult]?
    var popularSeriesList : [MovieResult]?
    var topRatedList : [MovieResult]?
    var actorList : ActorListResponse?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableViewCells()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "")
        initReactiveDataBinding()
        
    }
    
    //MARK: Init Reactive Databinding
    private func initReactiveDataBinding() {
        let dataSource = initDataSource()
        
        Observable.combineLatest(
            observablePopularMovies,
            observableUpcomingMovie,
            observableUpcomingSeries,
            observableGenreList,
            observableShowcaseList,
            observableActorList
        )
        .flatMap { (popularMovies, upcomingMovies, upcomingSeries, genreList , showcaseMovieList, actorList) -> Observable<[HomeMovieSectionModel]> in
            .just(
                [
                    HomeMovieSectionModel.movieResult(
                        items: [.upcomingMoviesSection(item: upcomingMovies)
                    ]),
                    HomeMovieSectionModel.movieResult(
                        items: [.popularMoviesSection(item: popularMovies)
                    ]),
                    HomeMovieSectionModel.genreResult(
                        items: [.movieGenresSection(item: genreList.genres)
                    ]),
                    HomeMovieSectionModel.movieResult(
                        items: [.popularSeriesSection(item: upcomingSeries)]
                    ),
                    HomeMovieSectionModel.movieResult(
                        items: [.showcaseMoviesSection(items: showcaseMovieList.results ?? [])
                    ]),
                    HomeMovieSectionModel.actorResult(
                        items: [.bestActorInfoSection(items: actorList.results ?? [])
                    ]),
                ]
            )
        }
        .bind(to: tableViewMovies.rx.items(dataSource: dataSource))
        .disposed(by: disposeBag)
    }
    
    //MARK: init Data Source
    private func initDataSource() -> RxTableViewSectionedReloadDataSource<HomeMovieSectionModel> {
        return RxTableViewSectionedReloadDataSource<HomeMovieSectionModel>.init { dataSource, tableView, indexPath, item in
            switch item {
            //MARK: Popular Movies
            case .popularMoviesSection(let items):
                let cell = tableView.dequeCell(identifier: PopularFilmTableViewCell.identifier, indexPath: indexPath) as PopularFilmTableViewCell
                self.popularMovieList = items
                cell.delegate = self
                cell.lblSectionTitle.text = "popular movies".uppercased()
                cell.data = items
                return cell
            //MARK: Upcoming Movies
            case .upcomingMoviesSection(let items):
                let cell = tableView.dequeCell(identifier: MovieSliderTableViewCell.identifier, indexPath: indexPath) as MovieSliderTableViewCell
                self.upcomingMovieList = items
                cell.delegate = self
                cell.data = items
                return cell
            //MARK: Popular Series
            case .popularSeriesSection(let items):
                let cell = tableView.dequeCell(identifier: PopularFilmTableViewCell.identifier, indexPath: indexPath) as PopularFilmTableViewCell
                self.popularSeriesList = items
                cell.delegate = self
                cell.lblSectionTitle.text = "popular series".uppercased()
                cell.data = items
                return cell

            //MARK: Movie Showtime
            case .movieShowtimeSection :
                return tableView.dequeCell(identifier: MovieShowTimeTableViewCell.identifier, indexPath: indexPath)

            //MARK: Movie Genre
            case .movieGenresSection(let genres) :
                let cell =  tableView.dequeCell(identifier: GenreTableViewCell.identifier, indexPath: indexPath) as GenreTableViewCell
                var movieCollection : [MovieResult] = []
                movieCollection.append(contentsOf: self.popularMovieList ?? [])
                movieCollection.append(contentsOf: self.popularSeriesList ?? [])
                movieCollection.append(contentsOf: self.upcomingMovieList ?? [])
                cell.movieCollection = movieCollection
                cell.delegate = { id in
                    self.navigateToMovieDetailViewController(movieId: id)
                }

                let genreVOList = genres.map({ genre in
                    return genre.convertToGenreVO()
                })
                genreVOList.first?.isSelected = true
                cell.genreList = genreVOList

                return cell

            //MARK: Movie Showcase
            case.showcaseMoviesSection(let items) :
                let cell =  tableView.dequeCell(identifier: ShowCaseTableViewCell.identifier, indexPath: indexPath) as! ShowCaseTableViewCell
                cell.data = items
                cell.onTapMoreShowcasesDelegate = {
                    self.navigateToSeeAllShowcase()
                }
                return cell

            //MARK: Best Actor
            case .bestActorInfoSection(let items) :
                let cell =  tableView.dequeCell(identifier: BestActorsTableViewCell.identifier, indexPath: indexPath) as! BestActorsTableViewCell
                cell.data = items
                cell.onTapSeeMoreDelegate = {
                    self.navigateToSeeAllActors()
                }
                cell.onTapActorDelegate = { id in
                    self.navigateToActorDetails(actorId: id)
                }
                return cell
            }
        }
    }
    
    
    let disposeBag = DisposeBag()
    
    private func registerTableViewCells(){
        tableViewMovies.registerForCell(identifier: MovieSliderTableViewCell.identifier)
        tableViewMovies.registerForCell(identifier: PopularFilmTableViewCell.identifier)
        tableViewMovies.registerForCell(identifier: MovieShowTimeTableViewCell.identifier)
        tableViewMovies.registerForCell(identifier: GenreTableViewCell.identifier)
        tableViewMovies.registerForCell(identifier: ShowCaseTableViewCell.identifier)
        tableViewMovies.registerForCell(identifier: BestActorsTableViewCell.identifier)
    }
    
    func onTapMovie(movie : MovieResult) {
        if movie.releaseDate == nil {
            // This is a series
            if let movieId = movie.id {
                navigateToSeriesDetailViewController(movieId: movieId)
            }
        }
        else { //This is a movie
            if let movieId = movie.id {
                navigateToMovieDetailViewController(movieId: movieId)
            }
        }
    }

}

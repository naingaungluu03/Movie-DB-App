//
//  MovieDetailViewController.swift
//  Hello World
//
//  Created by Harry Jason on 08/05/2021.
//

import UIKit
import Alamofire
import SDWebImage
import YouTubePlayer
import RxSwift
import RxCocoa

class MovieDetailViewController: UIViewController {

    //MARK: View Outlets
    
    @IBOutlet weak var btnRateMovie: UIButton!
    @IBOutlet weak var collectionViewActors: UICollectionView!
    @IBOutlet weak var collectionViewSimilarMovies: UICollectionView!
    @IBOutlet weak var collectionViewProductinCompanies: UICollectionView!
    
    @IBOutlet weak var ivPoster : UIImageView!
    @IBOutlet weak var lblReleaseYear : UILabel!
    @IBOutlet weak var lblMovieTitle : UILabel!
    @IBOutlet weak var lblDescription : UILabel!
    @IBOutlet weak var lblDuration : UILabel!
    @IBOutlet weak var lblRating : UILabel!
    @IBOutlet weak var viewRatingControl : RatingControl!
    @IBOutlet weak var lblVoteCount : UILabel!
    
    @IBOutlet weak var lblMovieInfoTitle : UILabel!
    @IBOutlet weak var lblMovieGenreList : UILabel!
    @IBOutlet weak var lblProductionCountry : UILabel!
    @IBOutlet weak var lblMovieInfoDescription : UILabel!
    @IBOutlet weak var lblReleaseDate : UILabel!
    @IBOutlet weak var btnPlayTrailer: UIButton!
    
    
    
    //MARK: State Variables
    
    public var movieId = 0
    private var productionCompanies : [ProductionCompany]?
    private var castList : [ActorInfoResponse]?
    private var similarMovies : [MovieResult]?
    private var trailerList : [MovieTrailer]?
    
    
    
    //MARK: Dependencies
    
    private let networkingAgent = AlamofireNetworkAgent.shared
    private let movieDetailModel = RxMovieDetailModelImpl.sharedModel
    
    
    
    //MARK: Rx Variables
    
    private let disposeBag = DisposeBag()
    private let rxMovieDetails = BehaviorSubject<MovieDetailVO?>(value : nil)
    private let rxSimilarMovies = BehaviorSubject<[MovieResult]>(value : [])
    private let rxCastList = BehaviorSubject<[Cast]>(value: [])
    private let rxProductionCompanies = BehaviorSubject<[ProductionCompany]>(value: [])
    
    
    
    //MARK: viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initRatingButton()
        
        setupCollectionViews()
        fetchData(movieId: movieId)
        initReactiveObservers()
        
    }
    
    
    //MARK: View Init
    
    private func initRatingButton() {
        btnRateMovie.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        btnRateMovie.layer.borderWidth = CGFloat(1)
        btnRateMovie.layer.cornerRadius = 20
    }
    
    @IBAction func onTapPlayTrailer() {
        if let videoItem = trailerList?.first {
            let youtubeVideoId = videoItem.key
            let youtubePlayerVC = YoutubePlayerViewController()
            youtubePlayerVC.youtubeVideoId = youtubeVideoId
            self.present(youtubePlayerVC, animated: true, completion: {})
        }
    }

    private func setupCollectionViews(){
        collectionViewActors.delegate = self
        collectionViewActors.registerCell(identifier: BestActorsCollectionViewCell.identifier)
        collectionViewActors.showsHorizontalScrollIndicator = false
        collectionViewActors.showsVerticalScrollIndicator = false
        
        collectionViewSimilarMovies.delegate = self
        collectionViewSimilarMovies.registerCell(identifier: PopularFilmCollectionViewCell.identifier)
        collectionViewSimilarMovies.showsHorizontalScrollIndicator = false
        collectionViewSimilarMovies.showsVerticalScrollIndicator = false
        
        collectionViewProductinCompanies.delegate = self
        collectionViewProductinCompanies.registerCell(identifier: ProductionCompanyCollectionViewCell.identifier)
        collectionViewProductinCompanies.showsHorizontalScrollIndicator = false
        collectionViewProductinCompanies.showsVerticalScrollIndicator = false
    }
    
    
    
    //MARK: Reactive Data Binding
    
    private func initReactiveObservers() {
        bindCasts()
        bindSimilarMovies()
        bindMovieDetails()
        bindProductionCompanies()
    }
    
    func bindMovieDetails() {
        rxMovieDetails
            .compactMap{$0}
            .subscribe { movieDetail in
                self.showMovieDetails(movieDetail: movieDetail)
            } onCompleted: {
                
            }
            .disposed(by: disposeBag)
    }
    
    func bindCasts(){
        //Data Binding
        rxCastList
            .map { castList in
                castList.filter({ cast in
                    return cast.knownForDepartment == "Acting"
                })
                .map({ cast in
                    cast.toActorInfoResponse()
                })
            }
            .bind(to: self.collectionViewActors.rx.items(cellIdentifier: BestActorsCollectionViewCell.identifier, cellType: BestActorsCollectionViewCell.self))
            { row , element , cell in
                cell.data = element
            }
            .disposed(by: disposeBag)

        
        //On Select item
        collectionViewActors.rx.itemSelected
        .subscribe (onNext: { indexPath in
            if let actorId = try! self.rxCastList.value()[indexPath.row].id {
                self.navigateToActorDetails(actorId: actorId)
            }
        })
        .disposed(by: disposeBag)
    }
    
    func bindSimilarMovies() {
        //Data binding
        rxSimilarMovies
            .bind(to: self.collectionViewSimilarMovies.rx.items(cellIdentifier: PopularFilmCollectionViewCell.identifier, cellType: PopularFilmCollectionViewCell.self))
            { row , element , cell in
                cell.data = element
            }
            .disposed(by: disposeBag)
        
        //On Select item
        collectionViewSimilarMovies.rx.itemSelected
        .subscribe (onNext: { indexPath in
            if let movieId = try! self.rxSimilarMovies.value()[indexPath.row].id {
                self.navigateToMovieDetailViewController(movieId: movieId)
            }
        })
        .disposed(by: disposeBag)
    }
    
    func bindProductionCompanies() {
        rxProductionCompanies
            .bind(to: self.collectionViewProductinCompanies.rx.items(cellIdentifier: ProductionCompanyCollectionViewCell.identifier, cellType: ProductionCompanyCollectionViewCell.self))
            { row , element , cell in
                cell.data = element
            }
            .disposed(by: disposeBag)
    }
    
    private func showMovieDetails(movieDetail detail : MovieDetailVO) {
        
        // Detail Header
        lblReleaseYear.text = String(detail.releaseDate?.split(separator: "-")[0] ?? "")
        lblMovieTitle.text =  detail.originalTitle
        lblDescription.text =  detail.overview
        
        //Runtime
        let runtimeHour = (detail.runtime ?? 0) / 60
        let runtimeMinutes = (detail.runtime ?? 0) % 60
        lblDuration.text =  "\(runtimeHour)h \(runtimeMinutes)m"
        
        //Rating
        lblRating.text =  "\(detail.voteAverage ?? 0)"
        lblVoteCount.text =  "\(detail.voteCount ?? 0)"
        viewRatingControl.rating = Int((detail.voteAverage ?? 0.0) * 0.5)
        
        
        //About section
        lblMovieInfoTitle.text =  detail.originalTitle
        
        // Genre
        var genreListString = detail.genres?
            .map{ $0.name }
            .reduce("")
            { value , result in
                "\(value ?? "")\(result), "
            } ?? ""
        if !genreListString.isEmpty { genreListString.removeLast(2)}
        lblMovieGenreList.text = genreListString
        
        //Production Country
        var countryListString : String = detail.productionCountries?
            .map{ $0.name }
            .reduce("")
            { value , result in
                "\(value ?? "")\(result ?? ""), "
            } ?? ""
        countryListString.removeLast(2)
        lblProductionCountry.text = countryListString
        
        
        lblMovieInfoDescription.text =  detail.overview
        lblReleaseDate.text =  detail.releaseDate
        
        
        //Poster Image
        let backdropPath = "\(NetworkConstants.BASE_IMAGE_URL)\(detail.backdropPath ?? "")"
        ivPoster.sd_setImage(with: URL(string: backdropPath))
        
        self.navigationItem.title = detail.title
    }
    
    
    
    
    //MARK: Data Fetchers
    
    func fetchData(movieId id : Int){
        fetchMovieDetails(id)
        fetchMovieCredits(movieId: id)
        fetchSimilarMovies(movieId: id)
        fetchMovieTrailers(movieId: id)
    }
    
    func fetchMovieDetails(_ id : Int) {
        movieDetailModel.getMovieDetailById(id : id)
            .subscribe { movieDetail in
                self.rxMovieDetails.onNext(movieDetail)
                self.rxProductionCompanies.onNext(movieDetail.productionCompanies ?? [])
            } onCompleted: {
                
            }
            .disposed(by: disposeBag)
    }
    
    private func fetchMovieCredits(movieId id : Int){
        movieDetailModel.getMovieCreditById(id : id)
            .subscribe { castList in
                self.rxCastList.onNext(castList)
            } onCompleted: {
                
            }
            .disposed(by: disposeBag)
    }
    
    private func fetchSimilarMovies(movieId id : Int){
        movieDetailModel.getSimilarMovies(id :id)
            .subscribe { similarMovies in
                self.rxSimilarMovies.onNext(similarMovies)
            } onCompleted: {
                
            }
            .disposed(by: disposeBag)
    }
    
    private func fetchMovieTrailers(movieId id : Int) {
        movieDetailModel.getMovieTrailers(id: id)
            .subscribe { trailer in
                self.trailerList = trailer.results
                let playTrailerButtonVisible = self.trailerList?.isEmpty ?? true
                self.btnPlayTrailer.isHidden = playTrailerButtonVisible
            } onCompleted: {
                
            }
            .disposed(by: disposeBag)
          
    }
    

}

//MARK: DelegateFlowLayout
extension MovieDetailViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if (collectionView == collectionViewProductinCompanies){
            let width : CGFloat = collectionView.frame.height
            let height : CGFloat = width
            return CGSize(width: width, height: height)
        }
        else if collectionView == collectionViewActors {
            return CGSize(width: collectionView.frame.width/2.5, height: CGFloat(200))
        }
        else {
            return CGSize(width: collectionView.frame.width / 3, height: collectionView.frame.height)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.subviews[scrollView.subviews.count - 1].subviews[0].backgroundColor = UIColor(named: "color_accent")
    }
    
}

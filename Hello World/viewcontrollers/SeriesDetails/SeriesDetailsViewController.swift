//
//  SeriesDetailsViewController.swift
//  Hello World
//
//  Created by Harry Jason on 11/07/2021.
//

import UIKit

class SeriesDetailsViewController: UIViewController {
    
    @IBOutlet weak var btnRateMovie: UIButton!
    @IBOutlet weak var collectionViewActors: UICollectionView!
    @IBOutlet weak var collectionViewProductinCompanies: UICollectionView!
    
    @IBOutlet weak var ivPoster : UIImageView!
    @IBOutlet weak var lblReleaseYear : UILabel!
    @IBOutlet weak var lblMovieTitle : UILabel!
    @IBOutlet weak var lblDescription : UILabel!
    @IBOutlet weak var lblRating : UILabel!
    @IBOutlet weak var viewRatingControl : RatingControl!
    @IBOutlet weak var lblVoteCount : UILabel!
    @IBOutlet weak var lblEpisodeCount : UILabel!
    @IBOutlet weak var layoutProductionCompanies : UIView!
    @IBOutlet weak var layoutActors : UIView!
    
    @IBOutlet weak var btnPlayTrailer: UIButton!
    
    public var movieId = 0
    
    private var productionCompanies : [ProductionCompany]?
    private var castList : [ActorInfoResponse]?
    private var similarMovies : [MovieResult]?
    private var trailerList : [MovieTrailer]?
    
    private let networkingAgent = AlamofireNetworkAgent.shared
    private let movieModel = MovieDetailModelImpl.sharedModel

    override func viewDidLoad() {
        super.viewDidLoad()

        btnRateMovie.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        btnRateMovie.layer.borderWidth = CGFloat(1)
        btnRateMovie.layer.cornerRadius = 20
        
        setupCollectionViews()
        fetchMovieDetails(movieId: movieId)
    
    }

    private func bindData(movieDetail detail : SeriesDetailResponse) {
        

        if (productionCompanies == nil || productionCompanies?.count ?? 0 < 1) {
            layoutProductionCompanies.isHidden = true
        }
        else {
            productionCompanies = detail.productionCompanies
            collectionViewProductinCompanies.reloadData()
        }
        
        // Detail Header
        lblReleaseYear.text = String(detail.firstAirDate?.split(separator: "-")[0] ?? "")
        lblMovieTitle.text =  detail.originalName ?? detail.name
        lblDescription.text =  detail.overview
        
        //Episode Count
        var seasonsCount = ""
        if (detail.numberOfSeasons ?? 1) > 1 {
            seasonsCount = "\(detail.numberOfSeasons ?? 1) Seasons"
        } else {
            seasonsCount = "\(detail.numberOfSeasons ?? 1) Season"
        }
        lblEpisodeCount.text = "\(seasonsCount) | \(detail.numberOfEpisodes ?? 0) Episodes"
        
        //Rating
        lblRating.text =  "\(detail.voteAverage ?? 0)"
        lblVoteCount.text =  "\(detail.voteCount ?? 0)"
        viewRatingControl.rating = Int((detail.voteAverage ?? 0.0) * 0.5)
        
                
        // Genre
        var genreListString = detail.genres?
            .map{ $0.name }
            .reduce("")
            { value , result in
                "\(value ?? "")\(result), "
            } ?? ""
        if genreListString.count >= 2 {
            genreListString.removeLast(2)
        }
        
        //Production Country
        var countryListString : String = detail.productionCountries?
            .map{ $0.name }
            .reduce("")
            { value , result in
                "\(value ?? "")\(result ?? ""), "
            } ?? ""
        if genreListString.count >= 2 {
            genreListString.removeLast(2)
        }
        
        //Poster Image
        let backdropPath = "\(NetworkConstants.BASE_IMAGE_URL)\(detail.backdropPath ?? "")"
        ivPoster.sd_setImage(with: URL(string: backdropPath))
        
        self.navigationItem.title = detail.name
    }
    
    func bindCasts(casts : [Cast]){
        castList = casts.filter({ cast in
            return cast.knownForDepartment == "Acting"
        })
        .map({ cast in
            return cast.toActorInfoResponse()
        })
        debugPrint(castList)
        if (castList == nil || castList?.count ?? 0 < 1) {
            layoutActors.isHidden = true
        }
        else {
            collectionViewActors.reloadData()
        }
    }
    
    func bindSimilarMovies(_ movieList : [MovieResult]) {
        similarMovies = movieList
    }
    
    func fetchMovieDetails(movieId id : Int){
        movieModel.getSeriesDetailById(id: id) { result in
            switch result {
            case .success(let movieDetail) :
                self.bindData(movieDetail: movieDetail)
            case .failure(let error):
                print(error)
            }
        }
        
        fetchMovieCredits(movieId: id)
        getSimilarMovies(movieId: id)
        getMovieTrailers(movieId: id)
    }
    
    private func fetchMovieCredits(movieId id : Int){
        movieModel.getMovieCreditById(id: id)
        { result in
            switch result {
            case .success(let movieCredits) :
                self.bindCasts(casts: movieCredits)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func getSimilarMovies(movieId id : Int){
        movieModel.getSimilarMovies(id: id)
        { result in
            switch result {
            case .success(let similarMovies) :
                self.bindSimilarMovies(similarMovies)
            case .failure(let error) :
                print(error)
            }
        }
    }
    
    private func getMovieTrailers(movieId id : Int) {
        networkingAgent.getMovieTrailersById(id)
        { result in
            switch result {
            case .success(let trailerResponse):
                self.trailerList = trailerResponse.results
                let playTrailerButtonVisible = self.trailerList?.isEmpty ?? true
                self.btnPlayTrailer.isHidden = playTrailerButtonVisible
            
            case .failure(let error) :
                print(error)
            }
        }
    }
    
    
    private func setupCollectionViews(){
        collectionViewActors.dataSource = self
        collectionViewActors.delegate = self
        collectionViewActors.registerCell(identifier: BestActorsCollectionViewCell.identifier)
        collectionViewActors.showsHorizontalScrollIndicator = false
        collectionViewActors.showsVerticalScrollIndicator = false
        
        collectionViewProductinCompanies.dataSource = self
        collectionViewProductinCompanies.delegate = self
        collectionViewProductinCompanies.registerCell(identifier: ProductionCompanyCollectionViewCell.identifier)
        collectionViewProductinCompanies.showsHorizontalScrollIndicator = false
        collectionViewProductinCompanies.showsVerticalScrollIndicator = false
    }

}

extension SeriesDetailsViewController : UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView == collectionViewProductinCompanies){
            return  productionCompanies?.count ?? 0
        }
        else if collectionView == collectionViewActors {
            return castList?.count ?? 0
        }
        else {
            return similarMovies?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (collectionView == collectionViewProductinCompanies){
            let cell = collectionView.dequeCell(identifier: ProductionCompanyCollectionViewCell.identifier, indexPath: indexPath) as! ProductionCompanyCollectionViewCell
            if let company = productionCompanies?[indexPath.row] {
                cell.data = company
            }
            return cell
        }
        else if collectionView == collectionViewActors {
            let cell =  collectionView.dequeCell(identifier: BestActorsCollectionViewCell.identifier, indexPath: indexPath) as! BestActorsCollectionViewCell
            cell.data = castList?[indexPath.row]
            return cell
        }
        else {
            let cell = collectionView.dequeCell(identifier: PopularFilmCollectionViewCell.identifier, indexPath: indexPath) as! PopularFilmCollectionViewCell
            cell.data = similarMovies?[indexPath.row]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if (collectionView == collectionViewProductinCompanies){
//            let height : CGFloat = 150
//            let width : CGFloat = height * (3 / 2)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      if collectionView == collectionViewActors {
            if let actorId = castList?[indexPath.row].id {
                navigateToActorDetails(actorId: actorId)
            }
        }
    }
    
}

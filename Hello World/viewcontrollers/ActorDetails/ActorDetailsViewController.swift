//
//  ActorDetailsViewController.swift
//  Hello World
//
//  Created by Harry Jason on 11/07/2021.
//

import UIKit

class ActorDetailsViewController: UIViewController {

    @IBOutlet weak var ivActorProfile: UIImageView!
    @IBOutlet weak var tvActorBirthdate: UILabel!
    @IBOutlet weak var lblActorName: UILabel!
    @IBOutlet weak var lblBiography: UILabel!
    @IBOutlet weak var collectionViewTvShows: UICollectionView!
    @IBOutlet weak var lblTvShowsTitle: UILabel!
    
    @IBAction func onTapReadMore(_ sender: Any) {
        guard let url = NSURL(string: data?.homepage ?? "") else { return }
        UIApplication.shared.open(url as URL)
    }
    
    private let networkAgent = AlamofireNetworkAgent.shared
    private let actorModel = ActorModelImpl.sharedModel
    
    var tvShowsByActor : [MovieResult] = []
    var moviesByActor : [MovieResult] = []
    
    var data : ActorDetailResponse?
    
    var actorId : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        fetchDetails()
        fetchTVCredits()
    }
    
    private func fetchDetails() {
        if let id = actorId {
            actorModel.getActorDetails(id)
            { result in
                switch result {
                case .success(let actorDetailsResponse) :
                    self.data = actorDetailsResponse
                    self.bindData()
                case .failure(let error) :
                    print(error)
                }
                
            }
        }
    }
    
    private func fetchTVCredits() {
        if let id = actorId {
            actorModel.getTVShowsByActor(id) { result in
                switch result {
                case .success(let tvShows) :
                    self.tvShowsByActor = tvShows
                    self.collectionViewTvShows.reloadData()
                case .failure(let error) :
                    print(error)
                }
                
            }
        }
    }
    
    private func bindData() {
        lblActorName.text = data?.name
        lblBiography.text = data?.biography
        tvActorBirthdate.text = data?.birthday
        let backdropPath = "\(NetworkConstants.BASE_IMAGE_URL)\(data?.profilePath ?? "")"
        ivActorProfile.sd_setImage(with: URL(string: backdropPath))
        lblTvShowsTitle.text =  "TvShows by \(data?.name ?? "")"
        
    }

    private func setupCollectionView() {
        collectionViewTvShows.delegate = self
        collectionViewTvShows.dataSource = self
        collectionViewTvShows.registerCell(identifier: PopularFilmCollectionViewCell.identifier)
    }


}

extension ActorDetailsViewController : UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewTvShows {
            return tvShowsByActor.count
        }
        else {
            return moviesByActor.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeCell(identifier: PopularFilmCollectionViewCell.identifier, indexPath: indexPath) as! PopularFilmCollectionViewCell
        if collectionView == collectionViewTvShows {
            cell.data = tvShowsByActor[indexPath.row]
        }
        else {
            cell.data = moviesByActor[indexPath.row]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionViewTvShows {
            if let id = tvShowsByActor[indexPath.row].id {
                navigateToSeriesDetailViewController(movieId: id)
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width : CGFloat = (collectionView.frame.width) / 3
        let height : CGFloat = 260
        return CGSize(width : width , height : height)
    }
    
}

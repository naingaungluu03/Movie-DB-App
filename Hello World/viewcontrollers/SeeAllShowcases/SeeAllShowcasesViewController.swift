//
//  SeeAllShowcasesViewController.swift
//  Hello World
//
//  Created by Harry Jason on 11/07/2021.
//

import UIKit

class SeeAllShowcasesViewController: UIViewController {

    @IBOutlet weak var collectionViewShowCases: UICollectionView!
    
    private let networkAgent = AlamofireNetworkAgent.shared
    private let movieModel = MovieModelImpl.sharedModel
    
    private var showcasesList : [MovieResult] = []
    private var totalPages = 1
    private var currentPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupCollectionView()
        fetchShowcaseList()
    }
    
    private func setupCollectionView() {
        collectionViewShowCases.dataSource = self
        collectionViewShowCases.delegate = self
        collectionViewShowCases.registerCell(identifier: ShowcaseCollectionViewCell.identifier)
    }

    private func fetchShowcaseList() {
        movieModel.getTopRatedMovieList(pageNo: currentPage)
        { result in
            switch result {
            case .success(let movieListResponse) :
                self.showcasesList.append(contentsOf: movieListResponse.results ?? [])
                self.collectionViewShowCases.reloadData()
                self.totalPages = movieListResponse.totalPages ?? 1

            case .failure(let error) : print(error)
            }
           
        }
    }

}

extension SeeAllShowcasesViewController : UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return showcasesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeCell(identifier: ShowcaseCollectionViewCell.identifier, indexPath: indexPath) as! ShowcaseCollectionViewCell
        cell.data = showcasesList[indexPath.row]
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let isLastItem = (indexPath.row == (showcasesList.count - 1))
        let hasNextPage = ( totalPages - currentPage ) > 0
        if isLastItem && hasNextPage {
            currentPage += 1
            fetchShowcaseList()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width : CGFloat = collectionView.frame.width - 16
        let height : CGFloat = 200
        return CGSize(width: width , height: height)
    }
    
}

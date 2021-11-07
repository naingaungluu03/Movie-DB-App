//
//  SearchViewController.swift
//  Hello World
//
//  Created by Harry Jason on 11/07/2021.
//

import UIKit
import RxSwift

class SearchViewController: UIViewController {

    @IBOutlet weak var collectionViewSearchResult : UICollectionView!
    
    var searchBar = UISearchBar()
    
    var searchResults : [MovieResult] = []
    
    let disposeBag : DisposeBag = DisposeBag()

    
    private let networkAgent = AlamofireNetworkAgent.shared
    private var totalPages = 1
    private var currentPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        
        searchBar.placeholder = "Search"
        searchBar.backgroundColor = UIColor(named: "Color")
        searchBar.tintColor = .white
        searchBar.searchTextField.textColor = .white
        searchBar.delegate = self
        
        self.navigationItem.titleView = searchBar
    }
    
    private func setupCollectionView() {
        collectionViewSearchResult.delegate = self
        collectionViewSearchResult.dataSource = self
        collectionViewSearchResult.registerCell(identifier: PopularFilmCollectionViewCell.identifier)
    }
    
    private func searchContent(_ query : String) {
        let processedQuery = query.replacingOccurrences(of: " ", with: "+")
        networkAgent.searchMovie(query: processedQuery, pageNo: currentPage)
        { result in
            switch result {
            case .success(let movieListResponse) :
                self.searchResults.append(contentsOf: movieListResponse.results ?? [])
                self.collectionViewSearchResult.reloadData()
                self.totalPages = movieListResponse.totalPages ?? 1
            case .failure(let error):
                print(error)
            }
        }
    }

}

extension SearchViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchContent(searchBar.text ?? "")
        searchBar.endEditing(true)
    }
}

extension SearchViewController : UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeCell(identifier: PopularFilmCollectionViewCell.identifier, indexPath: indexPath) as! PopularFilmCollectionViewCell
        cell.data = searchResults[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width : CGFloat = (collectionView.frame.width - 40) / 3
        let height : CGFloat = 260
        return CGSize(width : width , height : height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let movieId = searchResults[indexPath.row].id {
            navigateToMovieDetailViewController(movieId: movieId)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let isLastItem = (indexPath.row == (searchResults.count - 1))
        let hasNextPage = ( totalPages - currentPage ) > 0
        if isLastItem && hasNextPage {
            currentPage += 1
            searchContent(searchBar.text ?? "")
        }
    }
}



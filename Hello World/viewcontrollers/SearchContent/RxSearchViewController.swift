//
//  RxSearchController.swift
//  Hello World
//
//  Created by Harry Jason on 25/09/2021.
//

import Foundation
import RxSwift
import RxCocoa

class RxSearchViewController : UIViewController {
    
    @IBOutlet weak var collectionViewSearchResult: UICollectionView!
    
    var searchBar = UISearchBar()
    
    var searchResults : [MovieResult] = []
    
    var rxSearchResults : BehaviorSubject<[MovieResult]> = BehaviorSubject(value: [])
    
    let disposeBag : DisposeBag = DisposeBag()

    
    private let networkAgent = AlamofireNetworkAgent.shared
    private var totalPages = 1
    private var currentPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        initObservers()
    }
    
    //MARK: - init
    private func initView() {
        searchBar.placeholder = "Search"
        searchBar.backgroundColor = UIColor(named: "Color")
        searchBar.tintColor = .white
        searchBar.searchTextField.textColor = .white
        
        self.navigationItem.titleView = searchBar
        
        setupCollectionView()
    }
    
    private func initObservers(){
        addSearchBarObserver()
        addCollectionViewObserver()
        addPaginationObserver()
        addItemSelectionObserver()
    }
    
    private func setupCollectionView() {
        collectionViewSearchResult.delegate = self
        collectionViewSearchResult.registerCell(identifier: PopularFilmCollectionViewCell.identifier)
    }
    
    //MARK: - API
    private func rxSearchQuery(_ query : String) {
        RxNetworkAgent.shared.searchMovies(query: query, pageNo: currentPage)
            .do(onNext: { response in
                self.totalPages = response.totalPages ?? 1
            })
            .compactMap{ $0.results }
            .subscribe(onNext: { result in
                if self.currentPage == 1 {
                    self.rxSearchResults.onNext(result)
                } else {
                    self.rxSearchResults.onNext(try! self.rxSearchResults.value() + result)
                }
            })
            .disposed(by: disposeBag)
    }

}

//MARK: Rx Functions
extension RxSearchViewController {
    func addSearchBarObserver() {
        searchBar.rx.text.orEmpty
            .debounce(RxTimeInterval.milliseconds(1000), scheduler: MainScheduler.instance)
            .do(onNext: { value in
                print(value)
            })
            .subscribe(onNext: { query in
                if query.isEmpty {
                    self.currentPage = 1
                    self.totalPages = 1
                    self.rxSearchResults.onNext([])
                } else {
                    self.rxSearchQuery(query)
                }
            })
            .disposed(by: disposeBag)
        
    }
    
    func addCollectionViewObserver() {
        rxSearchResults
            .bind(to: collectionViewSearchResult.rx.items(cellIdentifier: PopularFilmCollectionViewCell.identifier, cellType: PopularFilmCollectionViewCell.self))
            { row , element , cell in
                cell.data = element
            }
            .disposed(by: disposeBag)
    }
    
    func addPaginationObserver() {
        Observable.combineLatest(
            collectionViewSearchResult.rx.willDisplayCell,
            searchBar.rx.value
        ).subscribe { (cellTuple , query) in
            let (_ , indexPath) = cellTuple
            let totalItems = try! self.rxSearchResults.value().count
            let isLastItem = (indexPath.row == (totalItems - 1))
            let hasNextPage = ( self.totalPages - self.currentPage ) > 0
            if isLastItem && hasNextPage {
                self.currentPage += 1
                self.rxSearchQuery(query ?? "")
            }
        }.disposed(by: disposeBag)
    }
    
    func addItemSelectionObserver() {
        collectionViewSearchResult.rx.itemSelected
            .subscribe (onNext: { indexPath in
                let items = try! self.rxSearchResults.value()
                let item = items[indexPath.row]
                self.navigateToMovieDetailViewController(movieId: item.id!)
            })
            .disposed(by: disposeBag)

    }
}


extension RxSearchViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width : CGFloat = (collectionView.frame.width - 40) / 3
        let height : CGFloat = 260
        return CGSize(width : width , height : height)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let isLastItem = (indexPath.row == (searchResults.count - 1))
        let hasNextPage = ( totalPages - currentPage ) > 0
        if isLastItem && hasNextPage {
            currentPage += 1
            rxSearchQuery(searchBar.text ?? "")
        }
    }
}

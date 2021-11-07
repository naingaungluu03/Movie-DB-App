//
//  MovieSliderTableViewCell.swift
//  Hello World
//
//  Created by Harry Jason on 09/05/2021.
//

import UIKit

class MovieSliderTableViewCell: UITableViewCell {

    @IBOutlet weak var movieCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    weak var delegate : MovieItemDelegate? = nil
    
    var data : [MovieResult]? {
        didSet {
            if let _ = data {
                movieCollectionView.reloadData()
                pageControl.numberOfPages = movieCollectionView.numberOfItems(inSection: 0)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        // Initialization codes
        movieCollectionView.dataSource = self
        movieCollectionView.delegate = self
        movieCollectionView.registerCell(identifier: MovieSliderCollectionViewCell.identifier)
        pageControl.numberOfPages = movieCollectionView.numberOfItems(inSection: 0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension MovieSliderTableViewCell : UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeCell(identifier: MovieSliderCollectionViewCell.identifier, indexPath: indexPath)
        
        (cell as! MovieSliderCollectionViewCell).data = data?[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: CGFloat(200))
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x)  / Int(scrollView.frame.width)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x)  / Int(scrollView.frame.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let movie = data?[indexPath.row] {
            delegate?.onTapMovie(movie: movie)
        }
    }
}


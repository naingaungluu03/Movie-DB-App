//
//  PopularFilmTableViewCell.swift
//  Hello World
//
//  Created by Harry Jason on 15/05/2021.
//

import UIKit

class PopularFilmTableViewCell: UITableViewCell {

    @IBOutlet weak var popularMoviesCollectionView: UICollectionView!
    @IBOutlet weak var lblSectionTitle : UILabel!
    
    weak var delegate : MovieItemDelegate? = nil
    
    var data : [MovieResult]? {
        didSet {
            if let _ = data {
                popularMoviesCollectionView.reloadData()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        popularMoviesCollectionView.dataSource = self
        popularMoviesCollectionView.delegate = self
        popularMoviesCollectionView.registerCell(identifier: PopularFilmCollectionViewCell.identifier)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension PopularFilmTableViewCell : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeCell(identifier: PopularFilmCollectionViewCell.identifier, indexPath: indexPath)
        
        (cell as! PopularFilmCollectionViewCell).data = data?[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 3, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let movie = data?[indexPath.row] {
            delegate?.onTapMovie(movie: movie)
        }
    }
}


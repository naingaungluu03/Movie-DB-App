//
//  PopularFilmCollectionViewCell.swift
//  Hello World
//
//  Created by Harry Jason on 16/05/2021.
//

import UIKit
import SDWebImage

class PopularFilmCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var ivMovieCover: UIImageView!
    @IBOutlet weak var labelMovieTitle : UILabel!
    @IBOutlet weak var ratingControl : RatingControl!
    @IBOutlet weak var lblRating : UILabel!
    
    var data : MovieResult? {
        didSet {
            if let data = data {
                let title = data.originalTitle ?? data.originalName ?? ""
                let backdropPath = "\(NetworkConstants.BASE_IMAGE_URL)\(data.posterPath ?? "")"
                
                let rating = data.voteAverage ?? 0.0
                lblRating.text = "\(rating)"
                ratingControl.rating = Int(rating * 0.5)
                labelMovieTitle.text = title
                ivMovieCover.sd_setImage(with: URL(string: backdropPath))
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        ivMovieCover.layer.cornerRadius = 4
    }

}

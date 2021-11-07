//
//  MovieSliderCollectionViewCell.swift
//  Hello World
//
//  Created by Harry Jason on 09/05/2021.
//

import UIKit
import SDWebImage

class MovieSliderCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var lableMovieTitle : UILabel!
    @IBOutlet weak var imgBackdrop : UIImageView!
    
    var data : MovieResult? {
        didSet {
            if let data = data {
                let title = data.originalTitle
                let backdropPath = "\(NetworkConstants.BASE_IMAGE_URL)\(data.backdropPath ?? "")"
                print(backdropPath)
                
                lableMovieTitle.text = title
                imgBackdrop.sd_setImage(with: URL(string: backdropPath))
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

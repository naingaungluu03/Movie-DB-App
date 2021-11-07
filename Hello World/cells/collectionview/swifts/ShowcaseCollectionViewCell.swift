//
//  ShowcaseCollectionViewCell.swift
//  Hello World
//
//  Created by Harry Jason on 16/05/2021.
//

import UIKit
import SDWebImage

class ShowcaseCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var ivMovieCover: UIImageView!
    @IBOutlet weak var labelMovieTitle : UILabel!
    @IBOutlet weak var lblDate : UILabel!

    
    var data : MovieResult? {
        didSet {
            if let _ = data {
                let title = data?.originalTitle ?? data?.originalName ?? ""
                let backdropPath = "\(NetworkConstants.BASE_IMAGE_URL)\(data?.backdropPath ?? "")"
                print(backdropPath)
                
                labelMovieTitle.text = title
                ivMovieCover.sd_setImage(with: URL(string: backdropPath))
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

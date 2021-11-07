//
//  GenreCollectionViewCell.swift
//  Hello World
//
//  Created by Harry Jason on 16/05/2021.
//

import UIKit

class GenreCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lblGenre: UILabel!
    @IBOutlet weak var viewTabIndicator: UIView!
    @IBOutlet weak var viewContainer: UIView!
    
    var onTapGenre : ((Int) -> Void) = { _ in
        
    }
    
    var data : GenreVO? = nil{
        didSet{
            if let genre = data {
                lblGenre.text = genre.name
                genre.isSelected  ? (viewTabIndicator.isHidden = false) : (viewTabIndicator.isHidden = true)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let tapGestureForContainer = UITapGestureRecognizer(
            target: self,
            action: #selector(didTapGenre)
        )
        
        viewContainer.isUserInteractionEnabled = true
        viewContainer.addGestureRecognizer(tapGestureForContainer)
        
    }
    
    @objc func didTapGenre(){
        onTapGenre(data?.id ?? 0)
    }

}

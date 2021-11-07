//
//  MovieShowTimeTableViewCell.swift
//  Hello World
//
//  Created by Harry Jason on 16/05/2021.
//

import UIKit

class MovieShowTimeTableViewCell: UITableViewCell {

    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var lblSeeMore: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
//        viewBackground.layer.cornerRadius = 15
//        viewBackground.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMinYCorner]
        
        lblSeeMore.underlineText()
    }
}

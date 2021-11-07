//
//  ProductionCompanyCollectionViewCell.swift
//  Hello World
//
//  Created by Harry Jason on 04/07/2021.
//

import UIKit
import SDWebImage

class ProductionCompanyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var lblCompanyName : UILabel!
    @IBOutlet weak var ivCompanyLogo : UIImageView!
    @IBOutlet weak var viewOverlay: UIView!
    
    var data : ProductionCompany? {
        didSet {
            if let company = data {
                
                if(data?.logoPath == nil) {
                    lblCompanyName.text = company.name
                    lblCompanyName.isHidden = false
                    ivCompanyLogo.isHidden = true
                }
                else {
                    lblCompanyName.text = ""
                    lblCompanyName.isHidden = true
                    let companyLogoUrl = "\(NetworkConstants.BASE_IMAGE_URL)\(data?.logoPath ?? "")"
                    ivCompanyLogo.sd_setImage(with: URL(string: companyLogoUrl))
                }
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

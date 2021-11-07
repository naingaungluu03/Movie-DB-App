//
//  BestActorsCollectionViewCell.swift
//  Hello World
//
//  Created by Harry Jason on 16/05/2021.
//

import UIKit
import SDWebImage

class BestActorsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var ivHeart: UIImageView!
    @IBOutlet weak var ivHeartFill: UIImageView!
    @IBOutlet weak var lblActorName : UILabel!
    @IBOutlet weak var lblKnownFor : UILabel!
    @IBOutlet weak var ivActorProfile : UIImageView!
    
    var data : ActorInfoResponse? {
        didSet {
            if let _ = data {
                let profileImageUrl = "\(NetworkConstants.BASE_IMAGE_URL)\(data?.profilePath ?? "")"
                lblActorName.text = data?.name
                lblKnownFor.text = data?.knownForDepartment
                ivActorProfile.sd_setImage(with: URL(string: profileImageUrl))
                print("Profile imge path => \(profileImageUrl)")
            }
        }
    }
    
    
    var delegate : ActorActionDelegate? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        ivHeart.isHidden = false
        ivHeartFill.isHidden = true
        initGestureRecognizers()
    }
    
    private func initGestureRecognizers(){
        let tapGestureForFavourite = UITapGestureRecognizer(target: self, action: #selector(onTapFav))
        ivHeart.isUserInteractionEnabled = true
        ivHeart.addGestureRecognizer(tapGestureForFavourite)
        
        let tapGestureForUnFavourite = UITapGestureRecognizer(target: self, action: #selector(onTapUnFavourite))
        ivHeartFill.isUserInteractionEnabled = true
        ivHeartFill.addGestureRecognizer(tapGestureForUnFavourite)
    }
    
    @objc func onTapFav(){
        ivHeart.isHidden = true
        ivHeartFill.isHidden = false
        delegate?.onTapDelegate(isFav: true)
    }
    
    @objc func onTapUnFavourite(){
        ivHeart.isHidden = false
        ivHeartFill.isHidden = true
        delegate?.onTapDelegate(isFav: false)
    }

}

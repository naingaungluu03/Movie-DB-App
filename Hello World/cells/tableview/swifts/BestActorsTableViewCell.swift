//
//  BestActorsTableViewCell.swift
//  Hello World
//
//  Created by Harry Jason on 16/05/2021.
//

import UIKit

class BestActorsTableViewCell: UITableViewCell {

    @IBOutlet weak var lblMoreActors: UILabel!
    @IBOutlet weak var collectionViewBestActors: UICollectionView!
    
    var onTapSeeMoreDelegate : (() -> Void)?
    
    var data : [ActorInfoResponse]? {
        didSet {
            if let _ = data {
                collectionViewBestActors.reloadData()
            }
        }
    }
    
    var onTapActorDelegate : ((Int) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lblMoreActors.underlineText()
        
        collectionViewBestActors.dataSource = self
        collectionViewBestActors.delegate = self
        collectionViewBestActors.registerCell(identifier: BestActorsCollectionViewCell.identifier)
        setupListeners()
    }
    
    private func setupListeners() {
        lblMoreActors.isUserInteractionEnabled = true
        let gestureForSeeAllActors = UITapGestureRecognizer(target: self, action: #selector(onTapSeeAllActors))
        lblMoreActors.addGestureRecognizer(gestureForSeeAllActors)
    }
    
    @objc func onTapSeeAllActors() {
        (onTapSeeMoreDelegate ?? {})()
        print("onTapSeeAllActors")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension BestActorsTableViewCell : UICollectionViewDataSource , UICollectionViewDelegateFlowLayout, ActorActionDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeCell(identifier: BestActorsCollectionViewCell.identifier, indexPath: indexPath) as! BestActorsCollectionViewCell
        cell.delegate = self
        cell.data = data?[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let actorId = data?[indexPath.row].id {
            onTapActorDelegate?(actorId)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2.5, height: CGFloat(200))
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.subviews[scrollView.subviews.count - 1].subviews[0].backgroundColor = UIColor(named: "color_accent")
    }
    
    //Actor Action Delegate
    func onTapDelegate(isFav: Bool) {
        debugPrint("isFavourite => \(isFav)")
    }
    
    
}

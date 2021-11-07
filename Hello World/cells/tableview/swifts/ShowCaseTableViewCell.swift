//
//  ShowCaseTableViewCell.swift
//  Hello World
//
//  Created by Harry Jason on 16/05/2021.
//

import UIKit

class ShowCaseTableViewCell: UITableViewCell {

    @IBOutlet weak var lblMoreShowcases: UILabel!
    @IBOutlet weak var collectionViewShowcases: UICollectionView!
    @IBOutlet weak var heightConstraint : NSLayoutConstraint!
    
    var onTapMoreShowcasesDelegate : (() -> Void)?
    
    var data : [MovieResult]? {
        didSet {
            if let _ = data {
                collectionViewShowcases.reloadData()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let itemWidth = collectionViewShowcases.frame.width - 50
        let itemHeight = (itemWidth / 16) * 9
        heightConstraint.constant = itemHeight + 40
        setupListeners()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        lblMoreShowcases.underlineText()
        
        collectionViewShowcases.dataSource = self
        collectionViewShowcases.delegate = self
        collectionViewShowcases.registerCell(identifier: ShowcaseCollectionViewCell.identifier)
        
    }
    
    private func setupListeners() {
        lblMoreShowcases.isUserInteractionEnabled = true
        let tapGestureForMoreShowcases = UITapGestureRecognizer(target: self, action: #selector(onTapSeeMoreShowcases))
        lblMoreShowcases.addGestureRecognizer(tapGestureForMoreShowcases)
    }
    
    @objc func onTapSeeMoreShowcases() {
        (onTapMoreShowcasesDelegate ?? {})()
    }
    
}

extension ShowCaseTableViewCell : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeCell(identifier: ShowcaseCollectionViewCell.identifier, indexPath: indexPath)
        
        (cell as! ShowcaseCollectionViewCell).data = data?[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = collectionView.frame.width - 50
        let itemHeight = (itemWidth / 16) * 9
        return CGSize(width : itemWidth , height : itemHeight)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        (scrollView.subviews[scrollView.subviews.count-1]).subviews[0].backgroundColor = UIColor(named: "color_accent")
    }
    
}

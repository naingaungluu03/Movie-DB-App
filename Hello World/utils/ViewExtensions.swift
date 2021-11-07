//
//  ViewExtensions.swift
//  Hello World
//
//  Created by Harry Jason on 16/05/2021.
//

import Foundation
import UIKit

extension UILabel {
    func underlineText(){
        let attributedString = NSMutableAttributedString.init(string: self.text ?? "")
        attributedString.addAttribute(
            NSAttributedString.Key.underlineStyle,
            value: 1.5,
            range: NSRange(location: 0, length: attributedString.length)
        )
        attributedString.addAttribute(
            .font,
            value: font as UIFont,
            range: NSRange(location: 0, length: attributedString.length)
        )
        self.attributedText = attributedString
    }
}

extension UITableViewCell {
    static var identifier : String {
        return String(describing: self)
    }
}

extension UITableView {
    func registerForCell(identifier : String){
        register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
    }
    func  dequeCell<T : UITableViewCell>(identifier : String , indexPath : IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: identifier,for: indexPath) as? T
        else {
            return UITableViewCell() as! T
        }
        return cell
    }
}

extension UICollectionViewCell {
    static var identifier : String {
        return String(describing: self)
    }
}

extension UICollectionView {
    func registerCell(identifier : String){
        register(UINib(nibName: identifier, bundle: nil), forCellWithReuseIdentifier: identifier)
    }
func dequeCell<T : UICollectionViewCell>(identifier : String , indexPath : IndexPath) -> T{
        guard let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? T
        else {
            return UICollectionViewCell() as! T
        }
        return cell
    }
}

extension UIViewController {
    static var identifier : String {
        return String(describing: self)
    }
}

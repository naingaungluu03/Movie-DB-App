//
//  RatingControl.swift
//  Hello World
//
//  Created by Harry Jason on 15/05/2021.
//

import UIKit

@IBDesignable
class RatingControl: UIStackView {
    
    @IBInspectable var starSize : CGSize = CGSize(width: 50.0, height: 50.0){
        didSet{
            setUpButtons()
            updateButtonRating()
        }
    }
    @IBInspectable var starCount :  Int = 5 {
        didSet{
            setUpButtons()
            updateButtonRating()
        }
    }
    @IBInspectable var rating : Int = 3 {
        didSet{
            updateButtonRating()
        }
    }
    
    var ratingButtons = [UIButton]()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpButtons()
        updateButtonRating()
    }
    
    required init(coder : NSCoder){
        super.init(coder: coder)
        setUpButtons()
        updateButtonRating()
    }
    
    private func setUpButtons(){

        clearStackView()
        for _ in 0..<starCount {
            
            let button = UIButton()
            button.setImage(UIImage(named: "ic_star_filled"), for: .selected)
            button.setImage(UIImage(named: "ic_star_outlined"), for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            addArrangedSubview(button)
            
            button.isUserInteractionEnabled = false
            button.isSelected = true
            
            ratingButtons.append(button)
        }
        
    }
    
    private func clearStackView(){
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()
    }
    
    private func updateButtonRating(){
        debugPrint(rating)
        for (index,  button) in ratingButtons.enumerated() {
            button.isSelected = index < rating
        }
    }

}

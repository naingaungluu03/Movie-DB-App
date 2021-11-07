//
//  ViewController.swift
//  Hello World
//
//  Created by Harry Jason on 08/05/2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textFieldName:UITextField!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var imageProfile: UIImageView!
    
    @IBAction func didTapButton(_ sender : Any){
        labelName.text = textFieldName.text
        textFieldName.text = ""
        debugPrint("Button Tapped")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureForImage = UITapGestureRecognizer(target: self, action: #selector(onTapImage))
        imageProfile.addGestureRecognizer(tapGestureForImage)
        imageProfile.isUserInteractionEnabled = true

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        debugPrint("View will appear")
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        debugPrint("View did appear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        debugPrint("View will disappear")
    }
    
    override func viewDidDisappear(_ animated: Bool){
        super.viewDidAppear(animated)
        debugPrint("View did disappear")
    }

    @objc func onTapImage(){
        textFieldName.text = "Naing Aung Luu"
    }

}


//
//  BasicUIComponentsViewController.swift
//  Hello World
//
//  Created by Harry Jason on 15/05/2021.
//

import UIKit

class BasicUIComponentsViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textView: UILabel!
    
    @IBAction func didTapGreet(_ sender: Any) {
        textView.text = textField.text
        debugPrint("Button Tapped")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTapImage))
        imageView.addGestureRecognizer(tapGestureRecognizer)
        imageView.isUserInteractionEnabled = true

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        debugPrint("view did appear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        debugPrint("view did disappeared")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        debugPrint("view will appear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        debugPrint("view will disappear")
    }
    
    @objc func onTapImage(){
        textField.text = "Naing Aung Luu"
    }
    
}

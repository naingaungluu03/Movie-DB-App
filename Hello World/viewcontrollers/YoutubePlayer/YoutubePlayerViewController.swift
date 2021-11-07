//
//  YoutubePlayerViewController.swift
//  Hello World
//
//  Created by Harry Jason on 09/07/2021.
//

import UIKit
import YouTubePlayer

class YoutubePlayerViewController: UIViewController {
    
    @IBOutlet weak var videoPlayer : YouTubePlayerView!
    
    var youtubeVideoId : String? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        if let data = youtubeVideoId {
            videoPlayer.loadVideoID(data)
            videoPlayer.play()
        }
        else {
            print("Invalid Youtube Id")
        }
        
    }
    
    @IBAction func onTapDismissVideo(_ sender : UIButton!) {
        self.dismiss(animated: true, completion: {})
    }

}

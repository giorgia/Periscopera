//
//  ViewController.swift
//  Periscopera
//
//  Created by Giorgia Marenda on 2/14/16.
//  Copyright © 2016 Giorgia Marenda. All rights reserved.
//

import UIKit
import FOGMJPEGImageView

class ViewController: UIViewController {

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var videoLabel: UILabel!
    @IBOutlet weak var containerView: FOGMJPEGImageView!
    var videos = [Video]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
            
        Model.requestModel { (videos, error) -> Void in
            guard let list = videos else { return }
            self.videos = list
            self.play()
        }
    }
    
    func play() {
        let randomInt = random() % videos.count
        let video = videos[randomInt]
        let tags = video.tags?.joinWithSeparator(", ") ?? ""
        if let videoUrl = video.video {
            containerView.startWithURL(videoUrl)
            videoLabel.text = tags.uppercaseString
            cityLabel.text = (video.city ?? "") + " // " + (video.country ?? "")
        }
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .MotionShake {
            containerView.stop()
            play()
        }
    }
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
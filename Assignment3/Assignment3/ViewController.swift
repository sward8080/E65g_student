//
//  ViewController.swift
//  Assignment3
//
//  Created by Van Simmons on 1/15/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var stepButton: UIButton!
    @IBOutlet weak var gridView: GridView!
    
    var stepAudioPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        /* 
          *     Mad dash and shameless attempt at "Texas Two Step" addition for bonus points
          *     It plays the short clip just fine but doesnt seem to stop on next button press.
          *     Also prints strange error messages to console.
          */
        let audio = Bundle.main.path(forResource: "twoStep", ofType: "mp3")
        
        do {
            stepAudioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: audio! ))
            stepAudioPlayer.prepareToPlay()
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
        }
        catch{
            print(error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func stepButtonAction(_ sender: Any) {
        gridView.stepPressedNextGrid()
        
        // Remove to stop the awesome music on button press
        if stepAudioPlayer.isPlaying { stepAudioPlayer.stop() }
        stepAudioPlayer.play()
        stepAudioPlayer.prepareToPlay()
    }

}


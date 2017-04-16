//
//  InstrumentationViewController.swift
//  Assignment4
//
//  Created by Van Simmons on 1/15/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

class InstrumentationViewController: UIViewController {
    
    @IBOutlet weak var gridSizeStepper: UIStepper!
    @IBOutlet weak var gridSizeText: UITextField!
    @IBOutlet weak var rate: UILabel!
    @IBOutlet weak var refreshSlider: UISlider!
    @IBOutlet weak var toggleSwitch: UISwitch!
    
    var engine : StandardEngine = StandardEngine.engine
    let nc = NotificationCenter.default
    let name = Notification.Name(rawValue: "EngineUpdate")
    var valInHZ = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        gridSizeStepper.value = Double(engine.grid.size.cols)
        gridSizeText.text = "\(Int(engine.grid.size.cols))"
        rate.text = "\(refreshSlider.value) Hz"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func editingBegan(_ sender: UITextField) {
        
    }
    
    @IBAction func editingChanged(_ sender: UITextField) {
    }
    
    
    @IBAction func editingEnded(_ sender: UITextField) {
        guard let text = sender.text else { return }
        guard let val = Int(text) else {
            showErrorAlert(withMessage: "Invalid Value: \(text), Please Try Again.") {
                sender.text = "\(self.engine.grid.size)"
            }
            return
        }
        engine.grid = Grid(val, val)
        engine.delegate?.engineDidUpdate(withGrid: engine.grid)
        let n = Notification(name: name,
                             object: nil,
                             userInfo: ["engine" : engine])
        nc.post(n)
    }

    @IBAction func stepGridSize(_ sender: UIStepper) {
        let newGridSize = Int(sender.value)
        gridSizeText.text = "\(newGridSize)"
        engine.grid = Grid(newGridSize, newGridSize)
        engine.delegate?.engineDidUpdate(withGrid: engine.grid)
        let n = Notification(name: name,
                             object: nil,
                             userInfo: ["engine" : engine])
        nc.post(n)
    }

    @IBAction func refreshChanged(_ sender: UISlider) {
        let num = round( Double(sender.value) * 10.0) / 10.0
        print("refresh changed sender value: \(num)")
        rate.text = "\(num) Hz"
    }
    
    @IBAction func refreshUpInside(_ sender: UISlider) {
        valInHZ = round( Double(sender.value) * 10.0) / 10.0
        print("refresh up inside: \(valInHZ)")
        if engine.refreshTimer != nil {
            engine.refreshTimer?.invalidate()
            engine.refreshTimer = nil
        }
        engine.refreshRate = 1 / valInHZ
    }
    
    @IBAction func toggle(_ sender: UISwitch) {
        if (sender.isOn) {
            refreshSlider.isEnabled = true
            if valInHZ < Double(refreshSlider.minimumValue) {
                refreshSlider.value = 1.0
                engine.refreshRate = 1
            }
            engine.refreshIsOn = true
        } else {
            refreshSlider.isEnabled = false
            if engine.refreshTimer != nil {
                engine.refreshTimer?.invalidate()
                engine.refreshTimer = nil
            }
            engine.refreshIsOn = false
        }
    }
    
    //MARK: AlertController Handling
    func showErrorAlert(withMessage msg:String, action: (() -> Void)? ) {
        let alert = UIAlertController(
            title: "Alert",
            message: msg,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            alert.dismiss(animated: true) { }
            OperationQueue.main.addOperation { action?() }
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}


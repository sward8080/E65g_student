//
//  SimulationViewController.swift
//  Assignment4
//
//  Created by Van Simmons on 1/15/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit
import Foundation

class SimulationViewController: UIViewController, EngineDelegate {
    
    @IBOutlet weak var stepTapped: UIButton!
    @IBOutlet weak var startTapped: UIButton!
    @IBOutlet weak var stopTapped: UIButton!
    @IBOutlet weak var gridView: GridView!
    
    let defaults = UserDefaults.standard
    let nc = NotificationCenter.default
    let engineUpdate = Notification.Name(rawValue: "EngineUpdate")
    let cellUpdate = Notification.Name(rawValue: "CellUpdate")
    var engine = StandardEngine.engine

    override func viewDidLoad() {
        super.viewDidLoad()
        nc.addObserver(
            forName: engineUpdate,
            object: nil,
            queue: nil) { (n) in
                guard let update = n.userInfo!["gridSize"] else { return }
                let newSize = update as! Int
                self.engine.grid = Grid(newSize, newSize)
                self.gridView.setNeedsDisplay()
        }
        engine.delegate = self
        gridView.engine = engine
        gridView.setNeedsDisplay()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Delegate function
    func engineDidUpdate(withGrid: GridProtocol) {
        self.gridView.setNeedsDisplay()
        nc.post(name: cellUpdate, object: nil, userInfo: nil)
    }
    
    // Get next iteration of grid when "step" button tapped
    @IBAction func stepTapped(_ sender: UIButton) {
        engine.grid = engine.step()
        engineDidUpdate(withGrid: engine.grid)
    }
    
    // Start refresh of grid based on user provided refresh rate
    @IBAction func start(_ sender: UIButton) {
        if engine.refreshTimer != nil {
            engine.refreshTimer?.invalidate()
            engine.refreshTimer = nil
        }
        if (engine.refreshRate > 0.0 && engine.refreshIsOn) {
            engine.refreshTimer = Timer.scheduledTimer(
                withTimeInterval: engine.refreshRate,
                repeats: true
            ) { (t: Timer) in
                _ = self.engine.step()
                self.engineDidUpdate(withGrid: self.engine.grid)
            }
        } else {
            engine.refreshTimer?.invalidate()
            engine.refreshTimer = nil
        }
    }
    
    // Stop grid refresh. Invalidate timer
    @IBAction func stop(_ sender: UIButton) {
        if engine.refreshTimer != nil {
            engine.refreshTimer?.invalidate()
            engine.refreshTimer = nil
        }
    }
    
    // Reset SimulationViewController grid
    @IBAction func reset(_ sender: UIButton) {
        let size = engine.grid.size.rows
        engine.grid = Grid(size, size)
        engineDidUpdate(withGrid: engine.grid)
    }
    
    // Save SimulationViewController grid state to memory (JSON format)
    @IBAction func save(_ sender: UIButton) {
        UserDefaults.resetStandardUserDefaults()
        let savedState = engine.grid.savedState
        let savedSize = engine.grid.size.rows
        guard let savedData = try? JSONSerialization.data(withJSONObject: savedState) else { return }
        defaults.set(savedData, forKey: "savedData")
        defaults.set(savedSize, forKey: "savedSize")
        showConfigNameAlert(withMessage: "Enter Configuration Name") { (textField) in
            var newRow = Config(json: savedState, title: textField)
            newRow.size = savedSize
            self.nc.post(name: self.engineUpdate, object: nil, userInfo: ["simSave" : newRow])
        }
    }
    
    func showConfigNameAlert(withMessage msg: String, completion: @escaping (String) -> Void) {
        let newRowPopUp = UIAlertController(
            title: "Configuration",
            message: nil,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            let textField = newRowPopUp.textFields![0]
            guard let configName = textField.text else { return }
            completion(configName)
            newRowPopUp.dismiss(animated: true) {}
            self.navigationController?.popViewController(animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            newRowPopUp.dismiss(animated: true) { }
            self.navigationController?.popViewController(animated: true)
        }
        newRowPopUp.addTextField { (textField) in
            textField.placeholder = "Enter New Configuration Name"
        }
        newRowPopUp.addAction(okAction)
        newRowPopUp.addAction(cancelAction)
        self.present(newRowPopUp, animated: true, completion: nil)
    }
    
}

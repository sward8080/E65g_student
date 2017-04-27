//
//  SimulationViewController.swift
//  Assignment4
//
//  Created by Van Simmons on 1/15/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

class SimulationViewController: UIViewController, EngineDelegate {
    
    @IBOutlet weak var stepTapped: UIButton!
    @IBOutlet weak var startTapped: UIButton!
    @IBOutlet weak var stopTapped: UIButton!
    @IBOutlet weak var gridView: GridView!
    let nc = NotificationCenter.default
    let name = Notification.Name(rawValue: "EngineUpdate")
    var engine : StandardEngine = StandardEngine.engine

    override func viewDidLoad() {
        super.viewDidLoad()
        engine = StandardEngine.engine
        engine.delegate = self
        if gridView.points != nil {
            engine.setPoints(gridView.points!)
        }
        gridView.setNeedsDisplay()
        nc.addObserver(
            forName: name,
            object: nil,
            queue: nil) { (n) in
                guard let update = n.userInfo!["engine"] else { return }
                self.engine = update as! StandardEngine
                self.gridView.size = self.engine.grid.size.rows
                self.gridView.setNeedsDisplay()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Delegate function
    func engineDidUpdate(withGrid: GridProtocol) {
        gridView.size = withGrid.size.rows
        self.gridView.setNeedsDisplay()
    }
    
    // Get next iteration of grid when "step" button tapped
    @IBAction func stepTapped(_ sender: UIButton) {
        engine.grid = engine.step()
        let n = Notification(name: name,
                             object: nil,
                             userInfo: ["engine" : engine])
        engine.countGridStates()
        nc.post(n)
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
}

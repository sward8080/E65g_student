//
//  StatisticsViewController.swift
//  Assignment4
//
//  Created by Sean Ward on 4/15/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {

    @IBOutlet weak var statView: StatisticsView!
    @IBOutlet weak var cellsAlive: UILabel!
    @IBOutlet weak var cellsEmpty: UILabel!
    @IBOutlet weak var cellsBorn: UILabel!
    @IBOutlet weak var cellsDied: UILabel!
    
    let nc = NotificationCenter.default
    let cellUpdate = Notification.Name(rawValue: "CellUpdate")
    
    var engine : StandardEngine = StandardEngine.engine
    
    override func viewDidLoad() {
        
        // Update value of cellStates displayed on first load
        super.viewDidLoad()
        setFields()
        statView.setNeedsDisplay()
        nc.addObserver(
            forName: cellUpdate,
            object: nil,
            queue: nil) { (n) in
                self.setFields()
                self.statView.setNeedsDisplay()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setFields() {
        let numAlive = engine.grid.savedState["alive"]!.count
        let numBorn = engine.grid.savedState["born"]!.count
        let numDied = engine.grid.savedState["died"]!.count
        let numEmpty = (engine.grid.size.rows * engine.grid.size.cols)
                        - numAlive - numBorn - numDied
        
        cellsAlive.text = "# of Cells Alive: \(numAlive)"
        cellsEmpty.text = "# of Cells Empty: \(numEmpty)"
        cellsBorn.text = "# of Cells Born: \(numBorn)"
        cellsDied.text = "# of Cells Died: \(numDied)"
    }
}

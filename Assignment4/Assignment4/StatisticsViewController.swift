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
    let name = Notification.Name(rawValue: "EngineUpdate")
    
    var engine : StandardEngine = StandardEngine.engine
    
    override func viewDidLoad() {
        
        // Update value of cellStates displayed on first load
        super.viewDidLoad()
        setFields()
        
        nc.addObserver(
            forName: name,
            object: nil,
            queue: nil) { (n) in
                self.setFields()
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func setFields() {
        engine.resetStateCount()
        engine.countGridStates()
        cellsAlive.text = "# of Cells Alive: \(self.engine.numAlive)"
        cellsEmpty.text = "# of Cells Empty: \(self.engine.numEmpty)"
        cellsBorn.text = "# of Cells Born: \(self.engine.numBorn)"
        cellsDied.text = "# of Cells Died: \(self.engine.numDied)"
    }
}

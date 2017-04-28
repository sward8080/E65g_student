//
//  GridEditorViewController.swift
//  FinalProject
//
//  Created by Sean Ward on 4/21/17.
//  Copyright © 2017 Sean Ward. All rights reserved.
//

import UIKit

class GridEditorViewController: UIViewController {
    
    @IBOutlet weak var gridEditor: GridView!
    
    let nc = NotificationCenter.default
    let name = Notification.Name(rawValue: "EngineUpdate")
    var editorEngine : StandardEngine = StandardEngine(10, 10)

    override func viewDidLoad() {
        super.viewDidLoad()
        gridEditor.setNeedsDisplay()
        nc.addObserver(
            forName: name,
            object: nil,
            queue: nil) { (n) in
                guard let update = n.userInfo!["engine"] else { return }
                self.editorEngine = update as! StandardEngine
                self.gridEditor.size = self.editorEngine.grid.size.rows
                self.gridEditor.setNeedsDisplay()
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func save(_ sender: UIButton) {
        let n = Notification(name: name,
                             object: nil,
                             userInfo: ["engine" : editorEngine])
        editorEngine.countGridStates()
        nc.post(n)
        navigationController?.popViewController(animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

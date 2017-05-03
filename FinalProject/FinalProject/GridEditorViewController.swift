//
//  GridEditorViewController.swift
//  FinalProject
//
//  Created by Sean Ward on 4/21/17.
//  Copyright © 2017 Sean Ward. All rights reserved.
//

import UIKit

class GridEditorViewController: UIViewController, EngineDelegate {
    
    @IBOutlet weak var gridEditorView: GridView!
    
    let nc = NotificationCenter.default
    let engineUpdate = Notification.Name(rawValue: "EngineUpdate")
    var saveClosure: ((Config) -> Void)?
    var editorEngine = StandardEngine(10, 10)
    var grid : GridProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        editorEngine.delegate = self
        if let grid = grid { editorEngine.grid = grid }
        gridEditorView.engine = editorEngine
        gridEditorView.setNeedsDisplay()
        nc.addObserver(
            forName: engineUpdate,
            object: nil,
            queue: nil) { (n) in
                guard let update = n.userInfo!["gridSize"] else { return }
                let newSize = update as! Int
                self.editorEngine.grid = Grid(newSize, newSize)
                self.gridEditorView.setNeedsDisplay()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func engineDidUpdate(withGrid: GridProtocol) {
        self.gridEditorView.setNeedsDisplay()
    }

    
    @IBAction func save(_ sender: UIButton) {
        let savedEditorConfig = Config(json: editorEngine.grid.savedState)
        if let saveClosure = saveClosure {
            saveClosure(savedEditorConfig)
        }
        navigationController?.popViewController(animated: true)
    }
}

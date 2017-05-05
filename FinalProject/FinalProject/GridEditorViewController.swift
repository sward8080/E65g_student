//
//  GridEditorViewController.swift
//  FinalProject
//
//  Created by Sean Ward on 4/21/17.
//  Copyright © 2017 Sean Ward. All rights reserved.
//

import UIKit

class GridEditorViewController: UIViewController, EngineDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var gridEditorView: GridView!
    
    let nc = NotificationCenter.default
    let engineUpdate = Notification.Name(rawValue: "EngineUpdate")
    var saveClosure: ((Config) -> Void)?
    var textClosure: ((String, Int, [String : [[Int]]]) -> Void)?
    var editorEngine = StandardEngine(10, 10)
    var grid : GridProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        editorEngine.delegate = self
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
    
    func engineDidUpdate(withGrid: GridProtocol) {
        editorEngine.grid = withGrid
        self.gridEditorView.setNeedsDisplay()
    }

    
    @IBAction func save(_ sender: UIButton) {
        showConfigNameAlert(withMessage: "Enter Configuration Name") { (textField) in
            if let textClosure = self.textClosure {
                let state = self.editorEngine.grid.savedState
                let size = self.editorEngine.grid.size.rows
                textClosure(textField, size, state)
            }
        }
        nc.post(name: engineUpdate, object: nil, userInfo: ["grid" : editorEngine.grid])
    }

    //MARK: AlertController Handling
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

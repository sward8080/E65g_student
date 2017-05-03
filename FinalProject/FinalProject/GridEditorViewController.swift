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
    var textClosure: ((String) -> Void)?
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        showNewRowAlert(withMessage: "Enter Configuration Name") { (textField) in
            if let textClosure = self.textClosure {
                textClosure(textField)
            }
        }
    }
    
    func engineDidUpdate(withGrid: GridProtocol) {
        editorEngine.grid = withGrid
        self.gridEditorView.setNeedsDisplay()
    }

    
    @IBAction func save(_ sender: UIButton) {
        nc.post(name: engineUpdate, object: nil, userInfo: ["grid" : editorEngine.grid])
        
//        if let saveClosure = saveClosure {
//            saveClosure(savedEditorConfig)
//        }
//        if let newValue = configurationTextField.text,
//        let textClosure = textClosure {
//            textClosure(newValue)
//        }
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: AlertController Handling
    func showNewRowAlert(withMessage msg: String, completion: @escaping (String) -> Void) {
        let newRowPopUp = UIAlertController(
            title: "Configuration",
            message: nil,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            let textField = newRowPopUp.textFields![0]
            guard let configName = textField.text else { return }
            completion(configName)
            newRowPopUp.dismiss(animated: true) { }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            newRowPopUp.dismiss(animated: true) { }
        }
        newRowPopUp.addTextField { (textField) in
            textField.placeholder = "Enter New Configuration Name"
        }
        newRowPopUp.addAction(okAction)
        newRowPopUp.addAction(cancelAction)
        self.present(newRowPopUp, animated: true, completion: nil)
    }
}

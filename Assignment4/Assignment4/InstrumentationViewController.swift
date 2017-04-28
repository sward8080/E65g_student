//
//  InstrumentationViewController.swift
//  Assignment4
//
//  Created by Van Simmons on 1/15/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

class InstrumentationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var rowsLabel: UILabel!
    @IBOutlet weak var rowsSlider: UISlider!
    @IBOutlet weak var colsLabel: UILabel!
    @IBOutlet weak var colsSlider: UISlider!
    @IBOutlet weak var refreshTextField: UITextField!
    @IBOutlet weak var toggleSwitch: UISwitch!
    @IBOutlet weak var tableView: UITableView!
    
    var engine : StandardEngine = StandardEngine.engine
    let nc = NotificationCenter.default
    let name = Notification.Name(rawValue: "EngineUpdate")
    var refreshTimeInSeconds = 0.0
    let classURL = URL(string: "https://dl.dropboxusercontent.com/u/7544475/S65g.json")!
    var configurations : [Any]!
    
    // ---------------------------------------------------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()
        getData(url: classURL) { items in
            self.configurations = items
        }
        print("configurations count: \(configurations)")
        rowsLabel.text = "Rows: \(Int(engine.grid.size.rows))"
        colsLabel.text = "Columns: \(Int(engine.grid.size.cols))"
        refreshTextField.text = "1 Hz"
        addDoneButtonToKeyboard()
    }
    
    typealias GetJSONCompletionHandler = (_ patterns : [Any]) -> Void
    func getData(url: URL, completion: @escaping GetJSONCompletionHandler) {
        Fetcher().fetchJSON(url: url) { (json: Any?, message: String?) in
            guard message == nil else {
                print(message ?? "nil")
                return
            }
            guard let json = json else {
                print("no json")
                return
            }
            let array = json as! [Any]
            completion(array)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let cellSelected = tableView.indexPathForSelectedRow
//        if let cellSelected = cellSelected {
//            
//        }
//    }
//   
    
    @IBAction func addRow(_ sender: UIButton) {
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return configurations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "basic"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        let label = cell.contentView.subviews.first as! UILabel
        let jsonDictionary = configurations[indexPath.item] as! [String : Any ]
        label.text = jsonDictionary["title"] as? String
        return cell
    }
    
   
    @IBAction func gridSizeChanged(_ sender: UISlider) {
        rowsLabel.text = "Rows: \(Int(sender.value))"
        colsLabel.text = "Cols: \(Int(sender.value))"
        if sender == rowsSlider {
            colsSlider.value = sender.value
        } else { rowsSlider.value = sender.value }
    }
    
    @IBAction func gridSizeUpInside(_ sender: UISlider) {
        let val = Int(sender.value)
        engine.grid = Grid(val, val)
    }
    
    // Set Refresh rate
    @IBAction func editingBegan(_ sender: UITextField) {
        
    }
    
    @IBAction func editingChanged(_ sender: UITextField) {
        print("editing changed")
    }
    
    // Check for numeric entry in text field. Borrowed from Van's code in lecture 9
    @IBAction func editingEnded(_ sender: UITextField) {
        print("editing ended")
        guard let text = sender.text else { return }
        guard let val = Double(text) else {
            showErrorAlert(withMessage: "Invalid Value: \(text), Please Try Again.") {
                sender.text = "\(1)"
            }
            return
        }
        refreshTimeInSeconds = val
        engine.refreshRate = 1 / refreshTimeInSeconds
        refreshTextField.text = "\(Int(val)) Hz"
        print("engine refreshRate: \(engine.refreshRate)")
        engine.delegate?.engineDidUpdate(withGrid: engine.grid)
        let n = Notification(name: name,
                             object: nil,
                             userInfo: ["engine" : engine])
        nc.post(n)
    }
    
    // Create "Done" button and toolbar for number pad keyboard
    func addDoneButtonToKeyboard() {
        let toolbarFrame = CGRect(x: 0, y: 0, width: 320, height: 50)
        let doneToolbar: UIToolbar = UIToolbar(frame: toolbarFrame)
        doneToolbar.barStyle = UIBarStyle.default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(InstrumentationViewController.doneButtonAction))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        self.refreshTextField.inputAccessoryView = doneToolbar
    }
    
    // Close keyboard on "Done"
    func doneButtonAction() {
        refreshTextField.resignFirstResponder()
    }


    
    // Toggle timer refresh on/off
    @IBAction func toggle(_ sender: UISwitch) {
        if (sender.isOn) {
            refreshTextField.isEnabled = true
            if refreshTimeInSeconds < 1.0 {
                refreshTextField.text = "1 Hz"
                engine.refreshRate = 1
            }
            engine.refreshIsOn = true
        } else {
            refreshTextField.isEnabled = false
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


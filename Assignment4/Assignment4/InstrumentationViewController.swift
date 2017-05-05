//
//  InstrumentationViewController.swift
//  Assignment4
//
//  Created by Van Simmons on 1/15/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

class InstrumentationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var gridSize: UILabel!
    @IBOutlet weak var gridSizeSlider: UISlider!
    @IBOutlet weak var refreshTextField: UITextField!
    @IBOutlet weak var toggleSwitch: UISwitch!
    @IBOutlet weak var tableView: UITableView!
    
    var engine : StandardEngine = StandardEngine.engine
    let nc = NotificationCenter.default
    let engineUpdate = Notification.Name(rawValue: "EngineUpdate")
    var refreshTimeInSeconds = 0.0
    let classURL = URL(string: "https://dl.dropboxusercontent.com/u/7544475/S65g.json")!
    var configurations : [Any]!
    var tableData : TableData?
    var numUserConfigs = 1
    
    // ---------------------------------------------------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()
        getData(url: classURL) { items in
            self.configurations = items
            self.tableData = TableData(jsonArray: items)
        }
        gridSize.text = "Size: \(engine.grid.size.rows)"
        gridSizeSlider.value = Float(engine.grid.size.rows)
        refreshTextField.text = "1 Hz"
        addDoneButtonToKeyboard()
        nc.addObserver(
            forName: engineUpdate,
            object: nil,
            queue: nil) { (n) in
                guard let update = n.userInfo!["grid"] else { return }
                let savedEditorGrid = update as! GridProtocol
                self.engine.grid = savedEditorGrid
                self.engine.delegate?.engineDidUpdate(withGrid: savedEditorGrid)
        }
    }
    
    // Retrieve data from JSON array
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
            let jsonArray = json as! [Any]
            completion(jsonArray)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cellSelected = tableView.indexPathForSelectedRow
        if let cellSelected = cellSelected {
            let row = cellSelected.item
            if let vc = segue.destination as? GridEditorViewController {
                vc.editorEngine.grid = (tableData?.initializeEditor(row: row))!
                vc.textClosure = { configTitle, configSize, configState in
                    var currentRow = Config(json: configState, title: configTitle)
                    currentRow.size = configSize
                    if self.tableData != nil {
                        self.tableData?.gridPatterns[row] = currentRow
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
   
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let tableData = tableData else { return 0 }
        return tableData.gridPatterns.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "basic"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        let label = cell.contentView.subviews.first as! UILabel
        guard let tableData = tableData else { label.text = "No Data to Display"; return cell }
        label.text = tableData[indexPath.item].title
        return cell
    }
    
    // Delete Row functionality
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableData?.gridPatterns.remove(at: indexPath.item)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        } else {
            print("nope")
        }
    }
    
    // Create new row. Adds new "Config" object to data model array with
    // name of numbered "Configuration" and Grid of size 10.
    @IBAction func addRow(_ sender: UIButton) {
        
        let newRow = Config(json: ["title" : "User Configuration \(numUserConfigs)",
                                    "contents" : [[Int]]()])
        if tableData != nil {
            tableData!.gridPatterns = [newRow] + tableData!.gridPatterns
            tableView.reloadData()
        }
        numUserConfigs += 1
    }
   
    // Increase/Decrease Grid Size
    @IBAction func gridSizeChanged(_ sender: UISlider) {
        gridSize.text = "Size: \(Int(sender.value))"
    }
    
    @IBAction func gridSizeUpInside(_ sender: UISlider) {
        let size = Int(sender.value)
        nc.post(name: engineUpdate, object: nil, userInfo: ["gridSize" : size])
    }
    
    // Set Refresh rate
    @IBAction func editingBegan(_ sender: UITextField) {
        
    }
    
    @IBAction func editingChanged(_ sender: UITextField) {
    }
    
    // Check for numeric entry in text field. Borrowed from Van's code in lecture 9
    @IBAction func editingEnded(_ sender: UITextField) {
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
    }
    
    // Create "Done" button and toolbar for number pad keyboard
    func addDoneButtonToKeyboard() {
        let toolbarFrame = CGRect(x: 0, y: 0, width: 320, height: 50)
        let doneToolbar: UIToolbar = UIToolbar(frame: toolbarFrame)
        doneToolbar.barStyle = UIBarStyle.default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem  = UIBarButtonItem(title: "Done",
                                                     style: UIBarButtonItemStyle.done,
                                                     target: self,
                                                     action: #selector(InstrumentationViewController.doneButtonAction))
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
    
    // Update tableView data with new row
    func updateTable(withConfig: Config) {
        if tableData != nil {
            tableData!.gridPatterns = [withConfig] + tableData!.gridPatterns
            tableView.reloadData()
        }
        numUserConfigs += 1
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


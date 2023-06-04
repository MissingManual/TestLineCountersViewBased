//
//  ViewController.swift
//  TestLineCounters
//
//  Created by Heinz-Jörg on 03.06.23.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet var arrayController: NSArrayController!
    @IBOutlet var textView: LoremIpsumTextView!
    
    @IBOutlet weak var label1: NSTextField!
    @IBOutlet weak var label2: NSTextField!
    @IBOutlet weak var label3: NSTextField!
    @IBOutlet weak var label4: NSTextField!
    @IBOutlet weak var label5: NSTextField!
    @IBOutlet weak var labelT: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.viewController = self
        populateTable()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func populateTable() {
        let table = ["Id": 0, "Name": "Test", "Address": "VS"] as [String : Any]
        arrayController.addObject(table)
        tableView.reloadData()
    }


}


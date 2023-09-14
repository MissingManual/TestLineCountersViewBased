//
//  ViewController.swift
//  TestLineCounters
//
//  Created by LegoEsprit on 03.06.23.
//
import os.log
import Cocoa

class ViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    
    @objc dynamic var benchmarkArray = [Benchmark]()
    @objc dynamic var sorts = [NSSortDescriptor]()
    @objc dynamic var filter: NSPredicate?


    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet var textView: LoremIpsumTextView!
    
    @IBOutlet weak var lineChartView: NSView!
    var lineChartController: LineChartsViewController!
    
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
        
        self.tableView.tableColumns[0].title = "Line"
        self.tableView.tableColumns[1].title = "Column"
        
        for i in 0...5 {
            self.tableView.tableColumns[2+i].title = Benchmark.header(section: i)
        }
    }
    
    func addBenchmark(_ array:[(Int, Int, Double)]) {
        benchmarkArray.append(
            Benchmark(array[0].0, array[0].1
                      , lineRange:  array[0].2
                      , regular:    array[1].2
                      , scanner:    array[2].2
                      , components: array[3].2
                      , enumerate:  array[4].2
                      , reduce:     array[5].2
            )
        )
        lineChartController.appendData(x: Double(array[0].0), ys:[array[0].2
                                                                  , array[1].2
                                                                  , array[2].2
                                                                  , array[3].2
                                                                  , array[4].2
                                                                  , array[5].2
                                                                 ]
                                       )
        let point = NSPoint(x: 0, y:tableView.frame.height)
        self.tableView.scroll(point)
    }
    
    
    @MainActor
    func tableView(
        _ tableView: NSTableView,
        toolTipFor cell: NSCell,
        rect: NSRectPointer,
        tableColumn: NSTableColumn?,
        row: Int,
        mouseLocation: NSPoint
    ) -> String {
        return "This is a tooltip"
    }
    
    @MainActor func tableView(
        _ tableView: NSTableView,
        willDisplayCell cell: Any,
        for tableColumn: NSTableColumn?,
        row: Int
    ) {
        for i in 0...5 {
            if tableColumn?.title == Benchmark.header(section: i) {
                //cell as NSTableCellView .t .setColor([Benchmark.color(section: i)])
            }
        }
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if (segue.identifier == "LineChartsSegue") {
            lineChartController = segue.destinationController as? LineChartsViewController
        }
    }
    

}


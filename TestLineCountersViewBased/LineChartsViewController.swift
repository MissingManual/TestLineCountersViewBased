//
//  LineChartsViewController.swift
//  TestLineCounters
//
//  Created by Heinz-Jörg on 06.06.23.
//

import os.log
import Foundation
import Cocoa
import Charts


class LineChartsViewController: NSViewController {

    
    @IBOutlet var lineChartView: LineChartView!
    
    var first: Bool = true
    var x: Double = 0.0
    var data = LineChartData()
    
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.lineChartView.xAxis.labelPosition = XAxis.LabelPosition.bottom
        self.lineChartView.xAxis.axisMinimum = 0
        self.lineChartView.xAxis.axisMaximum = 300
        self.lineChartView.leftAxis.axisMinimum = 0.0
        self.lineChartView.leftAxis.axisMaximum = 0.1
        self.lineChartView.rightAxis.enabled = false
        
        self.lineChartView.backgroundColor = #colorLiteral(red: 0.8000000119, green: 0.8000000119, blue: 0.8000000119, alpha: 1)

        self.lineChartView.chartDescription.text = "Benchmark"
        
        
        /*
        _ = Timer.scheduledTimer(timeInterval: 0.5
                                     , target: self
                                     , selector: #selector(fireTimer)
                                     , userInfo: nil
                                     , repeats: true
        )
        */
        
    }
    
    func appendData(x: Double, ys: [Double]) {
        if x > self.lineChartView.xAxis.axisMaximum {
            self.lineChartView.xAxis.axisMaximum = x
        }
        if ys[5] > self.lineChartView.leftAxis.axisMaximum {
            self.lineChartView.leftAxis.axisMaximum = ys[5]
        }

        if first {
            first = false
            for i in 0...5 {
                let ys = [ChartDataEntry(x: x, y: ys[i])]
                let ds   = LineChartDataSet(entries: ys, label: Benchmark.header(section: i))
                ds.colors = [Benchmark.color(section: i)]
                data.append(ds)
            }
        }
        else {
            for i in 0...5 {
                _ = data.dataSets[i].addEntry(ChartDataEntry(x: x, y: ys[i]))
            }
        }

        self.lineChartView.data = data
    }
    
    @objc fileprivate func fireTimer() {
        
        Logger.login("", className: className)
        appendData(x: x, ys: [Double.random(in: 0.0...1.2)])
        x += 1

        Logger.logout("", className: className)
    }

    
    override open func viewWillAppear() {
        self.lineChartView.animate(xAxisDuration: 0.0, yAxisDuration: 1.0)
    }
 

}

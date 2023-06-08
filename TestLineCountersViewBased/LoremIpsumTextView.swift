//
//  LoremIpsumTextView.swift
//  TestLineCounters
//
//  Created by LegoEsprit on 03.06.23.
//
#if canImport(os.log)
import os.log
#endif

import Cocoa

extension Double {
    static let twoFractionDigits: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 6
        formatter.maximumFractionDigits = 6
        return formatter
    }()
    var formatted: String {
        return Double.twoFractionDigits.string(for: self) ?? ""
    }
}

class LoremIpsumTextView: NSTextView {
    
    var viewController: ViewController? = nil
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        let myFileUrl = Bundle.main.url(forResource:"LoremIpsum", withExtension: "txt")
        do {
            string = try String(contentsOf: myFileUrl ?? URL(fileURLWithPath: ""), encoding: .utf8)
        }
        catch {
            string = """
                     Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et
                     dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet
                     clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet,
                     
                     consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed
                     diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea
                     takimata sanctus est Lorem ipsum dolor sit amet.
                     """
        }
    }


    /*
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
     */
    
    fileprivate func calculateColumnLine() {
        var array:[(Int, Int, Double)] = [
            lineNumber0()
            , lineNumber1()
            , lineNumber2()
            , lineNumber3()
            , lineNumber4()
            , lineNumber5()
        ]
        for i in 1...5 {
            if (array[0].0 != array[i].0 || array[0].1 != array[i].1) {
                if #available(macOS 11.0, *) {
                    Logger.write("Issue with method: \(i)")
                }
                array[i].2 = -array[i].2
            }
        }
        viewController?.addBenchmark(array)
    }
    
    /// mouseDown used to caluculate the text position in the ps file
    ///
    /// - parameter event:            The system ´NSEvent´.
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        calculateColumnLine()
    }

    
    /// keyDown used to restart the timer for autosave and syntax highligthing
    /// - parameter event:            The system ´NSEvent´.
    ///
    override func keyDown(with event: NSEvent) {
        super.keyDown(with: event)
        calculateColumnLine()
    }

    func lineNumber0() -> (Int, Int, Double) {
        let start = ProcessInfo.processInfo.systemUptime;
        var lineNumber = 0

        let selectionRange: NSRange = selectedRange()
        let stringIndexSelection = Range(selectionRange, in: string)!

        var index = string.startIndex
        var lineRange = stringIndexSelection
        while index <= stringIndexSelection.upperBound {
            lineRange = string.lineRange(for: index...index)
            index = lineRange.upperBound
            lineNumber += 1
        }
        let column = string.distance(from: lineRange.lowerBound, to: stringIndexSelection.upperBound)
        return (lineNumber, column, ProcessInfo.processInfo.systemUptime-start)
    }
    
    func lineNumber1() -> (Int, Int, Double) {
        let start = ProcessInfo.processInfo.systemUptime;
        let selectionRange: NSRange = selectedRange()
        let regex = try! NSRegularExpression(pattern: "\n", options: [])
        let lineNumber = regex.numberOfMatches(in: string, options: [], range: NSMakeRange(0, selectionRange.location)) + 1
        let stringIndexSelection = Range(selectionRange, in: string)!
        let lineRange = string.lineRange(for: stringIndexSelection)
        let column = string.distance(from: lineRange.lowerBound, to: stringIndexSelection.upperBound)
   
        return (lineNumber, column, ProcessInfo.processInfo.systemUptime-start)
    }
    
    func lineNumber2() -> (Int, Int, Double) {
        let start = ProcessInfo.processInfo.systemUptime;
        let selectionRange: NSRange = selectedRange()
        let stringIndexSelection = Range(selectionRange, in: string)!
        let startOfString = string[..<stringIndexSelection.upperBound]
        let scanner = Scanner(string: String(startOfString))
        scanner.charactersToBeSkipped = []
        let characterSet:CharacterSet = ["\n"]

        var lineNumber = 0
        if #available(macOS 10.15, *) {
            while true {
                lineNumber += 1
                _ = scanner.scanUpToCharacters(from: characterSet)
                if scanner.isAtEnd {
                    break
                }
                scanner.currentIndex = string.index(after: scanner.currentIndex)
            }
        }
        //lineNumber = max(1, lineNumber)
        let lineRange = string.lineRange(for: stringIndexSelection)
        let column = string.distance(from: lineRange.lowerBound, to: stringIndexSelection.upperBound)
        return (lineNumber, column, ProcessInfo.processInfo.systemUptime-start)
    }
    
    func lineNumber3() -> (Int, Int, Double) {
        let start = ProcessInfo.processInfo.systemUptime;
        let stringIndexSelection = Range(selectedRange(), in: string)!
        let startOfString = string[..<stringIndexSelection.upperBound]
        let lineNumber = startOfString.components(separatedBy: "\n").count
        let lineRange = string.lineRange(for: stringIndexSelection)
        let column = string.distance(from: lineRange.lowerBound, to: stringIndexSelection.upperBound)
        return (lineNumber, column, ProcessInfo.processInfo.systemUptime-start)
    }
    
    func lineNumber4() -> (Int, Int, Double) {
        let start = ProcessInfo.processInfo.systemUptime;

        let stringIndexSelection = Range(selectedRange(), in: string)!
        let startOfString = string[..<stringIndexSelection.upperBound]
        var lineNumber = 0
        startOfString.enumerateLines { (startOfString, _) in
            lineNumber += 1
        }

        let lineRange = string.lineRange(for: stringIndexSelection)
        let column = string.distance(from: lineRange.lowerBound, to: stringIndexSelection.upperBound)
        if 0 == column {
            lineNumber += 1
        }
        return (lineNumber, column, ProcessInfo.processInfo.systemUptime-start)

    }
    
    func lineNumber5() -> (Int, Int, Double) {
        let start = ProcessInfo.processInfo.systemUptime;

        let stringIndexSelection = Range(selectedRange(), in: string)!
        let startOfString = string[string.startIndex..<stringIndexSelection.upperBound]
        let lineNumber = startOfString.reduce(into: 1) { (counts, letter) in
            if "\n" == letter {
                counts += 1
            }
        }

        let lineRange = string.lineRange(for: stringIndexSelection)
        let column = string.distance(from: lineRange.lowerBound, to: stringIndexSelection.upperBound)
        return (lineNumber, column, ProcessInfo.processInfo.systemUptime-start)

    }
    
}

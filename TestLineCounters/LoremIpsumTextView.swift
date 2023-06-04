//
//  LoremIpsumTextView.swift
//  TestLineCounters
//
//  Created by Heinz-Jörg on 03.06.23.
//

import os.log
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
        string = """
                 Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et
                 dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet
                 clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet,
                 
                 consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed
                 diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea
                 takimata sanctus est Lorem ipsum dolor sit amet.
                 """
        
    }


    /*
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
     */
    
    fileprivate func calculateColumnLine() {
        let r1 = lineNumber1(); viewController?.label1.stringValue = "\(r1.0)/\(r1.1): \(r1.2.formatted)"
        let r2 = lineNumber2(); viewController?.label2.stringValue = "\(r2.0)/\(r2.1): \(r2.2.formatted)"
        let r3 = lineNumber3(); viewController?.label3.stringValue = "\(r3.0)/\(r3.1): \(r3.2.formatted)"
        let r4 = lineNumber4(); viewController?.label4.stringValue = "\(r4.0)/\(r4.1): \(r4.2.formatted)"
        let r5 = lineNumber5(); viewController?.label5.stringValue = "\(r5.0)/\(r5.1): \(r5.2.formatted)"
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

    
    
    func lineNumber1() -> (Int, Int, Double) {
        let start = ProcessInfo.processInfo.systemUptime;
        let selectionRange: NSRange = selectedRange()
        let regex = try! NSRegularExpression(pattern: "\n", options: [])
        let lineNumber = regex.numberOfMatches(in: string, options: [], range: NSMakeRange(0, selectionRange.location)) + 1
        var column = 0
        if let stringIndexSelection = Range(selectionRange, in: string) {
            let lineRange = string.lineRange(for: stringIndexSelection)
            column = string.distance(from: lineRange.lowerBound, to: stringIndexSelection.upperBound)
        }
        return (lineNumber, column, ProcessInfo.processInfo.systemUptime-start)
    }
    
    func lineNumber2() -> (Int, Int, Double) {
        let start = ProcessInfo.processInfo.systemUptime;
        let selectionRange: NSRange = selectedRange()
        let stringIndexSelection = Range(selectionRange, in: string)!
        let startOfString = string[..<stringIndexSelection.upperBound]
        let scanner = Scanner(string: String(startOfString))
        scanner.charactersToBeSkipped = ["\n"]
        let characterSet:CharacterSet = ["\n"]

        var lineNumber = 0
        repeat {
            lineNumber += 1
            _ = scanner.scanUpToCharacters(from: characterSet)
            //scanner.currentIndex = string.index(after: scanner.currentIndex)
        } while !scanner.isAtEnd
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

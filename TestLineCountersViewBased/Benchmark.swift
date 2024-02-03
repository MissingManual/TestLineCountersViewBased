//
//  myData.swift
//  TestLineCounters
//
//  Created by LegoEsprit on 05.06.23.
//

import Foundation
import Cocoa

class Benchmark: NSObject {
    
    @objc var line =  0
    @objc var column = 0
    @objc var lineRange = 0.0
    @objc var regular = 0.0
    @objc var scanner = 0.0
    @objc var components = 0.0
    @objc var enumerate = 0.0
    @objc var reduce = 0.0
    
    @objc let lineRangeColor = color(section: 0)
    @objc var regularColor = color(section: 1)
    @objc var scannerColor = color(section: 2)
    @objc var componentsColor = color(section: 3)
    @objc var enumerateColor = color(section: 4)
    @objc var reduceColor = color(section: 5)



    init(_ line: Int, _ column:Int
         , lineRange: Double
         , regular: Double
         , scanner: Double
         , components: Double
         , enumerate: Double
         , reduce: Double
    ) {
        self.line = line
        self.column = column
        self.lineRange = lineRange
        self.regular = regular
        self.scanner = scanner
        self.components = components
        self.enumerate = enumerate
        self.reduce = reduce
    }
    
    static func header(section: Int) -> String {
		let result = [
			LoremIpsumTextView.name0
		, LoremIpsumTextView.name1
		, LoremIpsumTextView.name2
		, LoremIpsumTextView.name3
		, LoremIpsumTextView.name4
		, LoremIpsumTextView.name5
		] [section]
		
		
		return result

		/*
        switch section {
        case 0:
			return "LineRange"
        case 1:
            return "Regular Expression"
        case 2:
            return "Scanner"
        case 3:
            return "Components"
        case 4:
            return "Enumeration"
        case 5:
            return "Reduce"
        default:
            return "Undefined"
        }
		 */
    }

    static func color(section: Int) -> NSColor {
        switch section {
        case 0:
            return NSColor.brown
        case 1:
            return NSColor.red
        case 2:
            return NSColor.orange
        case 3:
            return NSColor.yellow
        case 4:
            return NSColor.green
        case 5:
            return NSColor.blue
        default:
            return NSColor.magenta
        }

    }
}

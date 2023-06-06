//
//  AppDelegate.swift
//  TestLineCounters
//
//  Created by LegoEsprit on 03.06.23.
//

/*
 
 Bind the Table Cell View to the NSArrayController selection and then use a
 model key of observationInfo.

 Finally bind the views, eg Text View to the NSCell View with model key
 objectValue.name, where name is the field name of the corresponding
 element of the table.

 If you are using core data then set up the NSArrayController parameter to
 be the managedObjectContext, set it to type entity and provide the entity
 name and tick the prepares content check box.
 */

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }


}


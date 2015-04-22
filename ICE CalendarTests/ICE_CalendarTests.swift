//
//  ICE_CalendarTests.swift
//  ICE CalendarTests
//
//  Created by Andrew Sowers on 3/30/15.
//  Copyright (c) 2015 Andrew Sowers. All rights reserved.
//

import UIKit
import XCTest

class ICE_CalendarTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testFeedTableViewController() {
        let SB = UIStoryboard(name: "Main", bundle: nil)
        let VC: AnyObject! = SB.instantiateViewControllerWithIdentifier("FeedTableViewController")
        let _ = VC.view
    }
    
}

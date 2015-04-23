//
//  categoryManager.swift
//  ICE Calendar
//
//  Created by Andrew Sowers on 4/23/15.
//  Copyright (c) 2015 Andrew Sowers. All rights reserved.
//

import UIKit

class categoryManager: NSObject {
    
    func buildCategoryData(category:String) -> XmlParserManager {
        var baseURL: String = "http://events.ithaca.edu/calendar.xml"
        let data = NSURL(string: baseURL)!
        return XmlParserManager.alloc().initWithURL(data) as! XmlParserManager
    }
}

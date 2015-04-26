//
//  categoryManager.swift
//  ICE Calendar
//
//  Created by Andrew Sowers on 4/23/15.
//  Copyright (c) 2015 Andrew Sowers. All rights reserved.
//

import UIKit

class categoryManager: NSObject {

    let categories:[String:String] = ["All":"http://events.ithaca.edu/calendar.xml","athletics-intercollegiate":"http://events.ithaca.edu/calendar.xml?event_types%5B%5D=29600","concert_recitalEvents":"http://events.ithaca.edu/calendar.xml?event_types%5B%5D=26360","screening":"http://events.ithaca.edu/calendar.xml?event_types%5B%5D=26364","speaker_lecture":"http://events.ithaca.edu/calendar.xml?event_types%5B%5D=26366","conference_workshop":"http://events.ithaca.edu/calendar.xml?event_types%5B%5D=26361","social_networking":"http://events.ithaca.edu/calendar.xml?event_types%5B%5D=26365","alumni":"http://events.ithaca.edu/calendar.xml?event_types%5B%5D=28717","performance":"http://events.ithaca.edu/calendar.xml?event_types%5B%5D=26363","readings":"http://events.ithaca.edu/calendar.xml?event_types%5B%5D=26606","ceremony":"http://events.ithaca.edu/calendar.xml?event_types%5B%5D=34562"]

    
    func buildAndGetCategoryData(category:String) -> NSArray {
        
        // getting path to GameData.plist
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths[0] as! String
        let path = documentsDirectory.stringByAppendingPathComponent("RSSData.plist")
        let fileManager = NSFileManager.defaultManager()
        //check if file exists
        if(!fileManager.fileExistsAtPath(path)) {
            // If it doesn't, copy it from the default file in the Bundle
            if let bundlePath = NSBundle.mainBundle().pathForResource("RSSData", ofType: "plist") {
                let resultDictionary = NSMutableDictionary(contentsOfFile: bundlePath)
                println("Bundle RSSData.plist file is --> \(resultDictionary?.description)")
                fileManager.copyItemAtPath(bundlePath, toPath: path, error: nil)
            } else {
                println("RSSData.plist not found. Please, make sure it is part of the bundle.")
            }
        } else {
            println("RSSData.plist already exits at path.")
            // use this to delete file from documents directory
            //fileManager.removeItemAtPath(path, error: nil)
        }
        let resultDictionary = NSMutableDictionary(contentsOfFile: path)
        var myDictionary = NSDictionary(contentsOfFile: path)
        if let dictionary = myDictionary {
            if dictionary[category]!.count == 0 {
                let newData:NSArray = getCategoriesFromWebRequest(category) as NSArray!
                resultDictionary?.setObject(newData, forKey: category)
                resultDictionary!.writeToFile(path, atomically: false)
                let resultArray = NSMutableArray(contentsOfFile: path)
                return newData
            }else{
                return myDictionary?.objectForKey(category) as! NSArray
            }
        } else {
            println("WARNING: Couldn't create NSDictionary from RSSData.plist!")
            return getCategoriesFromWebRequest(category)
        }
    }
    
    func getCategoriesFromWebRequest(category:String) -> NSArray {
        var baseURL: String = categories[category]!
        let data = NSURL(string: baseURL)!
        let xmlManager: XmlParserManager = XmlParserManager.alloc().initWithURL(data) as! XmlParserManager
        return xmlManager.feeds

    }
}

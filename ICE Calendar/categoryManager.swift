//
//  categoryManager.swift
//  ICE Calendar
//
//  Created by Andrew Sowers on 4/23/15.
//  Copyright (c) 2015 Andrew Sowers. All rights reserved.
//

import UIKit

class categoryManager: NSObject {

    
    // MARK: instance properties
    
    let categories:[String:String] = ["All":"http://events.ithaca.edu/calendar.xml","athletics-intercollegiate":"http://events.ithaca.edu/calendar.xml?event_types%5B%5D=29600","concert_recitalEvents":"http://events.ithaca.edu/calendar.xml?event_types%5B%5D=26360","screening":"http://events.ithaca.edu/calendar.xml?event_types%5B%5D=26364","speaker_lecture":"http://events.ithaca.edu/calendar.xml?event_types%5B%5D=26366","conference_workshop":"http://events.ithaca.edu/calendar.xml?event_types%5B%5D=26361","social_networking":"http://events.ithaca.edu/calendar.xml?event_types%5B%5D=26365","alumni":"http://events.ithaca.edu/calendar.xml?event_types%5B%5D=28717","performance":"http://events.ithaca.edu/calendar.xml?event_types%5B%5D=26363","readings":"http://events.ithaca.edu/calendar.xml?event_types%5B%5D=26606","ceremony":"http://events.ithaca.edu/calendar.xml?event_types%5B%5D=34562","communityService":"http://events.ithaca.edu/calendar.xml?event_types%5B%5D=26369","athletics_recSports":"http://events.ithaca.edu/calendar.xml?event_types%5B%5D=29601","exhibit":"http://events.ithaca.edu/calendar.xml?event_types%5B%5D=26362","meeting":"http://events.ithaca.edu/calendar.xml?event_types%5B%5D=26359"]
    
    let intToCategoryStringName:[String] = ["Athletics - Intercollegiate","Concert/Recital","Screening","Conference/Workshop","Speaker/Lecture","Performance","Social/Networking", "Alumni","Reading","Ceremony","Community Service","Athletics - Rec Sports","Exhibit","Meeting"]

    // MARK: instance methods
    
    /********************************************************************
    *Function: buildAndGetCategoryData
    *Purpose: build our category data. Either get it from local plist file or get from the web.
    *Parameters: category:String
    *Return: NSArray
    *Properties NA
    *Precondition: NA
    *Written by: Andrew Sowers
    ********************************************************************/
    func buildAndGetCategoryData(category:String) -> NSArray {
        
        // getting path to RSSPath.plist
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
            println("RSSData.plist is intact.")
            // use this to delete file from documents directory => //fileManager.removeItemAtPath(path, error: nil)
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
    
    /********************************************************************
    *Function: getCategoriesFromWebRequest
    *Purpose: get NSArray of categories from the web
    *Parameters: Void.
    *Return: NSArrat
    *Properties NA
    *Precondition: NA
    *Written by: Andrew Sowers
    ********************************************************************/
    func getCategoriesFromWebRequest(category:String) -> NSArray {
        var baseURL: String = categories[category]!
        let data = NSURL(string: baseURL)!
        let xmlManager: XmlParserManager = XmlParserManager.alloc().initWithURL(data) as! XmlParserManager
        return xmlManager.feeds

    }
    
    /********************************************************************
    *Function: getPreferedKeys
    *Purpose: get array of strings where the strings are category names
    *Parameters: Void.
    *Return: [String]
    *Properties NA
    *Precondition: NA
    *Written by: Andrew Sowers
    ********************************************************************/
    func getPreferedKeys() -> [String] {
        var preferedKeys = [String]()
        let preferences:[String:Bool] = preferenceManager().getPreferenceList()
        for key in preferences.keys {
            if preferences[key] == true {
                preferedKeys.append(key)
            }
        }
        return preferedKeys
    }
    
    /********************************************************************
    *Function: getPreferedCategories
    *Purpose: get array of NSArrays of categories
    *Parameters: Void.
    *Return: Int
    *Properties NA
    *Precondition: NA
    *Written by: Andrew Sowers
    ********************************************************************/
    func getPreferedCategories() -> [NSArray] {
        var preferedCategories = [NSArray]()
        let preferences:[String:Bool] = preferenceManager().getPreferenceList()
        for key in preferences.keys {
            if preferences[key] == true {
                preferedCategories.append(buildAndGetCategoryData(key))
            }
        }
        return preferedCategories
    }
    
    /********************************************************************
    *Function: categoryCount
    *Purpose: get count of categories
    *Parameters: Void.
    *Return: Int
    *Properties NA
    *Precondition: NA
    *Written by: Andrew Sowers
    ********************************************************************/
    func categoryCount() -> Int {
        return intToCategoryStringName.count
    }
}

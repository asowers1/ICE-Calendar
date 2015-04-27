//
//  preferenceManager.swift
//  ICE Calendar
//
//  Created by Andrew Sowers on 4/26/15.
//  Copyright (c) 2015 Andrew Sowers. All rights reserved.
//

import UIKit

class preferenceManager: NSObject {
   
    // MARK: instance properties
    
    let categories: categoryManager = categoryManager()
    var categoryConversionList: [String:String] = ["Athletics - Intercollegiate":"athletics-intercollegiate","Concert/Recital":"concert_recital","Screening":"screening","Conference/Workshop":"conference_workshop","Speaker/Lecture":"speaker_lecture","Performance":"performance","Social/Networking":"social_networking", "Alumni":"alumni","Reading":"readings","Ceremony":"ceremony","Community Service":"communityService","Athletics - Rec Sports":"athletics-recSports","Exhibit":"exhibit","Meeting":"meeting"]
    
    
    // MARK: instance methods
    
    /********************************************************************
    *Function: setupPath
    *Purpose: helper method to setup the path of our preference plist file
    *Parameters: Void.
    *Return: String
    *Properties NA
    *Precondition: NA
    *Written by: Andrew Sowers
    ********************************************************************/
    func setupPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths[0] as! String
        let path = documentsDirectory.stringByAppendingPathComponent("userPreferences.plist")
        let fileManager = NSFileManager.defaultManager()
        //check if file exists
        if(!fileManager.fileExistsAtPath(path)){
            // if it doesn't copy it from the dfault file in the Bundle
            if let bundlePath = NSBundle.mainBundle().pathForResource("userPreferences", ofType: "plist"){
                let resultDictionary = NSMutableDictionary(contentsOfFile: bundlePath)
                println("Bundle RSSData.plist file is --> \(resultDictionary?.description)")
                fileManager.copyItemAtPath(bundlePath, toPath: path, error: nil)
            } else {
                println("RSSData.plist not found. Please, make sure it is part of the bundle.")
            }
        }else {
            // userPreferences.plist is intact.
            // use this to delete file from documents directory => //fileManager.removeItemAtPath(path, error: nil)
        }
        return path
    }
    
    /********************************************************************
    *Function: updatePreference
    *Purpose: update the preference list with a key:value pair
    *Parameters: key:String, value:Bool
    *Return: Void.
    *Properties NA
    *Precondition: NA
    *Written by: Andrew Sowers
    ********************************************************************/
    func updatePreference(key:String,value:Bool) {
        let path:String = setupPath()
        let resultDictionary = NSMutableDictionary(contentsOfFile: path)
        if let dictionary = NSDictionary(contentsOfFile: path){
            resultDictionary!.setObject(value, forKey: key)
            resultDictionary!.writeToFile(path, atomically: false)
        }

    }
    
    /********************************************************************
    *Function: getPreference
    *Purpose: get the prefered state of a category from the preference list
    *Parameters: key of category
    *Return: Bool
    *Properties NA
    *Precondition: NA
    *Written by: Andrew Sowers
    ********************************************************************/
    func getPreference(key:String) -> Bool {
        let path:String = setupPath()
        if let dictionary = NSDictionary(contentsOfFile: path){
            return dictionary.objectForKey(key) as! Bool
        }
        return false
    }
    
    /********************************************************************
    *Function: savePreferences
    *Purpose: save an entire preference list
    *Parameters: [category:prefered]
    *Return: Void.
    *Properties NA
    *Precondition: NA
    *Written by: Andrew Sowers
    ********************************************************************/
    func savePreferences(preferenceList:[String:Bool]) {
        let path:String = setupPath()
        let resultDictionary = NSMutableDictionary(contentsOfFile: path)
        if let dictionary = NSDictionary(contentsOfFile: path){
            for key:String in preferenceList.keys {
                resultDictionary?.setObject(preferenceList[key]!, forKey: key)
            }
            resultDictionary!.writeToFile(path, atomically: false)
        }
    }
    
    /********************************************************************
    *Function: getPreferenceList
    *Purpose: get the whole preference list
    *Parameters: Void.
    *Return: [category:prefered]
    *Properties NA
    *Precondition: NA
    *Written by: Andrew Sowers
    ********************************************************************/
    func getPreferenceList() -> [String:Bool] {
        let path:String = setupPath()
        if let dictionary = NSDictionary(contentsOfFile: path){
            // return result
            return dictionary as! [String:Bool]
        }else{
            // failsafe: return new empty dictionary pointer
            return [String:Bool]()
        }
    }
}

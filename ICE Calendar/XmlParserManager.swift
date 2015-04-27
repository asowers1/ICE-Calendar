//
//  XmlParserManager.swift
//  RSSwift
//
//  Created by Arled Kola on 20/10/2014.
//  Modified by Andrew Sowers on 4/26/2015.
//  Copyright (c) 2014 Arled. All rights reserved.


import Foundation

class XmlParserManager: NSObject, NSXMLParserDelegate {
    
    // MARK: - instance methods
    
    var parser = NSXMLParser()
    var feeds = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = NSString()
    var ftitle = NSMutableString()
    var link = NSMutableString()
    var fdescription = NSMutableString()
    var fdate = NSMutableString()
    
    
    // MARK: - instance methods
    
    /********************************************************************
    *Function: startParse
    *Purpose: initialize the parser
    *Parameters: url:NSURL
    *Return: AnyObject
    *Properties NA
    *Precondition: NA
    *Written by: Arled Kola
    ********************************************************************/
    func initWithURL(url :NSURL) -> AnyObject {
        startParse(url)
        return self
    }
    
    /********************************************************************
    *Function: startParse
    *Purpose: start the parsing
    *Parameters: url:NSURL
    *Return: Void
    *Properties NA
    *Precondition: NA
    *Written by: Arled Kola
    ********************************************************************/
    func startParse(url :NSURL) {
        feeds = []
        parser = NSXMLParser(contentsOfURL: url)!
        parser.delegate = self
        parser.shouldProcessNamespaces = false
        parser.shouldReportNamespacePrefixes = false
        parser.shouldResolveExternalEntities = false
        parser.parse()
    }
    
    /********************************************************************
    *Function: parser
    *Purpose: return data feed
    *Parameters: Void.
    *Return: NSArray
    *Properties NA
    *Precondition: NA
    *Written by: Arled Kola
    ********************************************************************/

    func allFeeds() -> NSMutableArray {
        return feeds
    }
    
    /********************************************************************
    *Function: parser
    *Purpose: parse XML
    *Parameters: parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [NSObject : AnyObject]
    *Return: Void.
    *Properties ftitle, link, fdescription, fdate
    *Precondition: NA
    *Written by: Arled Kola
    ********************************************************************/
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [NSObject : AnyObject]) {
        element = elementName
        
        if (element as NSString).isEqualToString("item") {
            elements = NSMutableDictionary.alloc()
            elements = [:]
            ftitle = NSMutableString.alloc()
            ftitle = ""
            link = NSMutableString.alloc()
            link = ""
            fdescription = NSMutableString.alloc()
            fdescription = ""
            fdate = NSMutableString.alloc()
            fdate = ""
        }

    }
    
    /********************************************************************
    *Function: parser
    *Purpose: parse XML
    *Parameters: parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?
    *Return: Void.
    *Properties ftitle, link, fdescription, fdate
    *Precondition: NA
    *Written by: Arled Kola
    ********************************************************************/
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if (elementName as NSString).isEqualToString("item") {
            if ftitle != "" {
                elements.setObject(ftitle, forKey: "title")
            }
            
            if link != "" {
                elements.setObject(link, forKey: "link")
            }
            
            if fdescription != "" {
                elements.setObject(fdescription, forKey: "description")
            }
            
            if fdate != "" {
                elements.setObject(fdate, forKey: "pubDate")
            }
            
            feeds.addObject(elements)
        }
        
    }
    
    /********************************************************************
    *Function: parser
    *Purpose: parse XML
    *Parameters: parser: NSXMLParser, foundCharacters string: String?
    *Return: Void.
    *Properties ftitle, link, fdescription, fdate
    *Precondition: NA
    *Written by: Arled Kola
    ********************************************************************/
    func parser(parser: NSXMLParser, foundCharacters string: String?) {
        
        if element.isEqualToString("title") {
            ftitle.appendString(string!)
        } else if element.isEqualToString("link") {
            link.appendString(string!)
        }else if element.isEqualToString("description") {
            fdescription.appendString(string!)
        }else if element.isEqualToString("pubDate") {
            fdate.appendString(string!)
        }
    }


    
}
//
//  FeedTableViewController.swift
//  ICE Calendar
//
//  Created by Andrew Sowers on 31/03/2015.
//  Copyright (c) 2014 Andrew Sowers All rights reserved.
//

import UIKit

class FeedTableViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate, NSXMLParserDelegate, UISearchBarDelegate, UISearchDisplayDelegate {

    var myFeed : NSArray = []
    var searchingTableData: [String] = []
    var searchingURLData: [String:String] = Dictionary()
    var url: NSURL = NSURL()
    var is_searching:Bool = false   // It's flag for searching
    var currentRow:NSIndexPath = NSIndexPath()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var nib = UINib(nibName: "Cell", bundle: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        // Cell height.
        self.tableView.rowHeight = 70
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        // Set feed url. http://www.formula1.com/rss/news/latest.rss
        url = NSURL(string: "http://events.ithaca.edu/calendar.xml")!
        // Call custom function.
        loadRss(url);

    }
    
    func loadRss(data: NSURL) {
        // XmlParserManager instance/object/variable
        var myParser : XmlParserManager = XmlParserManager.alloc().initWithURL(data) as! XmlParserManager
        // Put feed in array
        myFeed = myParser.feeds
        
        tableView.reloadData()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let newUrl = segue.destinationViewController as? NewFeedViewController {
            newUrl.onDataAvailable = {[weak self]
                (data) in
                if let weakSelf = self {
                    weakSelf.loadRss(data)
                }
            }
        }
        
        else if segue.identifier == "openPage" {
            var indexPath: NSIndexPath = self.currentRow
            let selectedFTitle: String = myFeed[indexPath.row].objectForKey("title") as! String
            let selectedFContent: String = myFeed[indexPath.row].objectForKey("description") as! String
            let fpvc: FeedWebPageViewController = segue.destinationViewController as! FeedWebPageViewController
            if self.is_searching == false {
                let selectedFURL: String = myFeed[indexPath.row].objectForKey("link") as! String
                fpvc.feedURL = selectedFURL
            }else{
                let selectedFTitle: String = searchingTableData[indexPath.row] as String
                println(selectedFTitle)
                let url: String = searchingURLData[selectedFTitle] as String!
                fpvc.feedURL = url
            }
        }
    }
    
    /********************************************************************
    *Function: tableView
    *Purpose: perform segue on table view cell tap
    *Parameters: tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath
    *Return: Void.
    *Properties modified: self.currentRow
    *Precondition: class must conform to UITableViewDelegate
    ********************************************************************/
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.currentRow = indexPath
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        performSegueWithIdentifier("openPage", sender: self)
    }
    
    
    /********************************************************************
    *Function: searchBar
    *Purpose: update search based on text
    *Parameters: searchBar: UISearchBar, textDidChange searchText: String
    *Return: Void.
    *Properties modified: is_searching, searcingTableData
    *Precondition: Class must conform to UISearchBarDelegate
    ********************************************************************/
    // MARK searching delegate logic
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String){
        println("did change")
        if searchBar.text.isEmpty{
            is_searching = false
            self.tableView.reloadData()
        } else {
            println(" search text %@ ",searchBar.text as NSString)
            is_searching = true
            searchingTableData.removeAll(keepCapacity: false)
            for var index = 0; index < myFeed.count; index++
            {
                var currentString: String = myFeed.objectAtIndex(index).objectForKey("title") as! String
                currentString += " "
                currentString += myFeed.objectAtIndex(index).objectForKey("description") as! String

                if currentString.lowercaseString.rangeOfString(searchText.lowercaseString)  != nil {
                    searchingTableData.append(myFeed.objectAtIndex(index).objectForKey("title") as! String)
                    //searchingURLData.append(myFeed.objectAtIndex(index).objectForKey("link") as String)
                    
                    var value = myFeed.objectAtIndex(index).objectForKey("title") as! String
                    searchingURLData[value] = myFeed.objectAtIndex(index).objectForKey("link") as? String
                }
                
            }
            searchingTableData.sort({$0 < $1})
            
            
            self.tableView.reloadData()
        }
    }
    
    /********************************************************************
    *Function: searchBarCancelButtonClicked
    *Purpose: handle cancle for search bar
    *Parameters: searchBar: UISearchBar
    *Return: Void.
    *Properties modified: is_searching
    *Precondition: Class must conform to UISearchBarDeletate and UITableViewDelegate
    ********************************************************************/
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        is_searching = false
        self.tableView.reloadData()
    }
    

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.is_searching == true {
            return self.searchingTableData.count
        }else{
            return self.myFeed.count;
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell
        
        
        // Set cell properties.
        if is_searching == true{
            if let labelText:String = searchingTableData[indexPath.row] as String?{
                cell.textLabel?.text = labelText
            }
        }else{
            // Feeds dictionary.
            var dict : NSDictionary! = myFeed.objectAtIndex(indexPath.row) as! NSDictionary
            cell.textLabel?.text = myFeed.objectAtIndex(indexPath.row).objectForKey("title") as? String
        
        
            // It seems that cell.textLabel?.text is no longer an optionional.
            // If the above line throws an error then comment it out and uncomment the below line.
            //cell.textLabel?.text = myFeed.objectAtIndex(indexPath.row).objectForKey("title") as? String

            cell.detailTextLabel?.text = myFeed.objectAtIndex(indexPath.row).objectForKey("pubDate") as? String
        }
        return cell
    }
}

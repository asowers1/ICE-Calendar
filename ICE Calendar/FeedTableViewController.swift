//
//  FeedTableViewController.swift
//  ICE Calendar
//
//  Created by Andrew Sowers on 31/03/2015.
//  Copyright (c) 2014 Andrew Sowers All rights reserved.
//

import UIKit

class FeedTableViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate {

    // MARK: - instance properties
    
    var myFeed : NSArray = []
    var searchingTableData: [String] = []
    var keys: [String] = []
    var searchingURLData: [String:String] = Dictionary()
    var url: NSURL = NSURL()
    var is_searching:Bool = false
    var currentRow:NSIndexPath = NSIndexPath()
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - UIKit overrides
    
    /********************************************************************
    *Function: viewDidLoad
    *Purpose: viewDidLoad
    *Parameters: Void.
    *Return: Void.
    *Properties NA
    *Precondition: NA
    *Written by: Andrew Sowers
    ********************************************************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        // Cell height.
        self.tableView.rowHeight = 70
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        //url = NSURL(string: "http://events.ithaca.edu/calendar.xml")!
        
    }
    
    /********************************************************************
    *Function: viewWillAppear
    *Purpose: viewWillAppear and load data
    *Parameters: animated: Bool
    *Return: Void.
    *Properties NA
    *Precondition: NA
    *Written by: Andrew Sowers
    ********************************************************************/
    override func viewWillAppear(animated: Bool) {
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        
        
        dispatch_async(dispatch_get_global_queue(priority, 0), { ()->() in
            
            self.loadRss()
            dispatch_async(dispatch_get_main_queue(), {
                
                println("hello from UI thread executed as dispatch")
                self.tableView.reloadData()
            })
            
        })
        println("hello from UI thread")
    }
    
    /********************************************************************
    *Function: loadRss
    *Purpose: load RSS
    *Parameters: Void.
    *Return: Void.
    *Properties self.myFeed
    *Precondition: NA
    *Written by: Andrew Sowers
    ********************************************************************/
    func loadRss() {
        let categories = categoryManager()
        self.myFeed = categories.buildAndGetCategoryData("All")
    }

    /********************************************************************
    *Function: didReceiveMemoryWarning
    *Purpose: didReceiveMemoryWarning
    *Parameters: Void.
    *Return: Void.
    *Properties NA
    *Precondition: NA
    *Written by: Andrew Sowers
    ********************************************************************/
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - segue methods
    
    /********************************************************************
    *Function: prepareForSegue
    *Purpose: perform segue
    *Parameters: segue: UIStoryboardSegue, sender: AnyObject?
    *Return: Void.
    *Properties modified: NA
    *Precondition: segue.identifier == "openPage" must be a thing to work properly
    *Written by: Andrew Sowers
    ********************************************************************/
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "openPage" {
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
    
    
    // MARK searching delegate logic
    
    /********************************************************************
    *Function: searchBar
    *Purpose: update search based on text
    *Parameters: searchBar: UISearchBar, textDidChange searchText: String
    *Return: Void.
    *Properties modified: is_searching, searcingTableData
    *Precondition: Class must conform to UISearchBarDelegate
    ********************************************************************/
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
    
    /********************************************************************
    *Function: numberOfSectionsInTableView
    *Purpose: sets the number of sections in local UITableView
    *Parameters: tableView: UITableView
    *Return: Int
    *Properties NA
    *Precondition: NA
    ********************************************************************/
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    /********************************************************************
    *Function: tableView
    *Purpose: sets number of rows in a section
    *Parameters: tableView: UITableView, numberOfRowsInSection section: Int
    *Return: Int
    *Properties NA
    *Precondition: NA
    ********************************************************************/
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.is_searching == true {
            return self.searchingTableData.count
        }else{
            return self.myFeed.count;
        }
    }

    /********************************************************************
    *Function: tableView
    *Purpose: sets the cell text with categories and keys
    *Parameters: tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath
    *Return: UITableViewCell
    *Properties modified: UITableView cell at indexPath
    *Precondition: Class must conform to UISearchBarDeletate and UITableViewDelegate
    ********************************************************************/
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        //var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell
        
        let cell:UITableViewCell = UITableViewCell(style: .Subtitle, reuseIdentifier: "Cell")
        // Set cell properties.
        if is_searching == true{
            if let labelText:String = searchingTableData[indexPath.row] as String?{
                cell.textLabel?.text = labelText
                cell.textLabel?.textColor = UIColor.whiteColor()
                cell.detailTextLabel?.textColor = UIColor(red: 255/255.0, green: 183/255.0, blue: 0/255.0, alpha: 0.7)
            }
        }else{
            // Feeds dictionary.
            var dict : NSDictionary! = myFeed.objectAtIndex(indexPath.row) as! NSDictionary
            cell.textLabel?.text = myFeed.objectAtIndex(indexPath.row).objectForKey("title") as? String
        
            //cell.detailTextLabel?.text = "test"
            cell.detailTextLabel?.text = myFeed.objectAtIndex(indexPath.row).objectForKey("pubDate") as? String
            
            cell.textLabel?.textColor = UIColor.whiteColor()
            cell.detailTextLabel?.textColor = UIColor(red: 255/255.0, green: 183/255.0, blue: 0/255.0, alpha: 0.7)
        }
        cell.backgroundColor = UIColor(red: 34/255.0, green: 71/255.0, blue: 98/255.0, alpha: 1)
        
        return cell
    }
}

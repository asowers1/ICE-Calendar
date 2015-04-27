//
//  preferedFeedTableViewController.swift
//  ICE Calendar
//
//  Created by Andrew Sowers on 4/26/15.
//  Copyright (c) 2015 Andrew Sowers. All rights reserved.
//

import UIKit

class preferedFeedTableViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate {
    
    // MARK: - instance properties
    
    var searchingTableData: [String] = []
    var keys: [String] = []
    var searchingURLData: [String:String] = Dictionary()
    var url: NSURL = NSURL()
    var is_searching:Bool = false
    var currentRow:NSIndexPath = NSIndexPath()
    let categoryMgr:categoryManager = categoryManager()
    var categories = [NSArray]()
    var preferedKeys = [String]()
    
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
        self.tableView.rowHeight = 70
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        
    }
    
    /********************************************************************
    *Function: viewWillAppear
    *Purpose: viewWillAppear
    *Parameters: animated: Bool
    *Return: Void.
    *Properties NA
    *Precondition: NA
    *Written by: Andrew Sowers
    ********************************************************************/
    override func viewWillAppear(animated: Bool) {
        // asynchronous block to get new RSS data or load it if it's cached
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0), { ()->() in
            self.categories = self.categoryMgr.getPreferedCategories()
            self.preferedKeys = self.categoryMgr.getPreferedKeys()
            dispatch_async(dispatch_get_main_queue(), {
                // completion block to updated view on main thread
                self.tableView.reloadData()
            })
        })
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
            let selectedFTitle: String = categories[indexPath.section][indexPath.row].objectForKey("title") as! String
            let selectedFContent: String = categories[indexPath.section][indexPath.row].objectForKey("description") as! String
            let fpvc: FeedWebPageViewController = segue.destinationViewController as! FeedWebPageViewController
            if self.is_searching == false {
                let selectedFURL: String = categories[indexPath.section][indexPath.row].objectForKey("link") as! String
                fpvc.feedURL = selectedFURL
            }else{
                let selectedFTitle: String = searchingTableData[indexPath.row] as String
                println(selectedFTitle)
                let url: String = searchingURLData[selectedFTitle] as String!
                fpvc.feedURL = url
            }
        }
    }
    
    // MARK: - searchBar methods
    
    /********************************************************************
    *Function: searchBar
    *Purpose: update search table data and reload table with new data
    *Parameters: searchBar: UISearchBar, textDidChange searchText: String
    *Return: Void.
    *Properties modified: is_searching, searcingTableData
    *Precondition: Class must conform to UISearchBarDelegate
    ********************************************************************/
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String){
        println("did change")
        if searchBar.text.isEmpty{
            is_searching = false
            tableView.reloadData()
        } else {
            println(" search text %@ ",searchBar.text as NSString)
            is_searching = true
            searchingTableData.removeAll(keepCapacity: false)
            
            // go through all categories
            for category in categories {
                // go through all entries in each category
                for var index = 0; index < category.count; index++
                {
                    var currentString: String = category.objectAtIndex(index).objectForKey("title") as! String
                    currentString += " "
                    currentString += category.objectAtIndex(index).objectForKey("description") as! String
                    
                    if currentString.lowercaseString.rangeOfString(searchText.lowercaseString)  != nil {
                        searchingTableData.append(category.objectAtIndex(index).objectForKey("title") as! String)
                        
                        var value = category.objectAtIndex(index).objectForKey("title") as! String
                        searchingURLData[value] = category.objectAtIndex(index).objectForKey("link") as? String
                    }
                }
            }
            searchingTableData.sort({$0 < $1})
        }
        tableView.reloadData()
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
    
    
    // MARK: - Table view delegate / data source methods
    
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
    *Function: numberOfSectionsInTableView
    *Purpose: sets the number of sections in local UITableView
    *Parameters: tableView: UITableView
    *Return: Int
    *Properties NA
    *Precondition: NA
    ********************************************************************/
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if is_searching == true {
            return 1
        }
        return categories.count
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
            return categories[section].count;
        }
    }
    
    /********************************************************************
    *Function: tableView
    *Purpose: sets the title of a section depending on current state
    *Parameters: tableView: UITableView, titleForHeaderInSection section: Int
    *Return: String?
    *Properties modified: NA
    *Precondition: Class must conform to UISearchBarDeletate and UITableViewDelegate
    ********************************************************************/
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if is_searching == true {
            return ""
        }
        return preferedKeys[section]
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
        
        let cell:UITableViewCell = UITableViewCell(style: .Subtitle, reuseIdentifier: "Cell")
        // Set cell properties.
        if is_searching == true{
            if let labelText:String = searchingTableData[indexPath.row] as String?{
                cell.textLabel?.text = labelText
                cell.textLabel?.textColor = UIColor.whiteColor()
            }
        }else{
            // Feeds dictionary.
            cell.textLabel?.text = categories[indexPath.section].objectAtIndex(indexPath.row).objectForKey("title") as? String
            cell.detailTextLabel?.text = categories[indexPath.section].objectAtIndex(indexPath.row).objectForKey("pubDate") as? String
            cell.textLabel?.textColor = UIColor.whiteColor()
            cell.detailTextLabel?.textColor = UIColor(red: 255/255.0, green: 183/255.0, blue: 0/255.0, alpha: 0.7)
        }
        cell.backgroundColor = UIColor(red: 34/255.0, green: 71/255.0, blue: 98/255.0, alpha: 1)
        
        return cell
    }

}

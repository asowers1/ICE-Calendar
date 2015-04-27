//
//  categoryCollectionViewViewController.swift
//  ICE Calendar
//
//  Created by Andrew Sowers on 4/25/15.
//  Copyright (c) 2015 Andrew Sowers. All rights reserved.
//

import UIKit

class categoryCollectionViewViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    // MARK: - IBOutlets
    
    @IBOutlet var collectionView: UICollectionView!
    
    // MARK: - instance properties
    
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    
    let prefMgr:preferenceManager = preferenceManager()
    
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
        
        println(prefMgr.getPreferenceList())
        // Do any additional setup after loading the view.
        layout.sectionInset = UIEdgeInsets(top:10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 90, height: 90)
        collectionView!.delegate = self
        collectionView!.backgroundColor = UIColor(red: 145/255.0, green: 175/255.0, blue: 189/255.0, alpha: 1)
        collectionView!.setCollectionViewLayout(layout, animated: true)
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
        // Dispose of any resources that can be recreated.
    }
    
    /********************************************************************
    *Function: numberOfSectionsInCollectionView
    *Purpose: define number of section in the collection view
    *Parameters: collectionView: UICollectionView
    *Return: Int
    *Properties NA
    *Precondition: NA
    *Written by: Andrew Sowers
    ********************************************************************/
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    /********************************************************************
    *Function: collectionView
    *Purpose: define number of items per section
    *Parameters: collectionView: UICollectionView, numberOfItemsInSection section: Int
    *Return: Int
    *Properties NA
    *Precondition: NA
    *Written by: Andrew Sowers
    ********************************************************************/
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryManager().categoryCount()
    }
    
    /********************************************************************
    *Function: collectionView
    *Purpose: define collection cell view
    *Parameters: collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath
    *Return: UICollectionViewCell
    *Properties NA
    *Precondition: NA
    *Written by: Andrew Sowers
    ********************************************************************/
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as! UICollectionViewCell
        cell.backgroundColor = UIColor(red: 34/255.0, green: 71/255.0, blue: 98/255.0, alpha: 1)
        return cell
    }
    
    /********************************************************************
    *Function: collectionView
    *Purpose: define collection cell view properties when loaded on main UI thread
    *Parameters: collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath
    *Return: Void.
    *Properties NA
    *Precondition: NA
    *Written by: Andrew Sowers
    ********************************************************************/
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        println("\(indexPath.section):\(indexPath.row)")
        var label = UILabel(frame: CGRectMake(5, 5, cell.bounds.size.width-10, cell.bounds.size.height-10))
        label.text = "\(categoryManager().intToCategoryStringName[indexPath.row])"
        label.font = UIFont(name: "Helvetica Neue", size: 14)
        // text will adjust font to fit size of parent view width
        label.adjustsFontSizeToFitWidth = true
        // make text white
        
        if let category:String = label.text {
            if let convertedCategory:String = prefMgr.categoryConversionList[category] {
                let state:Bool = prefMgr.getPreference(convertedCategory)
                if state == false {
                    label.textColor = UIColor.whiteColor()
                }else{
                    label.textColor = UIColor(red: 255/255.0, green: 183/255.0, blue: 0/255.0, alpha: 1)
                }
            }
        }
        // center text
        label.textAlignment = NSTextAlignment(rawValue: 1)!
        // add text cell to parent view
        label.tag = indexPath.row+1
        cell.contentView.addSubview(label)
        
    }
    
    /********************************************************************
    *Function: collectionView
    *Purpose: define collection cell view property cleanup when unloaded from main UI thread
    *Parameters: collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath
    *Return: Void.
    *Properties NA
    *Precondition: NA
    *Written by: Andrew Sowers
    ********************************************************************/
    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        cell.contentView.subviews.map({ $0.removeFromSuperview() })
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let label:UILabel = collectionView.cellForItemAtIndexPath(indexPath)?.contentView.viewWithTag(indexPath.row+1) as? UILabel {
            if let category:String = label.text {
                if let convertedCategory:String = prefMgr.categoryConversionList[category] {
                    let state:Bool = prefMgr.getPreference(convertedCategory)
                    if state == false {
                        println("was false, set to true")
                        prefMgr.updatePreference(convertedCategory, value: true)
                        label.textColor = UIColor(red: 255/255.0, green: 183/255.0, blue: 0/255.0, alpha: 1)
                    }else{
                        println("was true, set to false")
                        prefMgr.updatePreference(convertedCategory, value: false)
                        label.textColor = UIColor.whiteColor()
                    }
                }
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

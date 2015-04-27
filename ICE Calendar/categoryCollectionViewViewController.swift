//
//  categoryCollectionViewViewController.swift
//  ICE Calendar
//
//  Created by Andrew Sowers on 4/25/15.
//  Copyright (c) 2015 Andrew Sowers. All rights reserved.
//

import UIKit

class categoryCollectionViewViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    @IBOutlet var collectionView: UICollectionView!
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    
    let prefMgr:preferenceManager = preferenceManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println(prefMgr.getPreferenceList())
        // Do any additional setup after loading the view.
        layout.sectionInset = UIEdgeInsets(top:10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 90, height: 90)
        collectionView!.delegate = self
        collectionView!.backgroundColor = UIColor.whiteColor()
        collectionView!.setCollectionViewLayout(layout, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryManager().categoryCount()
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as! UICollectionViewCell
        cell.backgroundColor = UIColor.blackColor()
        return cell
    }
    
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
                    label.textColor = UIColor.greenColor()
                }
            }
        }
        // center text
        label.textAlignment = NSTextAlignment(rawValue: 1)!
        // add text cell to parent view
        label.tag = indexPath.row+1
        cell.contentView.addSubview(label)
        
    }
    
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
                        label.textColor = UIColor.greenColor()
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

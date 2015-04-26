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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        layout.sectionInset = UIEdgeInsets(top:20, left: 20, bottom: 10, right: 20)
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
        var title = UILabel(frame: CGRectMake(5, 5, cell.bounds.size.width-10, cell.bounds.size.height-10))
        title.text = "\(categoryManager().intToCategoryStringName[indexPath.row])"
        title.font = UIFont(name: "Helvetica Neue", size: 14)
        // text will adjust font to fit size of parent view width
        title.adjustsFontSizeToFitWidth = true
        // make text white
        title.textColor = UIColor.whiteColor()
        // center text
        title.textAlignment = NSTextAlignment(rawValue: 1)!
        // add text cell to parent view
        title.tag = indexPath.row
        cell.contentView.addSubview(title)
        
    }
    
    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        cell.contentView.subviews.map({ $0.removeFromSuperview() })
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let label:UILabel = collectionView.cellForItemAtIndexPath(indexPath)?.contentView.viewWithTag(indexPath.row) as? UILabel {
            label.textColor = UIColor.greenColor()
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

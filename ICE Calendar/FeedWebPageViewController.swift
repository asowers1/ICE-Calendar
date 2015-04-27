//
//  FeedWebPageViewController.swift
//  RSSwift
//
//  Created by Arled Kola on 27/10/2014.
//  Copyright (c) 2014 Arled. All rights reserved.
//

import UIKit

class FeedWebPageViewController: UIViewController {
    
    // MARK - instance variables
    
    var feedURL = ""

    // MARK - IBOutlets
    
    @IBOutlet var myWebView: UIWebView!
    
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
        myWebView.loadRequest(NSURLRequest(URL: NSURL(string: feedURL)!))
        // Do any additional setup after loading the view.
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


}

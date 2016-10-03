//
//  ViewController.swift
//  fylz
//
//  Created by asu on 2016-10-02.
//  Copyright © 2016 ArsenykUstaris. All rights reserved.
//

import UIKit

class FLZViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  @IBOutlet weak var tableView: UITableView!
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.delegate = self;
    tableView.dataSource = self;
    
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  // MARK: UITableViewDataSource

  func numberOfSectionsInTableView(tableView: UITableView) -> Int // Default is 1 if not implemented
  {
    return 1
  }
  
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    return 0
  }
  

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
  {
    return UITableViewCell(frame: CGRectZero)
  }
  
  
}


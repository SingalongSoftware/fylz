//
//  FLZFileListViewController.swift
//  fylz
//
//  Created by asu on 2016-10-03.
//  Copyright © 2016 ArsenykUstaris. All rights reserved.
//

import UIKit


class FLZFileListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  static let CellReuse = "FileListCell"
  
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
    let cell = tableView.dequeueReusableCellWithIdentifier(FLZFileListViewController.CellReuse, forIndexPath: indexPath)

    
    return cell
  }
  

}
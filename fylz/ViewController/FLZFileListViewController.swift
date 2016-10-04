//
//  FLZFileListViewController.swift
//  fylz
//
//  Created by asu on 2016-10-03.
//  Copyright © 2016 ArsenykUstaris. All rights reserved.
//

import UIKit
import TOSMBClient

class FLZFileListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  static let CellReuse = "FileListCell"
  
  var smbSession:TOSMBSession!
  var fileList = [TOSMBSessionFile]()
  
  @IBOutlet weak var tableView: UITableView!
  
  // MARK: Public
  
  func host(hostName:String?, ipAddress:String?)
  {
    guard let hostName = hostName, ipAddress = ipAddress else
    {
      return
    }
    
    print ("host \(hostName), ip \(ipAddress)")
    smbSession = TOSMBSession(hostName: hostName, ipAddress: ipAddress)
  }
  
  // MARK: Lifecycle
  
  override func viewDidLoad()
  {
    smbSession.setLoginCredentialsWithUserName("", password: "")
    guard let files = try? smbSession.requestContentsOfDirectoryAtFilePath("") as! [TOSMBSessionFile] else { return }

    fileList.appendContentsOf(files)
  
    self.tableView.reloadData()
  }
  
  // MARK: UITableViewDataSource
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int // Default is 1 if not implemented
  {
    return 1
  }
  
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    return fileList.count
  }
  
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
  {
    let cell = tableView.dequeueReusableCellWithIdentifier(FLZFileListViewController.CellReuse, forIndexPath: indexPath)

    let file = fileList[indexPath.row]
    
    cell.textLabel?.text = file.filePath + (file.directory ? "/" : "")
    cell.detailTextLabel?.text = "Size:\(file.fileSize), Modified:\(file.modificationTime)"
    
    return cell
  }
  

}
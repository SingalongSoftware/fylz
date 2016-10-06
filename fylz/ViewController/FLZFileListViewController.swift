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
  let SegueToFileList = "toFileList"

  private var smbSession:TOSMBSession!
  private var pathStart:String = ""
  
  private var fileList = [TOSMBSessionFile]()
  
  
  @IBOutlet weak var tableView: UITableView!
  
  // MARK: Public

  func session(session:TOSMBSession, pathStart:String)
  {
    smbSession = session
    self.pathStart = pathStart
    
    if (self.pathStart == "")
    {
      return
    }
    
    if (!self.pathStart.hasSuffix("/"))
    {
      self.pathStart = self.pathStart + "/"
    }
    
    if (!self.pathStart.hasPrefix("/"))
    {
      self.pathStart = self.pathStart + "/"
    }
    
    if (!self.pathStart.hasPrefix("//"))
    {
      self.pathStart = self.pathStart + "/"
    }
    
    print (self.pathStart)
  }
    
  // MARK: Lifecycle
  
  override func viewDidLoad()
  {
    smbSession.setLoginCredentialsWithUserName("", password: "")
    guard let files = try? smbSession.requestContentsOfDirectoryAtFilePath(pathStart) as! [TOSMBSessionFile] else { return }

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
    
    cell.textLabel?.text = (self.pathStart == "" ? file.filePath : file.name + (file.directory ? "/" : ""))
    cell.detailTextLabel?.text = "Size:\(file.fileSize), Modified:\(file.modificationTime)"
    cell.tag = indexPath.row

    return cell
  }
  
  
  // MARK: Transition
  
  override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool
  {
    if (identifier == SegueToFileList)
    {
      guard let cell = sender as? UITableViewCell,
            let file = fileList[safe: cell.tag]
      else
      {
        return false
      }
      
      return file.directory
    }
    
    return true
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
    if (segue.identifier == SegueToFileList)
    {
      guard let fileListVC = segue.destinationViewController as? FLZFileListViewController,
        let cell = sender as? UITableViewCell,
        let file = fileList[safe: cell.tag]
      else
      {
        return
      }

      fileListVC.session(smbSession, pathStart: "\(pathStart)\(file.name)")

    }
  }
  

}
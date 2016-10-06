//
//  FLZFileListViewController.swift
//  fylz
//
//  Created by asu on 2016-10-03.
//  Copyright © 2016 ArsenykUstaris. All rights reserved.
//

import UIKit
import TOSMBClient

enum SortOrder
{
  case Ascending
  case Descending
}

enum SortBy:Int
{
  case Name = 0
  case Size
  case Date
}

class FLZFileListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  static let CellReuse = "FileListCell"
  let SegueToFileList = "toFileList"

  private var smbSession:TOSMBSession!
  private var pathStart:String = ""
  
  private var fileList = [TOSMBSessionFile]()
  
  private var sortOrder = [SortOrder](count: 3, repeatedValue: SortOrder.Descending)
  private var currentSort = SortBy.Date
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var sortControl: UISegmentedControl!
  
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
    guard let files = try? smbSession.requestContentsOfDirectoryAtFilePath(pathStart) as! [TOSMBSessionFile] else { return }

    fileList.appendContentsOf(files)
  
    sortOrder[SortBy.Name.rawValue] = SortOrder.Ascending
    sortOrder[SortBy.Date.rawValue] = SortOrder.Descending
    sortOrder[SortBy.Size.rawValue] = SortOrder.Descending
    
    sortFileList(sortControl)
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
    guard let cell = tableView.dequeueReusableCellWithIdentifier(FLZFileListViewController.CellReuse, forIndexPath: indexPath) as? FLZFileCell
    else
    {
      return UITableViewCell()
    }
    
    guard let file = fileList[safe: indexPath.row] else { return cell }
    
    cell.file(file, asRoot:self.pathStart == "")
    cell.tag = indexPath.row

    return cell
  }
  
  
  // MARK: Transition
  
  override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool
  {
    if (identifier == SegueToFileList)
    {
      guard let cell = sender as? FLZFileCell,
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
  
  // MARK: Segmented Control
  
  
  func sortOrderToggle(sortBy:SortBy)
  {
    let ascending = sortOrder[sortBy.rawValue] == SortOrder.Ascending
    if (ascending)
    {
      sortOrder[sortBy.rawValue] = SortOrder.Descending
    }
    else
    {
      sortOrder[sortBy.rawValue] = SortOrder.Ascending
    }
  }
  
  @IBAction func sortFileList(sender: UISegmentedControl)
  {
    if (self.currentSort.rawValue == sender.selectedSegmentIndex)
    {
      self.sortOrderToggle(self.currentSort)
    }
    
    self.sortFileList(by: SortBy(rawValue: sender.selectedSegmentIndex)!)
  }
  
  func sortFileList(by sortBy:SortBy)
  {
    let ascending = sortOrder[sortBy.rawValue] == SortOrder.Ascending
    switch (sortBy.rawValue)
    {
      case SortBy.Name.rawValue:
        fileList = fileList.sort({ ascending ? $0.name < $1.name : $0.name > $1.name })
        break;
      
      case SortBy.Size.rawValue:
        fileList = fileList.sort({ ascending ? $0.fileSize < $1.fileSize : $0.fileSize > $1.fileSize })
        break;
      
      default:
        fileList = fileList.sort({ (file1, file2) in
          guard let modification1 = file1.modificationTime,
                let modification2 = file2.modificationTime
          else
          {
            return file1.directory != file2.directory;
          }
          return ascending ? modification1.isBefore(modification2) : modification1.isAfter(modification2)
        })
        break;
    }
    
    self.currentSort = sortBy
    self.tableView.reloadData()
  }
  

}
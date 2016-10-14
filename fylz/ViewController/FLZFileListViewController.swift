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
  case ascending
  case descending
}

enum SortBy:Int
{
  case name = 0
  case size
  case date
}

class FLZFileListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  static let CellReuse = "FileListCell"
  let SegueToFileList = "toFileList"

  fileprivate var smbSession:TOSMBSession!
  fileprivate var pathStart:String = ""
  
  fileprivate var fileList = [TOSMBSessionFile]()
  
  fileprivate var sortOrder = [SortOrder](repeating: SortOrder.descending, count: 3)
  fileprivate var currentSort = SortBy.date
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var sortControl: UISegmentedControl!
  
  // MARK: Public

  func session(_ session:TOSMBSession, pathStart:String)
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
      self.pathStart = "/" + self.pathStart
    }
    
    if (!self.pathStart.hasPrefix("//"))
    {
      self.pathStart = "/" + self.pathStart
    }
    
    print (self.pathStart)
  }
    
  // MARK: Lifecycle
  
  override func viewDidLoad()
  {
    guard let files = try? smbSession.requestContentsOfDirectory(atFilePath: pathStart) as! [TOSMBSessionFile] else { return }

    fileList.append(contentsOf: files)
  
    sortOrder[SortBy.name.rawValue] = SortOrder.ascending
    sortOrder[SortBy.date.rawValue] = SortOrder.descending
    sortOrder[SortBy.size.rawValue] = SortOrder.descending
    
    sortFileList(sortControl)
    
  }
  
  // MARK: UITableViewDataSource
  
  func numberOfSections(in tableView: UITableView) -> Int // Default is 1 if not implemented
  {
    return 1
  }
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    return fileList.count
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
  {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: FLZFileListViewController.CellReuse, for: indexPath) as? FLZFileCell
    else
    {
      return UITableViewCell()
    }
    
    guard let file = fileList[safe: (indexPath as NSIndexPath).row] else { return cell }
    
    cell.file(file, asRoot:self.pathStart == "")
    cell.tag = (indexPath as NSIndexPath).row

    return cell
  }
  
  
  // MARK: Transition
  
  override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool
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
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if (segue.identifier == SegueToFileList)
    {
      guard let fileListVC = segue.destination as? FLZFileListViewController,
            let cell = sender as? UITableViewCell,
            let file = fileList[safe: cell.tag],
            let filename = file.name
      else
      {
        return
      }

      fileListVC.session(smbSession, pathStart: "\(pathStart)\(filename)")

    }
  }
  
  // MARK: Segmented Control
  
  
  @IBAction func sortFileList(_ sender: UISegmentedControl)
  {
    if (self.currentSort.rawValue == sender.selectedSegmentIndex)
    {
      self.sortOrderToggle(self.currentSort)
    }
    
    self.sortFileList(by: SortBy(rawValue: sender.selectedSegmentIndex)!)
  }
  
  func sortOrderToggle(_ sortBy:SortBy)
  {
    let ascending = sortOrder[sortBy.rawValue] == SortOrder.ascending
    if (ascending)
    {
      sortOrder[sortBy.rawValue] = SortOrder.descending
    }
    else
    {
      sortOrder[sortBy.rawValue] = SortOrder.ascending
    }
  }
  
  func sortFileList(by sortBy:SortBy)
  {
    let ascending = sortOrder[sortBy.rawValue] == SortOrder.ascending
    switch (sortBy.rawValue)
    {
      case SortBy.name.rawValue:
        fileList = fileList.sorted(by: { ascending ? $0.name.caselessLesserThan($1.name) : $0.name.caselessGreaterThan($1.name) })
        break;
      
      case SortBy.size.rawValue:
        fileList = fileList.sorted(by: { ascending ? $0.fileSize < $1.fileSize : $0.fileSize > $1.fileSize })
        break;
      
      default:
        fileList = fileList.sorted(by: { (file1, file2) in
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

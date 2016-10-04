//
//  ViewController.swift
//  fylz
//
//  Created by asu on 2016-10-02.
//  Copyright © 2016 ArsenykUstaris. All rights reserved.
//

import UIKit
import TOSMBClient

class FLZNetNamesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  let NetBIOSDiscoveryTimeout = 10.0
  static let CellReuse = "NetNamesListCell"
  
  @IBOutlet weak var tableView: UITableView!
  
  var netBIOSNames = [String:TONetBIOSNameServiceEntry]();
  let netNames = TONetBIOSNameService()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    netNames.startDiscoveryWithTimeOut(
      NetBIOSDiscoveryTimeout,
      added:
      { [unowned self] (nameEntry:TONetBIOSNameServiceEntry!) in
        let ipAddressString = self.netNames.resolveIPAddressWithName(nameEntry.name, type: nameEntry.type)
        self.netBIOSNames[ipAddressString] = nameEntry;
        
        self.reloadTableView()

      },
      removed:
      { [unowned self] (nameEntry:TONetBIOSNameServiceEntry!) in
        let ipAddressString = self.netNames.resolveIPAddressWithName(nameEntry.name, type: nameEntry.type)
        self.netBIOSNames.removeValueForKey(ipAddressString)
        
      }
    )
    
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
    return self.netBIOSNames.count
  }
  

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
  {
    let cell = tableView.dequeueReusableCellWithIdentifier(FLZNetNamesViewController.CellReuse, forIndexPath: indexPath)
    
    let ipAddress = Array(netBIOSNames.keys)[indexPath.row]
    let netName = netBIOSNames[ipAddress]?.name
    
    cell.textLabel?.text = netName
    cell.detailTextLabel?.text = ipAddress
    
    return cell
  }
  
  // MARK: Helper
//  BooleanType
  
  func reloadTableView()
  {
    let isMainThread:BooleanType = NSThread.isMainThread()

    guard isMainThread else
    {
      dispatch_async(dispatch_get_main_queue(),{ () -> Void in self.reloadTableView() } )
      return;
    }
    
    self.tableView.reloadData()
  }
}


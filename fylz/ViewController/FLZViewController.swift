//
//  ViewController.swift
//  fylz
//
//  Created by asu on 2016-10-02.
//  Copyright © 2016 ArsenykUstaris. All rights reserved.
//

import UIKit
import TOSMBClient

class FLZViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  let NetBIOSDiscoveryTimeout = 10.0
  
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
        print("++++++++++ \(nameEntry.name)")
        print(self.netBIOSNames);
      },
      removed:
      { [unowned self] (nameEntry:TONetBIOSNameServiceEntry!) in
        let ipAddressString = self.netNames.resolveIPAddressWithName(nameEntry.name, type: nameEntry.type)
        self.netBIOSNames.removeValueForKey(ipAddressString)
        print("---------- \(nameEntry.name)")
        print(self.netBIOSNames);
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
    return 0
  }
  

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
  {
    return UITableViewCell(frame: CGRectZero)
  }
  
  
}


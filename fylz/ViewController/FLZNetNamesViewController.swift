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

  static let CellReuse = "NetNamesListCell"

  let NetBIOSDiscoveryTimeout = 10.0
  let SegueToFileList = "toFileList"
  
  @IBOutlet weak var tableView: UITableView!
  
  var netBIOSNames = [String:TONetBIOSNameServiceEntry]();
  let netNames = TONetBIOSNameService()
  
  // MARK: Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()

    netNames.startDiscovery(
      withTimeOut: NetBIOSDiscoveryTimeout,
      added: { [unowned self] (nameEntry:TONetBIOSNameServiceEntry?) in
        guard let ipAddressString = self.netNames.resolveIPAddress(withName: nameEntry?.name, type: (nameEntry?.type)!) else
        {
          return
        }
        
        self.netBIOSNames[ipAddressString] = nameEntry;
        self.reloadTableView()
      
      },
      removed: { [unowned self] (nameEntry:TONetBIOSNameServiceEntry?) in
        guard let ipAddressString = self.netNames.resolveIPAddress(withName: nameEntry?.name, type: (nameEntry?.type)!) else
        {
          return
        }
        self.netBIOSNames.removeValue(forKey: ipAddressString)
        self.reloadTableView()
      }
    )
  
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  // MARK: UITableViewDataSource

  func numberOfSections(in tableView: UITableView) -> Int // Default is 1 if not implemented
  {
    return 1
  }
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    return self.netBIOSNames.count
  }
  

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
  {
    let cell = tableView.dequeueReusableCell(withIdentifier: FLZNetNamesViewController.CellReuse, for: indexPath)
    
    let ipAddress = Array(netBIOSNames.keys)[(indexPath as NSIndexPath).row]
    let netName = netBIOSNames[ipAddress]?.name
    
    cell.textLabel?.text = netName
    cell.detailTextLabel?.text = ipAddress
    
    return cell
  }
  
  // MARK: Transition
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if (segue.identifier == SegueToFileList)
    {
      guard let fileListVC = segue.destination as? FLZFileListViewController,
            let cell = sender as? UITableViewCell else
      {
        return
      }
      
      let hostName = cell.textLabel?.text
      let ipAddress = cell.detailTextLabel?.text
      
      guard let smbSession = TOSMBSession(hostName: hostName, ipAddress: ipAddress) else
      {
        return
      }
      
      smbSession.setLoginCredentialsWithUserName("tc", password: "guest")
      
      fileListVC.session(smbSession, pathStart:"")
      
    }
  }
  
  // MARK: Helper
  
  func reloadTableView()
  {
    let isMainThread:Bool = Thread.isMainThread

    guard isMainThread else
    {
      DispatchQueue.main.async(execute: { () -> Void in self.reloadTableView() } )
      return;
    }
    
    self.tableView.reloadData()
  }
}


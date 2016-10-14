//
//  FLZFileCell.swift
//  fylz
//
//  Created by asu on 2016-10-05.
//  Copyright © 2016 ArsenykUstaris. All rights reserved.
//

import UIKit
import TOSMBClient

class FLZFileCell: UITableViewCell
{
  
  @IBOutlet weak var mainLabel: UILabel!
  @IBOutlet weak var detailLabel: UILabel!
  @IBOutlet weak var selectionButton: UIButton!

  fileprivate var file:TOSMBSessionFile!
  fileprivate var fileIsRoot:Bool = false

  func file(_ file:TOSMBSessionFile, asRoot:Bool)
  {
    self.file = file
    fileIsRoot = asRoot

    update()
  }

  func update()
  {
    mainLabel.text = (fileIsRoot ? file.filePath : file.name + (file.directory ? "/" : ""))
    
    if (file.directory)
    {
      detailLabel.text = ""
    }
    else
    {
      let fileSizeString = ByteCountFormatter.string(fromByteCount: Int64(file.fileSize), countStyle:ByteCountFormatter.CountStyle.binary)
      
      var modificationDateString = file.modificationTime.relativeTime
      
      if (file.modificationTime.days(from: Date()) > 1)
      {
        modificationDateString = DateFormatter.localizedString(from: file.modificationTime, dateStyle: .short, timeStyle: .short)
      }
      modificationDateString = DateFormatter.localizedString(from: file.modificationTime, dateStyle: .medium, timeStyle: .short)

      detailLabel.text = "Size:\(fileSizeString), Modified:\(modificationDateString)"

    }
  }
  
  
  override func setSelected(_ selected: Bool, animated: Bool)
  {
    let subviewBackgrounds = self.contentView.subviews.map(
    { (subview) -> (UIView,UIColor?) in
      (subview,subview.backgroundColor)
    })
    super.setSelected(selected, animated: animated)
    
    if(selected) {
      let _ = subviewBackgrounds.map({ subview, backgroundColor in
        subview.backgroundColor = backgroundColor
      })
    }
  }
  
  override func setHighlighted(_ highlighted: Bool, animated: Bool)
  {
    let subviewBackgrounds = self.contentView.subviews.map(
    { (subview) -> (UIView,UIColor?) in
      (subview,subview.backgroundColor)
    })
    super.setHighlighted(highlighted, animated: animated)
    
    if(highlighted) {
      let _ = subviewBackgrounds.map(
      { subview, backgroundColor in
        subview.backgroundColor = backgroundColor
      })
    }
  }
}

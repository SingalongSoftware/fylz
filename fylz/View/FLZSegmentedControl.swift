//
//  FLZSegmentedControl.swift
//  fylz
//
//  Created by asu on 2016-10-06.
//  Copyright © 2016 ArsenykUstaris. All rights reserved.
//

import UIKit

class FLZSegmentedControl: UISegmentedControl
{
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    let current = self.selectedSegmentIndex;
    super.touchesEnded(touches, with: event)
    if (current == self.selectedSegmentIndex)
    {
      self.sendActions(for: .valueChanged)
    }
  }
  
}

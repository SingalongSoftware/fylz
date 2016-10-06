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
  override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    let current = self.selectedSegmentIndex;
    super.touchesEnded(touches, withEvent: event)
    if (current == self.selectedSegmentIndex)
    {
      self.sendActionsForControlEvents(.ValueChanged)
    }
  }
  
}

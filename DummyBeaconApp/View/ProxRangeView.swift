//
//  ProxRangeView.swift
//  DummyBeaconApp
//
//  Created by Daniel Seijo Sánchez on 30/8/15.
//  Copyright © 2015 Daniel Seijo Sánchez. All rights reserved.
//

import UIKit

class ProxRangeView: UIView {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = UIColor.clearColor()
  }
  
  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // Only override drawRect: if you perform custom drawing.
  // An empty implementation adversely affects performance during animation.
  override func drawRect(rect: CGRect) {
    // Get the Graphics Context
    let context = UIGraphicsGetCurrentContext();
    
    // Set the circle outerline-width
    CGContextSetLineWidth(context, 1.0);
    
    // Set the circle colors
    UIColor.redColor().setStroke()
    UIColor.blueColor().setFill()
    
    // Create Circle
    CGContextAddArc(context, frame.size.width / 2, frame.size.height / 2, (frame.size.width - 10) / 2, 0.0, CGFloat(M_PI * 2.0), 1)
    // Fill circle with color
    CGContextDrawPath(context, CGPathDrawingMode.Fill);
    
    // Draw
    CGContextStrokePath(context);
  }
  
}

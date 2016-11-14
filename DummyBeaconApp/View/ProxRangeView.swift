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
        self.backgroundColor = UIColor.clear
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Get the Graphics Context
        let context = UIGraphicsGetCurrentContext()
        
        // Set the circle outerline-width
        context?.setLineWidth(1.0)
        
        // Set the circle colors
        color.setStroke()
        color.setFill()
        
        // Create Circle
        let center = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        context?.addArc(center: center, radius: (frame.size.width - 10) / 2, startAngle: 0.0, endAngle: CGFloat(M_PI * 2.0), clockwise: true)
        // Fill circle with color
        context?.drawPath(using: CGPathDrawingMode.fill)
        
        // Draw
        context?.strokePath()
    }
    
    var color = UIColor.blue {
        didSet {
            setNeedsDisplay()
        }
    }
}

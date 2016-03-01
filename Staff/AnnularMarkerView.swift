//
//  AnnularMarkerView.swift
//  Staff
//
//  Created by Haizhen Lee on 16/3/1.
//  Copyright © 2016年 banxi1988. All rights reserved.
//

import UIKit


class AnnularMarkerView:UIView{
  var annularBackgroundColor = UIColor(white: 0.966, alpha: 1.0){
    didSet{
      setNeedsDisplay()
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .clearColor()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  var startAngle:CGFloat = 0{
    didSet{
      setNeedsDisplay()
    }
  }
  var totalAngle:CGFloat = CGFloat(M_PI * 2){
    
    didSet{
      setNeedsDisplay()
    }
  }
  
  var markerPaddingIn :CGFloat = 4
  var markerPaddingOut :CGFloat = 2
  
  var shortMarkerWidth: CGFloat = 2{
    didSet{
      setNeedsDisplay()
    }
  }
  var longMarkerWidth :CGFloat = 2{
    didSet{
      setNeedsDisplay()
    }
  }
  var shortMarkerSize:CGFloat = 15{
    didSet{
      setNeedsDisplay()
    }
  }
  var longMarkerSize:CGFloat = 30{
    didSet{
      setNeedsDisplay()
    }
  }
  var markerCount:UInt = 11{
    didSet{
      setNeedsDisplay()
    }
  }
  
  var markerMod:UInt = 3{
    didSet{
      setNeedsDisplay()
    }
  }
  
  var markerColor:UIColor = UIColor(white: 0.78, alpha: 1.0){
    didSet{
      setNeedsDisplay()
    }
  }
  
  override func drawRect(rect: CGRect) {
    super.drawRect(rect)
    let annularWidth = longMarkerSize + markerPaddingIn + markerPaddingOut
    
    let inset = annularWidth * 0.5
    let annularPath = UIBezierPath(ovalInRect: rect.insetBy(dx: inset, dy: inset))
    annularPath.lineWidth = annularWidth
    annularBackgroundColor.setStroke()
    annularPath.stroke()
    
    let ctx = UIGraphicsGetCurrentContext()
    CGContextSaveGState(ctx)
    markerColor.set()
    CGContextSetLineWidth(ctx, 1.0)
    
    CGContextTranslateCTM(ctx, bounds.midX, bounds.midY)
    
    let lineRect = CGRect(x: -longMarkerWidth * 0.5, y: 0, width: longMarkerWidth, height: longMarkerSize)
    let shortRect = CGRect(x: -shortMarkerWidth * 0.5, y: 0, width: shortMarkerWidth, height: shortMarkerSize)
    
    let linePath = UIBezierPath(rect: lineRect)
    let shortPath = UIBezierPath(rect: shortRect)
    linePath.lineCapStyle = .Round
    linePath.lineJoinStyle = .Round
    
    
    let radius = bounds.width * 0.5 - markerPaddingOut
    
    for dial in (0...markerCount){
      CGContextSaveGState(ctx)
      let angle =  startAngle +   CGFloat(dial) / CGFloat(markerCount + 1) * totalAngle
      CGContextRotateCTM(ctx, angle)
      if dial % markerMod == 0{
        CGContextTranslateCTM(ctx, 0, radius - longMarkerSize)
        linePath.fill()
        
      }else{
        CGContextTranslateCTM(ctx, 0, radius - shortMarkerSize)
        shortPath.fill()
      }
      CGContextRestoreGState(ctx)
      
    }
    CGContextRestoreGState(ctx)
    
  }
}
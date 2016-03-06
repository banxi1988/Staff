//
//  ArtProgressView.swift
//  Staff
//
//  Created by Haizhen Lee on 16/3/6.
//  Copyright © 2016年 banxi1988. All rights reserved.
//


import UIKit


class ArtProgressView:UIView{
  
  
  lazy var annularLayer  :  CAGradientLayer = {
    let annularLayer = CAGradientLayer()
    self.layer.addSublayer(annularLayer)
    let colors :[CGColorRef] = [UIColor.redColor(),UIColor.orangeColor(),UIColor.yellowColor(), UIColor.greenColor(),UIColor.greenColor(), UIColor.greenColor()].map{$0.CGColor}
    let locations = [0,3,6,8,9,12].map{ CGFloat($0) / 12.0 }
    annularLayer.colors = colors
    annularLayer.locations = locations
    annularLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
    annularLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
    return annularLayer
  }()
  
  lazy var maskLayer : CAShapeLayer = {
    let maskLayer  = CAShapeLayer()
    maskLayer.fillColor = UIColor.clearColor().CGColor
    maskLayer.strokeColor = UIColor.whiteColor().CGColor
    maskLayer.lineWidth = self.lineWidth
    maskLayer.lineJoin = "round"
    maskLayer.lineCap = "round"
    self.annularLayer.mask = maskLayer
    return maskLayer
  }()
  
  var startAngle:CGFloat = CGFloat(M_PI_2)
  var progress:CGFloat = 0.0{
    didSet{
      updatePath()
    }
  }
  
  var endAngle:CGFloat {
    let angle = progress * CGFloat(M_PI) * 2
    return startAngle + angle
  }
  
  var maskPath:UIBezierPath{
    return  UIBezierPath(arcCenter: CGPoint(x: bounds.midX, y: bounds.midY), radius: radius, startAngle: CGFloat(M_PI / 2.0), endAngle: endAngle, clockwise: true)
  }
  
  var radius:CGFloat{
    return bounds.width * 0.5 - lineWidth * 0.5
  }
  
  var lineWidth :CGFloat = 15{
    didSet{
      updatePath()
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    annularLayer.frame = bounds
    maskLayer.frame = bounds
    updatePath()
  }
  
  func updatePath(){
    maskLayer.path = maskPath.CGPath
    playProgressAnimation()
  }
  
  
  func playProgressAnimation(){
    let anim = CABasicAnimation(keyPath: "strokeEnd")
    anim.duration = 1.0
    anim.repeatCount = 1.0
    anim.removedOnCompletion = false
    anim.fromValue = 0.0
    anim.toValue = progress
    anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
    maskLayer.addAnimation(anim, forKey: "drawArc")
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
//
//  RecordStatusView.swift
//  Staff
//
//  Created by Haizhen Lee on 16/3/1.
//  Copyright © 2016年 banxi1988. All rights reserved.
//

import Foundation

// Build for target uimodel
import UIKit
import BXModel
import SwiftyJSON
import BXiOSUtils
import BXForm

//-ClockStatusView:v
//progress[x,y,a1,w230]:v
//marker[x,y,a1,w316,t8,b8]:v

class ClockView : UIView  ,BXBindable {
  let progressView = AnnularProgressView(frame:CGRectZero)
  let markerView = AnnularMarkerView(frame:CGRectZero)
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  func bind(item:CGFloat){
    progressView.progress = item
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    commonInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  var allOutlets :[UIView]{
    return [progressView,markerView]
  }
  var allUIViewOutlets :[UIView]{
    return [progressView,markerView]
  }
  
  func commonInit(){
    for childView in allOutlets{
      addSubview(childView)
      childView.translatesAutoresizingMaskIntoConstraints = false
    }
    installConstaints()
    setupAttrs()
    
  }
  
  func installConstaints(){
    progressView.pa_centerY.install()
    progressView.pa_centerX.install()
    progressView.pa_aspectRatio(1).install()
    progressView.pa_width.eq(230).install()
    markerView.pa_aspectRatio(1).install()
    markerView.pa_bottom.eq(8).install()
    markerView.pa_top.eq(8).install()
    markerView.pa_width.eq(316).install()
    markerView.pa_centerY.install()
    markerView.pa_centerX.install()
  }
  
  func setupAttrs(){
    backgroundColor =  UIColor(white: 0.8, alpha: 1.0)
  }
  
  override class func requiresConstraintBasedLayout() -> Bool{
    return true
  }
}

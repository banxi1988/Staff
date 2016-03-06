//
//  ArtClockView.swift
//  Staff
//
//  Created by Haizhen Lee on 16/3/5.
//  Copyright © 2016年 banxi1988. All rights reserved.
//

import Foundation
import UIKit




// Build for target uimodel
import UIKit
import BXModel
import SwiftyJSON
import BXiOSUtils
import BXForm

//-ArtClockView:v
//clock[hor0,t0,b0]:i
//progress[hor0,t0,h303]:v
//punch[x,t10]:b

class ArtClockView : UIView {
  let clockImageView = UIImageView(frame:CGRectZero)
  let progressView = ArtProgressView(frame:CGRectZero)
  let punchButton = PunchButtonView(frame: CGRectZero)
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
 
  func bind(progress:CGFloat){
    progressView.progress = progress
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    commonInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  var allOutlets :[UIView]{
    return [clockImageView,progressView,punchButton]
  }

  var allUIImageViewOutlets :[UIImageView]{
    return [clockImageView]
  }
  var allUIViewOutlets :[UIView]{
    return [progressView]
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
    clockImageView.pa_bottom.eq(0).install()
    clockImageView.pac_horizontal(0)
    clockImageView.pa_top.eq(0).install()
   
    progressView.pa_aspectRatio(1).install()
    progressView.pa_centerX.install()
    progressView.pa_centerY.offset(-24).install()
    progressView.pa_width.eq(231).install()
    
    punchButton.pa_centerX.install()
    punchButton.pa_centerY.offset(-25.5).install()
  }
  
  func setupAttrs(){
    clockImageView.image = Images.Biaopen.image
    progressView.lineWidth = 10
    progressView.progress = 0.6
//    punchButton.addTarget(self, action: "onPunchButtonPressed:", forControlEvents: .TouchUpInside)
  }
  
  func onPunchButtonPressed(sender:AnyObject){
    log.debug(" PUNCH")
  }
  
  override func intrinsicContentSize() -> CGSize {
    return Images.Biaopen.image.size
  }
}

//
//  PunchButtonView.swift
//  Staff
//
//  Created by Haizhen Lee on 16/3/6.
//  Copyright © 2016年 banxi1988. All rights reserved.
//

import Foundation
// Build for target uimodel
import UIKit
import BXModel
import SwiftyJSON
import BXiOSUtils
import BXForm

//-PunchView:v
//title[x,y0](fb33,cw)
//sun[x,y0]:i

class PunchButtonView : UIButton{
  let backgroundImageView = UIImageView(frame: CGRectZero)
  let textLabel = UILabel(frame:CGRectZero)
  let sunImageView = UIImageView(frame:CGRectZero)
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    commonInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  var allOutlets :[UIView]{
    return [backgroundImageView,textLabel,sunImageView]
  }
  var allUIImageViewOutlets :[UIImageView]{
    return [backgroundImageView,sunImageView]
  }
  var allUILabelOutlets :[UILabel]{
    return [textLabel]
  }
  
  func commonInit(){
    translatesAutoresizingMaskIntoConstraints = false
    
    for childView in allOutlets{
      addSubview(childView)
      childView.translatesAutoresizingMaskIntoConstraints = false
    }
    installConstaints()
    setupAttrs()
    
  }
  
  func installConstaints(){
    let size = intrinsicContentSize()
    backgroundImageView.pac_size(size)
    backgroundImageView.pac_edge(0)
    
    textLabel.pa_bottom.equalTo(.CenterY, ofView: self).offset(-sdp2dp(4)).install()
    textLabel.pa_centerX.install()
    sunImageView.pa_centerX.install()
    sunImageView.pa_top.equalTo(.CenterY, ofView: self).offset(sdp2dp(12)).install()
  }
  
  func setupAttrs(){
    backgroundImageView.image = Images.Oval_button_bg.image
    setBackgroundImage(Images.Oval_button_bg.image, forState: .Normal)
    setBackgroundImage(Images.Oval_button_pressed.image, forState: .Highlighted)
    
    textLabel.font = UIFont.boldSystemFontOfSize(36.3)
    textLabel.textColor = UIColor.whiteColor()
    textLabel.text = "打卡"
    
    sunImageView.image = Images.Ic_sun.image
  }
  
  override func intrinsicContentSize() -> CGSize {
    let size = Images.Oval_button_bg.image.size
    return CGSize(width: sdp2dp(size.width), height: sdp2dp(size.height))
  }
}



//
//  AboutViewController.swift
//  Staff
//
//  Created by Haizhen Lee on 16/3/7.
//  Copyright © 2016年 banxi1988. All rights reserved.
//

import Foundation

// Build for target uicontroller
import UIKit
import SwiftyJSON
import BXModel
import BXiOSUtils
import BXForm

//-AboutViewController:vc
//title[t36,x](fb22,cw):l
//version[bl4@title,x](f13,cst)
//devBy[r15,b36](f15,cpt)
//designBy[r15,bl4@devBy](f15,cpt)

class AboutViewController : UIViewController {
  
  let titleLabel = UILabel(frame:CGRectZero)
  let versionLabel = UILabel(frame:CGRectZero)
  let devByLabel = UILabel(frame:CGRectZero)
  let designByLabel = UILabel(frame:CGRectZero)
  convenience init(){
    self.init(nibName: nil, bundle: nil)
  }
  // must needed for iOS 8
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  var allOutlets :[UIView]{
    return [titleLabel,versionLabel,devByLabel,designByLabel]
  }
  var allUILabelOutlets :[UILabel]{
    return [titleLabel,versionLabel,devByLabel,designByLabel]
  }
  
  func commonInit(){
    for childView in allOutlets{
      self.view.addSubview(childView)
      childView.translatesAutoresizingMaskIntoConstraints = false
    }
    installConstaints()
    setupAttrs()
  }
  
  func installConstaints(){
    titleLabel.pa_centerX.install()
    titleLabel.pa_below(self.topLayoutGuide).offset(60).install()
    versionLabel.pa_below(titleLabel,offset:4).install()
    versionLabel.pa_centerX.install()
    devByLabel.pa_trailing.eq(20).install()
    devByLabel.pa_above(self.bottomLayoutGuide).offset(-60).install()
    designByLabel.pa_above(devByLabel,offset:4).install()
    designByLabel.pa_trailing.eq(20).install()
  }
  
  func setupAttrs(){
    titleLabel.font = UIFont.boldSystemFontOfSize(22)
    titleLabel.textColor = UIColor.whiteColor()
    versionLabel.textColor = AppColors.secondaryTextColor
    versionLabel.font = UIFont.systemFontOfSize(13)
    devByLabel.textColor = AppColors.primaryTextColor
    devByLabel.font = UIFont.systemFontOfSize(15)
    designByLabel.textColor = AppColors.primaryTextColor
    designByLabel.font = UIFont.systemFontOfSize(15)
    
    titleLabel.text = "模拟打卡"
    #if DEBUG
    let buildType = "debug"
      #else
    let buildType = "release"
      #endif
    versionLabel.text = "版本:\(bx_versionName()),编译版本:\(bx_versionNumber())-\(buildType)"
    
    designByLabel.text = "设计 : 曾焕燕"
    devByLabel.text = "开发 : 李海珍"
  }
  override func loadView(){
    super.loadView()
    self.view.backgroundColor = AppColors.colorBackground
    commonInit()
  }
  
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "关于"
    navigationItem.title = title
    
  }
  
  
  
  
  
  
  
  
}




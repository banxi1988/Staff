//
//  ViewController.swift
//  Staff
//
//  Created by Haizhen Lee on 16/2/29.
//  Copyright © 2016年 banxi1988. All rights reserved.
//

import UIKit

// Build for target uicontroller
import UIKit
import SwiftyJSON
import BXModel
import BXiOSUtils
import BXForm

//-MainViewController:vc
//clockStatus[x,y]:v
//clockList[hor0,bl15@clockStatus,h50]:v

class MainViewController : UIViewController {
  
  let clockStatusView = ClockStatusView(frame:CGRectZero)
  let clockListView = UIView(frame:CGRectZero)
//  let manageButton = UIButton(type: .System)
//  let settingsButton = UIButton(type: .System)
  
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
    return [clockStatusView,clockListView]
  }
  var allUIViewOutlets :[UIView]{
    return [clockStatusView,clockListView]
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
    clockStatusView.pa_below(self.topLayoutGuide, offset: 16).install()
    clockStatusView.pa_centerX.install()
    clockListView.pa_below(clockStatusView,offset:15).install()
    clockListView.pa_height.eq(50).install()
    clockListView.pac_horizontal(0)
    
//    for button in [settingsButton,manageButton]{
//      button.pa_below(topLayoutGuide, offset: 8).install()
//      button.pa_width.eq(42).install()
//      button.pa_height.eq(36).install()
//      button.titleLabel?.font = UIFont.systemFontOfSize(16)
//      button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
//    }
//   
//    settingsButton.setTitle("设置", forState: .Normal)
//    manageButton.setTitle("管理", forState: .Normal)
//    settingsButton.pa_leading.eq(15).install()
//    manageButton.pa_trailing.eq(15).install()
    
  }
  
  func setupAttrs(){
  }
  override func loadView(){
    super.loadView()
    self.view.backgroundColor = AppColors.colorPrimary
    commonInit()
    
//    manageButton.addTarget(self, action: "onManageButtonPressed:", forControlEvents: .TouchUpInside)
  }
  
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
//    title = "打卡"
//    navigationItem.title = title
   
    let settingsItem = UIBarButtonItem(title: "设置", style: .Plain, target: self, action: "onSettingsButtonPressed:")
    let manageItem = UIBarButtonItem(title: "记录", style: .Plain, target: self, action: "onManageButtonPressed:")
    navigationItem.leftBarButtonItem = settingsItem
    navigationItem.rightBarButtonItem = manageItem
    

    
    
  }
 
  func onManageButtonPressed(sender:AnyObject){
    let vc = ClockRecordListViewController()
    showViewController(vc, sender: self)
  }
 
  func onSettingsButtonPressed(sender:AnyObject){
    let vc = SettingsViewController()
    showViewController(vc, sender: self)
  }
  
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    clockStatusView.startTimer()
  }
  
  override func viewDidDisappear(animated: Bool) {
    super.viewDidDisappear(animated)
    clockStatusView.stopTimer()
  }
  
  
  
  
  
}






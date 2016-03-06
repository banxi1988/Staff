//
//  ArtClockViewController.swift
//  Staff
//
//  Created by Haizhen Lee on 16/3/5.
//  Copyright © 2016年 banxi1988. All rights reserved.
//

import UIKit

// Build for target uicontroller
import UIKit
import SwiftyJSON
import BXModel
import BXiOSUtils
import BXForm

//-ArtClockViewController:vc
//clock[x,y]:v

class ArtClockViewController : UIViewController {
  
  let clockView = ArtClockView(frame:CGRectZero)
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
    return [clockView]
  }
  var allUIViewOutlets :[UIView]{
    return [clockView]
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
    clockView.pa_centerY.install()
    clockView.pa_centerX.install()
  }
  
  func setupAttrs(){
  }
  override func loadView(){
    super.loadView()
    self.view.backgroundColor = AppColors.colorBackground
    commonInit()
  }
  
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = ""
    navigationItem.title = title
    
    
    
  }
  
  
  
  
  
  
  
  
}




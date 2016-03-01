import Foundation
import UIKit
import BXiOSUtils

struct AppMetrics{
  static let cornerRadius : CGFloat = 4.0
  static let iconPadding : CGFloat = 8.0
  static let seperatorLineWidth :CGFloat = 0.5
}

// 相关主题颜色的命名,参考 Material Design 以便开发统一
struct AppColors{
  static let seperatorLineColor = UIColor(hex: 0xe8e8e8) // UIColor(white: 0.914, alpha: 1.0) // 0.914 white
  static let primaryTextColor = UIColor(hex:0xffffff) // .08627451 white
  static let secondaryTextColor = UIColor(hex:0xa6acb4) // .08627451 white
  static let tertiaryTextColor = UIColor(hex:0x808994) //
  static let hintTextColor = UIColor(hex:0xccc3c8) // .509803922 white
  static let colorPrimary = UIColor(hex:0x4c6982) // v2.5 :01c5b7 v2.0: 00aca0
  static let accentColor = UIColor(hex:0x65cfef)
  static let colorPrimaryDark = UIColor(hex:0x5c6c80)
  static let grayColor = UIColor(hex: 0xcccccc)
  static let darkGrayTextColor = UIColor(hex: 0x868686)

  static let colorPrimaryLight = UIColor(hex:0xfa5555)
  static let redColor = UIColor(hex:0xf04a4a)
  static let colorBackground = UIColor(hex: 0x404d5c)
  
  static let orangeColor = UIColor(hex: 0xffb359)
  
}


extension AppDelegate{
  
  func setUpAppearanceProxy(){
    let colorPrimary = AppColors.colorPrimary
    let app = UIApplication.sharedApplication()
    self.window?.tintColor = AppColors.accentColor
    app.statusBarStyle = .LightContent
    
    setUpNavigationBarAppearance()
    setUpSearchBarAppearance()
    setUpTextFieldAppearance()
    setUpBarButtonItemAppearance()
//    setupZjdjLibAppApperance()
  }
  
  private func setUpNavigationBarAppearance(){
    let nap =  UINavigationBar.appearance()
    nap.barStyle  = UIBarStyle.Default
    nap.tintColor = UIColor.whiteColor()
    nap.barTintColor = AppColors.colorPrimary
    nap.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
    nap.backIndicatorImage  = UIImage(named: "ic_arrow_left")
    let navBg =  UIImage.bx_image(AppColors.colorPrimary) //UIImage.imageWithColor(AppColors.colorPrimary)
    nap.setBackgroundImage(navBg, forBarPosition:.Any, barMetrics: .Default)
    nap.shadowImage = navBg
  }
  
  private func setUpSearchBarAppearance(){
    let sbap = UISearchBar.appearance()
    sbap.translucent = false
    sbap.barStyle = .Default
    sbap.barTintColor = .whiteColor()
    let sbbg = UIImage.bx_image(.whiteColor(), size: CGSize(width: 320, height: 44))
    sbap.setBackgroundImage(sbbg, forBarPosition: .Any, barMetrics: .Default)
    let sfbg = UIImage.bx_roundImage(UIColor(hex: 0xefeff4), size: CGSize(width: 320, height: 33), cornerRadius: 4)
    sbap.setSearchFieldBackgroundImage(sfbg, forState: .Normal)
    
  }
  
  private func setUpTextFieldAppearance(){
    let teap = UITextField.appearance()
    teap.borderStyle = .None
    teap.keyboardAppearance = .Light
  }
  
  private func setUpBarButtonItemAppearance(){
    let bap = UIBarButtonItem.appearance()
    bap.tintColor = UIColor.whiteColor()
    let attrs = [NSFontAttributeName:UIFont.systemFontOfSize(17)]
    bap.setTitleTextAttributes(attrs, forState: .Normal)
    // 隐藏 backbutton 中的 title
    bap.setBackButtonTitlePositionAdjustment(UIOffset(horizontal: 0, vertical: -64), forBarMetrics: .Default)
  }
  
  
}


func themedBackgroundView() -> UIView{
  let view = UIView(frame:CGRect(x: 0, y: 0, width: 10, height: 10))
  view.backgroundColor = AppColors.colorPrimary
  return view
}

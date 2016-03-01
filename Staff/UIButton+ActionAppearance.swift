//
//  UIButton+ActionAppearance.swift
//  Youjia
//
//  Created by Haizhen Lee on 15/11/3.
//  Copyright © 2015年 xiyili. All rights reserved.
//

import Foundation
import DynamicColor

extension UIButton{
    
  func setupAsRedButton(){
    backgroundColor = nil
    let redColor = AppColors.redColor
    let normalBg = AppButtons.backgroundImage(redColor)
    let disabledBg = AppButtons.backgroundImage(redColor.desaturateColor(0.35))
    setBackgroundImage(normalBg, forState: .Normal)
    setBackgroundImage(disabledBg, forState: .Disabled)
    setTitleColor(UIColor.whiteColor(), forState: .Normal)
  }
  
  func setupAsAccentButton(){
    backgroundColor = nil
    let highlighBg = AppButtons.backgroundImage(AppColors.accentColor.saturateColor(0.2))
    setBackgroundImage(highlighBg, forState: .Highlighted)
    setBackgroundImage(AppButtons.accentImage, forState: .Normal)
    setBackgroundImage(AppButtons.accentDisabledImage, forState: .Disabled)
    setBackgroundImage(AppButtons.accentPressedImage, forState: .Highlighted)
    setTitleColor(.whiteColor(),forState:.Normal)
  }
  
  func setupAsPrimaryActionButton(){
    setupAsAccentButton()
    titleLabel?.font = UIFont.systemFontOfSize(18)
  }
}

struct AppButtons{
  
  static func backgroundImage(color:UIColor) -> UIImage{
    let cornerRadius = AppMetrics.cornerRadius
    let size = CGSize(width: 36, height: 36)
    let image = UIImage.bx_roundImage(color, size: size, cornerRadius: cornerRadius)
    let buttonImage = image.resizableImageWithCapInsets(UIEdgeInsets(top: cornerRadius, left: cornerRadius, bottom: cornerRadius, right: cornerRadius))
    return buttonImage
  }
  
  static let accentImage = AppButtons.backgroundImage(AppColors.accentColor)
  static let accentPressedImage = AppButtons.backgroundImage(AppColors.accentColor.darkerColor())
  static let accentDisabledImage = AppButtons.backgroundImage(AppColors.accentColor.desaturateColor(0.35))
  static let primaryImage = AppButtons.backgroundImage(AppColors.accentColor)
  
}
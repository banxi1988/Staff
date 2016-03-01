//
//  UIKitGlobals.swift
//  Pods
//
//  Created by Haizhen Lee on 15/12/6.
//
//

import UIKit

public let screenScale = UIScreen.mainScreen().scale
public let screenWidth = UIScreen.mainScreen().bounds.width
public let screenHeight = UIScreen.mainScreen().bounds.height
public var designBaseWidth:CGFloat = 375 //  // Design Pointer to Devices Pointer

public func dp2dp(dp:CGFloat) -> CGFloat{
  let coefficent = screenWidth / designBaseWidth
  return ceil(dp * coefficent)
}

// 比 375 小的设备对应缩小，大的不变
public func sdp2dp(dp:CGFloat) -> CGFloat{
  if screenWidth >= designBaseWidth{
    return dp
  }else{
    return dp2dp(dp)
  }
}
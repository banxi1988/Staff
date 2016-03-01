//
//  ClockStatusView.swift
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

//-ClockStatusView:
//clock[hor0,t0]:v
//worked_time[x,bl8@clock](f15,cpt)
//need_time[l0@worked_time,bl8@worked_time](f15,cpt)
//off_time[l0@worked_time,bl8@need_time](f15,cpt)

class ClockStatusView : UIView  ,BXBindable {
  let clockView = ClockView(frame:CGRectZero)
  let worked_timeLabel = UILabel(frame:CGRectZero)
  let need_timeLabel = UILabel(frame:CGRectZero)
  let off_timeLabel = UILabel(frame:CGRectZero)
  let statusLabel = UILabel(frame: CGRectZero)
  let clockButton = OvalButton(frame: CGRectZero)
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  func bind(item:ClockStatus){
    worked_timeLabel.attributedText = item.worked_time_text
    need_timeLabel.attributedText  = item.need_time_text
    off_timeLabel.attributedText = item.off_time_text
    if isWorking && timerInterval > 10 {
      clockView.bind(CGFloat(item.progress))
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    commonInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  var allOutlets :[UIView]{
    return [clockView,worked_timeLabel,need_timeLabel,off_timeLabel,clockButton,statusLabel]
  }
  var allUILabelOutlets :[UILabel]{
    return [worked_timeLabel,need_timeLabel,off_timeLabel]
  }
  var allUIViewOutlets :[UIView]{
    return [clockView]
  }
  
  func commonInit(){
    for childView in allOutlets{
      addSubview(childView)
      childView.translatesAutoresizingMaskIntoConstraints = false
    }
    installConstaints()
    setupAttrs()
    autobind()
    
  }
  
  func installConstaints(){
    statusLabel.pa_top.eq(16).install()
    statusLabel.pa_centerX.install()
    
    clockView.pac_horizontal(0)
    clockView.pa_below(statusLabel, offset: 15).install()
    worked_timeLabel.pa_below(clockView,offset:8).install()
    worked_timeLabel.pa_centerX.install()
    need_timeLabel.pa_below(worked_timeLabel,offset:8).install()
//    need_timeLabel.pa_leading.eqTo(worked_timeLabel).offset(0).install()
    need_timeLabel.pa_centerX.install()
    off_timeLabel.pa_below(need_timeLabel,offset:8).install()
//    off_timeLabel.pa_leading.eqTo(worked_timeLabel).offset(0).install()
    off_timeLabel.pa_centerX.install()
    off_timeLabel.pa_bottom.eq(15).install()
    
    clockButton.pa_centerX.eqTo(clockView).install()
    clockButton.pa_centerY.eqTo(clockView).install()
    clockButton.pa_aspectRatio(1).install()
    clockButton.pa_width.eq(160).install()
  }
  
  func setupAttrs(){
    statusLabel.textColor = AppColors.accentColor
    statusLabel.font = UIFont.systemFontOfSize(26)
    
    worked_timeLabel.textColor = AppColors.primaryTextColor
    worked_timeLabel.font = UIFont.systemFontOfSize(15)
    need_timeLabel.textColor = AppColors.primaryTextColor
    need_timeLabel.font = UIFont.systemFontOfSize(15)
    off_timeLabel.textColor = AppColors.primaryTextColor
    off_timeLabel.font = UIFont.systemFontOfSize(15)
    
    clockButton.setTitle("打卡", forState: .Normal)
    clockButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    clockButton.titleLabel?.font = UIFont.boldSystemFontOfSize(28)
    clockButton.setupAsAccentButton()
    clockButton.addTarget(self, action: "onClockButtonPressed:", forControlEvents: .TouchUpInside)
  }
  
  override static func requiresConstraintBasedLayout() -> Bool{
    return true
  }
  
  var isWorking :Bool = false
  var timerInterval :NSTimeInterval = 1
  func autobind(){
    isWorking =  (ClockRecordService.sharedService.lastRecordInToday()?.recordType == ClockRecordType.On) ?? false
    let status = ClockRecordHelper.currentClockStatus()
    let bestTimerInterval:NSTimeInterval = status.worked_seconds > 60  ? 60: 1
    if bestTimerInterval != timerInterval{
      timerInterval = bestTimerInterval
      startTimer()
    }
    statusLabel.text = isWorking ? "工作中..." : "休息中..."
    bind(status)
  }
  
  func onClockButtonPressed(sender:AnyObject){
     ClockRecordHelper.clock()
    autobind()
  }
  
  override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
    let cpoint = clockButton.convertPoint(point, fromView: self)
    if clockButton.pointInside(cpoint, withEvent: event){
      return clockButton
    }
    let view = super.hitTest(point, withEvent: event)
    return view
  }
  
  
  func onTimerCallback(){
    autobind()
  }
  
  var timer:NSTimer?
  
  func startTimer(){
    stopTimer()
    timer = NSTimer.scheduledTimerWithTimeInterval(timerInterval, target: self, selector: "onTimerCallback", userInfo: nil, repeats: true)
  }
  
  func stopTimer(){
    timer?.invalidate()
    timer = nil
  }
}


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
  let clockView = ArtClockView(frame:CGRectZero)
  let worked_timeLabel = UILabel(frame:CGRectZero)
  let worked_timeText = UILabel(frame:CGRectZero)
  let need_timeLabel = UILabel(frame:CGRectZero)
  let need_timeText = UILabel(frame:CGRectZero)
  let off_timeLabel = UILabel(frame:CGRectZero)
  let off_timeText = UILabel(frame:CGRectZero)
  let statusLabel = UILabel(frame: CGRectZero)
  
  
  var isFirstShow  = true
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  func bind(item:ClockStatus){
    worked_timeLabel.text = item.worked_time_label
    worked_timeText.text = item.worked_time_text
    
    need_timeLabel.text = item.need_time_label
    need_timeText.text = item.need_time_text
    
    off_timeLabel.text = item.off_time_label
    off_timeText.text = item.off_time_text
    
    if (isWorking && timerInterval > 10) || isFirstShow || isClockEvent {
      clockView.bind(CGFloat(item.progress))
      isFirstShow = false
      isClockEvent = false
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
    return [clockView,worked_timeLabel,worked_timeText, need_timeLabel,need_timeText,off_timeLabel,off_timeText,statusLabel]
  }
  var allUILabelOutlets :[UILabel]{
    return [worked_timeLabel,worked_timeText, need_timeLabel,need_timeText,off_timeLabel,off_timeText]
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
    
    NSNotificationCenter.defaultCenter().addObserverForName(AppEvents.WorkDurationChanged, object: nil, queue: nil) { [weak self] (notif) -> Void in
      self?.isClockEvent = true
      self?.autobind()
    }
    
    NSNotificationCenter.defaultCenter().addObserverForName(AppEvents.ClockDataSetChanged, object: nil, queue: nil) { [weak self] (notif) -> Void in
      self?.isClockEvent = true
      self?.autobind()
    }
    
  }
  
  deinit{
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
  func installConstaints(){
    statusLabel.pa_top.eq(sdp2dp(16)).install()
    statusLabel.pa_centerX.install()
    
    clockView.pac_horizontal(0)
    clockView.pa_below(statusLabel, offset: sdp2dp(15)).install()
    worked_timeLabel.pa_below(clockView,offset:-16).install()
    worked_timeLabel.pa_centerX.install()
    
    worked_timeText.pa_below(worked_timeLabel, offset: 4).install()
    worked_timeText.pa_centerX.install()
    
    need_timeLabel.pa_below(worked_timeText,offset:sdp2dp(15)).install()
    need_timeLabel.pa_trailing.equalTo(.CenterX, ofView: self).offset(-50).install()
    
    need_timeText.pa_trailing.eqTo(need_timeLabel).install()
    need_timeText.pa_below(need_timeLabel, offset: 4).install()
    
    
   
    off_timeLabel.pa_top.eqTo(need_timeLabel).install()
    off_timeLabel.pa_leading.equalTo(.CenterX, ofView: self).offset(50).install()
    
    off_timeText.pa_leading.eqTo(off_timeLabel).install()
    off_timeText.pa_bottom.eqTo(need_timeText).install()
    
  }
  
  func setupAttrs(){
    for label in allUILabelOutlets{
      label.textColor = AppColors.primaryTextColor
      label.font = UIFont.systemFontOfSize(13)
    }
    
    statusLabel.textColor = AppColors.primaryTextColor
    let statusFontSize = sdp2dp(36)
    if #available(iOS 8.2, *) {
        statusLabel.font = UIFont.systemFontOfSize(statusFontSize, weight: UIFontWeightMedium)
    } else {
      statusLabel.font = UIFont.systemFontOfSize(statusFontSize)
    }
   
    worked_timeText.font = UIFont.boldSystemFontOfSize(sdp2dp(40))
    
 
    need_timeLabel.textAlignment = .Right
    need_timeText.textAlignment = .Right
    
    off_timeLabel.textAlignment = .Left
    off_timeText.textAlignment = .Left
    
 
    clockView.punchButton.addTarget(self, action: "onClockButtonPressed:", forControlEvents: .TouchUpInside)
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
    statusLabel.text = isWorking ? "工作中" : "休息中"
    bind(status)
    
    if isWorking && timerInterval > 0 {
      AppNotifications.notifyWorkedTimeExceed(status.need_time_seconds)
    }
  }
  
  var isClockEvent = false
  func onClockButtonPressed(sender:AnyObject){
     ClockRecordHelper.clock()
    isClockEvent = true
    autobind()
  }
  
  var clockButton:UIView{
    return clockView.punchButton
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
    autobind()
  }
  
  func stopTimer(){
    timer?.invalidate()
    timer = nil
  }
}


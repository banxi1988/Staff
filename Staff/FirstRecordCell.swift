//
//  FirstRecordCell.swift
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

//-FirstRecordCell(m=ClockRecord):cc
//weekday[l15,t8,w30,a1](f17,cw)
//day[x0@weekday,bl4@weekday,b8](f14,cst)
//time[l60,y](f15,cpt)
//type[r15,y](f13,cst)

class FirstRecordCell : ClockRecordCell{
  let weekdayLabel = OvalLabel(frame:CGRectZero)
  let dayLabel = UILabel(frame:CGRectZero)
  let worked_timeLabel = UILabel(frame: CGRectZero)
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  override func bind(item:ClockRecord){
    let date = item.clock_time
    weekdayLabel.text  = date.zhShortWeekday
    dayLabel.text  = date.bx_shortDateString
    super.bind(item)
    bx_async{
      let clockStatus = ClockRecordHelper.clockStatusInDate(date)
      bx_runInUiThread{
        self.worked_timeLabel.text = "工作: " + clockStatus.worked_time
      }
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    commonInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override var allOutlets :[UIView]{
    return [weekdayLabel,dayLabel,timeLabel,typeLabel,worked_timeLabel]
  }
  override var allUILabelOutlets :[UILabel]{
    return [weekdayLabel,dayLabel,timeLabel,typeLabel,worked_timeLabel]
  }
  
//  override func commonInit(){
//    for childView in allOutlets{
//      contentView.addSubview(childView)
//      childView.translatesAutoresizingMaskIntoConstraints = false
//    }
//    installConstaints()
//    setupAttrs()
//    
//  }
  
  override func installConstaints(){
    super.installConstaints()
    weekdayLabel.pa_aspectRatio(1).install()
    weekdayLabel.pa_leading.eq(15).install()
    weekdayLabel.pa_width.eq(50).install()
    weekdayLabel.pa_top.eq(15).install()
    dayLabel.pa_below(weekdayLabel,offset:4).install()
    dayLabel.pa_centerX.eqTo(weekdayLabel).offset(0).install()
    
    worked_timeLabel.pa_leading.eqTo(timeLabel).install()
//    worked_timeLabel.pa_top.eqTo(weekdayLabel).install()
    worked_timeLabel.pa_centerY.eqTo(weekdayLabel).install()
    

  }
  
  override func setupAttrs(){
    super.setupAttrs()
    weekdayLabel.textColor = UIColor.whiteColor()
    weekdayLabel.font = UIFont.systemFontOfSize(17)
    dayLabel.textColor = AppColors.secondaryTextColor
    dayLabel.font = UIFont.systemFontOfSize(14)
    
    weekdayLabel.backgroundColor = AppColors.accentColor
    weekdayLabel.textAlignment = .Center
    
    worked_timeLabel.textColor = AppColors.primaryTextColor
    worked_timeLabel.font = UIFont.systemFontOfSize(15)
    worked_timeLabel.text = "上班时长:"
  }
}

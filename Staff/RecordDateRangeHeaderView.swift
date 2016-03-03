//
//  RecordDateRangeHeaderView.swift
//  Staff
//
//  Created by Haizhen Lee on 16/3/3.
//  Copyright © 2016年 banxi1988. All rights reserved.
//

import Foundation

//UICollectionReusableView
// Build for target uimodel
import UIKit
import BXModel
import SwiftyJSON
import BXiOSUtils
import BXForm

//-RecordDateRangeHeaderView:v
//title[l15,t8,b8](f15,cpt)
//disclosure[r8,ver0,w60]:b

class RecordDateRangeHeaderView : UICollectionReusableView  ,BXBindable {
  let titleLabel = UILabel(frame:CGRectZero)
  let disclosureButton = UIButton(type:.System)
  let worked_timeLabel = UILabel(frame: CGRectZero)
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  var item:RecordDateRange?
  func bind(item:RecordDateRange){
    self.item = item
    titleLabel.text  = item.rangeTitle
    bx_async{
      let clockStatus = ClockRecordHelper.clockStatusInRange(item)
      bx_runInUiThread{
        self.worked_timeLabel.text = "上班时长累计: " + clockStatus.worked_time
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
  
  var allOutlets :[UIView]{
    return [titleLabel,disclosureButton,worked_timeLabel]
  }
  var allUIButtonOutlets :[UIButton]{
    return [disclosureButton]
  }
  var allUILabelOutlets :[UILabel]{
    return [titleLabel,worked_timeLabel]
  }
  
  func commonInit(){
    for childView in allOutlets{
      addSubview(childView)
      childView.translatesAutoresizingMaskIntoConstraints = false
    }
    installConstaints()
    setupAttrs()
    
  }
  
  func installConstaints(){
    titleLabel.pa_bottom.eq(8).withLowPriority.install()
    titleLabel.pa_top.eq(8).withLowPriority.install()
    titleLabel.pa_centerY.install()
    titleLabel.pa_leading.eq(15).install()
    
    worked_timeLabel.pa_leading.eq(75).install()
    worked_timeLabel.pa_centerY.install()
    
    disclosureButton.pa_trailing.eq(8).install()
    disclosureButton.pac_vertical(0)
    disclosureButton.pa_width.eq(60).install()
  }
  
  func setupAttrs(){
    backgroundColor = AppColors.colorPrimary
    titleLabel.textColor = AppColors.primaryTextColor
    titleLabel.font = UIFont.systemFontOfSize(15)
    
    worked_timeLabel.textColor = AppColors.primaryTextColor
    worked_timeLabel.font = UIFont.systemFontOfSize(15)
    
    disclosureButton.hidden = true
    disclosureButton.setTitle("统计", forState: .Normal)
    disclosureButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
  }
}

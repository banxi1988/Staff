//
//  ClockRecordCell.swift
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

//-ClockRecordCell(m=ClockRecord):cc
//time[l15,t15,b15](f15,cpt)
//type[r15,y](f13,cst)

class ClockRecordCell : UICollectionViewCell  ,BXBindable {
  let timeLabel = UILabel(frame:CGRectZero)
  let typeLabel = UILabel(frame:CGRectZero)
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  func bind(item:ClockRecord){
    timeLabel.text  = item.clock_time.bx_shortTimeString
    typeLabel.text  = item.recordType.title
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    commonInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  var allOutlets :[UIView]{
    return [timeLabel,typeLabel]
  }
  var allUILabelOutlets :[UILabel]{
    return [timeLabel,typeLabel]
  }
  
  func commonInit(){
    for childView in allOutlets{
      contentView.addSubview(childView)
      childView.translatesAutoresizingMaskIntoConstraints = false
    }
    installConstaints()
    setupAttrs()
    
  }
  
  func installConstaints(){
    
    timeLabel.pa_leading.eq(85).install()
    timeLabel.pa_bottom.eq(8).install()
    
    typeLabel.pa_trailing.eq(15).install()
    typeLabel.pa_centerY.eqTo(timeLabel).install()
    
  }
  
  func setupAttrs(){
    timeLabel.textColor = AppColors.primaryTextColor
    timeLabel.font = UIFont.boldSystemFontOfSize(18)
    typeLabel.textColor = AppColors.secondaryTextColor
    typeLabel.font = UIFont.systemFontOfSize(13)
  }
}

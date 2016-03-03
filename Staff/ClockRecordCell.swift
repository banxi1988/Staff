//
//  ClockRecordCell.swift
//  Staff
//
//  Created by Haizhen Lee on 16/3/1.
//  Copyright © 2016年 banxi1988. All rights reserved.
//

import Foundation

protocol ClockRecordCellDelegate{
  func clockRecordCell(cell:ClockRecordCell,deleteAtIndexPath indexPath:NSIndexPath)
}

// Build for target uimodel
import UIKit
import BXModel
import SwiftyJSON
import BXiOSUtils
import BXForm

//-ClockRecordCell(m=ClockRecord):cc
//time[l15,t15,b15](f15,cpt)
//type[r15,y](f13,cst)

class ClockRecordCell : UICollectionViewCell  ,BXBindable, UIGestureRecognizerDelegate {
  let timeLabel = UILabel(frame:CGRectZero)
  let typeLabel = UILabel(frame:CGRectZero)
  private let topContentView = UIView(frame: CGRectZero)
  private let deleteButton = UIButton(type: .System)
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  var item:ClockRecord?
  var indexPath:NSIndexPath?
  func bind(item:ClockRecord){
    self.item = item
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
      topContentView.addSubview(childView)
      childView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    contentView.addSubview(deleteButton)
    contentView.addSubview(topContentView)
    
    topContentView.translatesAutoresizingMaskIntoConstraints = false
    deleteButton.translatesAutoresizingMaskIntoConstraints = false
    
    installConstaints()
    setupAttrs()
    
  }
  
  func installConstaints(){
    deleteButton.pac_vertical(0)
    deleteButton.pa_width.eq(70).install()
    deleteButton.pa_trailing.eq(0).install()
    topContentView.pac_edge(0, left: 0, bottom: 0, right: 0)
    
    
    timeLabel.pa_leading.eq(85).install()
    timeLabel.pa_bottom.eq(8).install()
    
    typeLabel.pa_trailing.eq(15).install()
    typeLabel.pa_centerY.eqTo(timeLabel).install()
    
  }
  
  func setupAttrs(){
    contentView.backgroundColor = AppColors.grayColor
    deleteButton.backgroundColor = AppColors.redColor
    deleteButton.setTitle("删除", forState: .Normal)
    deleteButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    deleteButton.addTarget(self, action: "onDeleteButtonPressed:", forControlEvents: .TouchUpInside)
    
    
    topContentView.backgroundColor = AppColors.colorBackground
    
    
    timeLabel.textColor = AppColors.primaryTextColor
    timeLabel.font = UIFont.boldSystemFontOfSize(18)
    typeLabel.textColor = AppColors.secondaryTextColor
    typeLabel.font = UIFont.systemFontOfSize(13)
  }
  
  private var lastLocation:CGPoint?
  func handlePanGesture(gesture:UIPanGestureRecognizer){
    let location = gesture.locationInView(contentView)
    switch gesture.state{
    case .Began:
      lastLocation = location
    case .Changed:
      moveToPoint(location)
    case .Ended, .Cancelled:
      moveToPoint(location)
      commitOrRollback()
      
    default:break
    }
  }
  
  func moveToPoint(point:CGPoint){
    guard let prevLoc = lastLocation else {
      lastLocation = point
      return
    }
//    log.verbose("moveFrom: \(prevLoc) to:\(point)")
    let translationX = point.x - prevLoc.x
    let newFrame = topContentView.frame.offsetBy(dx: translationX, dy: 0)
    UIView.animateWithDuration(0.15){
      self.topContentView.frame = newFrame
    }
    lastLocation = point
  }
  
  func commitOrRollback(){
    let offset  = contentView.maxX - topContentView.maxX
    let buttonWidth = deleteButton.width
    
    if offset > buttonWidth * 0.5 {
      UIView.animateWithDuration(0.2){
        self.topContentView.frame.origin.x = -buttonWidth
      }
    }else{
      swipe_rollback()
    }
  }
  
  func swipe_rollback(){
      UIView.animateWithDuration(0.2){
        self.topContentView.frame.origin.x = 0
      }
  }
 
  //MARK: UIGestureRecognizerDelegate
  override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool{
    if let panGesture = gestureRecognizer as? UIPanGestureRecognizer{
      let translation = panGesture.translationInView(self)
      return (translation.x * translation.x > translation.y * translation.y)
    }else{
      return super.gestureRecognizerShouldBegin(gestureRecognizer)
    }
  }
  
  var delegate:ClockRecordCellDelegate?
  
  func onDeleteButtonPressed(sender:AnyObject){
    guard let indexPath = self.indexPath else {
      return
    }
    self.swipe_rollback()
    self.delegate?.clockRecordCell(self, deleteAtIndexPath: indexPath)
  }
  
}

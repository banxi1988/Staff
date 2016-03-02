//
//  ClockRecordEditorViewController.swift
//  Staff
//
//  Created by Haizhen Lee on 16/3/1.
//  Copyright © 2016年 banxi1988. All rights reserved.
//

import Foundation

// Build for target uicontroller
import UIKit
import SwiftyJSON
import BXModel
import BXiOSUtils
import BXForm

//-ClockRecordEditorViewController(m=ClockRecord,sadapter):tvc

class ClockRecordEditorViewController : UITableViewController {
  
  init(){
    super.init(style:.Plain)
  }
  
  override init(style: UITableViewStyle){
    super.init(style:style)
  }
  // must needed for iOS 8
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  var allOutlets :[UIView]{
    return []
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
  }
  
  func setupAttrs(){
  }
  override func loadView(){
    super.loadView()
    self.view.backgroundColor = AppColors.colorBackground
    commonInit()
  }
 
  var typeCell: RightDetailCell = {
     let cell = RightDetailCell()
      cell.textLabel?.text = "打卡类型"
      cell.staticHeight = 50
      return cell
  }()
  
  var timeCell: RightDetailCell = {
    let cell = RightDetailCell()
    cell.textLabel?.text = "打卡时间"
    cell.detailTextLabel?.text = "请选择打卡时间"
    cell.staticHeight = 50
    return cell
  }()
  
 
  var clockRecord:ClockRecord = ClockRecord(type: .On)
  
  let staticAdapter = StaticTableViewAdapter()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title =  clockRecord.id > 0 ? "修改打卡记录" : "新增打卡记录"
    navigationItem.title = title
    
    if clockRecord.id > 0 {
      time  = clockRecord.clock_time
      timeCell.detailTextLabel?.text = clockRecord.clock_time.bx_dateTimeString
    }
    
    staticAdapter.appendContentsOf([typeCell,timeCell])
    staticAdapter.bindTo(tableView)
    
    clearsSelectionOnViewWillAppear = true
    tableView.keyboardDismissMode = .OnDrag
    tableView.tableFooterView = UIView()
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 120
    tableView.separatorStyle = .None
    tableView.separatorColor = AppColors.seperatorLineColor
    
    staticAdapter.didSelectCell = { cell,index in
        self.didTapCell(cell)
    }
    
    let doneButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "trySave:")
    navigationItem.rightBarButtonItem = doneButton
    autobind()
  }
  
  func autobind(){
    bind(clockRecord)
  }
  
  func bind(record:ClockRecord){
    type = record.recordType
    typeCell.detailTextLabel?.text = record.recordType.title
  }
  
  
  func didTapCell(cell:UITableViewCell){
    switch cell{
    case typeCell:
      chooseType()
    case timeCell:
      chooseTime()
    default:break
    }
  }
  
  var type:ClockRecordType?
  var time:NSDate?
  
  func trySave(sender:AnyObject){
    guard let type = self.type else{
      return
    }
    
    guard let date = self.time else{
      return
    }
    
    clockRecord.updateClockTime(date)
    clockRecord.updateType(type)
    if clockRecord.id > 0 {
      ClockRecordService.sharedService.update(clockRecord)
    }else{
      ClockRecordService.sharedService.add(clockRecord)
    }
    
    NSNotificationCenter.defaultCenter().postNotificationName(AppEvents.ClockDataSetChanged, object: nil)
    bx_closeSelf()
  }
  
  func chooseType(){
    let picker = SelectPickerController(options: ClockRecordType.allCases)
    picker.onSelectOption = { option in
      self.type = option
      self.typeCell.detailTextLabel?.text = option.title
    }
    
    presentViewController(picker, animated: true, completion: nil)
  }
  
  func chooseTime(){
    let pickerController = DatePickerController()
    let picker = pickerController.datePicker
    pickerController.date = NSDate()
    picker.minimumDate = NSDate(timeIntervalSinceNow: -3600 * 24 * 10)
    picker.maximumDate = NSDate()
    picker.datePickerMode = .DateAndTime
    pickerController.pickDoneHandler = { date in
      self.time = date
      self.timeCell.detailTextLabel?.text = date.bx_dateTimeString
    }
    presentViewController(pickerController, animated: true, completion: nil)
  }
  
  
}





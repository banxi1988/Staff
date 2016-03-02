//
//  SettingsViewController.swift
//  Staff
//
//  Created by Haizhen Lee on 16/3/2.
//  Copyright © 2016年 banxi1988. All rights reserved.
//

import Foundation

// Build for target uicontroller
import UIKit
import SwiftyJSON
import BXModel
import BXiOSUtils
import BXForm

//-SettingsViewController(sadapter):tvc

class SettingsViewController : UITableViewController {
  
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
  
  
  
  let staticAdapter = StaticTableViewAdapter()
  
  
  lazy var work_durationCell: RightDetailCell = {
    let cell = RightDetailCell()
    cell.textLabel?.text = "上班时长"
    cell.detailTextLabel?.text = "8小时"
    cell.staticHeight = 50
    return cell
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "设置"
    navigationItem.title = title
   
    staticAdapter.bindTo(tableView)
    staticAdapter.appendContentsOf([work_durationCell])
    staticAdapter.didSelectCell = { cell,index in
      self.didTapCell(cell)
    }
    
    clearsSelectionOnViewWillAppear = true
    tableView.keyboardDismissMode = .OnDrag
    tableView.tableFooterView = UIView()
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 120
    tableView.separatorStyle = .None
    tableView.separatorColor = AppColors.seperatorLineColor
    autobind()
  }
  
  func autobind(){
    let  duration = AppUserDefaults.workDuration
     work_durationCell.detailTextLabel?.text = duration.description
  }
  
  
  func didTapCell(cell:UITableViewCell){
    if cell == work_durationCell{
        chooseWorkDuration()
    }
  }
  
  func chooseWorkDuration(){
   let picker = SelectPickerController(options: WorkDuration.presetDurations)
    picker.onSelectOption = { option in
      AppUserDefaults.workDuration = option
      self.autobind()
    }
    presentViewController(picker, animated: true, completion: nil)
  }
  
  
  
  
  
  
  
}

struct WorkDuration{
  let hours:Double
  
  init(hours:Double){
    self.hours = hours
  }
  
  static let presetDurations = [6,6.5,7,7.5,8,8.5,9,9.5,10,10.5,11].map{ WorkDuration(hours: $0) }
}

extension WorkDuration{
  var asSeconds:NSTimeInterval{
    return hours * 60 * 60
  }
}

extension WorkDuration:CustomStringConvertible{
  var description:String{ return "\(hours)个小时" }
}

extension WorkDuration :Equatable{
  
}

func ==(lhs:WorkDuration,rhs:WorkDuration) -> Bool{
  return lhs.hours == rhs.hours
}


extension WorkDuration: Hashable{
  var hashValue:Int { return self.hours.hashValue }
}



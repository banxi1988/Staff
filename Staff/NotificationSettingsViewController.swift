//
//  NotificationSettingsViewController.swift
//  Staff
//
//  Created by Haizhen Lee on 16/3/4.
//  Copyright © 2016年 banxi1988. All rights reserved.
//

import UIKit
import BXModel
import BXForm


class NotificationSettingsViewController:UITableViewController{
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
  
  
  lazy var region_notifyCell: SwitchCell = {
    let cell = SwitchCell()
    cell.textLabel?.text = "基于公司位置的上下班提醒"
    cell.staticHeight = 50
    cell.toggleSwitch.addTarget(self, action: "onRegionNotifySwitchChanged:", forControlEvents: .ValueChanged)
    return cell
  }()
  
  lazy var workedtime_exceedCell: SwitchCell = {
    let cell = SwitchCell()
    cell.textLabel?.text = "到点提醒"
    cell.staticHeight = 50
    cell.toggleSwitch.addTarget(self, action: "onWorkedtimeExceedSwitchChanged:", forControlEvents: .ValueChanged)
    return cell
  }()
  
  
  
  lazy var companyRegion = AppUserDefaults.companyRegion ?? presetCompanyLoc
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "设置"
    navigationItem.title = title
    
    staticAdapter.bindTo(tableView)
    staticAdapter.appendContentsOf([region_notifyCell,workedtime_exceedCell])
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
    region_notifyCell.bind(AppUserDefaults.regionNotifyEnabled)
    workedtime_exceedCell.bind(AppUserDefaults.workedtimeExceedNotifyEnabled)
  }
  
  func onRegionNotifySwitchChanged(sender:AnyObject){
     AppUserDefaults.regionNotifyEnabled = region_notifyCell.toggleSwitch.on
    NSNotificationCenter.defaultCenter().postNotificationName(AppEvents.RegionNotifySwitchChanged, object: self)
  }
 
  func onWorkedtimeExceedSwitchChanged(sender:AnyObject){
      AppUserDefaults.workedtimeExceedNotifyEnabled = workedtime_exceedCell.toggleSwitch.on
    NSNotificationCenter.defaultCenter().postNotificationName(AppEvents.WorkedtimeExceedSwitchChanged, object: self)
  }
  
  func didTapCell(cell:UITableViewCell){
    switch cell{
    case region_notifyCell:break
    case workedtime_exceedCell:break

    default:break
    }
  }
}

extension AppEvents{
  static let WorkedtimeExceedSwitchChanged = "WorkedtimeExceedSwitchChanged"
  static let RegionNotifySwitchChanged = "RegionNotifySwitchChanged"
}
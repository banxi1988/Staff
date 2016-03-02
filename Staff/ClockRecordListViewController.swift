//
//  ClockRecordListViewController.swift
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

//-ClockRecordListViewController(m=ClockRecord,adapter=c):cvc

class ClockRecordListViewController : UICollectionViewController,UICollectionViewDelegateFlowLayout{
  
  init(){
    super.init(collectionViewLayout: UICollectionViewFlowLayout())
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
  
  var flowLayout:UICollectionViewFlowLayout = {
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = CGSize(width: screenWidth - 30, height: 44)
    layout.scrollDirection = .Vertical
    layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    layout.minimumInteritemSpacing = 10
    layout.minimumLineSpacing = 10
    return layout
  }()
  
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
    
    collectionView?.collectionViewLayout = flowLayout
  }
  override func loadView(){
    super.loadView()
    self.view.backgroundColor = AppColors.colorBackground
    self.collectionView?.backgroundColor = AppColors.colorBackground
    commonInit()
  }
  
  struct CellIdentifiers{
    static let recordCell = "record_cell"
    static let firstRecordCell = "first_record_cell"
    
  }
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "打卡记录"
    navigationItem.title = title
    
    collectionView?.registerClass(ClockRecordCell.self, forCellWithReuseIdentifier: CellIdentifiers.recordCell)
    collectionView?.registerClass(FirstRecordCell.self, forCellWithReuseIdentifier: CellIdentifiers.firstRecordCell)
    
    let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addRecord:")
    navigationItem.rightBarButtonItem =  addButton
    
    NSNotificationCenter.defaultCenter().addObserverForName(AppEvents.ClockDataSetChanged, object: nil, queue: nil) { (notif) -> Void in
       self.loadData()
    }
    loadData()
  }
  
  deinit{
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
  var records: [ClockRecord] = []
  
  func loadData(){
    let records = ClockRecordService.sharedService.all()
    setupRecords(records)
    self.records.removeAll()
    self.records.appendContentsOf(records)
    collectionView?.reloadData()
  }
  
  func setupRecords(records:[ClockRecord]){
    let calendar = NSCalendar.currentCalendar()
    var prevDate = NSDate(timeIntervalSinceReferenceDate: 0)
    for r in records{
      if calendar.isDate(r.clock_time, inSameDayAsDate: prevDate){
        continue
      }else{
        r.isFirstRecordOfDay = true
        prevDate = r.clock_time
      }
    }
  }
  
  func addRecord(sender:AnyObject){
    let vc = ClockRecordEditorViewController()
    showViewController(vc, sender: self)
  }
  
 
  // MARK: Helper
  func recordAtIndexPath(indexPath:NSIndexPath) -> ClockRecord{
    return records[indexPath.item]
  }
  
  var numberOfSections:Int{
    return 1
  }
  
  func numberOfItemsInSection(section:Int) -> Int {
    return records.count
  }
  // MARK: DataSource
  
  override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1
  }
  
  override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return records.count
  }
  
  override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let item = recordAtIndexPath(indexPath)
    let identifier = item.isFirstRecordOfDay ? CellIdentifiers.firstRecordCell : CellIdentifiers.recordCell
   let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as! ClockRecordCell
    cell.bind(item)
    
    // swipe
    
    let swipeGestureRecognizer = UIPanGestureRecognizer(target: cell, action: "handlePanGesture:")
    cell.addGestureRecognizer(swipeGestureRecognizer)
    swipeGestureRecognizer.delegate = cell
    collectionView.panGestureRecognizer.requireGestureRecognizerToFail(swipeGestureRecognizer)
    cell.delegate = self
    return cell
  }
  
  
  // MARK: Delegate
 
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
    let item = recordAtIndexPath(indexPath)
    let itemWidth = screenWidth
    let itemHeight:CGFloat = item.isFirstRecordOfDay ? 90:30
    return CGSize(width: itemWidth, height: itemHeight)
  }
  
  
  
  
  
  
}

extension ClockRecordListViewController: ClockRecordCellDelegate{
  func deleteRecord(record:ClockRecord){
    if let index = records.indexOf(record){
      records.removeAtIndex(index)
      ClockRecordService.sharedService.delete(record)
      let indexPath = NSIndexPath(forItem: index, inSection: 0)
      collectionView?.deleteItemsAtIndexPaths([indexPath])
      loadData()
    }
    
  }
  
  
  func clockRecordCell(cell: ClockRecordCell, deleteClockRecord record: ClockRecord) {
    bx_prompt("确定删除这条打卡记录?"){ sure in
      self.deleteRecord(record)
    }
  }
}




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
    static let sectionHeader = "sectionHeader"
    
  }
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "打卡记录"
    navigationItem.title = title
    
    collectionView?.registerClass(ClockRecordCell.self, forCellWithReuseIdentifier: CellIdentifiers.recordCell)
    collectionView?.registerClass(FirstRecordCell.self, forCellWithReuseIdentifier: CellIdentifiers.firstRecordCell)
    collectionView?.registerClass(RecordDateRangeHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: CellIdentifiers.sectionHeader)
    
    let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addRecord:")
    navigationItem.rightBarButtonItem =  addButton
    
    NSNotificationCenter.defaultCenter().addObserverForName(AppEvents.ClockDataSetChanged, object: nil, queue: nil) { [weak self] (notif) -> Void in
      if (notif.object as? NSObject) != self{
         self?.loadData()
      }
    }
    loadData()
  }
  
  deinit{
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
  var recordDateRanges: [RecordDateRange] = []
  
  func loadData(){
    let today = NSDate()
    recordDateRanges.removeAll()
    recordDateRanges.append(RecordDateRange(monthDate: today))
    recordDateRanges.append(RecordDateRange(monthDate: calendar.bx_prevMonthDate(today)))
    collectionView?.reloadData()
    if #available(iOS 9.0, *) {
        flowLayout.sectionHeadersPinToVisibleBounds = true
    }
  }
  

  
  func addRecord(sender:AnyObject){
    let vc = ClockRecordEditorViewController()
    showViewController(vc, sender: self)
  }
  
 
  // MARK: Helper
  func recordDateRangeAtSection(section:Int) -> RecordDateRange{
    return recordDateRanges[section]
  }
  
  func recordsOfSection(section:Int) -> [ClockRecord]{
    return recordDateRangeAtSection(section).records
  }
  
  func recordAtIndexPath(indexPath:NSIndexPath) -> ClockRecord{
    let records = recordsOfSection(indexPath.section)
    return records[indexPath.item]
  }
  
  var numberOfSections:Int{
    return recordDateRanges.count
  }
  
  func numberOfItemsInSection(section:Int) -> Int {
    return recordsOfSection(section).count
  }
  // MARK: DataSource
  
  override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return numberOfSections
  }
  
  override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return numberOfItemsInSection(section)
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
    cell.indexPath = indexPath
    return cell
  }
  
  
  // MARK: Delegate
 
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
    let item = recordAtIndexPath(indexPath)
    let itemWidth = screenWidth
    let itemHeight:CGFloat = item.isFirstRecordOfDay ? 90:30
    return CGSize(width: itemWidth, height: itemHeight)
  }
  
  
  // MARK: Section Header
  override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
    if kind == UICollectionElementKindSectionHeader{
      let header = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: CellIdentifiers.sectionHeader, forIndexPath: indexPath) as! RecordDateRangeHeaderView
      let range = recordDateRangeAtSection(indexPath.section)
      header.bind(range)
      return header
    }else{
      fatalError("Unsupported kind: \(kind)")
    }
  }
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    let width = collectionView.bounds.width
    let height: CGFloat = 36
    return CGSize(width: width, height: height)
  }
  
  
  
  
}

extension ClockRecordListViewController: ClockRecordCellDelegate{
  func deleteRecordAtIndexPath(indexPath:NSIndexPath){
      let record = recordAtIndexPath(indexPath)
      ClockRecordService.sharedService.delete(record)
      let records = recordsOfSection(indexPath.section)
      if let index = records.indexOf(record){
         recordDateRangeAtSection(indexPath.section).records.removeAtIndex(index)
      }
      collectionView?.deleteItemsAtIndexPaths([indexPath])
      collectionView?.reloadData()
      flowLayout.invalidateLayout()
    if numberOfItemsInSection(indexPath.section) == 0{
      loadData()
    }
    NSNotificationCenter.defaultCenter().postNotificationName(AppEvents.ClockDataSetChanged, object: self)
  }
  
 
  func clockRecordCell(cell: ClockRecordCell, deleteAtIndexPath indexPath: NSIndexPath) {
    bx_prompt("确定删除这条打卡记录?"){ sure in
      self.deleteRecordAtIndexPath(indexPath)
    }
  }
}




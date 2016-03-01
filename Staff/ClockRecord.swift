//
//  ClockRecord.swift
//  Staff
//
//  Created by Haizhen Lee on 16/3/1.
//  Copyright © 2016年 banxi1988. All rights reserved.
//

import Foundation

enum ClockRecordType:Int{
  case On = 1
  case Off = 2
  
  var isOn:Bool{
    return self == .On
  }
  
  var isOff: Bool{
    return self == .Off
  }
  
  var typeValue:Int{
    return rawValue
  }
  
  var nextType:ClockRecordType{
    switch self{
    case .On: return .Off
    case .Off: return .On
    }
  }
  
  var title:String{
    switch self{
    case .On: return "上班"
    case .Off: return "下班"
    }
  }
  
  static let allCases :[ ClockRecordType] = [.On,.Off]
}

extension ClockRecordType:CustomStringConvertible{
  var description:String{ return title }
}


import SwiftyJSON
import BXModel
import SQLite
// Model Class Generated from templates
// -ClockRecord
// id:i,created:di,last_modified:di,clock_time:di,type:i,memo,props:j
class ClockRecord:BXModel {
  var id:Int = 0
  let created:NSDate 
  let last_modified:NSDate 
  private(set) var clock_time:NSDate
  private(set) var type:Int
  let memo:String 
  let props:JSON 
  
  required init(json:JSON){
    self.id = json["id"].intValue
    let tmp_created_value = json["created"].doubleValue 
    self.created = NSDate(timeIntervalSince1970: tmp_created_value)
    let tmp_last_modified_value = json["last_modified"].doubleValue 
    self.last_modified = NSDate(timeIntervalSince1970: tmp_last_modified_value)
    let tmp_clock_time_value = json["clock_time"].doubleValue 
    self.clock_time = NSDate(timeIntervalSince1970: tmp_clock_time_value)
    self.type = json["type"].intValue
    self.memo = json["memo"].stringValue
    self.props = json["props"]
  }
  
  func toDict() -> [String:AnyObject]{
    var dict : [String:AnyObject] = [ : ]
    dict["id"] = self.id
    dict["created"] = self.created.timeIntervalSince1970 
    dict["last_modified"] = self.last_modified.timeIntervalSince1970 
    dict["clock_time"] = self.clock_time.timeIntervalSince1970 
    dict["type"] = self.type
    dict["memo"] = self.memo
    dict["props"] = self.props.object
    return dict
  }
  
  typealias Columns = ClockRecordService.Columns
  init(row:Row){
    self.id = row[Columns.id]
    self.created = row[Columns.created]
    self.last_modified = row[Columns.last_modified]
    self.clock_time = row[Columns.clock_time]
    self.type = row[Columns.type]
    self.memo = row[Columns.memo]
    self.props = row[Columns.props]
  }
 
  init(type:ClockRecordType){
    let now = NSDate()
    self.created = now
    self.last_modified = now
    self.clock_time = now
    self.type = type.rawValue
    self.memo = ""
    self.props = JSON.null
  }
  
  func updateType(type:ClockRecordType){
    self.type = type.typeValue
//    ClockRecordService.sharedService.update(self)
  }
  
  func updateClockTime(time:NSDate){
    self.clock_time = time
//    ClockRecordService.sharedService.update(self)
  }
  
  var isFirstRecordOfDay = false
  
}

extension ClockRecord{
  var recordType:ClockRecordType{
    return ClockRecordType(rawValue: type)!
  }
}
    
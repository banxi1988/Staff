//
//  ClockRecordHelper.swift
//  Staff
//
//  Created by Haizhen Lee on 16/3/1.
//  Copyright © 2016年 banxi1988. All rights reserved.
//

import Foundation

struct ClockRecordHelper {
  
  static func clock() -> ClockRecord{
    let lastRecord = ClockRecordService.sharedService.lastRecordInToday()
    let nextType = lastRecord?.recordType.nextType ?? ClockRecordType.On
    let record = ClockRecord(type: nextType)
    ClockRecordService.sharedService.add(record)
    NSNotificationCenter.defaultCenter().postNotificationName(AppEvents.Clocked, object: nil, userInfo: [AppEvents.clockedUserInfoKey:record])
    return record
  }
  
  static func currentClockStatus() -> ClockStatus{
    return clockStatusInDate(NSDate())
  }
  
  static func workedTimeSecondsInDate(date:NSDate) -> NSTimeInterval{
    var records = ClockRecordService.sharedService.recordsInDate(date)
    if records.isEmpty{
      return 0
    }
    if records.count % 2  == 1{
      if calendar.isDateInToday(date){
        let record = ClockRecord(type: .Off)
        records.append(record)
      }else{
        let record = records.last!
        records.append(record)
      }
    }
    
    var total_seconds : NSTimeInterval = 0
    while !records.isEmpty{
      let start = records.removeAtIndex(0)
      let end = records.removeAtIndex(0)
      let seconds = end.clock_time.timeIntervalSince1970 - start.clock_time.timeIntervalSince1970
      total_seconds += seconds
    }
    return total_seconds
  }
  
  static func clockStatusInDate(date:NSDate) -> ClockStatus{
    let total_seconds = workedTimeSecondsInDate(date)
    return ClockStatus(seconds: total_seconds)
  }
  
  
  
  static func clockStatusInRange(range:RecordDateRange) -> ClockStatus{
    var total_seconds : NSTimeInterval = 0
    var calcDate = range.start
    while calcDate.isBefore(range.end){
      total_seconds += workedTimeSecondsInDate(calcDate)
      calcDate = calendar.dateByAddingUnit(.Day, value: 1, toDate: calcDate, options: [])!
    }
    return ClockStatus(seconds: total_seconds)
  }
  
  static func  setupRecords(records:[ClockRecord]){
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
}
//
//  RecordDateRange.swift
//  Staff
//
//  Created by Haizhen Lee on 16/3/3.
//  Copyright © 2016年 banxi1988. All rights reserved.
//

import Foundation

enum DateRangeType{
  case Week
  case Month
}

class RecordDateRange {
  let type:DateRangeType
  let start:NSDate
  let end: NSDate
  
  lazy var days:Int = {
    switch self.type{
    case .Week: return 7
    case .Month: return calendar.rangeOfUnit(.Day, inUnit: .Month, forDate: self.start).length
    }
  }()
  
  
  init(weekDate:NSDate){
    type = .Week
    start = calendar.bx_mondayInWeek(weekDate)
    end = calendar.bx_sundayInWeek(weekDate)
  }
  
  init(monthDate:NSDate){
    type = .Month
    start = calendar.bx_startDateInMonth(monthDate)
    end = calendar.bx_endDateInMonth(monthDate)
  }
  
  lazy var records:[ClockRecord] = {
    let records =  ClockRecordService.sharedService.recordsBetween(self.start, toDate: self.end)
     ClockRecordHelper.setupRecords(records)
    return records
  }()
}

extension RecordDateRange{
  var rangeTitle:String{
    let today = NSDate()
    switch self.type{
    case .Week:
      let currentWeek = calendar.component(.WeekOfYear, fromDate:today)
      let rangeWeek = calendar.component(.WeekOfYear, fromDate: start)
      let diff = currentWeek - rangeWeek
      switch diff{
      case 0 : return "本周"
      case 1:  return "上周"
      default: return "第\(rangeWeek)周"
      }
    case .Month:
      let currentMonth = today.month
       let rangeMonth = start.month
      let diff = currentMonth - rangeMonth
      switch diff{
      case 0: return "本月"
      default: return "\(rangeMonth)月"
      }
        
    }
  }
}
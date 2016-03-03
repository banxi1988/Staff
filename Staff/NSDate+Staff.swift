//
//  NSDate+Staff.swift
//  Staff
//
//  Created by Haizhen Lee on 16/3/1.
//  Copyright © 2016年 banxi1988. All rights reserved.
//

import Foundation

private let weekday_chars  = "日一二三四五六".characters.map{String($0)}
extension NSDate{
  var zhStandaloneWeekday:String{
      return weekday_chars[weekday-1]
  }
  
  var zhShortWeekday:String{
    return "周\(zhStandaloneWeekday)"
  }
  
  var zhLongWeekday:String{
    return "星期\(zhStandaloneWeekday)"
  }
}

extension NSCalendar{
  func bx_startDateInMonth(date:NSDate) -> NSDate{
    let comps = components([.Year,.Month,.Day], fromDate: date)
    comps.day = 1
    comps.hour = 0
    return dateFromComponents(comps)!
  }
  
  func bx_endDateInMonth(date:NSDate) -> NSDate{
    let comps = components([.Year,.Month,.Day], fromDate: date)
    let maxDay = rangeOfUnit(.Day, inUnit: .Month, forDate: date).length
    comps.day = maxDay
    comps.hour = 24
    return dateFromComponents(comps)!
  }
  
  func bx_endDayOfDate(date:NSDate) -> NSDate{
    let comps = components([.Year,.Month,.Day], fromDate: date)
    comps.hour = 24
    return dateFromComponents(comps)!
  }
  
  func bx_mondayInWeek(date:NSDate) -> NSDate{
    let comps = components([.Year,.WeekOfYear,.Weekday], fromDate: date)
    comps.weekday = 2 // monday
    return dateFromComponents(comps)!
  }
  
  func bx_sundayInWeek(date:NSDate, mondayAsFirstDay : Bool = true) -> NSDate{
    let comps = components([.Year,.WeekOfYear,.Weekday], fromDate: date)
    comps.weekday = 1 // monday
    if mondayAsFirstDay{
      comps.weekOfYear = comps.weekOfYear + 1
    }
    comps.hour = 24
    return dateFromComponents(comps)!
  }

  func bx_nextMonthDate(date:NSDate) -> NSDate{
    return calendar.dateByAddingUnit(.Month, value: 1, toDate: date, options: [])!
  }
  
  func bx_prevMonthDate(date:NSDate) -> NSDate{
    return calendar.dateByAddingUnit(.Month, value: -1, toDate: date, options: [])!
  }

  
  
}
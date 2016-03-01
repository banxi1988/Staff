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
      return weekday_chars[weekday]
  }
  
  var zhShortWeekday:String{
    return "周\(zhStandaloneWeekday)"
  }
  
  var zhLongWeekday:String{
    return "星期\(zhStandaloneWeekday)"
  }
}
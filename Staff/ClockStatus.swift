//
//  ClockStatus.swift
//  Staff
//
//  Created by Haizhen Lee on 16/3/1.
//  Copyright © 2016年 banxi1988. All rights reserved.
//

import Foundation
import UIKit

let calendar = NSCalendar.currentCalendar()

struct ClockStatus{
  let worked_seconds:NSTimeInterval
  let workTimeIntevalStandard = AppUserDefaults.workDuration.asSeconds
  
  init(seconds:NSTimeInterval){
    self.worked_seconds = seconds
  }
  
  var progress:Double {
    let p = worked_seconds / NSTimeInterval(3600 * 12)
    return min(p,1.0)
  }
  
  var worked_time:String{ return friendlyTimeDuration(worked_seconds) }
  
  var need_time:String{
    if worked_seconds >= workTimeIntevalStandard{
      return "0"
    }else{
      return friendlyTimeDuration(workTimeIntevalStandard - worked_seconds)
    }
  }
  
  var need_time_seconds:NSTimeInterval{
    return workTimeIntevalStandard - worked_seconds
  }
  
  var off_time:String{
    if worked_seconds >= workTimeIntevalStandard{
      return "到点了"
    }else{
      let need_seconds = workTimeIntevalStandard - worked_seconds
      let date = NSDate(timeIntervalSinceNow: need_seconds)
      if calendar.isDateInToday(date){
        return date.bx_shortTimeString
      }else if calendar.isDateInTomorrow(date){
        return "明天:\(date.bx_shortTimeString)"
      }else{
        return date.bx_dateTimeString
      }
    }
  }
}

extension ClockStatus{
  
  var worked_time_label:String{ return  "已经工作" }
  var worked_time_text:String{
    return worked_time
  }
  
  var need_time_label:String { return "还需工作" }
  
  var need_time_text: String{
     return need_time
  }
  
  var off_time_label:String{ return "下班时间" }
  
  var off_time_text:String{
    return "\(off_time)"
  }
}

func friendlyTimeDuration(interval:NSTimeInterval) -> String{
  let seconds = Int64(interval)
  
  switch seconds{
  case 0..<60: return "\(seconds) 秒"
  case 60..<3600:
    let minutes = seconds / 60
    let secs = seconds % 60
    if secs == 0{
      return "\(minutes) 分钟"
    }else{
      return "\(minutes) 分钟"
    }
  default:
     let hours = seconds / 3600
    let minutes = (seconds % 3600) / 60
     let minutesStr = String(format: "%02d", minutes)
     if minutes == 0{
        return "\(hours) 小时"
     }else{
        return "\(hours):\(minutesStr)"
     }
  }
  
}
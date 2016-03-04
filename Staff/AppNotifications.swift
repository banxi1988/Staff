//
//  AppNotifications.swift
//  Staff
//
//  Created by Haizhen Lee on 16/3/4.
//  Copyright © 2016年 banxi1988. All rights reserved.
//

import Foundation
import UIKit

struct AppNotifications{
  static let WorkedTimeExceedNotificationIdentifier = "WorkedTimeExceedNotification"
  static func notifyWorkedTimeExceed(afterSeconds:NSTimeInterval){
    if afterSeconds < 0{
      return
    }
    removeExpiredWorkedTimeExceedNotification()
    if !AppUserDefaults.workedtimeExceedNotifyEnabled{
      return
    }
    let notif = UILocalNotification()
     let fireDate = NSDate(timeIntervalSinceNow: afterSeconds)
    notif.fireDate = fireDate
    if #available(iOS 8.2, *) {
        notif.alertTitle = "到点提醒"
    }
    notif.alertBody = "恭喜,已经超过规定的工作时间,可以准备下班了"
    notif.soundName = UILocalNotificationDefaultSoundName
    notif.userInfo = [WorkedTimeExceedNotificationIdentifier:true]
    app.scheduleLocalNotification(notif)
  }
  
  private static func removeExpiredWorkedTimeExceedNotification(){
    guard let notifications = app.scheduledLocalNotifications else {
      return
    }
    for notif in notifications{
      if let found = notif.userInfo?[WorkedTimeExceedNotificationIdentifier] as? Bool where found{
       app.cancelLocalNotification(notif)
      }
    }
  }
}
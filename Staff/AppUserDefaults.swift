//
//  AppUserDefaults.swift
//  Staff
//
//  Created by Haizhen Lee on 16/3/2.
//  Copyright © 2016年 banxi1988. All rights reserved.
//

import Foundation

// Build for target settings
//-AppUserDefaults(sync_on_save=true,prefix=staff)
//workDuration:f

class AppUserDefaults:NSObject {
    struct Keys{
        static let workDuration = "staff_workDuration"
    }

    static let  userDefaults = NSUserDefaults.standardUserDefaults()
    static var workDuration:WorkDuration{
        set{
            userDefaults.setDouble(newValue.hours,forKey:Keys.workDuration)
            userDefaults.synchronize()
        }get{
            let hours =  userDefaults.doubleForKey(Keys.workDuration)
          return WorkDuration(hours: hours)
        }
    }
  
  static func registerDefaults(){
    userDefaults.registerDefaults([Keys.workDuration:8])
  }
}
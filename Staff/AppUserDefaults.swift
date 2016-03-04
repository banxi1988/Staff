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
        static let companyRegion = "company_region"
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


import CoreLocation

extension AppUserDefaults{
  static var companyRegion: CLCircularRegion?{
    set{
      if let region = newValue{
        let data = NSKeyedArchiver.archivedDataWithRootObject(region)
        userDefaults.setObject(data, forKey: Keys.companyRegion)
      }else{
        userDefaults.removeObjectForKey(Keys.companyRegion)
      }
      userDefaults.synchronize()
    }get{
      guard let data = userDefaults.objectForKey(Keys.companyRegion) as? NSData else{
        return nil
      }
      
      let region = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? CLCircularRegion
      return region
    }
    
  }
}
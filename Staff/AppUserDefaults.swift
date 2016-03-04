//
//  AppUserDefaults.swift
//  Staff
//
//  Created by Haizhen Lee on 16/3/2.
//  Copyright © 2016年 banxi1988. All rights reserved.
//

import Foundation

// Build for target settings
// Build for target settings
//-AppUserDefaults(sync_on_save=true,prefix=staff)
//regionNotifyEnabled:b
//workedtimeExceedNotifyEnabled:b


struct Keys{
      static let workDuration = "staff_workDuration"
      static let companyRegion = "staff_company_region"
}

class AppUserDefaults:NSObject {


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
    userDefaults.registerDefaults([
      Keys.workDuration:8,
      Keys.workedtimeExceedNotifyEnabled:true,
      Keys.regionNotifyEnabled: true
      ])
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

extension Keys{
  static let regionNotifyEnabled = "staff_regionNotifyEnabled"
  static let workedtimeExceedNotifyEnabled = "staff_workedtimeExceedNotifyEnabled"
}
extension AppUserDefaults {
  static var regionNotifyEnabled:Bool{
    set{
    userDefaults.setBool(newValue,forKey:Keys.regionNotifyEnabled)
    userDefaults.synchronize()
    }get{
      return userDefaults.boolForKey(Keys.regionNotifyEnabled)
    }
  }
  static var workedtimeExceedNotifyEnabled:Bool{
    set{
    userDefaults.setBool(newValue,forKey:Keys.workedtimeExceedNotifyEnabled)
    userDefaults.synchronize()
    }get{
      return userDefaults.boolForKey(Keys.workedtimeExceedNotifyEnabled)
    }
  }
}
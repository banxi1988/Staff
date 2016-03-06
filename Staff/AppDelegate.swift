//
//  AppDelegate.swift
//  Staff
//
//  Created by Haizhen Lee on 16/2/29.
//  Copyright © 2016年 banxi1988. All rights reserved.
//

import UIKit
import BXiOSUtils
import SwiftyBeaver

let log = SwiftyBeaver.self
let Images = UIImage.Asset.self

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?



  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    // Override point for customization after application launch.
    window = UIWindow(frame: UIScreen.mainScreen().bounds)
    setupLog()
    setUpAppearanceProxy()
    AppUserDefaults.registerDefaults()
    setupLocalNotification()
    start()
    return true
  }
  func start(){
    log.debug("start")
    window?.rootViewController = startEntry()
    window?.makeKeyAndVisible()
    log.debug("makeKeyAndVisible Down")
  }
  
  func startEntry() -> UIViewController{
    #if DEBUG
//      return currentDebugEntry()
      #endif
    let vc = MainViewController()
    return UINavigationController(rootViewController: vc)
  }
  
  func currentDebugEntry() -> UIViewController{
//    let vc = CompanyGeoRegionPickerViewController()
//    let vc = SettingsViewController()
    let vc = ArtClockViewController()
    return UINavigationController(rootViewController: vc)
  }
  
  func setupLocalNotification(){
    let app = UIApplication.sharedApplication()
    let settings = UIUserNotificationSettings(forTypes: [.Sound,.Alert,.Badge], categories: nil)
    app.registerUserNotificationSettings(settings)
    app.cancelAllLocalNotifications()
  }
  
  func setupLog(){
    let file = FileDestination()  // log to default swiftybeaver.log file
    
    #if DEBUG
      // add log destinations. at least one is needed!
      let console = ConsoleDestination()  // log to Xcode Console
      log.addDestination(console)
      file.minLevel = .Debug
    #else
      file.minLevel = .Info
    #endif
    log.addDestination(file)
    
  }
  
  func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
    log.info("notification:\(notification)")
  }


  func applicationWillResignActive(application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }


}




//
//  CompanyGeoRegionPickerViewController.swift
//  Staff
//
//  Created by Haizhen Lee on 16/3/4.
//  Copyright © 2016年 banxi1988. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

// Build for target uicontroller
import UIKit
import SwiftyJSON
import BXModel
import BXiOSUtils
import BXForm

//-CompanyGeoRegionPickerViewController:vc
//map[hor0,t0,b0]:v

class CompanyGeoRegionPickerViewController : UIViewController {
  let mapView = MKMapView(frame:CGRectZero)
  convenience init(){
    self.init(nibName: nil, bundle: nil)
  }
  // must needed for iOS 8
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  var allOutlets :[UIView]{
    return [mapView]
  }
  var allUIViewOutlets :[UIView]{
    return [mapView]
  }
  
  func commonInit(){
    for childView in allOutlets{
      self.view.addSubview(childView)
      childView.translatesAutoresizingMaskIntoConstraints = false
    }
    installConstaints()
    setupAttrs()
  }
  
  func installConstaints(){
    mapView.pa_above(self.bottomLayoutGuide).offset(0).install()
    mapView.pac_horizontal(0)
    mapView.pa_below(self.topLayoutGuide).offset(0).install()
  }
  
  func setupAttrs(){
    
    // MAP
    mapView.delegate = self
    mapView.showsUserLocation = true
    mapView.showsBuildings = true
    
  }
  override func loadView(){
    super.loadView()
    self.view.backgroundColor = AppColors.colorBackground
    commonInit()
  }
  
  
  let companyAnnotation = CompanyLocationAnnotation()
 
  let locManager = CLLocationManager()
  lazy var  companyRegion = AppUserDefaults.companyRegion ?? presetCompanyLoc
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "请选择公司位置"
    navigationItem.title = title
 
    let cancelButton = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "onCancelButtonPressed:")
    navigationItem.leftBarButtonItem = cancelButton
    
    let doneButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "onDoneButtonPressed:")
    navigationItem.rightBarButtonItem = doneButton
    
    setupInitialCompanyRegion()
    
    locManager.delegate = self
    locManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    locManager.distanceFilter = 10
    
    let status = CLLocationManager.authorizationStatus()
    if status != CLAuthorizationStatus.AuthorizedAlways{
      locManager.requestAlwaysAuthorization()
    }else{
      
    }
    
    
    
  }
  
  func onCancelButtonPressed(sender:AnyObject){
    bx_closeSelf()
  }
 
  func onDoneButtonPressed(sender:AnyObject){
    let region = mapView.region
    let newRegion = CLCircularRegion(center: region.center, radius: 36, identifier: RegionIdentifiers.company)
    AppUserDefaults.companyRegion = newRegion
    NSNotificationCenter.defaultCenter().postNotificationName(AppEvents.CompanyRegionChanged, object: nil)
    bx_closeSelf()
  }

  // MAP
  var isFirstRegion = true
  var companyLocationView:MKPinAnnotationView?
  
}

extension CompanyGeoRegionPickerViewController: CLLocationManagerDelegate{
  
  func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
    log.info("currentAuthStatus: \(status.rawValue)")
    
    mapView.showsUserLocation = status == .AuthorizedAlways
    if status == CLAuthorizationStatus.AuthorizedAlways{
    }
  }
  
  func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
    log.info("newLocation:\(newLocation)")
  }
  
  func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
    log.error("error:\(error)")
  }
  
  
}

class CompanyLocationAnnotation:MKPointAnnotation{
  static let identifier = "compnayLoc"
}


extension CompanyGeoRegionPickerViewController: MKMapViewDelegate{
  //MARK: Map Utils
  func setupInitialCompanyRegion(){
    let region = companyRegion
    companyAnnotation.coordinate = region.center
    mapView.addAnnotation(companyAnnotation)
    
    let mapRegion = MKCoordinateRegionMakeWithDistance(region.center, 200, 200)
    mapView.setRegion(mapRegion, animated: true)
  }
  
  func zoomToUserLocation(location:MKUserLocation){
    guard let loc = location.location else{
      return
    }
    let center = loc.coordinate
    let span = MKCoordinateSpanMake(0.01, 0.01)
    let region = MKCoordinateRegionMake(center, span)
    mapView.setRegion(region, animated: true)
    
  }
  
  
  func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
    log.info("userLocation:\(userLocation)")
//    zoomToUserLocation(userLocation)
  }
  
  func mapView(mapView: MKMapView, didFailToLocateUserWithError error: NSError) {
    log.error("error:\(error)")
    bx_confirm("定位失败"){}
  }
  
  func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
    log.debug("annotation:\(annotation)")
    if annotation is MKUserLocation{
      return nil
    }
    if annotation is CompanyLocationAnnotation{
      
      if let pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(CompanyLocationAnnotation.identifier) as? MKPinAnnotationView{
        pinView.annotation = annotation
        companyLocationView = pinView
      }else{
        let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: CompanyLocationAnnotation.identifier)
        pinView.draggable = false
        pinView.animatesDrop = true
        pinView.pinColor = MKPinAnnotationColor.Red
        pinView.canShowCallout = false
        companyLocationView = pinView
      }
      return companyLocationView
    }
    
    return nil
  }
 
  func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
    log.debug("currentRegion:\(mapView.region)")
    if isFirstRegion{
      isFirstRegion = false
      return
    }
    let region = mapView.region
    self.companyAnnotation.coordinate = region.center
    self.companyLocationView?.center = mapView.center
  }
  
}




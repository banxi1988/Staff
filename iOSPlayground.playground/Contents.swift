//: Playground - noun: a place where people can play

import UIKit
import CoreLocation

var str = "Hello, playground"

struct RegionIdentifiers{
  static let company = "company"
}

let companyLoc = CLCircularRegion(center: CLLocationCoordinate2D(latitude: 22.840974, longitude: 108.258372), radius: 36, identifier: RegionIdentifiers.company)

//
//  Helpers.swift
//  Pods
//
//  Created by Haizhen Lee on 15/11/10.
//
//

import Foundation

internal func simpleClassName(type:Any) -> String{
    let fullName = "\(type)"
    return fullName.componentsSeparatedByString(".").last!
}
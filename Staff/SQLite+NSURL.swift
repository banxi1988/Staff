//
//  SQLite+NSURL.swift
//  Pods
//
//  Created by Haizhen Lee on 16/3/1.
//
//

import Foundation
import SQLite

extension NSURL: SQLite.Value{
  public static var declaredDatatype: String {
    return String.declaredDatatype
  }
  
  public static func fromDatatypeValue(stringValue: String) -> NSURL {
    return NSURL(string:stringValue)!
  }
  
  public var datatypeValue: String {
    return self.absoluteString
  }
}

public extension QueryType{
  public subscript(column: Expression<NSURL>) -> Expression<NSURL> {
    return namespace(column)
  }
  public subscript(column: Expression<NSURL?>) -> Expression<NSURL?> {
    return namespace(column)
  }
}

public extension Row{
  public subscript(column: Expression<NSURL>) -> NSURL {
    return get(column)
  }
  public subscript(column: Expression<NSURL?>) -> NSURL? {
    return get(column)
  }
}
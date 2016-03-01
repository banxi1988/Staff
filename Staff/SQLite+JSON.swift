import SQLite
import SwiftyJSON

extension JSON: SQLite.Value{
  public static var declaredDatatype: String {
    return String.declaredDatatype
  }
  
  public static func fromDatatypeValue(stringValue: String) -> JSON {
    return JSON.parse(stringValue)
  }
  
  public var datatypeValue: String {
    return self.rawString(NSUTF8StringEncoding, options: [])!
  }
}

public extension QueryType{
  public subscript(column: Expression<JSON>) -> Expression<JSON> {
    return namespace(column)
  }
  public subscript(column: Expression<JSON?>) -> Expression<JSON?> {
    return namespace(column)
  }
}

public extension Row{
  public subscript(column: Expression<JSON>) -> JSON {
    return get(column)
  }
  public subscript(column: Expression<JSON?>) -> JSON? {
    return get(column)
  }
}
//
//  ClockRecordService.swift
//  Staff
//
//  Created by Haizhen Lee on 16/3/1.
//  Copyright © 2016年 banxi1988. All rights reserved.
//

import Foundation

// Build for target sqlite_model
//-ClockRecord
//id:i;created:d;last_modified:d;clock_time:d;type:i;memo;props:j
import SQLite
import SwiftyJSON
import BXiOSUtils


extension ClockRecord{

}
private let db = try! Connection("\(bx_documentPath())/db.sqlite3")

private let clockRecordService = ClockRecordService()

class ClockRecordService{
  struct Columns  {
    static let id = Expression<Int>("id")
    static let created = Expression<NSDate>("created")
    static let last_modified = Expression<NSDate>("last_modified")
    static let clock_time = Expression<NSDate>("clock_time")
    static let type = Expression<Int>("type")
    static let memo = Expression<String>("memo")
    static let props = Expression<JSON>("props")
  }
  
  let t_ClockRecord = Table("clockRecord")
  static var sharedService:ClockRecordService{ return clockRecordService }
  private init(){
    let stmt =  t_ClockRecord.create(ifNotExists:true){ t in
      t.column(Columns.id, primaryKey:.Autoincrement)
      t.column(Columns.created)
      t.column(Columns.last_modified)
      t.column(Columns.clock_time)
      t.column(Columns.type)
      t.column(Columns.memo)
      t.column(Columns.props)
    }
    try! db.run(stmt)
  }
  
  func query(queryType:QueryType) -> [ClockRecord]{
    var list = [ClockRecord]()
    for row in try! db.prepare(queryType.order(Columns.id.desc)) {
      let obj = ClockRecord(row:row)
      list.append(obj)
    }
    return list
  }
  
  func all() -> [ClockRecord]{
    return query(t_ClockRecord)
  }
  
  func add(obj:ClockRecord){
    do{
      let stmt = t_ClockRecord.insert(or: .Replace,
        Columns.created <- obj.created,
        Columns.last_modified <- obj.last_modified,
        Columns.clock_time <- obj.clock_time,
        Columns.type <- obj.type,
        Columns.memo <- obj.memo,
        Columns.props <- obj.props
      )
      let rowId = try db.run(stmt)
      obj.id = Int(rowId)
      log.debug("Insert success:\(rowId)")
    }catch {
      log.error("Insert failed:\(obj))")
    }
  }
  
  func update(obj:ClockRecord) -> Bool{
    do{
      let stmt = t_ClockRecord.filter(Columns.id == obj.id).update(
        Columns.created <- obj.created,
        Columns.last_modified <- NSDate(),
        Columns.clock_time <- obj.clock_time,
        Columns.type <- obj.type,
        Columns.memo <- obj.memo,
        Columns.props <- obj.props
      )
      let count = try db.run(stmt)
      log.debug("Update success:\(count)")
      return count > 0
    }catch {
      log.error("Update failed:\(obj))")
      return false
    }
  }
  
  
  func delete(obj:ClockRecord) -> Bool{
    do{
      let stmt = t_ClockRecord.filter(Columns.id == obj.id).delete()
      if try db.run(stmt) > 0 {
        return true
      }
    }catch{
      log.error("Delete failed \(obj) error:\(error))")
    }
    return false
  }
  
  func deleteAll() -> Bool{
    do{
      let stmt = t_ClockRecord.delete()
      if try db.run(stmt) > 0 {
        return true
      }
    }catch{
      log.error("Delete All Failed:\(error))")
    }
    return false
  }
  
}

extension ClockRecordService{
  
  func recordsInDate(date:NSDate) -> [ClockRecord]{
    let calendar = NSCalendar.currentCalendar()
    return all().filter{ calendar.isDate($0.clock_time, inSameDayAsDate: date) }.sort{ (l,r) -> Bool in
      return l.clock_time.isBefore(r.clock_time)
    }

  }
  
  func recordsInToday() -> [ClockRecord]{
    return recordsInDate(NSDate())
  }
  
  func lastRecordInToday() -> ClockRecord?{
    return recordsInToday().last
  }
}
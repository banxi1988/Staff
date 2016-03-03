//
//  SQLite+NSDate.swift
//  Staff
//
//  Created by Haizhen Lee on 16/3/3.
//  Copyright © 2016年 banxi1988. All rights reserved.
//

import Foundation
import SQLite

extension String{
  @warn_unused_result func quote(mark: Character = "\"") -> String {
    let escaped = characters.reduce("") { string, character in
      string + (character == mark ? "\(mark)\(mark)" : "\(character)")
    }
    return "\(mark)\(escaped)\(mark)"
  }
  
  @warn_unused_result func join(expressions: [Expressible]) -> Expressible {
    var (template, bindings) = ([String](), [Binding?]())
    for expressible in expressions {
      let expression = expressible.expression
      template.append(expression.template)
      bindings.appendContentsOf(expression.bindings)
    }
    return Expression<Void>(template.joinWithSeparator(self), bindings)
  }
  
  @warn_unused_result func wrap<T>(expression: Expressible) -> Expression<T> {
    return Expression("\(self)(\(expression.expression.template))", expression.expression.bindings)
  }
  @warn_unused_result func infix<T>(lhs: Expressible, _ rhs: Expressible, wrap: Bool = true) -> Expression<T> {
    let expression = Expression<T>(" \(self) ".join([lhs, rhs]).expression)
    guard wrap else {
      return expression
    }
    return "".wrap(expression)
  }
  

}


extension ExpressionType where UnderlyingType == NSDate{
  @warn_unused_result
  public func between(fromDate:NSDate,toDate date:NSDate) -> Expression<Bool>{
      return Expression("\(template) BETWEEN ? AND ?",bindings + [fromDate.datatypeValue,date.datatypeValue])
  }
  
  @warn_unused_result
  public func inDay(day:NSDate) -> Expression<Bool>{
    let exp1:Expression<String> = "date".wrap(self)
    let exp2: Expression<String> = "date".wrap(day)
     return "=".infix(exp1,exp2)
  }
}
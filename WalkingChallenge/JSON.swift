/**
 * Copyright © 2017 Aga Khan Foundation
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 *    this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 *
 * 3. The name of the author may not be used to endorse or promote products
 *    derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR "AS IS" AND ANY EXPRESS OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
 * EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
 * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 **/

import Foundation

enum JSON {
case array([JSON])
case dictionary([String: JSON])
case null
case number(Float)
case string(String)
}

extension JSON {
  public init?(_ value: Any) {
    if let string = value as? String {
      if string.lowercased() == "null" {
        self = .null
        return
      }
      self = .string(string)
      return
    }
    if let number = value as? NSNumber {
      self = .number(Float(truncating: number))
      return
    }
    if let dictionary = value as? [String: Any] {
      var object: [String:JSON] = [:]                                           // swiftlint:disable:this colon
      for (key, value) in dictionary {
        object[key] = JSON(value)
      }
      self = .dictionary(object)
      return
    }
    if let array = value as? [Any] {
      self = .array(array.compactMap({ JSON($0) }))
      return
    }
    return nil
  }
}

extension JSON {
  public var arrayValue: [JSON]? {
    switch self {
    case .array(let value):
      return value
    default:
      return nil
    }
  }

  public var boolVaue: Bool? {
    switch self {
    case .number(let value):
      return value != 0
    case .string(let value):
      if value.lowercased() == "true" {
        return true
      }
      if value.lowercased() == "false" {
        return false
      }
      fallthrough
    default:
      return nil
    }
  }

  public var dictionaryValue: [String:JSON]? {                                  // swiftlint:disable:this colon
    switch self {
    case .dictionary(let value):
      return value
    default:
      return nil
    }
  }

  public var floatValue: Float? {
    switch self {
    case .number(let value):
      return value
    default:
      return nil
    }
  }

  public var intValue: Int? {
    switch self {
    case .number(let value):
      return Int(value)
    default:
      return nil
    }
  }

  public var stringValue: String? {
    switch self {
    case .string(let value):
      return value
    default:
      return nil
    }
  }

  public var isNil: Bool {
    switch self {
    case .null:
      return true
    default:
      return false
    }
  }
}

extension JSON {
  public subscript(_ key: String) -> JSON? {
    switch self {
    case .dictionary(let dictionary):
      if let value: JSON = dictionary[key] {
        return value
      }
      fallthrough
    default:
      return nil
    }
  }

  public subscript(_ index: Int) -> JSON? {
    switch self {
    case .array(let array):
      if let value: JSON = array[safe: index] {
        return value
      }
      fallthrough
    default:
      return nil
    }
  }
}

extension JSON: CustomStringConvertible {
  public var description: String {
    switch self {
    case .array(let array):
      return "[\(String(describing: array))]"
    case .dictionary(let dictionary):
      var repr: String = ""
      var comma: Bool = false

      repr.append("{")
      for (key, value) in dictionary {
        if comma {
          repr.append(",")
        } else {
          comma = true
        }
        repr.append("\"\(key)\":\(value)")
      }
      repr.append("}")

      return repr
    case .null:
      return "null"
    case .number(let number):
      let formatter: NumberFormatter = NumberFormatter()
      formatter.numberStyle = .decimal
      formatter.minimumFractionDigits = 0
      return formatter.string(from: NSNumber(value: number)) ?? ""
    case .string(let string):
      return "\"\(string)\""
    }
  }
}

extension JSON {
  static func deserialise(_ data: Data) -> JSON? {
    do {
      let deserialised =
          try JSONSerialization.jsonObject(with: data,
                                           options: [JSONSerialization.ReadingOptions.allowFragments])
      return JSON(deserialised)
    } catch {
      print("unable to read JSON payload `\(String(data: data, encoding: .utf8)!)`: \(error.localizedDescription)")
    }
    return nil
  }

  static func deserialise(_ data: String) -> JSON? {
    guard let json = data.data(using: .utf8) else { return nil }
    return deserialise(json)
  }

  private var foundationTyped: Any? {
    switch self {
    case .array(let array):
      return array.compactMap({ $0.foundationTyped })
    case .dictionary(let dictionary):
      var dict: [String:Any] = [:]                                              // swiftlint:disable:this colon
      for (key, value) in dictionary {
        dict[key] = value.foundationTyped
      }
      return dict
    case .null:
      return nil
    case .number(let number):
      return NSNumber(value: number)
    case .string(let string):
      return String(string)
    }
  }

  func serialise() -> Data? {
    do {
      if let value = self.foundationTyped {
        return try JSONSerialization.data(withJSONObject: value, options: [])
      }
    } catch {
      print("unable to write JSON payload `\(self)`: \(error.localizedDescription)")
    }
    return nil
  }
}

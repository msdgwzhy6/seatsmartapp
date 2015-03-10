import Foundation

public class JSONDecoder {
    var value: AnyObject?
    
    public var description: String {
        return self.print()
    }
    
    public var string: String? {
        return value as? String
    }
    
    public var integer: Int? {
        return value as? Int
    }
    
    public var unsigned: UInt? {
        return value as? UInt
    }
    
    public var double: Double? {
        return value as? Double
    }
    
    public var float: Float? {
        return value as? Float
    }
    
    public var bool: Bool {
        if let str = self.string {
            let lower = str.lowercaseString
            if lower == "true" || lower.toInt() > 0 {
                return true
            }
        } else if let num = self.integer {
            return num > 0
        } else if let num = self.double {
            return num > 0.99
        } else if let num = self.float {
            return num > 0.99
        }
        return false
    }
    
    public var error: NSError? {
        return value as? NSError
    }
    
    public var dictionary: Dictionary<String,JSONDecoder>? {
        return value as? Dictionary<String,JSONDecoder>
    }
    
    public var array: Array<JSONDecoder>? {
        return value as? Array<JSONDecoder>
    }
    
    public func getArray<T>(inout collect: Array<T>?) {
        if let array = value as? Array<JSONDecoder> {
            if collect == nil {
                collect = Array<T>()
            }
            for decoder in array {
                if let obj = decoder.value as? T {
                    collect?.append(obj)
                }
            }
        }
    }
    
    public func getDictionary<T>(inout collect: Dictionary<String,T>?) {
        if let dictionary = value as? Dictionary<String,JSONDecoder> {
            if collect == nil {
                collect = Dictionary<String,T>()
            }
            for (key,decoder) in dictionary {
                if let obj = decoder.value as? T {
                    collect?[key] = obj
                }
            }
        }
    }
    
    public init(_ raw: AnyObject) {
        var rawObject: AnyObject = raw
        if let data = rawObject as? NSData {
            var error: NSError?
            var response: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(), error: &error)
            if error != nil || response == nil {
                value = error
                return
            }
            rawObject = response!
        }
        if let array = rawObject as? NSArray {
            var collect = [JSONDecoder]()
            for val: AnyObject in array {
                collect.append(JSONDecoder(val))
            }
            value = collect
        } else if let dict = rawObject as? NSDictionary {
            var collect = Dictionary<String,JSONDecoder>()
            for (key,val: AnyObject) in dict {
                collect[key as String] = JSONDecoder(val)
            }
            value = collect
        } else {
            value = rawObject
        }
    }
    
    public subscript(index: Int) -> JSONDecoder {
        get {
            if let array = self.value as? NSArray {
                if array.count > index {
                    return array[index] as JSONDecoder
                }
            }
            return JSONDecoder(createError("index: \(index) is greater than array or this is not an Array type."))
        }
    }
    
    public subscript(key: String) -> JSONDecoder {
        get {
            if let dict = self.value as? NSDictionary {
                if let value: AnyObject = dict[key] {
                    return value as JSONDecoder
                }
            }
            return JSONDecoder(createError("key: \(key) does not exist or this is not a Dictionary type"))
        }
    }
    
    public func print() -> String {
        if let arr = self.array {
            var str = "["
            for decoder in arr {
                str += decoder.print() + ","
            }
            str.removeAtIndex(advance(str.endIndex, -1))
            return str + "]"
        } else if let dict = self.dictionary {
            var str = "{"
            for (key, decoder) in dict {
                str += "\"\(key)\": \(decoder.print()),"
            }
            str.removeAtIndex(advance(str.endIndex, -1))
            return str + "}"
        }
        if value != nil {
            if let str = self.string {
                return "\"\(value!)\""
            }
            return "\(value!)"
        }
        return ""
    }
    
    func createError(text: String) -> NSError {
        return NSError(domain: "JSONDecoder", code: 1002, userInfo: [NSLocalizedDescriptionKey: text]);
    }
}
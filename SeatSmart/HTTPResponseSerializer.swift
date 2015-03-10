import Foundation

public protocol HTTPResponseSerializer {
    func responseObjectFromResponse(response: NSURLResponse, data: NSData) -> (object: AnyObject?, error: NSError?)
}

public struct JSONResponseSerializer : HTTPResponseSerializer {
    public init(){}
    public func responseObjectFromResponse(response: NSURLResponse, data: NSData) -> (object: AnyObject?, error: NSError?) {
        var error: NSError?
        let response: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(), error: &error)
        return (response,error)
    }
}
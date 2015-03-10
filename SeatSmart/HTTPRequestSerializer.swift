import Foundation


extension String {
    var escaped: String {
        return CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,self,"[].",":/?&=;+!@#$()',*",CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding))
    }
}

public class HTTPRequestSerializer: NSObject {
    let contentTypeKey = "Content-Type"
    
    public var headers = Dictionary<String,String>()
    public var stringEncoding: UInt = NSUTF8StringEncoding
    public var allowsCellularAccess = true
    public var HTTPShouldHandleCookies = true
    public var HTTPShouldUsePipelining = false
    public var timeoutInterval: NSTimeInterval = 60
    public var cachePolicy: NSURLRequestCachePolicy = NSURLRequestCachePolicy.UseProtocolCachePolicy
    public var networkServiceType = NSURLRequestNetworkServiceType.NetworkServiceTypeDefault
    
    public override init() {
        super.init()
    }
    
    func newRequest(url: NSURL, method: HTTPMethod) -> NSMutableURLRequest {
        var request = NSMutableURLRequest(URL: url, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
        request.HTTPMethod = method.rawValue
        request.cachePolicy = self.cachePolicy
        request.timeoutInterval = self.timeoutInterval
        request.allowsCellularAccess = self.allowsCellularAccess
        request.HTTPShouldHandleCookies = self.HTTPShouldHandleCookies
        request.HTTPShouldUsePipelining = self.HTTPShouldUsePipelining
        request.networkServiceType = self.networkServiceType
        for (key,val) in self.headers {
            request.addValue(val, forHTTPHeaderField: key)
        }
        return request
    }
    
    func createRequest(url: NSURL, method: HTTPMethod, parameters: Dictionary<String,AnyObject>?) -> (request: NSURLRequest, error: NSError?) {
        
        var request = newRequest(url, method: method)
        var isMulti = false

        if let params = parameters {
            isMulti = isMultiForm(params)
        }
        if isMulti {
            if(method != .POST && method != .PUT) {
                request.HTTPMethod = HTTPMethod.POST.rawValue
            }
            var boundary = "Boundary+\(arc4random())\(arc4random())"
            if parameters != nil {
                request.HTTPBody = dataFromParameters(parameters!,boundary: boundary)
            }
            if request.valueForHTTPHeaderField(contentTypeKey) == nil {
                request.setValue("multipart/form-data; boundary=\(boundary)",
                    forHTTPHeaderField:contentTypeKey)
            }
            return (request,nil)
        }
        var queryString = ""
        if parameters != nil {
            queryString = self.stringFromParameters(parameters!)
        }
        if isURIParam(method) {
            var para = (request.URL!.query != nil) ? "&" : "?"
            var newUrl = "\(request.URL!.absoluteString!)"
            if countElements(queryString) > 0 {
                newUrl += "\(para)\(queryString)"
            }
            request.URL = NSURL(string: newUrl)
        } else {
            var charset = CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(self.stringEncoding));
            if request.valueForHTTPHeaderField(contentTypeKey) == nil {
                request.setValue("application/x-www-form-urlencoded; charset=\(charset)",
                    forHTTPHeaderField:contentTypeKey)
            }
            request.HTTPBody = queryString.dataUsingEncoding(self.stringEncoding)
        }
        return (request,nil)
    }
    
    func isMultiForm(params: Dictionary<String,AnyObject>) -> Bool {
        for (name,object: AnyObject) in params {
            if object is HTTPUpload {
                return true
            } else if let subParams = object as? Dictionary<String,AnyObject> {
                if isMultiForm(subParams) {
                    return true
                }
            }
        }
        return false
    }
    
    func stringFromParameters(parameters: Dictionary<String,AnyObject>) -> String {
        return join("&", map(serializeObject(parameters, key: nil), {(pair) in
            return pair.stringValue()
        }))
    }
    
    func isURIParam(method: HTTPMethod) -> Bool {
        if(method == .GET || method == .HEAD || method == .DELETE) {
            return true
        }
        return false
    }
    
    func serializeObject(object: AnyObject,key: String?) -> Array<HTTPPair> {
        var collect = Array<HTTPPair>()
        if let array = object as? Array<AnyObject> {
            for nestedValue : AnyObject in array {
                collect.extend(self.serializeObject(nestedValue,key: "\(key!)[]"))
            }
        } else if let dict = object as? Dictionary<String,AnyObject> {
            for (nestedKey, nestedObject: AnyObject) in dict {
                var newKey = key != nil ? "\(key!)[\(nestedKey)]" : nestedKey
                collect.extend(self.serializeObject(nestedObject,key: newKey))
            }
        } else {
            collect.append(HTTPPair(value: object, key: key))
        }
        return collect
    }
    
    func dataFromParameters(parameters: Dictionary<String,AnyObject>,boundary: String) -> NSData {
        var mutData = NSMutableData()
        var multiCRLF = "\r\n"
        var boundSplit =  "\(multiCRLF)--\(boundary)\(multiCRLF)".dataUsingEncoding(self.stringEncoding)!
        var lastBound =  "\(multiCRLF)--\(boundary)--\(multiCRLF)".dataUsingEncoding(self.stringEncoding)!
        mutData.appendData("--\(boundary)\(multiCRLF)".dataUsingEncoding(self.stringEncoding)!)
        
        let pairs = serializeObject(parameters, key: nil)
        let count = pairs.count-1
        var i = 0
        for pair in pairs {
            var append = true
            if let upload = pair.getUpload() {
                if let data = upload.data {
                    mutData.appendData(multiFormHeader(pair.key, fileName: upload.fileName,
                        type: upload.mimeType, multiCRLF: multiCRLF).dataUsingEncoding(self.stringEncoding)!)
                    mutData.appendData(data)
                } else {
                    append = false
                }
            } else {
                let str = "\(self.multiFormHeader(pair.key, fileName: nil, type: nil, multiCRLF: multiCRLF))\(pair.getValue())"
                mutData.appendData(str.dataUsingEncoding(self.stringEncoding)!)
            }
            if append {
                if i == count {
                    mutData.appendData(lastBound)
                } else {
                    mutData.appendData(boundSplit)
                }
            }
            i++
        }
        return mutData
    }
    
    func multiFormHeader(name: String, fileName: String?, type: String?, multiCRLF: String) -> String {
        var str = "Content-Disposition: form-data; name=\"\(name.escaped)\""
        if fileName != nil {
            str += "; filename=\"\(fileName!)\""
        }
        str += multiCRLF
        if type != nil {
            str += "Content-Type: \(type!)\(multiCRLF)"
        }
        str += multiCRLF
        return str
    }
    
    class HTTPPair: NSObject {
        var value: AnyObject
        var key: String!
        
        init(value: AnyObject, key: String?) {
            self.value = value
            self.key = key
        }
        
        func getUpload() -> HTTPUpload? {
            return self.value as? HTTPUpload
        }
        
        func getValue() -> String {
            var val = ""
            if let str = self.value as? String {
                val = str
            } else if self.value.description != nil {
                val = self.value.description
            }
            return val
        }
        
        func stringValue() -> String {
            var val = getValue()
            if self.key == nil {
                return val.escaped
            }
            return "\(self.key.escaped)=\(val.escaped)"
        }
        
    }
    
}

public class JSONRequestSerializer: HTTPRequestSerializer {
    
    public override func createRequest(url: NSURL, method: HTTPMethod, parameters: Dictionary<String,AnyObject>?) -> (request: NSURLRequest, error: NSError?) {
        if self.isURIParam(method) {
            return super.createRequest(url, method: method, parameters: parameters)
        }
        var request = newRequest(url, method: method)
        var error: NSError?
        if parameters != nil {
            var charset = CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
            request.setValue("application/json; charset=\(charset)", forHTTPHeaderField: self.contentTypeKey)
            request.HTTPBody = NSJSONSerialization.dataWithJSONObject(parameters!, options: NSJSONWritingOptions(), error:&error)
        }
        return (request, error)
    }
    
}
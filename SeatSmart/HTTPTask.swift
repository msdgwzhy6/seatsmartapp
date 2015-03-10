import Foundation

public enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case HEAD = "HEAD"
    case DELETE = "DELETE"
}

public class HTTPResponse {
    public var headers: Dictionary<String,String>?
    public var mimeType: String?
    public var suggestedFilename: String?
    public var responseObject: AnyObject?
    public var statusCode: Int?
    public func text() -> String? {
        if let d = self.responseObject as? NSData {
            return  NSString(data: d, encoding: NSUTF8StringEncoding)
        }
        return nil
    }
    public var URL: NSURL?
}

class BackgroundBlocks {
    var success:((HTTPResponse) -> Void)?
    var failure:((NSError, HTTPResponse?) -> Void)?
    var progress:((Double) -> Void)?
    
    init(_ success: ((HTTPResponse) -> Void)?, _ failure: ((NSError, HTTPResponse?) -> Void)?,_ progress: ((Double) -> Void)?) {
        self.failure = failure
        self.success = success
        self.progress = progress
    }
}

public class HTTPOperation : NSOperation {
    private var task: NSURLSessionDataTask!
    private var stopped = false
    private var running = false
    
    public var done = false
    
    override public var asynchronous: Bool {
        return false
    }
    
    override public var cancelled: Bool {
        return stopped
    }
    
    override public var executing: Bool {
        return running
    }
    
    override public var finished: Bool {
        return done
    }

    override public var ready: Bool {
        return !running
    }
    
    override public func start() {
        super.start()
        stopped = false
        running = true
        done = false
        task.resume()
    }
    
    override public func cancel() {
        super.cancel()
        running = false
        stopped = true
        done = true
        task.cancel()
    }
    
    public func finish() {
        self.willChangeValueForKey("isExecuting")
        self.willChangeValueForKey("isFinished")
        
        running = false
        done = true
        
        self.didChangeValueForKey("isExecuting")
        self.didChangeValueForKey("isFinished")
    }
}

public class HTTPTask : NSObject, NSURLSessionDelegate, NSURLSessionTaskDelegate {
    var backgroundTaskMap = Dictionary<String,BackgroundBlocks>()
    
    public var baseURL: String?
    public var requestSerializer = HTTPRequestSerializer()
    public var responseSerializer: HTTPResponseSerializer?

    public var auth:((NSURLAuthenticationChallenge) -> NSURLCredential?)?
    
    public override init() {
        super.init()
    }
    
    public func create(url: String, method: HTTPMethod, parameters: Dictionary<String,AnyObject>!, success:((HTTPResponse) -> Void)!, failure:((NSError, HTTPResponse?) -> Void)!) ->  HTTPOperation? {
        
        let serialReq = createRequest(url, method: method, parameters: parameters)
        if serialReq.error != nil {
            if failure != nil {
                failure(serialReq.error!, nil)
            }
            return nil
        }
        let opt = HTTPOperation()
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config, delegate: self, delegateQueue: nil)
        let task = session.dataTaskWithRequest(serialReq.request,
            completionHandler: {(data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
                opt.finish()
                if error != nil {
                    if failure != nil {
                        failure(error, nil)
                    }
                    return
                }
                if data != nil {
                    var responseObject: AnyObject = data
                    if self.responseSerializer != nil {
                        let resObj = self.responseSerializer!.responseObjectFromResponse(response, data: data)
                        if resObj.error != nil {
                            if failure != nil {
                                failure(resObj.error!, nil)
                            }
                            return
                        }
                        if resObj.object != nil {
                            responseObject = resObj.object!
                        }
                    }
                    var extraResponse = HTTPResponse()
                    if let hresponse = response as? NSHTTPURLResponse {
                        extraResponse.headers = hresponse.allHeaderFields as? Dictionary<String,String>
                        extraResponse.mimeType = hresponse.MIMEType
                        extraResponse.suggestedFilename = hresponse.suggestedFilename
                        extraResponse.statusCode = hresponse.statusCode
                        extraResponse.URL = hresponse.URL
                    }
                    extraResponse.responseObject = responseObject
                    if extraResponse.statusCode > 299 {
                        if failure != nil {
                            failure(self.createError(extraResponse.statusCode!), extraResponse)
                        }
                    } else if success != nil {
                        success(extraResponse)
                    }
                } else if failure != nil {
                    failure(error, nil)
                }
        })
        opt.task = task
        return opt
    }
    
    public func GET(url: String, parameters: Dictionary<String,AnyObject>?, success:((HTTPResponse) -> Void)!, failure:((NSError, HTTPResponse?) -> Void)!) {
        var opt = self.create(url, method:.GET, parameters: parameters,success,failure)
        if opt != nil {
            opt!.start()
        }
    }
    
    public func POST(url: String, parameters: Dictionary<String,AnyObject>?, success:((HTTPResponse) -> Void)!, failure:((NSError, HTTPResponse?) -> Void)!) {
        var opt = self.create(url, method:.POST, parameters: parameters,success,failure)
        if opt != nil {
            opt!.start()
        }
    }
    
    public func PUT(url: String, parameters: Dictionary<String,AnyObject>?, success:((HTTPResponse) -> Void)!, failure:((NSError, HTTPResponse?) -> Void)!) {
        var opt = self.create(url, method:.PUT, parameters: parameters,success,failure)
        if opt != nil {
            opt!.start()
        }
    }
    
    public func DELETE(url: String, parameters: Dictionary<String,AnyObject>?, success:((HTTPResponse) -> Void)!, failure:((NSError, HTTPResponse?) -> Void)!)  {
        var opt = self.create(url, method:.DELETE, parameters: parameters,success,failure)
        if opt != nil {
            opt!.start()
        }
    }
    
    public func HEAD(url: String, parameters: Dictionary<String,AnyObject>?, success:((HTTPResponse) -> Void)!, failure:((NSError, HTTPResponse?) -> Void)!) {
        var opt = self.create(url, method:.HEAD, parameters: parameters,success,failure)
        if opt != nil {
            opt!.start()
        }
    }
    
    public func download(url: String, parameters: Dictionary<String,AnyObject>?,progress:((Double) -> Void)!, success:((HTTPResponse) -> Void)!, failure:((NSError, HTTPResponse?) -> Void)!) -> NSURLSessionDownloadTask? {
        let serialReq = createRequest(url,method: .GET, parameters: parameters)
        if serialReq.error != nil {
            failure(serialReq.error!, nil)
            return nil
        }
        let ident = createBackgroundIdent()
        let config = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier(ident)
        let session = NSURLSession(configuration: config, delegate: self, delegateQueue: nil)
        let task = session.downloadTaskWithRequest(serialReq.request)
        self.backgroundTaskMap[ident] = BackgroundBlocks(success,failure,progress)

        task.resume()
        return task
    }
    
    //MARK: Private Methods

    private func createRequest(url: String, method: HTTPMethod, parameters: Dictionary<String,AnyObject>!) -> (request: NSURLRequest, error: NSError?) {
        var urlVal = url
        //probably should change the 'http' to something more generic
        if !url.hasPrefix("http") && self.baseURL != nil {
            var split = url.hasPrefix("/") ? "" : "/"
            urlVal = "\(self.baseURL!)\(split)\(url)"
        }
        if let u = NSURL(string: urlVal) {
            return self.requestSerializer.createRequest(u, method: method, parameters: parameters)
        }
        return (NSURLRequest(),createError(-1001))
    }
    
    private func createBackgroundIdent() -> String {
        let letters = "abcdefghijklmnopqurstuvwxyz"
        var str = ""
        for var i = 0; i < 14; i++ {
            let start = Int(arc4random() % 14)
            str.append(letters[advance(letters.startIndex,start)])
        }
        return "com.vluxe.swifthttp.request.\(str)"
    }
    
    private func createError(code: Int) -> NSError {
        var text = "An error occured"
        if code == 404 {
            text = "Page not found"
        } else if code == 401 {
            text = "Access denied"
        } else if code == -1001 {
            text = "Invalid URL"
        }
        return NSError(domain: "HTTPTask", code: code, userInfo: [NSLocalizedDescriptionKey: text])
    }
    
    private func cleanupBackground(identifier: String) {
        self.backgroundTaskMap.removeValueForKey(identifier)
    }
    
    //MARK: NSURLSession Delegate Methods
    
    /// Method for authentication challenge.
    public func URLSession(session: NSURLSession, task: NSURLSessionTask, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential!) -> Void) {
        if let a = auth {
            let cred = a(challenge)
            if let c = cred {
                completionHandler(.UseCredential, c)
                return
            }
            completionHandler(.RejectProtectionSpace, nil)
            return
        }
        completionHandler(.PerformDefaultHandling, nil)
    }
    
    /// Called when the background task failed.
    func URLSession(session: NSURLSession!, task: NSURLSessionTask!, didCompleteWithError error: NSError!) {
        if error != nil {
            let blocks = self.backgroundTaskMap[session.configuration.identifier]
            if blocks?.failure != nil { //Swift bug. Can't use && with block (radar: 17469794)
                blocks?.failure!(error, nil)
                cleanupBackground(session.configuration.identifier)
            }
        }
    }
    
    /// The background download finished and reports the url the data was saved to.
    func URLSession(session: NSURLSession!, downloadTask: NSURLSessionDownloadTask!, didFinishDownloadingToURL location: NSURL!) {
        let blocks = self.backgroundTaskMap[session.configuration.identifier]
        if blocks?.success != nil {
            var resp = HTTPResponse()
            if let hresponse = downloadTask.response as? NSHTTPURLResponse {
                resp.headers = hresponse.allHeaderFields as? Dictionary<String,String>
                resp.mimeType = hresponse.MIMEType
                resp.suggestedFilename = hresponse.suggestedFilename
                resp.statusCode = hresponse.statusCode
                resp.URL = hresponse.URL
            }
            resp.responseObject = location
            if resp.statusCode > 299 {
                if blocks?.failure != nil {
                    blocks?.failure!(self.createError(resp.statusCode!), resp)
                }
                return
            }
            blocks?.success!(resp)
            cleanupBackground(session.configuration.identifier)
        }
    }
    
    /// Will report progress of background download
    func URLSession(session: NSURLSession!, downloadTask: NSURLSessionDownloadTask!, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let increment = 100.0/Double(totalBytesExpectedToWrite)
        var current = (increment*Double(totalBytesWritten))*0.01
        if current > 1 {
            current = 1;
        }
        let blocks = self.backgroundTaskMap[session.configuration.identifier]
        if blocks?.progress != nil {
            blocks?.progress!(current)
        }
    }
    
    /// The background download finished, don't have to really do anything.
    func URLSessionDidFinishEventsForBackgroundURLSession(session: NSURLSession!) {
    }
    
}
import Foundation

#if os(iOS)
    import MobileCoreServices
#endif

public class HTTPUpload: NSObject {
    var fileUrl: NSURL? {
        didSet {
            updateMimeType()
            loadData()
        }
    }
    var mimeType: String?
    var data: NSData?
    var fileName: String?
    
    func updateMimeType() {
        if mimeType == nil && fileUrl != nil {
            var UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, fileUrl?.pathExtension as NSString?, nil);
            var str = UTTypeCopyPreferredTagWithClass(UTI.takeUnretainedValue(), kUTTagClassMIMEType);
            if (str == nil) {
                mimeType = "application/octet-stream";
            } else {
                mimeType = str.takeUnretainedValue() as NSString
            }
        }
    }
    
    func loadData() {
        if let url = fileUrl {
            self.fileName = url.lastPathComponent
            self.data = NSData.dataWithContentsOfMappedFile(url.path!) as? NSData
        }
    }
    
    public override init() {
        super.init()
    }
    
    public convenience init(fileUrl: NSURL) {
        self.init()
        self.fileUrl = fileUrl
        updateMimeType()
        loadData()
    }
    
    public convenience init(data: NSData, fileName: String, mimeType: String) {
        self.init()
        self.data = data
        self.fileName = fileName
        self.mimeType = mimeType
    }
}
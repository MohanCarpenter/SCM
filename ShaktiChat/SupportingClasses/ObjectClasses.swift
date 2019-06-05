//
//  ObjectClasses.swift
//  ShaktiChat
//
//  Created by mac on 24/10/17.
//  Copyright © 2017 himanshuPal_kavya. All rights reserved.
//

import UIKit


public struct chatRangId {
    public static let chatMaxId: String = "chatMaxId"
    public static let chatMinId: String = "chatMinId"
}

public struct chatingType {
    public static let group: String = "group"
    public static let individual: String = "individual"
    public static let brodcast: String = "brodcast"
    
}

extension ChatMohanViewController: CachingPlayerItemDelegate {
    
    func playerItem(_ playerItem: CachingPlayerItem, didFinishDownloadingData data: Data) {
        print("File is downloaded and ready for storing")
    }
    
    func playerItem(_ playerItem: CachingPlayerItem, didDownloadBytesSoFar bytesDownloaded: Int, outOf bytesExpected: Int) {
        print("\(bytesDownloaded)/\(bytesExpected)")
    }
    
    func playerItemPlaybackStalled(_ playerItem: CachingPlayerItem) {
        print("Not enough data for playback. Probably because of the poor network. Wait a bit and try to play later.")
    }
    
    func playerItem(_ playerItem: CachingPlayerItem, downloadingFailedWith error: Error) {
        print(error)
    }
    
}
func generateBoundaryString() -> String {
    return "Boundary-\(NSUUID().uuidString)"
}
class groupcontactClass : NSObject {
    var groupName = ""
    var groupNo = ""
    var badgeCount = 0
    var created_by = ""
    var group_id = ""
    var group_type = ""
    var maContacts:NSMutableArray? = nil
    var timeInterval = 0

}

class groupdetailClass  : NSObject {
    var btrtl = ""
    var btrtlTxt = ""
    var category = ""
    var ename = ""
    var groupNo = ""
    var pernr = ""
    var telnr = ""
    var group_id = ""
    var pic = ""
}

class ContactClass  : NSObject {
    var btrtlTxt = ""
    var category = ""
    var name = ""
    var pernr10 = ""
    var telnr = ""
    var pic = ""
    var pk_user_id = ""
    var xmpp_id = ""
    var pernr = ""
    var badgeCount = 0
    var check = false
    var timeInterval = 0

}


class contactName : NSObject{
    static let messagecontact = "messagecontact"
    static let groupcontact = "groupcontact"
}

extension Date {
    func daysBetweenDate(toDate: Date) -> Int {
        let components = Calendar.current.dateComponents([.day], from: self, to: toDate)
        return components.day ?? 0
    }
    func hourBetweenDate(toDate: Date) -> Int {
        let components = Calendar.current.dateComponents([.hour], from: self, to: toDate)

        return components.hour ?? 0
    }

}

func stringDecode(_ s: String) -> String? {
    if let str :String  =  s as? String{
        if let data = str.data(using: .utf8) {
            return String(data: data, encoding: .nonLossyASCII)
        }
    }
    return "\(s)"
}
func stringEncode(_ s: String) -> String {
    if let data = s.data(using: .nonLossyASCII, allowLossyConversion: true) {
        return String(data: data, encoding: .utf8)!
    }else {
        return s
    }
}
func dateFormateToGate(format:String)->String {
    let formatter = DateFormatter()
    formatter.dateFormat = format // "yyyy-mm-dd hh:mm:ss"
    return "\(formatter.string(from: Date()))"
}
func stringToDate(_ strDate:String) -> Date {
    // "MMMM dd, yyyy"
    let formatter = DateFormatter()
    formatter.dateFormat = "MMMM dd, yyyy" // "yyyy-mm-dd hh:mm:ss"
    if let date1 = formatter.date(from: strDate) {
        return date1//"\(formatter.string(from: Date()))"
    }else {
        return Date()
    }
    
    
}




/*
 extension String {
 func height(withConstrainedWidth width: CGFloat) -> CGFloat {
 let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
 let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: 12], context: nil)
 
 return ceil(boundingBox.height)
 }
 
 func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
 let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
 let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
 
 return ceil(boundingBox.width)
 }
 }
 */



class topicClass : NSObject{
    var id = ""
    var topic = ""
}

func converDictToJson(dict: Any) -> String{
    
    var jsonData = NSData()
    var strTest111 = ""
    do {
        jsonData = try JSONSerialization.data(withJSONObject: dict, options: []) as NSData
        // here "jsonData" is the dictionary encoded in JSON data
        strTest111 = String(data: jsonData as Data, encoding: String.Encoding.utf8)!
        //   print("strTest111 ------>",strTest111)
        return strTest111
    } catch let error as NSError {
        print(error)
    }
    return ""
}
extension Data {
    var formatMohan: String {
        let array = [UInt8](self)
        //        print("ext --",array)
        let ext: String
        switch (array[0]) {
        case 0xFF:
            ext = "jpg"
        case 0x89:
            ext = "png"
        case 0x47:
            ext = "gif"
        case 0x49, 0x4D :
            ext = "tiff"
        default:
            ext = "unknown"
        }
        return ext
    }
}

extension String {
    func removeCategory(){
        
    }
}


class Downloader {
    class func load(URL: String, completionHandler: @escaping (Data?) -> Swift.Void) {
        let URL = NSURL(string: URL)
        let sessionConfig = URLSessionConfiguration.default
        //      let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        let request = NSMutableURLRequest(url: URL! as URL)
        request.httpMethod = "GET"
        
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            if error != nil {
                print("error=\(error)")
                completionHandler(nil)
                return
            }
            
            // You can print out response object
            if response?.mimeType != nil {
                print("******* response = \(response) --mimeType -----\(response?.mimeType)")
                
            }
            
            // Print out reponse body
            completionHandler(data)
            
            //            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            //            print("****** response data = \(responseString!)")
            
        }
        
        task.resume()
    }
}

public func hour12To24(time:String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "h:mm a"
    
    if let dt = dateFormatter.date(from: time) {
        dateFormatter.dateFormat = "H:mm:ss"
        return dateFormatter.string(from: dt)
    }else {
        print("")
    }
    
    return time
}




public func localToUTCTime(date:String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "h:mm a"
    dateFormatter.calendar = NSCalendar.current
    dateFormatter.timeZone = TimeZone.current
    
    if let dt = dateFormatter.date(from: date) {
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "H:mm:ss"
        return dateFormatter.string(from: dt)
    }else {
        print("")
    }
    return date
}

public func UTCToLocalTime(date:String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "H:mm:ss"
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    
    if let dt = dateFormatter.date(from: date) {
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from: dt)
        
    }else {
        print("")
    }
    return date
    
}

func saveDetail() {
    
}


extension String {
    func chopPrefix(_ count: Int = 1) -> String {
        return substring(from: index(startIndex, offsetBy: count))
    }
    
    func chopSuffix(_ count: Int = 1) -> String {
        return substring(to: index(endIndex, offsetBy: -count))
    }
    
    
}



extension UIImage {
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
}




import UIKit // For using UIImage

// 1. Type Enum
/**
 Enum specifing the type
 
 - Mine:     Chat message is outgoing
 - Opponent: Chat message is incoming
 */
enum BubbleDataType: Int{
    case Mine = 0
    case Opponent
}

/// DataModel for maintaining the message data for a single chat bubble
class ChatBubbleData {
    
    // 2.Properties
    var text: String?
    var image: UIImage?
    var date: NSDate?
    var type: BubbleDataType
    
    // 3. Initialization
    init(text: String?,image: UIImage?,date: NSDate? , type:BubbleDataType = .Mine) {
        // Default type is Mine
        self.text = text
        self.image = image
        self.date = date
        self.type = type
    }
}

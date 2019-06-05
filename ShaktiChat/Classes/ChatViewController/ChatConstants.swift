//
//  ChatConstants.swift
//  Aquantuo
//
//  Created by Rajat on 2/18/16.
//  Copyright © 2016 Rajat. All rights reserved.
//

import UIKit

class ChatConstants: NSObject {
    let senderMsg = "msg"
    let senderId = "id"
//    let senderName = "name"
//    let senderImg = "image"
    
    let senderName = "fromName"
    let senderImg = "fromImage"
    
    // for aquanto
    let senderFromName = "name"//"fromName"
    let senderFromImage = "image"//"fromImage"
     // testing  "@shakti.techinventions.in"//
    let chatHostName = "@shakti.techinventions.in" //  "@shaktipumps.co.in"
    let loginHostServerName = "shakti.techinventions.in"// "shaktipumps.co.in"
    let loginHostServerPort: UInt16 = 5223
    let chatInfo = "User chat information is not available."
    let chatConnection = "Please wait while we are connecting to server."
    
 //     let unreadedMessages = "UnreadedPrivateMessages"
    func chatPlaceHolderText() -> String {
        return "New Message"
    }
    
    /*func chatSendButtonText() -> String {
        let language = strLang
        if language == "En" {
            return "Send"
        } else {
            return "Invia"
        }
    }
    
    func newChatMessageFrom() -> String {
        let language = strLang
        if language == "En" {
            return "You have new message(s) from "
        } else {
            //return "Hai un nuovo messaggio/Hai dei nuovi messaggi da "
            return "Hai un nuovo messaggio da "
        }
    }
 
    func newChatMessage() -> String {
        let language = strLang
        if language == "En" {
            return "You have new message(s)"
        } else {
            //return "Hai un nuovo messaggio/Hai dei nuovi messaggi"
            return "Hai un nuovo messaggio"
        }
    }*/
    
  /*  func checkObjectInDictionaryHoney(dictH: NSDictionary, strObject: String) -> String {
        var strHoney: String = ""
        if !(dictH.object(forKey: strObject) is NSNull) && dictH.object(forKey: strObject) != nil {
            if (dictH.object(forKey: strObject) as? NSNumber != nil) {
                let numH = dictH.object(forKey: strObject) as? NSNumber
                let floatH = numH?.floatValue
                strHoney = NSString(format: "%.0f", floatH!) as String
            } else if (dictH.object(forKey: strObject) as? String != nil){
                strHoney = dictH.object(forKey: strObject) as! String
            }
        }
        return strHoney
    }
    
    func addUnreadedMessage(myId: String, otherUserId: String) {
        let defaults = UserDefaults.standard
        var unreadedMsgCount: Int = 0
        var dict = NSMutableDictionary()
        //let strKey: String = "myId" + myId.stringByReplacingOccurrencesOfString(ChatConstants().chatHostName, withString: "") + "otherUserId" + otherUserId.stringByReplacingOccurrencesOfString(ChatConstants().chatHostName, withString: "")
        
        let strKey: String = "myId\(myId.replacingOccurrences(of: ChatConstants().chatHostName, with: ""))otherUserId\(otherUserId.replacingOccurrences(of: ChatConstants().chatHostName, with: ""))"
        
        if defaults.object(forKey: unreadedMessages) != nil {
            let dictTemp = defaults.object(forKey: unreadedMessages) as? NSMutableDictionary
            if (dictTemp != nil) {
                if dictTemp!.count > 0 {
                    dict = dictTemp!.mutableCopy() as! NSMutableDictionary
                    if self.checkObjectInDictionaryHoney(dictH: dictTemp!, strObject: strKey) != "" {
                        let count = (dictTemp!.object(forKey: strKey)! as AnyObject).integerValue
                        unreadedMsgCount = count! + 1
                    } else {
                        unreadedMsgCount += 1
                    }
                } else {
                    unreadedMsgCount += 1
                }
            } else {
                unreadedMsgCount += 1
            }
        } else {
            unreadedMsgCount += 1
        }
        
        dict.setObject(unreadedMsgCount, forKey: strKey as NSCopying)
        defaults.set(dict, forKey: unreadedMessages)
    }
    
    func removeUnreadedMessage(myId: String, otherUserId: String) {
        let defaults = UserDefaults.standard
        var dict = NSMutableDictionary()
        //let strKey: String = "myId" + myId.stringByReplacingOccurrencesOfString(ChatConstants().chatHostName, withString: "") + "otherUserId" + otherUserId.stringByReplacingOccurrencesOfString(ChatConstants().chatHostName, withString: "")
        let strKey: String = "myId\(myId.replacingOccurrences(of: ChatConstants().chatHostName, with: ""))otherUserId\(otherUserId.replacingOccurrences(of: ChatConstants().chatHostName, with: ""))"
        
        if defaults.object(forKey: unreadedMessages) != nil {
            let dictTemp = defaults.object(forKey: unreadedMessages) as? NSMutableDictionary
            if (dictTemp != nil) {
                if dictTemp!.count > 0 {
                    dict = dictTemp!.mutableCopy() as! NSMutableDictionary
                    if !(dict.object(forKey: strKey) is NSNull) && dict.object(forKey: strKey) != nil {
                        dict.removeObject(forKey: strKey)
                    }
                }
            }
        }
        defaults.set(dict, forKey: unreadedMessages)
    }
    
    func getUnreadedMessage(myId: String, otherUserId: String) -> String {
        let defaults = UserDefaults.standard
        //        let strKey: String = "myId" + myId.stringByReplacingOccurrencesOfString(ChatConstants().chatHostName, withString: "") + "otherUserId" + otherUserId.stringByReplacingOccurrencesOfString(ChatConstants().chatHostName, withString: "")
        let strKey: String = "myId\(myId.replacingOccurrences(of: ChatConstants().chatHostName, with: ""))otherUserId\(otherUserId.replacingOccurrences(of: ChatConstants().chatHostName, with: ""))"
        if defaults.object(forKey: unreadedMessages) != nil {
            let dictTemp = defaults.object(forKey: unreadedMessages) as? NSMutableDictionary
            if (dictTemp != nil) {
                if dictTemp!.count > 0 {
                    if self.checkObjectInDictionaryHoney(dictH: dictTemp!, strObject: strKey) != "" {
                        let count = (dictTemp!.object(forKey: strKey)! as AnyObject).integerValue
                        return "\(count!)"
                    }
                }
            }
        }
        return "0"
    }
    
    func getTotalNumberOfUnreadedMessages() -> String {
        let defaults = UserDefaults.standard
        var count = 0
        if defaults.object(forKey: unreadedMessages) != nil {
            let dictTemp = defaults.object(forKey: unreadedMessages) as? NSMutableDictionary
            if (dictTemp != nil) {
                if dictTemp!.count > 0 {
                    let arrKeys = dictTemp!.allKeys as! [String]
                    for key in arrKeys {
                        let countTemp = (dictTemp!.object(forKey: key)! as AnyObject).integerValue
                        count = count + countTemp!
                    }
                }
            }
        }
        return "\(count)"
    }
    
    func removeAllUnreadedMessages() {
       UserDefaults.standard.removeObject(forKey: unreadedMessages)
    }*/
    
}

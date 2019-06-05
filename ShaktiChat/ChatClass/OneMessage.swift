//
//  OneMessage.swift
//  OneChat
//
//  Created by Paul on 27/02/2015.
//  Copyright (c) 2015 ProcessOne. All rights reserved.
//

import Foundation
//import JSQMessagesViewController
import UserNotifications

import XMPPFramework

public typealias OneChatMessageCompletionHandler = (_ stream: XMPPStream, _ message: XMPPMessage) -> Void

// MARK: Protocols

public protocol OneMessageDelegate {
    func oneStreamGetNewMessage(_ dict: NSDictionary)
	func oneStream(_ sender: XMPPStream, didReceiveMessage message: XMPPMessage, from user: XMPPJID)
	func oneStream(_ sender: XMPPStream, userIsComposing user: XMPPJID)
}
public protocol OneMessageDelegateMohan {
    func oneStreamGetNewMmsg(dict:NSDictionary)
    func oneStream(_ sender: XMPPStream, didReceiveMessage message: XMPPMessage, from user: XMPPJID)
    func oneStream(_ sender: XMPPStream, userIsComposing user: XMPPJID)
}

open class OneMessage: NSObject {
	open var delegate: OneMessageDelegate?
    open var delegateMohan: OneMessageDelegateMohan?

    open  let sleepTime = 10
    open var boolSendMessage = false

   // let db = DBManager()

	open var xmppMessageStorage: XMPPMessageArchivingCoreDataStorage?
	var xmppMessageArchiving: XMPPMessageArchiving?
	var didSendMessageCompletionBlock: OneChatMessageCompletionHandler?
	
	// MARK: Singleton
	
	open class var sharedInstance : OneMessage {
		struct OneMessageSingleton {
			static let instance = OneMessage()
		}
		
		return OneMessageSingleton.instance
	}
	
	// MARK: private methods


    
	func setupArchiving() {
		xmppMessageStorage = XMPPMessageArchivingCoreDataStorage.sharedInstance()
		xmppMessageArchiving = XMPPMessageArchiving(messageArchivingStorage: xmppMessageStorage)
		
		xmppMessageArchiving?.clientSideMessageArchivingOnly = true
		xmppMessageArchiving?.activate(OneChat.sharedInstance.xmppStream)
		xmppMessageArchiving?.addDelegate(self, delegateQueue: DispatchQueue.main)
	}
	
	// MARK: public methods

	open class func sendMessage(_ message: String, to recipient: String, completionHandler completion:@escaping OneChatMessageCompletionHandler) {
		let body = DDXMLElement.element(withName: "body") as! DDXMLElement
		let messageID = OneChat.sharedInstance.xmppStream?.generateUUID()
		//body.value(forKey: message)
        body.stringValue = message
		//body.stringValue(message)
		
		let completeMessage = DDXMLElement.element(withName: "message") as! DDXMLElement
		
		completeMessage.addAttribute(withName: "id", stringValue: messageID!)
		completeMessage.addAttribute(withName: "type", stringValue: "chat")
		completeMessage.addAttribute(withName: "to", stringValue: recipient)
		completeMessage.addChild(body)
		
		let active = DDXMLElement.element(withName: "active", stringValue: "http://jabber.org/protocol/chatstates") as! DDXMLElement
		completeMessage.addChild(active)
		
		sharedInstance.didSendMessageCompletionBlock = completion
		OneChat.sharedInstance.xmppStream?.send(completeMessage)
	}
	
	open class func sendIsComposingMessage(_ recipient: String, completionHandler completion:@escaping OneChatMessageCompletionHandler) {
		if recipient.characters.count > 0 {
			let message = DDXMLElement.element(withName: "message") as! DDXMLElement
			message.addAttribute(withName: "type", stringValue: "chat")
			message.addAttribute(withName: "to", stringValue: recipient)
			
			let composing = DDXMLElement.element(withName: "composing", stringValue: "http://jabber.org/protocol/chatstates") as! DDXMLElement
			message.addChild(composing)
            
            
			//composing.namespaces = DDXMLElement.element
               // [(DDXMLElement.namespaceWithNullableName(nil , stringValue: "http://jabber.org/protocol/chatstates")) as! DDXMLNode]
            
            
			sharedInstance.didSendMessageCompletionBlock = completion
			OneChat.sharedInstance.xmppStream?.send(message)
		}
	}
	
	open class func sendIsNotComposingMessage(_ recipient: String, completionHandler completion:@escaping OneChatMessageCompletionHandler) {
		if recipient.characters.count > 0 {
			let message = DDXMLElement.element(withName: "message") as! DDXMLElement
			message.addAttribute(withName: "type", stringValue: "chat")
			message.addAttribute(withName: "to", stringValue: recipient)
			
			let active = DDXMLElement.element(withName: "active", stringValue: "http://jabber.org/protocol/chatstates") as! DDXMLElement
			message.addChild(active)
			
			sharedInstance.didSendMessageCompletionBlock = completion
			OneChat.sharedInstance.xmppStream?.send(message)
		}
	}
	
    open func loadArchivedMessagesFrom(jid: String) -> NSMutableArray{
        let moc = xmppMessageStorage?.mainThreadManagedObjectContext
       // let entityDescription = NSEntityDescription.entity(forEntityName: "XMPPMessageArchiving_Message_CoreDataObject", in: moc!)
          let retrievedMessages = NSMutableArray()

        return retrievedMessages
    }

    
	open func deleteMessagesFrom(jid: String, messages: NSArray) {
        messages.enumerateObjects({ (message, idx, stop) -> Void in
            let moc = self.xmppMessageStorage?.mainThreadManagedObjectContext
            let entityDescription = NSEntityDescription.entity(forEntityName: "XMPPMessageArchiving_Message_CoreDataObject", in: moc!)
            let request = NSFetchRequest<NSFetchRequestResult>()
            let predicateFormat = "messageStr like %@ "
            let predicate = NSPredicate(format: predicateFormat, message as! String)
            
            request.predicate = predicate
            request.entity = entityDescription
            
            do {
                let results = try moc?.fetch(request)
                
                for message in results! {
                    var element: DDXMLElement!
                    do {
                        element = try DDXMLElement(xmlString: (message as AnyObject).messageStr)
                    } catch _ {
                        element = nil
                    }
                    
                    if element.attributeStringValue(forName: "messageStr") == message as! String {
                        moc?.delete(message as! NSManagedObject)
                    }
                }
            } catch _ {
                //catch fetch error here
            }
        })
	}
    
    
    func SendMessageInBG() {
        self.performSelector(inBackground: #selector(checkTosendMessageInBG), with: nil)
       self.performSelector(inBackground: #selector(updateSendMessage), with: nil)
    }
    
    func updateSendMessage() {
       //  sleep(UInt32(sleepTime*2))
        while (boolSendMessage) {
            
            self.performSelector(inBackground: #selector(updateMessageThread), with: nil)
            sleep(UInt32(sleepTime))
        }
    }
    func checkTosendMessageInBG(){
        while (true) {
            
            self.performSelector(inBackground: #selector(checkTosendMessage), with: nil)
            sleep(5)
        }
    }
    
    func checkTosendMessage(){
        let defaultsApp = UserDefaults.init(suiteName: "group.com.shakti.shaktichat")

        var data_file = Data()
        var arrList = NSMutableArray()
        var filename = "", msg_type_temp = "", strMessage = ""
       
        
        if let dict :NSMutableDictionary = defaultsApp?.value(forKey: "toSendData") as?  NSMutableDictionary {
            
            if let  data_file00: Data = dict.object(forKey: "data_File") as?  Data {
                data_file = data_file00
            }
            
            if let  data00: NSMutableArray = dict.object(forKey: "toSend") as?  NSMutableArray {
                arrList = data00
            }
            if let  data00: String = dict.object(forKey: "file_name") as?  String {
                filename = data00
            }
            
            if let  data00: String = dict.object(forKey: "msg_type") as?  String {
                msg_type_temp = data00
            }
            if let  data00: String = dict.object(forKey: "msg") as?  String {
                strMessage = data00
            }
            
            
            
            defaultsApp?.removeObject(forKey: "toSendData")
            defaultsApp?.synchronize()
            
        }
        
        
       // print("arrTmp -----\(arrList)----arrTmp - data_file--\(data_file.count)")
        if  arrList.count > 0 {
            
            var maxId = DBManagerChat.sharedInstance.getLastId(query: "select * from ChatTable")
            
            
            maxId = maxId + 1
            OneMessage.uploadDataSendData(url: WebServices.uploadFile, data: data_file, filename: filename, params: ["sap_id":getSap_id()], completionHandler: { (json) in
                
                if let dictJSN: NSDictionary = json as? NSDictionary {
                    print("dictJSN---",dictJSN)
                    if Int("\(dictJSN.object(forKey: "status")!)") == 1 {
                    //   self.showAlert(MSG: "kUTTypeImage maxId-->\(maxId)<-maxIddictJSN ---\(dictJSN)")
                    
                    
                    
                    var queryString = "insert into ChatTable (Incid, delivery_type, direction, downloading, file_path, group_id, id, msg, msg_from, msg_timestamp, msg_to, msg_type, name, pk_chat_id, status, topic, topic_id, xmpp_user, date, extra, file, file_name, group_name, time, type, reply_id) values "
                    
                    for iii in 0..<arrList.count {
                        
                        if let dictTmp:NSDictionary  = arrList.object(at: iii) as? NSDictionary {
                            var maxId = DBManagerChat.sharedInstance.getLastId(query: "select * from ChatTable")
                            
                            
                            maxId = maxId + 1
                            
                            let formatter = DateFormatter()
                            

                            
                            formatter.dateFormat = "yyyy-mm-dd h:mm a"
                            
                            var delivery_type = "I"
                            if  dictTmp.object(forKey: "group_type") != nil {
                                delivery_type = "G"
                            }
                            
                            let direction = "out",  status = "U"
                            
                            //  string(dictTmp, "")
                            queryString = queryString + "(null, '\(delivery_type)', '\(direction)', '0', '\(string(dictJSN, "file"))', '\(string(dictTmp, "group_id"))', '\(maxId)', '\(strMessage)', '\(UserDefaults.standard.object(forKey: "name")!)', '\(Int(Date().timeIntervalSince1970))', '\(string(dictTmp, "pernr"))', '\(msg_type_temp)', '\(string(dictTmp, "name"))', '\(string(dictTmp, "pk_user_id"))', '\(status)', '', '', '\(string(dictTmp, "xmpp_id"))', '\(dateFormateToGate(format: "MMMM dd, yyyy"))', '', '\(string(dictJSN, "file"))', '\(filename)', '\(string(dictTmp, "groupName"))', '\(localToUTCTime(date: dateFormateToGate(format: "h:mm a")))', '\(msg_type_temp)', '')"
                            
                            
                            if arrList.count != iii + 1 {
                                queryString = queryString + ","
                            }
                            
                        }
                        
                    }
                    print("query---->\(queryString)<-------query")
                    
                    DBManagerChat.sharedInstance.prepareToInsert(query: queryString, completionHandler: { (count) in
                        self.performSelector(inBackground: #selector(self.updateMessageThread), with: nil)
                    })
                    }
                    
                }
                
            })
            
            
        }
        
        
    }
    
    func updateMessageThread() {
        
        
    DBManagerChat.sharedInstance.DatabaseToGatValues(query: "select * from ChatTable where status='U' and direction='out'", completionHandler: { (arrData) in
            if arrData != nil {
                
                if let arr :NSMutableArray = arrData as? NSMutableArray {
                    print("all arr - \(arr)")
                    if arr.count > 0{
                        var jsonData1 = NSData()
                        var strTestArr = ""
                        do {
                            jsonData1 = try JSONSerialization.data(withJSONObject: arr, options: []) as NSData
                            // here "jsonData" is the dictionary encoded in JSON data
                            strTestArr = String(data: jsonData1 as Data, encoding: String.Encoding.utf8)!
                        } catch let error as NSError {
                            print(error)
                        }
                        print("strTestArr  --",strTestArr)
                        
                        let params1  = NSMutableDictionary (dictionary:["sap_id": getSap_id() , "data" : strTestArr ,"device_type":"IOS"])
                        // user/updatecontacts
                        OneMessage.uploadData(url:WebServices.syncMessageMulti , data: nil, params: params1 as? [String : String] , completionHandler: { (json) in
                            if json != nil {
                                
                                if let result :NSDictionary = json as? NSDictionary {
                                print("syncMessageMulti  ----------->",result)
                                if string(result, "status") == "1" {
                                    if let Array: NSArray = result.object(forKey: "data") as? NSArray {
                                        
                                        for i in 0 ..< Array.count {
                                            if  let dictTemp:NSDictionary =  Array.object(at: i) as? NSDictionary {  //  NSDictionary
                                                // let when = // change 2 to desired number of seconds
                                                // update ChatTable set type='P', id=100 where Incid=1 and msg_to='E651' and group_id=0
                                                // msg_to=? and ,string(dictTemp, "msg_to")
                                              //  DBManager.shared.updateChatMsg(query: "update ChatTable set status=?, id=? where Incid=?", values: ["P",string(dictTemp, "pk_chat_id"),string(dictTemp, "id")])
                                                // and group_id=? ,string(dictTemp, "group_id")
                                                
                                                DBManagerChat.sharedInstance.prepareToInsert(query:"update ChatTable set status='P', id=\(string(dictTemp, "pk_chat_id")) where id=\(string(dictTemp, "id")) and direction='out'" , completionHandler: { (arrr) in
                                                    
                                                })
                                            }
                                            
                                        }
                                    }
                                    }
                                }
                            }
                            
                        })
                    }
                    
                }
            }
        })
        
    }
    open class func uploadDataSendData(url: String?, data: Data?, filename: String?, params: [String: String]?, completionHandler: @escaping (Any?) -> Swift.Void)
    {
        
        print("url-------\(String(describing: url)) -params-----------\(String(describing: params))")
        let url  = URL(string: url!)!
        let cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData;
        let request = NSMutableURLRequest(url: url, cachePolicy: cachePolicy, timeoutInterval: 6.0);
        request.httpMethod = "POST";
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        
        //        request.appendPart(withFileData: videoData, name: "video", fileName: strVideoFilePath.lastPathComponent, mimeType: "video/quicktime")
        
        //if(data == nil)  { ret urn; }
        var body = Data();
        
        if params != nil {
            for (key, value) in params! {
                body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
                body.append("\(value)\r\n".data(using: String.Encoding.utf8)!)
            }
        }
        
        if   data != nil {
            //  let mimetype = "text/csv"
            
            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            //        body.append("Content-Disposition: form-data; name=\"attachment\"; filename=\"\(String(describing: params?["filename"]!))\"\r\n".data(using: String.Encoding.utf8)!)
            
            body.append("Content-Disposition: form-data; name=\"attachment\"; filename=\"\(filename)\"\r\n".data(using: String.Encoding.utf8)!)
            
            //   body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Type: application/octet-stream\r\n\r\n".data(using: String.Encoding.utf8)!)
            
            body.append(data!)
            body.append("\r\n".data(using: String.Encoding.utf8)!)
            
            body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        }
        
        request.httpBody = body
        
        //myActivityIndicator.startAnimating();
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error=\(String(describing: error))")
                completionHandler(nil)
                return
            }
            
            // You can print out response object
            print("******* response = \(response)")
            
            // Print out reponse body
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("****** response data = \(responseString!)")
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                
                //    print("JSONSerialization json-\(json)-")
                
                if json != nil {
                    completionHandler(json)
                }
                
            } catch {
                //if you recieve an error saying that the data could not be uploaded,
                //make sure that the upload size is set to something higher than the size
                print(error)
                completionHandler(nil)
                
            }
            
        }
        
        task.resume()
        
    }
    open class func uploadData(url: String?, data: Data?, params: [String: String]?, completionHandler: @escaping (Any?) -> Swift.Void)
    {
        
        print("url-------\(url) -params-----------\(params)")
        let url  = URL(string: url!)!
        let cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData;
        let request = NSMutableURLRequest(url: url, cachePolicy: cachePolicy, timeoutInterval: 6.0);
        request.httpMethod = "POST";
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        
        //        request.appendPart(withFileData: videoData, name: "video", fileName: strVideoFilePath.lastPathComponent, mimeType: "video/quicktime")
        
        //if(data == nil)  { ret urn; }
        var body = Data()
        let file_name =  ""
        
        if params != nil {
            
            for (key, value) in params! {
                body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
                body.append("\(value)\r\n".data(using: String.Encoding.utf8)!)
            }
        }
        
        if data != nil {
            let mimetype = "text/csv"
            
            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            //        body.append("Content-Disposition: form-data; name=\"attachment\"; filename=\"\(String(describing: params?["filename"]!))\"\r\n".data(using: String.Encoding.utf8)!)
            
            body.append("Content-Disposition: form-data; name=\"attachment\"; filename=\"\(file_name)\"\r\n".data(using: String.Encoding.utf8)!)
            
            body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
            
            body.append(data!)
            body.append("\r\n".data(using: String.Encoding.utf8)!)
            
            body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        }
        
        request.httpBody = body
        
        //myActivityIndicator.startAnimating();
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                completionHandler(nil)
                return
            }
            
            // You can print out response object
           // print("******* response = \(response)")
            
            // Print out reponse body
        //    let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
        //    print("****** response data = \(responseString!)")
            
            do {
         //       let json:Any? = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? Any
              
                let jsonResult = try JSONSerialization.jsonObject(with: data!) as? Any

                //    print("JSONSerialization json-\(json)-")
                
                if jsonResult != nil {
                    completionHandler(jsonResult)
                }
                
            } catch {
                //if you recieve an error saying that the data could not be uploaded,
                //make sure that the upload size is set to something higher than the size
                print("error---",error)
                completionHandler(nil)
                
            }
            
        }
        
        task.resume()
        
    }
    
   
}

extension OneMessage: XMPPStreamDelegate {
    
    public func xmppStream(_ sender: XMPPStream, didSend message: XMPPMessage) {
        print("didSend ---",message)
        if message.isChatMessageWithBody() {
            OneMessage.sharedInstance.didSendMessageCompletionBlock!(sender, message)
        }
    }
    
    public func xmppStream(_ sender: XMPPStream, didReceive message: XMPPMessage) {
        //		let user = OneChat.sharedInstance.xmppRosterStorage.user(for: message.from(), xmppStream: OneChat.sharedInstance.xmppStream, managedObjectContext: OneRoster.sharedInstance.managedObjectContext_roster())
        //		if !OneChats.knownUserForJid(jidStr: (user?.jidStr)!) {
        //			OneChats.addUserToChatList(jidStr: (user?.jidStr)!)
        //		}
        
        if message.isChatMessage() {
            print("message.body --->",message.body())
            
            var data = NSData()
            if message.body() != nil {
                data = message.body().data(using: String.Encoding.utf8)! as NSData
            }
            
            var dictTest:NSDictionary = NSDictionary()
            do {
                dictTest = try JSONSerialization.jsonObject(with: data as Data, options: []) as! NSDictionary
                // here "decoded" is the dictionary decoded from JSON data
                //
                //
            } catch let error as NSError {
                print(error)
            }
            if dictTest.count > 0 {
                if message.isChatMessageWithBody() {
                    if kAppDelegate.dictChatInfo.count == 0 {
                        
                        if let _:NSDictionary =  UserDefaults.standard.object(forKey: "ContactJson") as? NSDictionary {
                            if let type:String =  dictTest["type"] as? String {
                                if type == "msg"{
                                    self.performSelector(inBackground: #selector(getAllMessage), with: nil)
                                    
                                    // OneMessage.sharedInstance.delegateMohan?.oneStream(sender, didReceiveMessage: message, from: sender.myJID)
//                                    if  let dictTmp: NSDictionary  = dictTest.object(forKey: "payload") as? NSDictionary  {
//                                     //   _  = string(dictTmp, "xmpp_id")
//                                    }
                                    
                                    
                                }
                                else if type == "msgstatus"  {
                                    DBManagerChat.sharedInstance.prepareToInsert(query: "update ChatTable set status='\(string(dictTest, "status"))' where id=\(string(dictTest, "id"))", completionHandler: { (arr) in
                                        // "update ChatTable set status='P', id=\(string(dictTemp, "pk_chat_id")) where Incid=\(string(dictTemp, "id"))"
                                    })
                                    //   DBManager.shared.updateChatMsg(query: "update ChatTable set status=? where id=?", values: [string(dictTest, "status"),string(dictTest, "id")])
                                }
                                
                            }
                        }else {
                            if let type:String =  dictTest["type"] as? String {
                                if type == "msg" {
                                    self.performSelector(inBackground: #selector(getAllMessage), with: nil)
                                }else if type == "msgstatus"  {
                                    DBManagerChat.sharedInstance.prepareToInsert(query: "update ChatTable set status='\(string(dictTest, "status"))' where id=\(string(dictTest, "id"))", completionHandler: { (arr) in
                                        // "update ChatTable set status='P', id=\(string(dictTemp, "pk_chat_id")) where Incid=\(string(dictTemp, "id"))"
                                    })
                                    //  DBManager.shared.updateChatMsg(query: "update ChatTable set status=? where id=?", values: [string(dictTest, "status"),string(dictTest, "id")])
                                }
                            }
                            OneMessage.sharedInstance.delegate?.oneStream(sender, didReceiveMessage: message, from: sender.myJID)
                            
                        }
                        
                    }else {
                        if let type:String =  dictTest["type"] as? String {
                            if type == "msg" {
                                self.performSelector(inBackground: #selector(getAllMessage), with: nil)
                            }else if type == "msgstatus"  {
                                
                                DBManagerChat.sharedInstance.prepareToInsert(query: "update ChatTable set status='\(string(dictTest, "status"))' where id=\(string(dictTest, "id"))", completionHandler: { (arr) in
                                    // "update ChatTable set status='P', id=\(string(dictTemp, "pk_chat_id")) where Incid=\(string(dictTemp, "id"))"
                                })
                                
                                
                                //  DBManager.shared.updateChatMsg(query: "update ChatTable set status=? where id=?", values: [string(dictTest, "status"),string(dictTest, "id")])
                            }
                        }
                        OneMessage.sharedInstance.delegate?.oneStream(sender, didReceiveMessage: message, from: sender.myJID)
                        
                    }
                } else {
                    //was composing
                    if let _ = message.forName("composing") {
                        //     OneMessage.sharedInstance.delegate?.oneStream(sender, userIsComposing: message.from())
                    }
                }
                
                
            }
        }
    }
    
    func getAllMessage() {
        self.performSelector(inBackground: #selector(getAllMessageThredBG), with: nil)
        
    }
    
    func getAllMessageThredBG() {
        // UserDefaults.standard.object(forKey: "name")!
        
        var boolLoader = false
        
        let params  = NSMutableDictionary (dictionary:["sap_id": getSap_id()])
        //  , "min_id" : "\(UserDefaults.standard.object(forKey: chatRangId.chatMinId)!)" ,"max_id":"\(UserDefaults.standard.object(forKey: chatRangId.chatMaxId)!)"
        
        
        if UserDefaults.standard.object(forKey: chatRangId.chatMinId) != nil {
            params["min_id"] = "\(UserDefaults.standard.object(forKey: chatRangId.chatMinId)!)"
        }else {
            UserDefaults.standard.set("0", forKey: chatRangId.chatMinId)
            params["min_id"] = "0"
            
            boolLoader = true
            Http.startActivityIndicator()
            print("mohan t1 \(Date())")
            DBManagerChat.sharedInstance.deleteMessage(query: "DELETE FROM ChatTable", completionHandler: { (isOk) in
            })
//            if  DBManager.shared.deleteChatMessage(withquery: "DELETE FROM ChatTable", values: nil) {
//            }
            
        }
        
        
        if UserDefaults.standard.object(forKey: chatRangId.chatMaxId) != nil {
            params["max_id"] = "\(UserDefaults.standard.object(forKey: chatRangId.chatMaxId)!)"
        }else {
            UserDefaults.standard.set("0", forKey: chatRangId.chatMaxId)
            params["max_id"] = "0"
        }
        print("chat/getChatMessage ----\(params)")
        // user/updatecontacts
        
        OneMessage.uploadData(url:WebServices.getChatMessage , data: nil, params: params as? [String : String] , completionHandler: { (json) in
            
            if let  dictResult : NSDictionary = json as? NSDictionary {
                print("dictResult ---\(dictResult)---dictResult")
                print("mohan t2 \(Date())")
             
                //  if json != nil {
                // print("getChatMessage ------>\(dictResult)")
                
                UserDefaults.standard.set(string(dictResult,"max_id"), forKey: chatRangId.chatMaxId)
                UserDefaults.standard.set(string(dictResult,"min_id"), forKey: chatRangId.chatMinId)
                
                if let  arrData: NSArray = dictResult.object(forKey: "data") as? NSArray {
                    
                    self.insertInto(arrData, completionHandler: {(index) in
                        if boolLoader {
                           
                            Http.stopActivityIndicator()
                        }
                        if index != nil {
                           
                            
                            
                            if kAppDelegate.dictChatInfo.count == 0 {
                                if #available(iOS 10.0, *) {
                                    let content = UNMutableNotificationContent()
                                    var fromCount = 0
                                    var badge = 0
                                    self.gatBadgeCount("messagecontact", "I", completionHandler: { (countMember,countMsg) in
                                        if let cnt0 = countMember as? Int {
                                            fromCount = cnt0
                                        }
                                        if let cnt1 = countMsg as? Int {
                                            badge = cnt1
                                        }
                                        self.gatBadgeCount("groupcontact", "G", completionHandler: { (countMember,countMsg) in
                                            if let cnt0 = countMember as? Int {
                                                fromCount = fromCount + cnt0
                                            }
                                            if let cnt1 = countMsg as? Int {
                                                badge = badge + cnt1
                                            }
                                            
                                            content.title = "Shakti Chat"
                                            
                                            content.body =  "\(badge) messages form \(fromCount) chats" //  "New messages for chat"
                                            if badge > 0 {
                                                
                                                //Setting time for notification trigger
                                                let date = Date(timeIntervalSinceNow: 1)
                                                let dateCompenents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
                                                
                                                let trigger = UNCalendarNotificationTrigger(dateMatching: dateCompenents, repeats: false)
                                                //Adding Request
                                                let request = UNNotificationRequest(identifier: "timerdone", content: content, trigger: trigger)
                                                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                                                
                                                OneMessage.sharedInstance.delegateMohan?.oneStreamGetNewMmsg(dict: NSDictionary())
                                            }
                                            
                                            
                                        })
                                        
                                    })
                                } else {
                                    // Fallback on earlier versions
                                }
                                

                                
                                
                            }else {
                                for  dict_101 in arrData {
                                    if let dict:NSDictionary = dict_101 as? NSDictionary {
                                        let date0 =  UTCToLocalTime(date:hour12To24(time: string(dict,"time")))
                                        
                                        let dictTemp = NSMutableDictionary(dictionary: ["delivery_type":string(dict, "delivery_type"), "direction":string(dict, "direction"), "downloading":"", "file_path":string(dict, "file_name"), "group_id":string(dict,"group_id"), "id":string(dict,"id"), "msg":string(dict,"msg"), "msg_from":string(dict,"msg_to"), "msg_timestamp":string(dict,"timestamp"), "msg_to": string(dict,"msg_from"), "msg_type": string(dict,"type"), "name":  string(dict,"name"), "pk_chat_id": string(dict,"id"), "status": string(dict,"status"), "topic": string(dict,"topic_id"), "topic_id": string(dict,"topic_id"), "xmpp_user": string(dict,"xmpp_user"), "date":string(dict,"date"), "extra":string(dict,"extra"), "file":string(dict,"file"), "file_name":string(dict,"file_name"), "group_name":string(dict,"group_name"), "time":date0,"type":string(dict,"type"),"reply_id":string(dict,"reply_id")])
                                        OneMessage.sharedInstance.delegate?.oneStreamGetNewMessage(dictTemp)
                                        
                                    }
                                }
                            }
                        }
                        
                    })
                    if !OneMessage.sharedInstance.boolSendMessage {
                        OneMessage.sharedInstance.boolSendMessage =  true
                        
                        OneMessage.sharedInstance.SendMessageInBG()
                    }
                    if boolLoader {
                   
                        Http.stopActivityIndicator()
                    }
                }
            }
            
          
        })
    }
    
    
    func gatBadgeCount(_ mainKey: String, _ type:String, completionHandler: @escaping (Any?,Any?) -> Swift.Void){ // ->(Int,Int)
        
        let defaults = UserDefaults.standard
        var countMsg = 0
        var countMember = 0

        if let dict: NSDictionary =  defaults.object(forKey: "ContactJson") as? NSDictionary {
            
            let mDict = dict.mutableCopy() as! NSMutableDictionary
            
            if let arr = dict.object(forKey: mainKey) as? NSArray {
                
                let mArr = arr.mutableCopy() as! NSMutableArray
                
                var y = 0
                
                
                while y < mArr.count {
                    
                    if let dict1 = mArr.object(at: y) as? NSDictionary {
                    //   select * from ChatTable where msg_to='E307' and delivery_type='I' and direction="in" and (status='P' OR status='D')
                        var qury = "select * from ChatTable where msg_to='\(string(dict1, "pernr"))' and delivery_type='I' and direction='in' and (status='P' OR status='D')"
                        
                        if type == "G" {
                            qury = "select * from ChatTable where group_id='\(string(dict1, "group_id"))' and delivery_type='G' and direction='in' and (status='P' OR status='D')"
                            
                        }
                        
                        let count00 = DBManagerChat.sharedInstance.getLastId(query: qury)
                      //      if let count = arrdate {
                                let mutableDict = dict1.mutableCopy() as! NSMutableDictionary
                                
                                mutableDict.setValue(count00, forKey: "badge_count")
                                if count00 > 0{
                                    print("count----\(count00)--count")
                                    countMember = countMember + 1
                                    mutableDict.setValue("\(Int(Date().timeIntervalSince1970))", forKey: "timeInterval")
                                }
                                //  mutableDict.setValue(Int(Date().timeIntervalSince1970), forKey: "timeInterval")
                                countMsg  = countMsg + count00

                                mArr.replaceObject(at: y, with: mutableDict)

                        
                        }
                    
                    y += 1
                }

                mDict.setValue(mArr, forKey: mainKey)
            }
            
            defaults.set(mDict, forKey: "ContactJson")
            completionHandler(countMember,countMsg)

        }
      //  return (countMember,countMsg)
    }
    
    func insertInto (_ data:NSArray, completionHandler: @escaping (Any?) -> Swift.Void) {
        
        var query = "insert into ChatTable (Incid, delivery_type, direction, downloading, file_path, group_id, id, msg, msg_from, msg_timestamp, msg_to, msg_type, name, pk_chat_id, status, topic, topic_id, xmpp_user, date, extra, file, file_name, group_name, time, type, reply_id) values"
        
        
        
        for i in 0..<data.count {
            if let dict:NSDictionary = data[i] as? NSDictionary {
                let date0 =  UTCToLocalTime(date:hour12To24(time: string(dict,"time")))
                
                query = query + " (null, '\(string(dict,"delivery_type"))', '\(string(dict,"direction"))','0', '\(string(dict,"file_path"))', '\(string(dict,"group_id"))', '\(string(dict,"id"))', '\(string(dict,"msg").replacingOccurrences(of: "'", with: ""))', '\(string(dict,"msg_to"))', '\(string(dict,"timestamp"))', '\(string(dict,"msg_from"))', '\(string(dict,"msg_type"))', '\(string(dict,"name"))', '\(string(dict,"id"))', '\(string(dict,"status"))', '\(string(dict,"topic"))', '\(string(dict,"topic_id"))', '\(string(dict,"xmpp_user"))', '\(string(dict,"date"))', '\(string(dict,"extra"))', '\(string(dict,"file"))' , '\(string(dict,"file_name"))', '\(string(dict,"group_name"))', '\(date0)', '\(string(dict,"type"))', '\(string(dict,"reply_id"))')"
                
                if i + 1 != data.count {
                    query = query + ","
                }
            }
        }
        
//        DBManager.shared.insertChatData(query: query, completionHandler: { (count) in
//            completionHandler(true)
//        })
        DBManagerChat.sharedInstance.prepareToInsert(query: query, completionHandler: { (count) in
            completionHandler(true)
        })
    }
 
}

//func setTotaladgeCount() -> Int{
//    
//    return 0
//}

//==========
func getBadgeCountInDictMy(key: String, id: String, idKey: String) -> (Int,Int) {
    let defaults = UserDefaults.standard
    var badge = 0
    var fromCount = 0
    if let dict: NSDictionary =  defaults.object(forKey: "ContactJson") as? NSDictionary {
        
        if let arr = dict.object(forKey: key) as? NSArray {
            
            let mArr = arr.mutableCopy() as! NSMutableArray
            for i in 0 ..< mArr.count {
                if let dict1 = mArr.object(at: i) as? NSDictionary {
                    let no = number(dict1, "badge_count").intValue
                    badge = badge + no
                    if no > 0 {
                        fromCount = fromCount + 1
                    }
                    
                }
            }
        }
    }
    return (badge,fromCount)
}
func getBadgeCountInDict(key: String, id: String, idKey: String) -> Int {
    
    let defaults = UserDefaults.standard
    let badge = 0

    if let dict: NSDictionary =  defaults.object(forKey: "ContactJson") as? NSDictionary {
        
        
        let mDict = dict.mutableCopy() as! NSMutableDictionary
        
        if let arr = dict.object(forKey: key) as? NSArray {
            
            let mArr = arr.mutableCopy() as! NSMutableArray
            
            
            var y = 0
            
            while y < mArr.count {
                if let dict1 = mArr.object(at: y) as? NSDictionary {
                    
                    if id == string(dict1, idKey) {
                        return number(dict1, "badge_count").intValue
                    }
                }
                y += 1
            }
            
            
            mDict.setValue(mArr, forKey: key)
        }
        
        defaults.set(mDict, forKey: "ContactJson")
    }
    return badge
}

//==========





func changeBadgeCountInDict(key: String, count: Int, Interval: Int, id: String, idKey: String) {
    
    let defaults = UserDefaults.standard
    
    if let dict: NSDictionary =  defaults.object(forKey: "ContactJson") as? NSDictionary {
        
        
        let mDict = dict.mutableCopy() as! NSMutableDictionary
        
        if let arr = dict.object(forKey: key) as? NSArray {
            
            let mArr = arr.mutableCopy() as! NSMutableArray
            
            
            var y = 0
            
            
            while y < mArr.count {
                
                if let dict1 = mArr.object(at: y) as? NSDictionary {
                    
                    if id == string(dict1, idKey) {
                        
                        let mutableDict = dict1.mutableCopy() as! NSMutableDictionary
                        
                        mutableDict.setValue(count, forKey: "badge_count")
                        mutableDict.setValue(Interval, forKey: "timeInterval")

                       //  mutableDict.setValue(Int(Date().timeIntervalSince1970), forKey: "timeInterval")
                        
                        mArr.replaceObject(at: y, with: mutableDict)
                    }
                }
                y += 1
            }
            
            mDict.setValue(mArr, forKey: key)
        }
        
        defaults.set(mDict, forKey: "ContactJson")
    }
}

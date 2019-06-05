//
//  ForwardMsgView.swift
//  ShaktiChat
//
//  Created by mac on 20/11/17.
//  Copyright © 2017 himanshuPal_kavya. All rights reserved.
//

import UIKit

class ForwardMsgView: UIViewController , UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate{

     var dictMessage  = NSDictionary()
    
   
    @IBOutlet var tblContact: UITableView!
    var arrmessagecontact = NSMutableArray()
    var arrMessageTemp = NSMutableArray()
    @IBOutlet var tfSearch: UITextField!

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet var btnSend: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("dictMessage --->\(dictMessage)<---dictMessage")

        let defaults = UserDefaults.standard
        //        uuuudde?.removeObject(forKey: "updatecontacts")
        //        uuuudde?.set(result, forKey: "updatecontacts")
        
        if let dict:NSDictionary =  defaults.object(forKey: "ContactJson") as? NSDictionary { //data is already
            print("Mohan forward mesage --->😊😊😊😊😊😊")

            if let messagecontact:NSArray = dict.object(forKey: "messagecontact") as? NSArray  {
                _ = NSMutableArray()

            
//            if let messagecontact:NSMutableArray = dict.object(forKey: "messagecontact") as? NSMutableArray  {
                arrmessagecontact = messagecontact.mutableCopy() as! NSMutableArray
                
                tblContact.reloadData()
            }
            
            let obj = seprateGroupBroadcastArray()
            let arrGroup = obj.group
            
            
            if arrGroup.count > 0 {
                print("grupdetail --->\(arrGroup.count)-----arrmessagecontact-->\(arrmessagecontact.count)")

                if  let arr_0 : NSMutableArray = arrGroup.mutableCopy() as? NSMutableArray {
                    let mergedArray = arrmessagecontact.addingObjects(from: arr_0 as! [Any])
                    arrmessagecontact = mergedArray as! NSMutableArray
                    print("grupdetail --->\(arrmessagecontact.count)")
                }
            }
            let arr =  NSMutableArray()
            for ii in 0 ..< arrmessagecontact.count {
                let dict = arrmessagecontact.object(at: ii) as? NSMutableDictionary
                let dict_121:NSMutableDictionary = dict?.mutableCopy() as! NSMutableDictionary
                if dict?.object(forKey: "timeInterval") == nil && (dict?.object(forKey: "timeInterval") is NSNull){
                    dict_121.setValue(0, forKey: "timeInterval")
                }else {
                    dict_121.setValue(number(dict!, "timeInterval").intValue, forKey: "timeInterval")
                }
                arr.add(dict_121)
            }

            arrmessagecontact = arr
            //   showAlert(MSG: "\(arrmessagecontact)")
            print("arrmessagecontact --->\(arrmessagecontact)<---arrmessagecontact")

            arrMessageTemp = arrmessagecontact
            
              let arrMessageTemp1 = arrmessagecontact as! [NSDictionary]
            
             arrmessagecontact = arrMessageTemp1.sorted(by: {  $0.object(forKey: "timeInterval") as! Int > $1.object(forKey: "timeInterval") as! Int }) as! NSMutableArray
            
            arrMessageTemp = self.arrmessagecontact
            
            
            //convert dict to object rahul
        }
        tblContact.delegate = self
        tblContact.dataSource = self
        tfSearch.delegate = self
        
        

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func cancel() {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func done() {
        
        let arrTmp = NSMutableArray()
        for dict in arrmessagecontact {
            if let dictTmp:NSDictionary  = dict as? NSDictionary {
                if dictTmp.object(forKey: "check") != nil {
                    arrTmp.add(dictTmp)
                }
            }
        }
        print("dictMessage->\(dictMessage) arrTmp -----\(arrTmp)----arrTmp")
        
        
        var queryString = "insert into ChatTable (Incid, delivery_type, direction, downloading, file_path, group_id, id, msg, msg_from, msg_timestamp, msg_to, msg_type, name, pk_chat_id, status, topic, topic_id, xmpp_user, date, extra, file, file_name, group_name, time, type, reply_id) values "
      //  for tmp in (arrTmp) {
        for iii in 0..<arrTmp.count {
            
            if let dictTmp:NSDictionary  = arrTmp.object(at: iii) as? NSDictionary {
                var maxId = DBManagerChat.sharedInstance.getLastId(query: "select * from ChatTable")
                
                let strMessage = stringEncode(string(dictMessage, "msg"))
                maxId = maxId + 1
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-mm-dd h:mm a"
                var delivery_type = "I"
                if  dictTmp.object(forKey: "group_type") != nil {
                    delivery_type = "G"
                }
                let direction = "out", downloading = "0", file_path = string(dictMessage, "file"), group_id = string(dictTmp, "group_id") , msg_timestamp = "\(Int(Date().timeIntervalSince1970))" , msg_type = string(dictMessage, "msg_type"), status = "U", date = dateFormateToGate(format: "MMMM dd, yyyy"), extra = "", file = string(dictMessage, "file"), file_name = string(dictMessage, "file_name"), group_name = string(dictTmp, "groupName"), time = localToUTCTime(date: dateFormateToGate(format: "h:mm a")), type = string(dictMessage, "type"), reply_id = "", topic_id = string(dictMessage, "topic_id"), topic_name  = string(dictMessage, "topic_name") , xmpp_id  = string(dictTmp, "xmpp_id"), pk_user_id  = string(dictTmp, "pk_user_id")
                
                //  string(dictTmp, "")
                queryString = queryString + "(null, '\(delivery_type)', '\(direction)', '\(downloading)', '\(file_path)', '\(group_id)', '\(maxId)', '\(strMessage)', '\(UserDefaults.standard.object(forKey: "name")!)', '\(msg_timestamp)', '\(string(dictTmp, "pernr"))', '\(msg_type)', '\(string(dictTmp, "name"))', '\(pk_user_id)', '\(status)', '\(topic_name)', '\(topic_id)', '\(xmpp_id)', '\(date)', '\(extra)', '\(file)', '\(file_name)', '\(group_name)', '\(time)', '\(type)', '\(reply_id)')"
                
                
                if arrTmp.count != iii + 1 {
                    queryString = queryString + ","
                }
                
            }
          
        }
        print("query---->\(queryString)<-------query")
        
        DBManagerChat.sharedInstance.prepareToInsert(query: queryString, completionHandler: { (count) in

            self.navigationController?.popViewController(animated: true)

        })
    }
    /*
     
     
     @IBAction func btnSendMessage(_ sender: Any) {
     typingStatus(type: "stoptyping")
     
     if tvMessage.text != "" {
     setDefoultTimeSendMessage()
     // var maxId = DBManager.shared.getLastId()
     var maxId = DBManagerChat.sharedInstance.getLastId(query: "select * from ChatTable")
     
     let strMessage = encode(tvMessage.text)
     
     maxId = maxId + 1
     let formatter = DateFormatter()
     formatter.dateFormat = "yyyy-mm-dd h:mm a"
     
     let dict1 = NSMutableDictionary(dictionary: ["delivery_type":isGroupType, "direction":"out", "downloading":0, "file_path":"", "group_id":groupcontactClassTemp.group_id, "id":maxId, "msg":strMessage, "msg_from":"\(UserDefaults.standard.object(forKey: "name")!)", "msg_timestamp":"\(Int(timeInterval))", "msg_to":  ContactTemp.pernr, "msg_type": "T", "name":  ContactTemp.name, "pk_chat_id": ContactTemp.pk_user_id, "status": "U", "topic": topic_name, "topic_id": topic_id, "xmpp_user": ContactTemp.xmpp_id, "date":dateFormateToGate(format: "MMMM dd, yyyy"), "extra":"", "file":"", "file_name":"", "group_name":groupcontactClassTemp.groupName,  "type":"T","reply_id":ReplayId])
     
     
     
     let delivery_type = "I",  direction = "out", downloading = "0", file_path = "", group_id = groupcontactClassTemp.group_id , msg_timestamp = "\(Int(timeInterval))" , msg_type = "T", status = "U", date = dateFormateToGate(format: "MMMM dd, yyyy"), extra = "", file = "", file_name = "", group_name = groupcontactClassTemp.groupName, time = localToUTCTime(date: dateFormateToGate(format: "h:mm a")), type = "T", reply_id = "\(ReplayId)"
     
     
     
     
     let query111 = "insert into ChatTable (Incid, delivery_type, direction, downloading, file_path, group_id, id, msg, msg_from, msg_timestamp, msg_to, msg_type, name, pk_chat_id, status, topic, topic_id, xmpp_user, date, extra, file, file_name, group_name, time, type, reply_id) values (null, '\(delivery_type)', '\(direction)', '\(downloading)', '\(file_path)', '\(group_id)', '\(maxId)', '\(strMessage)', '\(UserDefaults.standard.object(forKey: "name")!)', '\(msg_timestamp)', '\(ContactTemp.pernr)', '\(msg_type)', '\(ContactTemp.name)', '\(ContactTemp.pk_user_id)', '\(status)', '\(topic_name)', '\(topic_id)', '\(ContactTemp.xmpp_id)', '\(date)', '\(extra)', '\(file)', '\(file_name)', '\(group_name)', '\(time)', '\(type)', '\(reply_id)')"
     
     DBManagerChat.sharedInstance.prepareToInsert(query: query111, completionHandler: { (count) in
     })
     
     
     dict1["time"] =  localToUTCTime(date: dateFormateToGate(format: "h:mm a")) //dateFormateToGate(format: "h:mm a")
     
     self.gatMessageForReply(dict12: dict1)
     self.objectAddInmyArr(dict: dict1)
     
     if ReplayId != "0" {
     self.btnCloseReply(true)
     }
     
     
     let params1  = NSMutableDictionary (dictionary:["sap_id": getSap_id() , "data" : converDictToJson(dict: NSMutableArray(array: [dict1])) ,"device_type":"IOS"])
     SyncMessageMultiDataWebServices(params: params1)
     
     // user/updatecontacts
     /* self.uploadData(url:WebServices.syncMessageMulti , data: nil, params: params1 as? [String : String] , completionHandler: { (json) in
     if json != nil {
     
     let result = json as? NSDictionary
     //  print("syncMessageMulti  ----------->\(result)")
     if string(result!, "status") == "1" {
     if let Array: NSArray = result?.object(forKey: "data") as? NSArray {
     var arr  = NSMutableArray()
     arr = self.arrMessages
     //  print("arr1----\(arr)")
     //                            print("arr2---->\(arr)<-arr2")
     
     for i in 0 ..< Array.count {
     if  let dictTemp:NSDictionary =  Array.object(at: i) as? NSDictionary {  //  NSDictionary
     
     DBManager.shared.updateChatMsg(query: "update ChatTable set status=?, id=? where Incid=?", values: ["P",string(dictTemp, "pk_chat_id"),string(dictTemp, "id")])
     
     var dictTmp = arr.object(at: arr.count - 1) as!  NSDictionary// NSMutableArray
     
     //                                       print("dict my-----\(dictTmp)")
     // dictTemp = dict.mutableCopy() as! NSMutableDictionary
     let arr_11 = dictTmp.object(forKey: "data") as! NSArray
     
     let arr111 = arr_11.mutableCopy() as! NSMutableArray
     
     for i in  0 ..< arr111.count {
     
     let dict = arr111.object(at: i) as? NSDictionary
     let dict1: NSMutableDictionary = dict?.mutableCopy() as! NSMutableDictionary
     if string(dict1, "id") == string(dictTemp, "id") {
     
     dict1.setValue("P", forKey: "status")
     dict1.setValue(string(dictTemp, "pk_chat_id"), forKey: "id")
     
     arr111.replaceObject(at: i , with: dict1)
     
     self.arrAllMessageArr.add(dict1)
     
     
     }
     
     }
     let dict_00 = dictTmp.mutableCopy() as! NSMutableDictionary
     
     dict_00.setObject(arr111, forKey: "data" as NSCopying)
     dictTmp = dict_00
     
     arr.replaceObject(at: arr.count - 1 , with: dictTmp)
     //  }
     }
     
     }
     //                         print("arr2---->\(arr)<-arr2")
     self.arrMessages = NSMutableArray()
     self.arrMessages = arr
     
     DispatchQueue.main.async {
     self.tblView.reloadData()
     self.moveToLastComment()
     }
     }
     
     }
     }
     
     })*/
     
     //            moveToLastComment()
     tvMessage.text = ""
     lblchatMsg.isHidden = false
     }
     }
     
     */
    
    //MARK:- textField
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newLength: Int = textField.text!.characters.count + string.characters.count - range.length
        
        if string == "\n" {
            textField.resignFirstResponder()
            return false
        }else {
            if newLength == 0 {
                search(strSearch: "")
            }else {
                search(strSearch: textField.text! + string)
            }
        }
        
        return true
    }
    func search(strSearch:String){
        
        
        var arr =  NSMutableArray()
        if strSearch == "" {
            arr = arrMessageTemp
        }else {
            for i in 0 ..< arrMessageTemp.count {
                let dict = arrMessageTemp.object(at: i) as! NSDictionary
                var namepp = ""
                if let name1:String = dict.object(forKey: "name") as? String{
                    namepp = name1
                }else if let name1:String = dict.object(forKey: "groupName") as? String{
                    namepp = name1
                }
                if namepp.characters.count > 0 {
                    if namepp.range(of: strSearch) != nil {
                        arr.add(dict)
                    }
                }
            }
        }
        
        arrmessagecontact = arr
        tblContact.reloadData()
        
    }
    
//MARK:- tableView
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForwardListCell", for: indexPath) as! ForwardListCell
        let dict = self.arrmessagecontact.object(at: indexPath.row) as! NSDictionary
        if let name:String = dict.object(forKey: "name") as? String {
            cell.lblName.text = name
        }else if let name:String = dict.object(forKey: "groupName") as? String {
            cell.lblName.text = name
        }
        // pic
        if let _:String = dict.object(forKey: "group_type") as? String {   // group_type
            cell.imgProfile.sd_setImage(with: URL(string: string(dict, "pic")), placeholderImage: UIImage(named: "group_icon1.png"), options: SDWebImageOptions.retryFailed)
        }else {
            cell.imgProfile.sd_setImage(with: URL(string: string(dict, "pic")), placeholderImage: UIImage(named: "profile.png"), options: SDWebImageOptions.retryFailed)
        }

        cell.imgProfile.layer.cornerRadius = cell.imgProfile.frame.size.height/2
        cell.imgProfile.clipsToBounds = true
       //  group_icon1.png
        
        if dict.object(forKey: "check") != nil {
            cell.imgCheck.image = UIImage(named: "ic_checkbox_checked_24.png")
            
        }else {
            cell.imgCheck.image = nil
            
        }
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrmessagecontact.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let arr  = arrmessagecontact.mutableCopy() as! NSMutableArray
        let dict = arrmessagecontact.object(at: indexPath.row) as! NSDictionary
        let dict11 = dict.mutableCopy() as! NSMutableDictionary
        if dict.object(forKey: "check") != nil {
            dict11.removeObject(forKey: "check")
        }else {
            dict11.setValue(1, forKey: "check")
        }
        
        var isCheck = false
        arr.replaceObject(at: indexPath.row, with: dict11)
        
        for dict111 in arr {
            if let dict_1: NSDictionary = dict111 as? NSDictionary {
                if dict_1.object(forKey: "check") != nil {
                    isCheck = true
                    break
                }
            }
        }
        if isCheck {
            btnSend.alpha = 1.0
            btnSend.isUserInteractionEnabled = true
            
        }else {
            btnSend.alpha = 0.65
            btnSend.isUserInteractionEnabled = false
            
        }
        
        arrmessagecontact = arr
        tblContact.reloadData()
 
    }


}

//
//  PersonsVC.swift
//  ShaktiChat
//
//  Created by kavya_mac_1 on 9/6/17.
//  Copyright © 2017 himanshuPal_kavya. All rights reserved.
//

import UIKit
import Foundation
import XMPPFramework




class PersonsVC: UIViewController , UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, UITextFieldDelegate  , OneMessageDelegateMohan,EPPickerDelegate {
    var intMessagebadgeCount = 0
    
    @IBOutlet var scGallery: UIScrollView!
    @IBOutlet var tblBoradCast: UITableView!
    @IBOutlet var tblGroups: UITableView!
    @IBOutlet var tblContact: UITableView!
    @IBOutlet var tfSearch: UITextField!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var viewSearch: UIView!
    @IBOutlet var lblId: UILabel!
    @IBOutlet var btnGroups: UIButton!
    @IBOutlet var btnContacts: UIButton!
    @IBOutlet var btnBroadCast: UIButton!
    @IBOutlet var ivBtnSelect: UIImageView!
    @IBOutlet var viewPopUp: UIView!
    var arrTables = [UITableView]()
    var arrX = [CGFloat]()
    //   let db = DBManager()
  
    var maPersonContact:NSMutableArray? = nil
    var arrMessageTemp = NSMutableArray()
    var arrGroupTempForSearch = NSMutableArray()
    var arrBrodCstempForSearch = NSMutableArray()

    
    @IBOutlet var tfAddBroadcast: UITextField!
    
    @IBOutlet var btnAddBroadcast: Button!
    //MARK:- lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
      
        if !OneMessage.sharedInstance.boolSendMessage {
            OneMessage.sharedInstance.boolSendMessage =  true
            
            OneMessage.sharedInstance.SendMessageInBG()
        }
        if !kAppDelegate.boolLocation {
            kAppDelegate.boolLocation = true
            kAppDelegate.updateLocation()
        }
//        boolLocation
//        updateLocation

    /*
        let epocTime = TimeInterval("1507812621")! / 1000 // convert it from milliseconds dividing it by 1000
        var date = Date(timeIntervalSince1970: epocTime)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        formatter.locale = NSLocale(localeIdentifier: "en_US") as Locale!
        print(formatter.string(from: date as Date))
        

        print("date - \(date)")

        
        let timeInterval = Date().timeIntervalSince1970
        
        // convert to Integer
        let myInt = Int(timeInterval)

        print("epocTime------------\(epocTime)--------myInt------\(myInt)-")
*/
        
        
       //  vcChat  =  self.storyboard?.instantiateViewController(withIdentifier: "ChatMohanViewController") as! ChatMohanViewController
        
        
        tfSearch.delegate = self
        self.tfAddBroadcast.delegate = self
        OneMessage.sharedInstance.delegateMohan = self

        viewPopUp.frame = self.view.frame
        viewPopUp.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        btnAddBroadcast.frame.origin.y =  self.view.frame.size.height
        arrTables = [tblContact, tblGroups, tblBoradCast]
        arrX = [btnContacts.frame.origin.x, btnGroups.frame.origin.x, btnBroadCast.frame.origin.x]
        
        makeImgForSwipe()
        tfSearch.attributedPlaceholder = NSAttributedString(string:"Search...", attributes: [NSForegroundColorAttributeName: lightblueColor ])
        
        let defaults = UserDefaults.standard
        // "ContactJson"
        let userdetail = defaults.object(forKey: "userdetail") as? NSDictionary
        lblName.text =  string(userdetail!, "name")
        let id = defaults.object(forKey: "name") as! String
        sapid = id
        lblId.text = "ID: " + id
        
      
     
    }
    var sapid = ""
    override func viewWillAppear(_ animated: Bool) {
        
        
        // search(strSearch: "Muk")
        let defaults = UserDefaults.standard
    
            if let dict:NSDictionary =  defaults.object(forKey: "ContactJson") as? NSDictionary { //data is already
                self.calldata(result: dict) //convert dict to object rahul
            }else {
                if (defaults.object(forKey: "userdetail") != nil) {
                    self.ws_contact()
                    
                }
        }
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //MARK:- text Field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    //   tabgesture hold hp  UIGestureRecognizerDelegate rahul
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view != nil && touch.view!.isDescendant(of: tblContact) {
            return false
        }else if touch.view != nil && touch.view!.isDescendant(of: tblGroups) {
            return false
        }else if touch.view != nil && touch.view!.isDescendant(of: tblBoradCast) {
            return false
        }
        return true
    }
    
     //MARK:- IBAction
    @IBAction func actionSync(_ sender: Any) {
//        let defaults = UserDefaults.standard
//        let Password = defaults.object(forKey: "password") as! String
//        let userType = defaults.object(forKey: "usertype") as! String
      //  var id = getSap_id()
       
        self.ws_contact()
        
    }
    
    @IBAction func actionSearch(_ sender: Any) {
        tfSearch.text = ""
        self.view.addSubview(viewSearch)
        self.viewSearch.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.viewSearch.frame.size.height)
    }
    @IBAction func actionMenu(_ sender: Any) {
        self.sideMenuViewController.presentLeftMenuViewController()
    }
    
    
    //0
    @IBAction func actionContacts(_ sender: Any) {
        UIView.animate(withDuration: 0.2, animations: {
            self.btnAddBroadcast.frame.origin.y =  self.view.frame.size.height
        }, completion: { finished in
        })
        
        print(indexOfView)
        if indexOfView != 0 {
            indexOfView = 1
            swipeRight()
        }
        print(indexOfView)
        
    }
    //1
    @IBAction func actionGroups(_ sender: Any) {
        UIView.animate(withDuration: 0.2, animations: {
            self.btnAddBroadcast.frame.origin.y =  self.view.frame.size.height
        }, completion: { finished in
        })
        print(indexOfView)
        if indexOfView != 1 {
            if indexOfView > 1 {
                swipeRight()
            } else {
                swipeLeft()
            }
            //  reloadTable()
        }
        print(indexOfView)
    }
    
    
    //2
    @IBAction func actionBroadCast(_ sender: Any) {
        UIView.animate(withDuration: 0.2, animations: {
            self.btnAddBroadcast.frame.origin.y =  self.view.frame.size.height  - (self.btnAddBroadcast.frame.size.height + 20)
        }, completion: { finished in
        })
        
        print(indexOfView)
        
        
        if indexOfView != 2 {
            indexOfView = 1
            swipeLeft()
        }
        print(indexOfView)
    }
    
    @IBAction func actionBack(_ sender: Any) {
        viewSearch.removeFromSuperview()
    }
    
    
    func reloadTable() {
        
        if indexOfView == 0 {
            UIView.animate(withDuration: 0.2, animations: {
                self.btnAddBroadcast.frame.origin.y =  self.view.frame.size.height
            }, completion: { finished in
            })
            tblContact.reloadData()
        } else if indexOfView == 1 {
            UIView.animate(withDuration: 0.2, animations: {
                self.btnAddBroadcast.frame.origin.y =  self.view.frame.size.height
            }, completion: { finished in
            })
            tblGroups.reloadData()
        } else {
            UIView.animate(withDuration: 0.2, animations: {
                self.btnAddBroadcast.frame.origin.y =  self.view.frame.size.height  - (self.btnAddBroadcast.frame.size.height + 20)
            }, completion: { finished in
            })
            tblBoradCast.reloadData()
        }
        
    }
    
    
    //-=--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
    //MARK : FUNCTIONS
    var totalX: CGFloat = 0
    func makeImgForSwipe() {
        for i in 0..<arrTables.count {
            arrTables[i].frame = CGRect(x: totalX, y: 0, width: scGallery.frame.size.width, height: scGallery.frame.size.height)
            totalX += scGallery.frame.size.width
            scGallery.addSubview(arrTables[i])
            scGallery.autoresizesSubviews = true
        }
        
        scGallery.contentSize = CGSize(width: totalX, height: 0)
        scGallery.isScrollEnabled = false
        
        let rightGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeRight))
        rightGestureRecognizer.direction = (.right)
        scGallery.addGestureRecognizer(rightGestureRecognizer)
        
        let leftGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeLeft))
        leftGestureRecognizer.direction = (.left)
        scGallery.addGestureRecognizer(leftGestureRecognizer)
        
    }
    
    var indexOfView = Int()
    
    func swipeRight() {
        print(indexOfView)
        self.view.isUserInteractionEnabled = false
        if indexOfView == 0 {
            self.view.isUserInteractionEnabled = true
        } else {
            let offSetX = self.scGallery.frame.size.width * CGFloat(indexOfView)
            self.indexOfView -= 1
            
            
            let point = CGPoint(x: offSetX - scGallery.frame.size.width, y: 0)
            self.scGallery.setContentOffset(point, animated: true)
            
            let deadlineTime = DispatchTime.now() + 0.5
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                self.view.isUserInteractionEnabled = true
            }
        }
        reloadTable()
        UIView.animate(withDuration: 0.2, animations: {
            self.ivBtnSelect.frame.origin.x = self.arrX[self.indexOfView]
        }, completion: { finished in
        })
        print(indexOfView)
        
    }
    
    func swipeLeft() {
        print(indexOfView)
        self.view.isUserInteractionEnabled = false
        
        if indexOfView == arrTables.count - 1{
            self.view.isUserInteractionEnabled = true
        } else {
            let offSetX = self.scGallery.frame.size.width * CGFloat(indexOfView)
            
            self.indexOfView += 1
            
            let point = CGPoint(x: offSetX + scGallery.frame.size.width, y: 0)
            self.scGallery.setContentOffset(point, animated: true)
            let deadlineTime = DispatchTime.now() + 0.5
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                self.view.isUserInteractionEnabled = true
            }
        }
        reloadTable()
        UIView.animate(withDuration: 0.2, animations: {
            self.ivBtnSelect.frame.origin.x = self.arrX[self.indexOfView]
        }, completion: { finished in
        })
        print(indexOfView)
    }
    
    
    
    
    var arrgroupcontact = NSMutableArray()
    var   arrgroupdetail = NSMutableArray()
    var   arrmessagecontact = NSMutableArray()
    
    
    var arrGroup = NSMutableArray() //change rahul.
    var arrBroadCast = NSMutableArray() //change rahul.
    
    
    var dictDataForSend  = NSDictionary()
    
    //MARK:--------------------------------------------------------
    func gatBrodCastDataAndGroupContact(){
        //    self.ws_UpdateImg(dict: dict)
        
        let params1  = NSMutableDictionary(dictionary:["sap_id": getSap_id()  , "contacts" : converDictToJson(dict: dictDataForSend)])
        print("\(WebServices.updatecontacts)-- params1 -->",params1)
        
        self.uploadData(url: URL(string: WebServices.updatecontacts)!, data: nil, params: params1 as? [String : String], completionHandler: { (json) in
            if json != nil {
                if let dictT: NSDictionary =  (json as AnyObject).object(forKey: "data") as? NSDictionary {
                    
                    // let dictT = dictT.object(forKey: "0") as! NSDictionary
                    print("ContactJson -\(dictT)-")
                    
                    
                    self.arrBroadCast = self.seprateGroupBYDICT(Dict: dictT)
                    let tempArrBroadCast = NSMutableArray()
                    
                    
                    for i in 0..<self.arrBroadCast.count {
                        
                        let dict = self.arrBroadCast.object(at: i) as! NSDictionary
                        
                        let ob = groupcontactClass()
                        ob.groupName = string(dict, "groupName")
                        ob.groupNo = string(dict, "groupNo")
                        ob.created_by = string(dict, "created_by")
                        ob.group_id = string(dict, "group_id")
                        ob.group_type = string(dict, "group_type")
                        ob.maContacts = NSMutableArray()
                        
                        tempArrBroadCast.add(ob)
                    }
                    
                    self.arrBroadCast = tempArrBroadCast
                    self.arrBrodCstempForSearch = self.arrBroadCast
                    
                    self.reloadTable()
                    
                }
                // self.tblContact.reloadData()
            }
        })
        
        
    }
    func ws_contact(){
        Http.instance().startActivityIndicator()
        let defaults = UserDefaults.standard
        let Password = defaults.object(forKey: "password") as! String
        let userType = defaults.object(forKey: "usertype") as! String
        let id = getSap_id()
        
        //category=E&pernr=651&pass=FAZA
        
        self.arrgroupcontact  = NSMutableArray()
        self.arrgroupdetail = NSMutableArray()
        self.arrmessagecontact = NSMutableArray()
        
        
        let params  = NSMutableDictionary (dictionary:[
            "pernr": id  , "category" : userType , "pass" : Password
            ])
        
        Http.instance().json(WebServices().contact, params, "POST", ai: false, popup: true, prnt: true, nil) { (json,param) in
            if json != nil {
                if let dict : NSDictionary = json as? NSDictionary {
            //    self.ws_UpdateImg(dict: dict)
                self.dictDataForSend  = dict
                let params1  = NSMutableDictionary(dictionary:["sap_id": id  , "contacts" : converDictToJson(dict: dict)])
                        print("\(WebServices.updatecontacts)-- params1 -->",params1)
            
                self.uploadData(url: URL(string: WebServices.updatecontacts)!, data: nil, params: params1 as? [String : String], completionHandler: { (json) in
                    Http.instance().stopActivityIndicator()
                    if json != nil {
                        if let dictT: NSDictionary =  (json as AnyObject).object(forKey: "data") as? NSDictionary {
                            
                            if let dict:NSDictionary =  UserDefaults.standard.object(forKey: "ContactJson") as? NSDictionary { //data is already there in
                                
                                self.oldData = dict
                            }
                           // let dictT = dictT.object(forKey: "0") as! NSDictionary
                         //   print("ContactJson -\(dictT)-")
                            
                            UserDefaults.standard.set(dictT, forKey: "ContactJson") //saved in userdefault here rahul
                            UserDefaults.standard.synchronize()
                            print("dictT JSONSerialization json-\(dictT)-")
                            
                             self.updateBadgeCount()
                            self.calldata(result: dictT)

                        }
                       // self.tblContact.reloadData()
                    }
                    OneMessage.sharedInstance.getAllMessage()

                })
                
            }}
        }
    }
    

    //MARK: ------------------ TABLEVIEW DELEGATE ------------------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == tblContact {
            return arrmessagecontact.count
        } else if tableView == tblGroups {
            // return arrgroupcontact.count
            return arrGroup.count
        } else if tableView == tblBoradCast {
            return arrBroadCast.count
        } else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == tblContact {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "PersonsCell", for: indexPath) as! PersonsCell
            let dict = self.arrmessagecontact.object(at: indexPath.row) as! ContactClass
            cell.lblName.text = dict.name
            cell.lblDepartment.text = dict.btrtlTxt
            cell.lblMobileNumber.text = dict.telnr
            cell.imgProfile.sd_setImage(with: URL(string: dict.pic), placeholderImage: UIImage(named: "bar_default"),  options: SDWebImageOptions.retryFailed)
            cell.imgProfile.layer.cornerRadius = cell.imgProfile.frame.size.height/2
            cell.imgProfile.clipsToBounds = true
            
            if dict.badgeCount != 0 {
                cell.lblBatchCount.isHidden = false
            }else {
                cell.lblBatchCount.isHidden = true
            }
            
            cell.lblBatchCount.text = "\(dict.badgeCount)"
            
            return cell
            
        } else if tableView == tblGroups {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "GroupsCell", for: indexPath) as! GroupsCell
            
            
            //let dict = self.arrgroupcontact.object(at: indexPath.row) as! groupcontactClass
            let dict = self.arrGroup.object(at: indexPath.row) as! groupcontactClass
            
            cell.lblGroupName.text = dict.groupName
            if dict.badgeCount != 0 {
                cell.lblBatchCount.isHidden = false
            }else {
                cell.lblBatchCount.isHidden = true
            }
            
            cell.lblBatchCount.text = "\(dict.badgeCount)"

            return cell
            
        } else if tableView == tblBoradCast {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardCell", for: indexPath) as! DashboardCell
            
            //let dict = self.arrgroupcontact.object(at: indexPath.row) as! groupcontactClass
            let dict = self.arrBroadCast.object(at: indexPath.row) as! groupcontactClass
            
            cell.lblGroupName.text = dict.groupName
            return cell
            
            
            
        }
            
            
            
        else {
        }
        
        return UITableViewCell()
    }
    var ContactTemp = ContactClass()
    var groupcontactClassTemp = groupcontactClass()
    var idTemp = 0
    var ChatType = ""
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == tblContact {
            ChatType = chatingType.individual
            idTemp = indexPath.row
            let dict = self.arrmessagecontact.object(at: indexPath.row) as! ContactClass
            ContactTemp = dict
            dict.badgeCount = 0
            toId = dict.xmpp_id
            toName = dict.name
            changeBadgeCountInDict(key: "messagecontact", count: 0, id: ContactTemp.xmpp_id, idKey: "xmpp_id")

            actionChat("chat")
        } else if tableView == tblGroups {
            ChatType = chatingType.group

            print("group")
            let ob = self.arrGroup.object(at: indexPath.row) as! groupcontactClass
            //  ContactTemp = ob
            ob.badgeCount = 0
            groupcontactClassTemp = ob
            toId = ob.group_id
            toName = ob.groupName

            changeBadgeCountInDict(key: "groupcontact", count: 0, id: groupcontactClassTemp.group_id, idKey: "group_id")

            actionChat(ob)
        } else {
            ChatType = chatingType.brodcast
            let ob = self.arrBroadCast.object(at: indexPath.row) as! groupcontactClass
            //  ContactTemp = ob
            groupcontactClassTemp = ob
            
            changeBadgeCountInDict(key: "groupcontact", count: 0, id: groupcontactClassTemp.group_id, idKey: "group_id")
            
            print("Broadcast")
            actionChat(ob)
        }
    }
    
    

 //   var vcChat: ChatMohanViewController!
    func pushToChatVC(_ type:Any){
        let vcChat  =  self.storyboard?.instantiateViewController(withIdentifier: "ChatMohanViewController") as! ChatMohanViewController
        
        if ChatType == chatingType.individual {
            vcChat.ContactTemp = self.ContactTemp
            
        }else if ChatType == chatingType.group {
           // vcChat.ContactTemp = ContactClass()
            vcChat.groupcontactClassTemp = self.groupcontactClassTemp
            
            if type is groupcontactClass {
                let ob = type as? groupcontactClass
                vcChat.maPersonContact = ob?.maContacts
            }
            
        }else if ChatType == chatingType.brodcast {
         //   vcChat.ContactTemp = ContactClass()
            vcChat.groupcontactClassTemp = self.groupcontactClassTemp
            
            if type is groupcontactClass {
                let ob = type as? groupcontactClass
                vcChat.maPersonContact = ob?.maContacts
            }
            
        }
        vcChat.fromChattingType = ChatType
        
        oneStreamGetNewMmsg(dict: NSDictionary())
        self.navigationController?.pushViewController(vcChat, animated: false)

    }
//MARK:-
     var toId = "" , toName = ""
    func actionChat(_ type:Any){
        
   
        if OneChat.sharedInstance.isConnected() {
            //print("dict>>>>>>>>\(Dict)")
            let chat = NSMutableDictionary()
            print("toId\(toId)")
            print("toName\(toName)")
            let str1 = toId + ChatConstants().chatHostName
            
            let str2 = string(getUserDetail(), "xmpp_id")
            chat.setObject(str1, forKey: "toId" as NSCopying)
            chat.setObject(toName, forKey: "toName" as NSCopying)
            
            chat.setObject(str2, forKey: "fromId" as NSCopying)
            // chat.setObject(fromImage, forKey: "fromImage" as NSCopying)
            
            print("chat >>>>>> \(chat)")
            kAppDelegate.dictChatInfo = NSMutableDictionary()
            kAppDelegate.dictChatInfo = chat.mutableCopy() as! NSMutableDictionary
            OneChat.sharedInstance.connect(username: str2, password: string(getUserDetail(), "xmpp_pass")) { (stream, error) -> Void in
                self.pushToChatVC(type)
                
                if let _ = error {
                    print("Error connecting \(String(describing: error))")
                    if error!.description == "<failure xmlns=\"urn:ietf:params:xml:ns:xmpp-sasl\"><not-authorized></not-authorized></failure>" {
                        print("mohan test test")
                        UserDefaults.standard.removeObject(forKey: kXMPP.myJID)
                        UserDefaults.standard.removeObject(forKey: kXMPP.myPassword)
                    }
                }
            }
            
        }else {
            self.pushToChatVC(type)
        }
        
    }
   //   self.performSelector(inBackground: #selector(callgetChatThreadinBG), with: nil)
    func callgetChatThreadinBG(){
        
        
    }
  //  var arrTopics = NSMutableArray()
    
    @IBAction func ActionAddBroadcast(_ sender: Any) {
        tfAddBroadcast.text = ""
        self.view.addSubview(viewPopUp)
        viewPopUp.frame = self.view.frame
    }
    @IBOutlet var viewPopupIn: View!
    
    @IBAction func ActionRemovePopup(_ sender: Any) {
        viewPopUp.removeFromSuperview()
    }
    @IBAction func actionCancelPopup(_ sender: Any) {
        viewPopUp.removeFromSuperview()
    }
    @IBAction func actionSubmitPopup(_ sender: Any) {
        viewPopUp.removeFromSuperview()
        wsAddBroadCast()
    }
    
    func wsAddBroadCast() {
        let params = NSMutableDictionary()
       
        params["topic"] = tfAddBroadcast.text
        params["sap_id"] = getSap_id()
        
        Http.instance().json(WebServices.BaseUrl + "user/createTopic", params, "POST", ai: true, popup: true, prnt: true, nil) { (json, params) in
            if (json != nil) {
                
                if string(json as! NSDictionary, "status") == "1" {
                    
                   // self.gatBrodCastDataAndGroupContact()
                    self.ws_contact()
                }
                
            }
        }
    }
    
    
 
    
    func wsBroadCastList(arr : NSMutableArray) {
        let params = NSMutableDictionary()
        print(arr)
        
        let dict = NSMutableDictionary()
        dict["messagecontact"] = arr
        
        params["contacts"] = dict
        params["sap_id"] = getSap_id()
        
        Http.instance().json(WebServices.BaseUrl + "user/updatecontacts", params, "POST", ai: true, popup: true, prnt: true, nil) { (json, params) in
            print(json)
            if (json != nil) {
                //                if string(json as! NSMutableDictionary, "status") == "1" {
                //                }
            }
        }
    }
    
    func uploadData(url: URL, data: Data?, params: [String: String]?, completionHandler: @escaping (Any?) -> Swift.Void)
    {
        let cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData;
        let request = NSMutableURLRequest(url: url, cachePolicy: cachePolicy, timeoutInterval: 6.0);
        request.httpMethod = "POST";
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        
        //if(data == nil)  { ret urn; }
        var body = Data();
        
        if params != nil {
            for (key, value) in params! {
                body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
                body.append("\(value)\r\n".data(using: String.Encoding.utf8)!)
            }
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
    //        print("******* response = \(response)")
            // Print out reponse body
           // let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
           // print("****** response data = \(responseString!)")
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                //     let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                if json != nil {
                   DispatchQueue.main.async {
                        completionHandler(json)
                    }
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
    
    
   
    
    
    let arrSearch = NSArray()
    
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
    
    
    //   var arrTemp = NSMutableArray()
    func search(strSearch:String){
        
        if indexOfView == 0 {
            var arr =  NSMutableArray()
            if strSearch == "" {
                arr = arrMessageTemp
            }else {
                for i in 0 ..< arrMessageTemp.count {
                    let dict = arrMessageTemp.object(at: i) as! ContactClass
                    if dict.name.subString(strSearch) {
                        arr.add(dict)
                    }
                }
            }

            arrmessagecontact = arr
        } else if indexOfView == 1 {
            var arr =  NSMutableArray()

            if strSearch == "" {
                arr = arrGroupTempForSearch
            }else {
            for i in 0 ..< arrGroupTempForSearch.count {
                let dict = arrGroupTempForSearch.object(at: i) as! groupcontactClass
                if dict.groupName.subString(strSearch) {
                    arr.add(dict)
                }
            }
            }
            arrGroup = arr
            
            
        } else {
            var arr =  NSMutableArray()
            
            if strSearch == "" {
                arr = arrBrodCstempForSearch
            }else {
            for i in 0 ..< arrBrodCstempForSearch.count {
                let dict = arrBrodCstempForSearch.object(at: i) as! groupcontactClass
                if dict.groupName.subString(strSearch) {
                    arr.add(dict)
                }
                }
            }
            arrBroadCast = arr
        }
        self.reloadTable()
        
        //  print(" found ---- \(arr)")
    }
    
    var oldData = NSDictionary()
    var update = false
    func updateBadgeCount(){

        if self.oldData.count > 0 {
            if let messagecontact:NSArray = oldData.object(forKey: "messagecontact") as? NSArray  {
                _ = NSMutableArray()
                for i in 0..<messagecontact.count {
                    let dict = messagecontact.object(at: i) as! NSDictionary
                    
                    setBadgeMyDataInDict(key: "messagecontact", count: number(dict, "badge_count").intValue, timeInterval: number(dict, "timeInterval").intValue , id: string(dict, "xmpp_id"), idKey: "xmpp_id")
                }
            }
            
            if let messagecontact:NSArray = oldData.object(forKey: "messagecontact") as? NSArray  {
                _ = NSMutableArray()
                for i in 0..<messagecontact.count {
                    let dict = messagecontact.object(at: i) as! NSDictionary
                    
                    setBadgeMyDataInDict(key: "messagecontact", count: number(dict, "badge_count").intValue, timeInterval: number(dict, "timeInterval").intValue , id: string(dict, "xmpp_id"), idKey: "xmpp_id")
                }
            }
            if let arr:NSArray =   oldData.object(forKey: "groupcontact") as? NSArray  {
                
                let grouplist:NSArray = arr
                
                for i in 0..<arr.count {
                    
                    let dict = grouplist.object(at: i) as! NSDictionary
                    
                      setBadgeMyDataInDict(key: "groupcontact", count: number(dict, "badge_count").intValue, timeInterval: number(dict, "timeInterval").intValue , id: string(dict, "group_id"), idKey: "group_id")
                    
                    //     // contactName.groupcontact
                }
            }
        }
    }
    
    
    //==========
    
    
    
    
    
    func setBadgeMyDataInDict(key: String, count: Int, timeInterval: Int, id: String, idKey: String) {
        
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
                            mutableDict.setValue(timeInterval, forKey: "timeInterval")
                            
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
    
    func calldata(result:NSDictionary) { //convert in object to dict rahul.
        
        
       // Http.instance().startActivityIndicator()
       // self.arrTopics = NSMutableArray()
        self.arrBroadCast = NSMutableArray()
        self.arrGroup = NSMutableArray()
        self.arrgroupcontact = NSMutableArray()
        
        arrmessagecontact = NSMutableArray()
      print("user/updatecontacts ----->result)")
        
//        if let arr:NSArray =   result.object(forKey: "topics") as? NSArray  {
//            for i in 0..<arr.count {
//                let dict = arr.object(at: i) as! NSDictionary
//                let ob = topicClass()
//                ob.topic = string(dict, "topic")
//                ob.id = string(dict, "id")
//                
//                self.arrTopics.add(ob)
//            }
//        }
        
        
        let dictcontact = NSMutableDictionary()
        
        // (dictionary: ["messagecontact":arrmessagecontact,"groupcontact":arrGroup])

        
        //===================== Change Rahul ============================
        
        let obj = seprateGroupBroadcastArray()
        
        arrBroadCast = obj.broadCast
        arrGroup = obj.group
        dictcontact["groupcontact"] = arrGroup
        let tempArrBroadCast = NSMutableArray()
        
        
        for i in 0..<arrBroadCast.count {
            
            let dict = arrBroadCast.object(at: i) as! NSDictionary
            
            let ob = groupcontactClass()
            ob.groupName = string(dict, "groupName")
            ob.groupNo = string(dict, "groupNo")
            ob.created_by = string(dict, "created_by")
            ob.group_id = string(dict, "group_id")
            ob.group_type = string(dict, "group_type")
            ob.maContacts = NSMutableArray()
            
            tempArrBroadCast.add(ob)
        }
        
        arrBroadCast = tempArrBroadCast
        arrBrodCstempForSearch = arrBroadCast
        
        let tempArrGroup = NSMutableArray()
      //  var arrGroup1 : [groupcontactClass] = []
        
        for i in 0..<arrGroup.count {
            
            let dict = arrGroup.object(at: i) as! NSDictionary
            
            let ob = groupcontactClass()
            ob.groupName = string(dict, "groupName")
            ob.groupNo = string(dict, "groupNo")
            ob.created_by = string(dict, "created_by")
            ob.group_id = string(dict, "group_id")
            ob.group_type = string(dict, "group_type")
            ob.badgeCount = number(dict, "badge_count").intValue
            ob.timeInterval = number(dict, "timeInterval").intValue

            ob.maContacts = NSMutableArray()
            
            tempArrGroup.add(ob)
        }
        
        arrGroup = tempArrGroup
        let arrGroup1 = arrGroup as! [groupcontactClass]

      //  arrGroup = arrGroup1.sorted(by: { $0.timeInterval > $1.timeInterval }) as! NSMutableArray   $0.badgeCount > $1.badgeCount ||
        arrGroup = arrGroup1.sorted(by: {   $0.timeInterval > $1.timeInterval }) as! NSMutableArray

        arrGroupTempForSearch = arrGroup

        
        
        //=================================================
        
        
        
        
        if let arr:NSArray =   result.object(forKey: "groupcontact") as? NSArray  {
            
            let grouplist:NSArray = arr
            
            for i in 0..<arr.count {
                
                let dict = grouplist.object(at: i) as! NSDictionary
                
                let ob = groupcontactClass()
                ob.groupName = string(dict, "groupName")
                ob.groupNo = string(dict, "groupNo")
                ob.created_by = string(dict, "created_by")
                ob.group_id = string(dict, "group_id")
                ob.group_type = string(dict, "group_type")
                ob.maContacts = NSMutableArray()
                ob.badgeCount = number(dict, "badge_count").intValue
                ob.timeInterval = number(dict, "timeInterval").intValue

                self.arrgroupcontact.add(ob)
                
                //     // contactName.groupcontact
            }
        }
        
        
        if let grupdetail:NSArray = result.object(forKey: "groupdetail") as? NSArray {
            for i in 0..<grupdetail.count {
                let dict = grupdetail.object(at: i) as! NSDictionary
                //  print(dict)
                let ob = groupdetailClass()
                ob.btrtl = string(dict, "btrtl")
                ob.btrtlTxt = string(dict, "btrtlTxt")
                ob.category = string(dict, "category")
                ob.ename = string(dict, "ename")
                ob.groupNo = string(dict, "groupNo")
                ob.pernr = string(dict, "pernr")
                ob.telnr = string(dict, "telnr")
                ob.pic = string(dict, "pic")
                ob.group_id = string(dict, "group_id")
                self.arrgroupdetail.add(ob)
                
                
                for i in 0..<self.arrGroup.count {
                    let obGC:groupcontactClass = self.arrGroup[i] as! groupcontactClass
                    if ob.group_id == obGC.group_id {
                        //if obGC.group_type == "G" {
                            obGC.maContacts?.add(ob)
                            break
                        //}
                    }
                }
                
                for i in 0..<self.arrBroadCast.count {
                    let obGC:groupcontactClass = self.arrBroadCast[i] as! groupcontactClass
                    if ob.group_id == obGC.group_id {
                        //if obGC.group_type == "T" {
                            obGC.maContacts?.add(ob)
                            break
                        //}
                    }
                }
            }
        }
        
        if let messagecontact:NSArray = result.object(forKey: "messagecontact") as? NSArray  {
            _ = NSMutableArray()
            dictcontact["messagecontact"] = messagecontact

            for i in 0..<messagecontact.count {
                let dict = messagecontact.object(at: i) as! NSDictionary
                //   print(dict)
                let ob = ContactClass()
                ob.btrtlTxt = string(dict, "btrtlTxt")
                ob.category = string(dict, "category")
                ob.name = string(dict, "name")
                ob.pernr10 = string(dict, "pernr10")
                ob.telnr = string(dict, "telnr")
                
                ob.pernr = string(dict, "pernr")
                ob.pic = string(dict, "pic")
                ob.pk_user_id = string(dict, "pk_user_id")
                ob.xmpp_id = string(dict, "xmpp_id")
                //ob.badgeCount = 0
                ob.badgeCount = number(dict, "badge_count").intValue
                ob.timeInterval = number(dict, "timeInterval").intValue
                self.arrmessagecontact.add(ob)
                
            }
            let arrMessageTemp1 = arrmessagecontact as! [ContactClass]
            
           // arrMessageTemp1 = arrMessageTemp1.sorted(by: { $0.badgeCount > $1.badgeCount })
            arrmessagecontact = arrMessageTemp1.sorted(by: {  $0.timeInterval > $1.timeInterval  }) as! NSMutableArray

            arrMessageTemp = self.arrmessagecontact
        }
     //   tblContact.reloadData()
        
        
        DispatchQueue.main.async {
            self.reloadTable()

        }
    //    Http.instance().stopActivityIndicator()

        let uuuudde = UserDefaults.init(suiteName: "group.com.shakti.shaktichat")
      //  print("dictcontact ----\(dictcontact)---dictcontact")

        uuuudde?.removeObject(forKey: "updatecontacts")
        uuuudde?.set(dictcontact, forKey: "updatecontacts")
        uuuudde?.synchronize()

    }
    
    
    
    //MARK: XMPP delegate method
    func oneStream(_ sender: XMPPStream, userIsComposing user: XMPPJID) {
        print("user \(user.user) userIsComposing ")
    }
    func oneStreamGetNewMmsg(dict:NSDictionary){
        
        
        let defaults = UserDefaults.standard

        if let dict:NSDictionary =  defaults.object(forKey: "ContactJson") as? NSDictionary { //data is already there in defaults rahul.
            
            self.calldata(result: dict)
        }
        
    }
    func oneStream(_ sender: XMPPStream, didReceiveMessage message: XMPPMessage, from user: XMPPJID) {
    }
    
    
    
    
    //======================================= Rahul 13 Oct. ========================================
    
    func changeBadgeCountInDict(key: String, count: Int, id: String, idKey: String) {
        
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
    func seprateGroupBYDICT(Dict:NSDictionary) ->  NSMutableArray {
        
        let arrBroadCast = NSMutableArray()
        let arrGroup = NSMutableArray()
        
        if let dict: NSDictionary =  Dict as? NSDictionary {
            
            if let arr = dict.object(forKey: "groupcontact") as? NSArray {
                
                var y = 0
                
                while y < arr.count {
                    
                    if let dict1 = arr.object(at: y) as? NSDictionary {
                        
                        let groupType = string(dict1, "group_type").lowercased() // G -> Group T -> Broadcast
                        
                        
                        if groupType == "t" {
                            
                            arrBroadCast.add(dict1)
                            
                        } else if groupType == "g" {
                            
                            arrGroup.add(dict1)
                        }
                    }
                    
                    y += 1
                }
            }
            
        }
        
        return arrBroadCast
    }

    
    //=======================================Rahul 13 Oct.========================================
}



func seprateGroupBroadcastArray() -> (broadCast: NSMutableArray, group: NSMutableArray) {
    
    let defaults = UserDefaults.standard
    
    let arrBroadCast = NSMutableArray()
    let arrGroup = NSMutableArray()
    
    if let dict: NSDictionary =  defaults.object(forKey: "ContactJson") as? NSDictionary {
        
        if let arr = dict.object(forKey: "groupcontact") as? NSArray {
            
            var y = 0
            
            while y < arr.count {
                
                if let dict1 = arr.object(at: y) as? NSDictionary {
                    
                    let groupType = string(dict1, "group_type").lowercased() // G -> Group T -> Broadcast
                    
                    
                    if groupType == "t" {
                        
                        arrBroadCast.add(dict1)
                        
                    } else if groupType == "g" {
                        
                        arrGroup.add(dict1)
                    }
                }
                
                y += 1
            }
        }
        
        defaults.set(dict, forKey: "ContactJson")
    }
    
    return (arrBroadCast, arrGroup)
}


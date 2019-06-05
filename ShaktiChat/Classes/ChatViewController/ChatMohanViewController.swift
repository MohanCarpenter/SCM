//
//  ChatMohanViewController.swift
//  ShaktiChat
//
//  Created by mac on 26/09/17.
//  Copyright © 2017 himanshuPal_kavya. All rights reserved.
//

import UIKit
import XMPPFramework
import Foundation
import AVFoundation
import MediaPlayer
import MobileCoreServices
import Contacts
import ContactsUI



class ChatMohanViewController: UIViewController , OneMessageDelegate,UIImagePickerControllerDelegate,  UIPopoverControllerDelegate, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate , OnePresenceDelegate,ChatLeftCellDelegate,ChatRightCellDelegate,EPPickerDelegate, AVAudioRecorderDelegate, AVAudioPlayerDelegate,CNContactViewControllerDelegate, URLSessionDownloadDelegate, UITextFieldDelegate, UIScrollViewDelegate ,UIDocumentMenuDelegate,UIDocumentPickerDelegate,UINavigationControllerDelegate , UIWebViewDelegate{
    //
    var moviePlayer : MPMoviePlayerController?
    var file_name = ""
    //   var file_nameTemp = ""
    var contactVC:CNContactViewController? = nil
    var btnShowContacts:UIButton? = nil
    @IBOutlet var viewContacts: UIView!
    @IBOutlet var lblContactsTitle: UILabel!
    @IBOutlet var tblGroupContacts: UITableView!
    let timeInterval = Date().timeIntervalSince1970
    
    var maPersonContact:NSMutableArray? = nil
    var keyBoardHeight:CGFloat = 0.0
    @IBOutlet weak var lblLineReply: UILabel!
    @IBOutlet var viewReplay: UIView!
    @IBOutlet weak var lblReplymsg: UILabel!
    @IBOutlet weak var lblReplyMsgType: UILabel!
    @IBOutlet weak var imgReplayIcon: UIImageView!
    @IBOutlet weak var lblNameReply: UILabel!
    
    var imgData = Data()
    @IBOutlet var lblchatMsg: UILabel!
    var groupcontactClassTemp =  groupcontactClass()
    var fromChattingType = ""
    var ContactTemp = ContactClass()
    @IBOutlet var viewPopup2: UIView!
    @IBOutlet var viewMedia: UIView!
    @IBOutlet var btnBrodCast: UIButton!
    let font = UIFont(name: "Helvetica", size: 16.0)! // HelveticaNeue
    @IBOutlet var viewZoomSub: ImageZoomView!
    
    var widthTextview = 0.0
    @IBOutlet var tblView: UITableView!
    var isComposing = false
    var timer: Timer?
    @IBOutlet weak var tvMessage: UITextView!
    @IBOutlet weak var tvTitle: UITextView!
    @IBOutlet var imgMessagBG: UIImageView!
    
    var topic_id = "", topic_name = ""
    
    var isClick =  Bool()
    @IBOutlet var tblViewTopic: UITableView!
    @IBOutlet var viewTopic: UIView!
    @IBOutlet var btnTopic: UIButton!
    @IBOutlet var btnaudio: UIButton!
    
    var arrTopic = NSMutableArray()
    
    var arrMessages = NSMutableArray()
    var recipient: XMPPUserCoreDataStorageObject?
    var imgSedImage = UIImage()
    var fromUser = ""
    var fromUserDisplay = ""
    var toUser = ""
    @IBOutlet weak var viewMessage: UIView!
    @IBOutlet var lblTyping: UILabel!
    @IBOutlet var lblTitle: UILabel!
    var isGroupType = "I"
    var chat_message_bg = UIImageView()
    var arrAllMSGRecord = NSMutableArray()
    var pageCount = 0
    
    @IBOutlet weak var wbView: UIWebView!
    //  var timerPresence = Timer()
    
    @IBOutlet var btCamera: UIButton!
    @IBOutlet var btnAttachment: UIButton!
    var imgProfilePicture:UIImage? = nil
    var strVideo = ""
    
    var arrContectList = NSMutableArray()
    @IBOutlet var viewPopup: UIView!
    
    var soundRecorder: AVAudioRecorder!
    var soundPlayer:AVAudioPlayer!
    var fileName = "temp_\("\(Int(NSDate().timeIntervalSince1970))").caf"
    var tableHeight:CGFloat = 0.0
    
    var refreshControl: UIRefreshControl!
    
    //MARK:- ------- Life Cycle --------
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //OneMessage.sharedInstance.boolSendMessage =  false

        print("getSap_id ---->\(UserDefaults.standard.object(forKey: "name")!)------\(getSap_id())")
        
        let uDefault = UserDefaults.init(suiteName: "group.com.shakti.shaktichat")
        if let proide =  uDefault?.value(forKey:"itemProvider") {
            print("itemProvider --->\(proide)")
        }
        if let dict11:NSDictionary = uDefault?.value(forKey: "img") as? NSDictionary {
            
            
            let imgData: Data = dict11.value(forKey: "imgData") as! Data
            print("imgData====\(imgData.count)")
            print("name====\(String(describing: dict11.value(forKey: "name")))")
            uDefault?.removeObject(forKey: "img")
            uDefault?.synchronize()
            
            let alert = UIAlertController (title: "Share Extension", message: "name====\(String(describing: dict11.value(forKey: "name")!))", preferredStyle: UIAlertControllerStyle.alert)
            
            self.present(alert, animated: true, completion: nil)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                //== MessagesStringFile().notifLogout()
            }))
        }
        
        
        messageBgImage()
        viewMessage.frame.size.height = tvMessage.frame.size.height + 20
        
        refreshControl = UIRefreshControl()
        
        // refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action:  #selector(self.refresh), for: UIControlEvents.valueChanged)
        tblView.addSubview(refreshControl) // not required when using UITableViewController
        
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.isNavigationBarHidden = true // 1 127 196
        
        
        viewPopup2.frame = self.view.frame
        viewPopup2.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        viewPopup.frame = self.view.frame
        viewPopup.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        btnTopic.backgroundColor = UIColor.white
        tblView.delegate = self
        tblView.dataSource = self
        
        tvMessage.delegate = self
        tvTitle.delegate = self
        tblViewTopic.delegate = self
        tblViewTopic.dataSource = self
        viewPopup2.frame = self.view.frame
        viewPopup2.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        OnePresence.sharedInstance.delegate = self
        OneMessage.sharedInstance.delegate = self
        
        viewPopup2.frame = self.view.frame
        viewPopup2.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        viewPopup.frame = self.view.frame
        viewPopup.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        
        NotificationCenter.default.addObserver (self, selector:#selector(self.keyboardWillShow(notification:)), name:NSNotification.Name.UIKeyboardWillShow,object:nil)
        
        NotificationCenter.default.addObserver(self,selector:#selector(self.keyboardWillHide(notification:)), name:NSNotification.Name.UIKeyboardWillHide, object:nil)
        tableHeight = tblView.frame.size.height
        self.view.addSubview(viewMessage)
        tblView.layoutSubviews()
        //        if ContactTemp.pernr10[0] != "E" {
        //            ContactTemp.pernr10 = "E" + ContactTemp.pernr10
        //        }
        print("to id -->",ContactTemp.pernr,ContactTemp.pernr10 , ContactTemp.xmpp_id , ContactTemp.pk_user_id)
        
        //      db.CreateOpenDB()
        
        widthTextview = Double(self.view.frame.size.width - self.view.frame.size.width/3)
        
        viewMessage.clipsToBounds = true
        
        getTopicList()
        setupRecorder() //rahul.
        showAudioRecordView() //rahul
        
        
        isClick = true
        setViewdefault()
        
        tfSearch.delegate = self
        
        if self.fromChattingType == chatingType.brodcast {
            self.getContactArrayFromDefault()
        }
        self.getDetailFromDataBase()
        
        
        viewMessage.frame.origin.y = tblView.frame.origin.y + tableHeight
        
    }
    func messageBgImage(){
        chat_message_bg.removeFromSuperview()
        // chat_message_bg
        
        viewMessage.frame.size.height = tvMessage.frame.origin.y + tvMessage.frame.size.height  + CGFloat(8.0)
        tvMessage.frame.origin.x = 8
        let bgImageNewX = CGFloat(0.0)
        let bgImageNewWidth = tvMessage.frame.origin.x + tvMessage.frame.size.width + CGFloat(10.0)
        let bgImageNewHeight = tvMessage.frame.origin.y + tvMessage.frame.size.height + CGFloat(6.0)
        
        chat_message_bg = UIImageView(frame: CGRect(x:0.0 ,y: 0.0, width:bgImageNewWidth  ,height: bgImageNewHeight))
        chat_message_bg.image = UIImage(named: "chat_message_bg")?.resizableImage(withCapInsets: UIEdgeInsetsMake(14, 14, 14, 28))
        
        viewMessage.addSubview(chat_message_bg)
        viewMessage.sendSubview(toBack: chat_message_bg)
        
        lblRecording.frame.origin.y = tvMessage.frame.origin.y
        lblchatMsg.frame.origin.y = tvMessage.frame.origin.y
        imgMessagBG.frame = CGRect(x:bgImageNewX, y:bgImageNewX, width: bgImageNewWidth,height: bgImageNewHeight)
    }
    
    
    
    func refresh(sender:AnyObject) {
        refreshControl.endRefreshing()
        print("co --\(arrAllMSGRecord.count - 1)---pageCount\(pageCount)")
        pageCount = pageCount - 1
        if arrAllMSGRecord.count - 1 > pageCount && pageCount > -1 {
            if let dict:NSDictionary = arrAllMSGRecord.object(at: pageCount) as? NSDictionary {
                arrMessages.insert(dict, at: 0)
                DispatchQueue.main.async {
                    self.tblView.reloadData()
                }
            }
        }
        
        //  arrMessages.add()
        // Code to refresh table view
    }
    override func viewDidAppear(_ animated: Bool) {
        //        if fromChattingType == chatingType.individual {
        //
        //            DBManager.shared.updateChatMsg(query: "update ChatTable set status=? where group_id=? and msg_to=? and delivery_type=? and direction=?", values: ["S","0","\(ContactTemp.pernr10)","I","in"])
        //        } else {
        //
        //            DBManager.shared.updateChatMsg(query: "update ChatTable set status=? where group_id=? and delivery_type=? and direction=?", values: ["S","\(groupcontactClassTemp.group_id)","G","in"])
        //        }
        
        if fromChattingType == chatingType.individual {
            DBManagerChat.sharedInstance.prepareToInsert(query: "update ChatTable set status='S' where group_id=0 and msg_to='\(ContactTemp.pernr)' and delivery_type='I' and direction='in'", completionHandler: { (arr) in
                
            })
            // DBManager.shared.updateChatMsg(query: "update ChatTable set status=? where group_id=? and msg_to=? and delivery_type=? and direction=?", values: ["S","0","\(ContactTemp.pernr10)","I","in"])
        } else {
            DBManagerChat.sharedInstance.prepareToInsert(query: "update ChatTable set status='S' where group_id=\(groupcontactClassTemp.group_id) and delivery_type='G' and direction='in'", completionHandler: { (arr) in
                
            })
            //  DBManager.shared.updateChatMsg(query: "update ChatTable set status=? where group_id=? and delivery_type=? and direction=?", values: ["S","\(groupcontactClassTemp.group_id)","G","in"])
        }
    }
    
    // MARK: Show contacts harish Start
    func initShowContactButton () {
        btnShowContacts = UIButton (frame: CGRect(x: 50.0, y: 0.0, width: 100.0, height: 60.0))
        btnShowContacts?.backgroundColor = UIColor.clear
        self.view.addSubview(btnShowContacts!)
        
        //btnShowContacts?.addTarget(self, action: #selector(actionShowContacts), for: .touchUpInside)
        
        btnShowContacts?.addTarget(self, action: #selector(actionShowContacts (_ :)), for: UIControlEvents.touchUpInside)
    }
    func setViewdefault(){
        //   Http.instance().startActivityIndicator()
        
        if kAppDelegate.dictChatInfo.count > 0 {
            let str1 = kAppDelegate.dictChatInfo.object(forKey: "fromId") as? String
            let str2 = kAppDelegate.dictChatInfo.object(forKey: "fromName") as? String
            let str3 = kAppDelegate.dictChatInfo.object(forKey: "toId") as? String
            let str4 = kAppDelegate.dictChatInfo.object(forKey: "toName") as? String
            if str1 != nil && str2 != nil && str3 != nil && str4 != nil {
                if str1 != "" && str3 != "" {
                    fromUser = kAppDelegate.dictChatInfo.object(forKey: "fromId") as! String
                    fromUserDisplay = kAppDelegate.dictChatInfo.object(forKey: "fromName") as! String
                    toUser = kAppDelegate.dictChatInfo.object(forKey: "toId") as! String
                    //       ChatConstants().removeUnreadedMessage(myId: fromUser, otherUserId: toUser)
                }
            }
        }
        
        
        lblTyping.text = ""
        
        
        if fromChattingType == chatingType.individual {
            
            
            
            
            isGroupType = "I"
            lblTitle.text =  ContactTemp.name
            
        } else {
            
            
            
            var str = ""
            if let arr =   maPersonContact{
                for i in 0 ..< arr.count {
                    let ob = maPersonContact?[i] as? groupdetailClass
                    if let name = ob?.ename {
                        if name != "" {
                            str = str + name + ","
                        }
                        
                    }
                }
            }
            lblContactsTitle.text = groupcontactClassTemp.groupName
            
            lblTyping.text = str
            isGroupType = "G"
            initShowContactButton ()
            lblTitle.text = groupcontactClassTemp.groupName
        }
        
        
        btnTopic.setTitle("Topic : None", for: .normal)
        lblRecording.backgroundColor = UIColor.white
        lblchatMsg.text = "Type a message"
        
        
        
        btnAttachment.frame.origin.x =  lblTitle.frame.origin.x +  lblTitle.frame.size.width + 10 + btnAttachment.frame.size.width + 10
        
        btCamera.frame.origin.x =  btnAttachment.frame.origin.x +  btnAttachment.frame.size.width + 10
        btnBrodCast.isHidden = true
        
        if fromChattingType == chatingType.brodcast {
            btnBrodCast.isHidden = false
            btnAttachment.frame.origin.x =  lblTitle.frame.origin.x +  lblTitle.frame.size.width + 10
            btCamera.frame.origin.x =  btnAttachment.frame.origin.x +  btnAttachment.frame.size.width + 10
            btnBrodCast.frame.origin.x =  btCamera.frame.origin.x +  btCamera.frame.size.width + 10
        }
        
        msgOrigin = viewMessage.frame.origin.y
    }
    var msgOrigin:CGFloat = 0.0
    
    @IBAction func actionShowContacts (_ sender: Any) {
        
        if maPersonContact != nil {
            if (maPersonContact?.count)! > 0 {
                //  let ob = maPersonContact?[0] as? groupdetailClass
                
                
                viewContacts.frame = self.view.frame
                self.view.addSubview(viewContacts)
                
                
                
                tblGroupContacts.reloadData()
            } else {
                Http.alert("", "System error!")
            }
        } else {
            Http.alert("", "System error!")
        }
    }
    
    
    @IBAction func btnRemoveContacts(_ sender: Any) {
        viewContacts.removeFromSuperview()
    }
    
    // MARK: Show contacts harish end
    
    override func viewDidDisappear(_ animated: Bool) {
//        OneMessage.sharedInstance.boolSendMessage =  true
//        OneMessage.sharedInstance.SendMessageInBG()

        NotificationCenter.default.removeObserver(NSNotification.Name.UIKeyboardWillShow)
        NotificationCenter.default.removeObserver(NSNotification.Name.UIKeyboardWillHide)
        
    }
    
    
    func keyboardWillShow(notification: NSNotification) {
        
        
        if tvMessage.text.length > 0 {
            btnSendVoiceMessage.isHidden = true
            btnSendTextMessage.isHidden = false
            lblRecording.isHidden = true
        } else {
            btnSendVoiceMessage.isHidden = false
            btnSendTextMessage.isHidden = true
            lblRecording.isHidden = true
        }
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            //     let keyboardHeight = keyboardRectangle.height
            print(keyboardRectangle.height)
            keyBoardHeight = keyboardRectangle.height
            // viewMessage.frame.origin.y =  tblView.frame.origin.y +  viewMessage.frame.size.height + tableHeight - keyboardHeight
            
            
            viewMessage.frame.origin.y = self.view.frame.size.height  - (viewMessage.frame.size.height + keyBoardHeight)
            
            tblView.frame.size.height =  self.view.frame.size.height - (tblView.frame.origin.y + viewMessage.frame.size.height + keyBoardHeight)
            
            //   tblView.frame.size.height = tableHeight - keyboardRectangle.height
            
            // tblView.frame.origin.y +  tableHeight - (viewMessage.frame.origin.y + 12)  //   +  viewMessage.frame.size.height - viewMessage.frame.origin.y
            //     tblView.layoutSubviews()
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        if tvMessage.text.length > 0 {
            btnSendVoiceMessage.isHidden = true
            btnSendTextMessage.isHidden = false
            lblRecording.isHidden = true
        } else {
            btnSendVoiceMessage.isHidden = false
            btnSendTextMessage.isHidden = true
            lblRecording.isHidden = true
        }
        keyBoardHeight = 0.0
        
        if ReplayId != "0" {
            //   tblView.frame.size.height = tableHeight - viewReplay.frame.size.height
            //  viewMessage.frame.origin.y = (tblView.frame.origin.y + tableHeight) - viewReplay.frame.size.height  // self.view.frame.size.height  - viewMessage.frame.size.height
            
            viewMessage.frame.origin.y = self.view.frame.size.height  - viewMessage.frame.size.height // msgOrigin -  keyboardHeight
            tblView.frame.size.height =  self.view.frame.size.height - (tblView.frame.origin.y + viewMessage.frame.size.height)
            
        }else {
            viewMessage.frame.origin.y = self.view.frame.size.height  - viewMessage.frame.size.height // msgOrigin -  keyboardHeight
            
            tblView.frame.size.height = tableHeight
            viewMessage.frame.origin.y = tblView.frame.origin.y + tableHeight  // self.view.frame.size.height  - viewMessage.frame.size.height
            
        }
        
        
        typingStatus(type: "stoptyping")
        //tblView.layoutSubviews()
        
    }
    
    
    //MARK: Notification
    
    func methodToShowAlert(notification: NSNotification) {
        
        let str: String = notification.name.rawValue
        
        if str == "" {
        }
        
        if str == "ShowAlertOnChatScreen" {
            let userInfoCurrent = notification.userInfo! as! [String:AnyObject]
            print("userInfoCurrent >>>>\(userInfoCurrent)")
            let alert = UIAlertController (title: "", message: userInfoCurrent["msg"] as? String, preferredStyle: UIAlertControllerStyle.alert)
            self.present(alert, animated: true, completion: nil)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                //== MessagesStringFile().notifLogout()
            }))
        }
    }
    
    
    //MARK:- sendimage
    func openFileAttachment() {
        isClick = false
        self.view.endEditing(true)
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Take Picture", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
            self.camera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Record Video", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
            self.video()
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func camera() {
        isClick = false
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func video() {
        strVideo = "yes"
        isClick = false
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.sourceType = .camera
            
            imagePicker.mediaTypes = [kUTTypeMovie as String]
            
            imagePicker.allowsEditing = false
            imagePicker.videoQuality = .typeLow
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func photoLibrary() {
        isClick = false
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            
            //imagePicker.mediaTypes = [kUTTypeMovie as String]
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    // Mark : Pickerview Delegate
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        viewPopup.removeFromSuperview()
        picker.dismiss(animated: true, completion: nil)
        isClick = true
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        
        if strVideo == "yes"{
            
            if let fileURL =  info[UIImagePickerControllerMediaURL] as? URL {
                do {
                    encodeVideo(videoURL: fileURL )
                    //                    let videoData = try NSData(contentsOf: fileURL, options: .mappedIfSafe)
                    //                    imgData = videoData as Data
                    self.file_name = "temp_\("\(Int(NSDate().timeIntervalSince1970))").mp4"  // m4a
                    //  file_nameTemp = "mp4"
                    
                    self.view.addSubview(viewPopup2)
                    
                } catch {
                    //   print(error)
                }
            }
            
        }else {
            var img:UIImage? = info[UIImagePickerControllerOriginalImage] as? UIImage
            
            if let iii = info[UIImagePickerControllerEditedImage] as? UIImage {
                img = iii
            }
            
            if let iii = info[UIImagePickerControllerEditedImage] as? UIImage {
                img = iii
                if let data = UIImageJPEGRepresentation(img!, 1.0) {
                    print(data.count)
                    imgData = data
                    img =  UIImage(data: data)
                }
            }
            
            if (img != nil) {
                imgSedImage = img!
                self.file_name =  "temp_\("\(Int(NSDate().timeIntervalSince1970))").jpg"
                // file_nameTemp = "jpg"
                
                self.view.addSubview(viewPopup2)
            }
            
        }
        
        picker.dismiss(animated: true, completion: nil);
        
    }
    
    func stripSecondsFromDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmm"
        let str = dateFormatter.string(from: NSDate() as Date)
        return str
    }
    
    
    
    
    
    
    //    func startTimer() {
    //        //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) { () -> Void in
    //        //self.checkUserStatus()
    //        //}
    //    }
    //
    //    func checkUserStatus() {
    //    }
    // Mark: Private methods
    
    
    func didSelectContact(recipient: XMPPUserCoreDataStorageObject) {
        self.recipient = recipient
        //		if userDetails == nil {
        //                navigationItem.title = recipient.displayName
        //        	}
        if !OneChats.knownUserForJid(jidStr: recipient.jidStr) {
            OneChats.addUserToChatList(jidStr: recipient.jidStr)
        } else {
            //       messages = OneMessage.sharedInstance.loadArchivedMessagesFrom(jid: recipient.jidStr)
            //   finishReceivingMessage(animated: true)
        }
    }
    
    
    
    // MARK:-  IBAction  method overrides
    
    
    @IBAction func btnCloseReply(_ sender: Any) {
        dictReply = NSMutableDictionary()
        
        viewReplay.removeFromSuperview()
        tvMessage.frame.origin.y = 4
        messageBgImage()
        ReplayId = "0"
        
        viewMessage.frame.size.height = tvMessage.frame.size.height + 20
        
        viewMessage.frame.origin.y = self.view.frame.size.height  - (viewMessage.frame.size.height + keyBoardHeight)
        
        tblView.frame.size.height = self.view.frame.size.height - (tblView.frame.origin.y + viewMessage.frame.size.height + keyBoardHeight)
    }
    
    
    @IBAction func btnSendMessage(_ sender: Any) {
        typingStatus(type: "stoptyping")
        
        if tvMessage.text != "" {
            setDefoultTimeSendMessage()
            // var maxId = DBManager.shared.getLastId()
            var maxId = DBManagerChat.sharedInstance.getLastId(query: "select * from ChatTable")
            
            let strMessage = stringEncode(tvMessage.text)
            
            maxId = maxId + 1
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-mm-dd h:mm a"
            
            let dict1 = NSMutableDictionary(dictionary: ["delivery_type":isGroupType, "direction":"out", "downloading":0, "file_path":"", "group_id":groupcontactClassTemp.group_id, "id":maxId, "msg":strMessage, "msg_from":getSap_id(), "msg_timestamp":"\(Int(timeInterval))", "msg_to":  ContactTemp.pernr, "msg_type": "T", "name":  ContactTemp.name, "pk_chat_id": ContactTemp.pk_user_id, "status": "U", "topic": topic_name, "topic_id": topic_id, "xmpp_user": ContactTemp.xmpp_id, "date":dateFormateToGate(format: "MMMM dd, yyyy"), "extra":"", "file":"", "file_name":"", "group_name":groupcontactClassTemp.groupName,  "type":"T","reply_id":ReplayId])
            
            var delivery_type = "G"
            if self.fromChattingType ==  chatingType.individual {
                delivery_type = "I"
            }
            
            
            let  direction = "out", downloading = "0", file_path = "", group_id = groupcontactClassTemp.group_id , msg_timestamp = "\(Int(timeInterval))" , msg_type = "T", status = "U", date = dateFormateToGate(format: "MMMM dd, yyyy"), extra = "", file = "", file_name = "", group_name = groupcontactClassTemp.groupName, time = localToUTCTime(date: dateFormateToGate(format: "h:mm a")), type = "T", reply_id = "\(ReplayId)"
            
            
            
            
            let query111 = "insert into ChatTable (Incid, delivery_type, direction, downloading, file_path, group_id, id, msg, msg_from, msg_timestamp, msg_to, msg_type, name, pk_chat_id, status, topic, topic_id, xmpp_user, date, extra, file, file_name, group_name, time, type, reply_id) values (null, '\(delivery_type)', '\(direction)', '\(downloading)', '\(file_path)', '\(group_id)', '\(maxId)', '\(strMessage)', '\(getSap_id())', '\(msg_timestamp)', '\(ContactTemp.pernr)', '\(msg_type)', '\(ContactTemp.name)', '\(ContactTemp.pk_user_id)', '\(status)', '\(topic_name)', '\(topic_id)', '\(ContactTemp.xmpp_id)', '\(date)', '\(extra)', '\(file)', '\(file_name)', '\(group_name)', '\(time)', '\(type)', '\(reply_id)')"
            print("query111 ===\(query111)")
            
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
            tvMessage.text = ""
            lblchatMsg.isHidden = false
        }
    }
    
    
    
    
    
    @IBAction func actionCancel(_ sender: Any) {
        viewPopup2.removeFromSuperview()
    }
    
    
    @IBAction func actionSend(_ sender: Any) {
        //   if tvTitle.text! != "" && tvTitle.text!.characters.count > 0{
        viewPopup2.removeFromSuperview()
        setDefoultTimeSendMessage()
        var maxId = DBManagerChat.sharedInstance.getLastId(query: "select * from ChatTable")
        
        //  var maxId = DBManager.shared.getLastId()
        
        maxId = maxId + 1
        
        
        uploadData(url: WebServices.uploadFile, data: imgData, params: ["sap_id":getSap_id()], completionHandler: { (json) in
            
            if json != nil {
                let dictJSN = json as? NSDictionary
                print("dictJSN---",dictJSN!)
                
                
                //  let tile =  "temp_\("\(NSDate().timeIntervalSince1970)".replacingOccurrences(of: ".", with: "")).png"
                let delivery_type = self.isGroupType,  direction = "out", downloading = "0", file_path = string(dictJSN!, "file"), group_id = self.groupcontactClassTemp.group_id , msg_timestamp = "\(Int(self.timeInterval))" , msg_type = "F", status = "U", date = dateFormateToGate(format: "MMMM dd, yyyy"), extra = "300_300", file = string(dictJSN!, "file"), file_name = self.file_name, group_name = self.groupcontactClassTemp.groupName, time = localToUTCTime(date: dateFormateToGate(format: "h:mm a")), type = "F"
                
                
                let query111 = "insert into ChatTable (Incid, delivery_type, direction, downloading, file_path, group_id, id, msg, msg_from, msg_timestamp, msg_to, msg_type, name, pk_chat_id, status, topic, topic_id, xmpp_user, date, extra, file, file_name, group_name, time, type, reply_id) values (null, '\(delivery_type)', '\(direction)', '\(downloading)', '\(file_path)', '\(group_id)', '\(maxId)', '\(self.tvTitle.text!)', '\(getSap_id())', '\(msg_timestamp)', '\(self.ContactTemp.pernr)', '\(msg_type)', '\(self.ContactTemp.name)', '\(self.ContactTemp.pk_user_id)', '\(status)', '\(self.topic_name)', '\(self.topic_id)', '\(self.ContactTemp.xmpp_id)', '\(date)', '\(extra)', '\(file)', '\(file_name)', '\(group_name)', '\(time)', '\(type)', '0')"
                
                DBManagerChat.sharedInstance.prepareToInsert(query: query111, completionHandler: { (count) in
                    
                })
                
                let dict1 = NSMutableDictionary(dictionary:["delivery_type":self.isGroupType, "direction":"out", "downloading":0, "file_path":string(dictJSN!, "file"), "group_id": self.groupcontactClassTemp.group_id, "id":maxId, "msg":self.tvTitle.text, "msg_from":"\(getSap_id())", "msg_timestamp":"\(Int(self.timeInterval))", "msg_to":  self.ContactTemp.pernr, "msg_type": "F", "name":  self.ContactTemp.name, "pk_chat_id": self.ContactTemp.pk_user_id, "status": "U", "topic": self.topic_name, "topic_id": self.topic_id, "xmpp_user": self.ContactTemp.xmpp_id, "date":date,"extra":"300_300","file":string(dictJSN!, "file"),"file_name":self.file_name,"group_name": self.groupcontactClassTemp.groupName,"time":time,"type":"F","reply_id": "0"])
                //self.ReplayId = "0"
                
                
                self.objectAddInmyArr(dict: dict1)
                
                let params1  = NSMutableDictionary (dictionary:["sap_id": getSap_id(), "data" : converDictToJson(dict: NSMutableArray(array: [dict1])) ,"device_type":"IOS"])
                self.SyncMessageMultiDataWebServices(params: params1)
            }
            
        })
        // }
        
    }
    
    @IBAction func btnCamera(_ sender: Any) {
        openFileAttachment()
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
        self.dismiss(animated: true, completion: nil)
        kAppDelegate.dictChatInfo = NSMutableDictionary()
    }
    
    
    
    func objectAddInmyArr(dict:NSMutableDictionary){
        var arr = NSMutableArray()
        arr = arrMessages.mutableCopy() as! NSMutableArray
        
        if arr.count > 0 {
            
            let dictTmp = arr.object(at: arr.count - 1) as!  NSDictionary// NSMutableArray
            let dateH1 = string(dictTmp, "date").getDate("MMMM dd, yyyy")
            
            let dfCount = Date().daysBetweenDate(toDate: dateH1)
            print("Date -->\(Date()) with -->\(dateH1) ----differance --\(dfCount)")
            
            
            if dfCount == 0 {
                
                let arr111 = dictTmp.object(forKey: "data") as! NSArray
                var arrTepm = NSMutableArray()
                arrTepm = arr111.mutableCopy() as! NSMutableArray
                arrTepm.add(dict)
                let dictTemp = NSMutableDictionary(dictionary:["data":arrTepm,"msg_timestamp":"\(string(dictTmp, "msg_timestamp"))"] )
                self.workOnTimestamp(dictTemp)
                
                arr.replaceObject(at: arr.count - 1, with: dictTemp)
                
            }else {
                
                let dictTemp = NSMutableDictionary(dictionary:["data":NSArray(array: [dict]),"msg_timestamp":"\(Int(timeInterval))"] )
                self.workOnTimestamp(dictTemp)
                arr.add(dictTemp)
                
                
            }
            //       print("arr ------->\(arr)<---arr")
            
            
            
            arrMessages = arr
            
        }else if arrMessages.count == 0 {
            
            
            let dictTemp = NSMutableDictionary(dictionary:["data":NSArray(array: [dict]),"msg_timestamp":"\(Int(timeInterval))"] )
            //            dict["msg_timestamp"] = "\(Int(timeInterval))"
            //            dict["data"] = NSMutableArray(array: [dict])
            self.workOnTimestamp(dictTemp)
            arrMessages.add(dictTemp)
            print("arrMessages-----\(arrMessages)")
            
        }
        DispatchQueue.main.async {
            
            self.tblView.reloadData()
            self.moveToLastComment()
        }
    }
    
    
    
    func moveToLastComment() {
        if self.tblView.contentSize.height > self.tblView.frame.height {
            // First figure out how many sections there are
            //   if arrMessages.count > 0 {
            let lastSectionIndex = self.tblView!.numberOfSections - 1
            
            // Then grab the number of rows in the last section
            let lastRowIndex = self.tblView!.numberOfRows(inSection: lastSectionIndex) - 1
            
            // Now just construct the index path
            let pathToLastRow = NSIndexPath(row: lastRowIndex, section: lastSectionIndex)
            
            // Make the last row visible
            self.tblView?.scrollToRow(at: pathToLastRow as IndexPath, at: UITableViewScrollPosition.bottom, animated: false)
        }
        
        //   }
    }
    
    
    @IBAction func btnCloseView(_ sender: AnyObject) {
        viewPopup2.removeFromSuperview()
    }
    @IBAction func btnCloseMedia(_ sender: Any) {
        viewMedia.removeFromSuperview()
        if moviePlayer != nil {
            moviePlayer?.stop()
        }
        
    }
    
    
    // MARK:- Chat message Delegates
    
    func oneStream(sender: XMPPStream, didReceiveMessage message: XMPPMessage, from user: String) {
        
    }
    
    func oneStream(sender: XMPPStream, userIsComposing user: String) {
        print("userIsComposing ----->\(user)")
        //		self.showTypingIndicator = !self.showTypingIndicator
        //		self.scrollToBottomAnimated(true)
    }
    
    // Mark: Memory Management
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func oneStream(_ sender: XMPPStream, userIsComposing user: XMPPJID) {
        print("user \(user.user) userIsComposing ")
    }
    
    
    func oneStream(_ sender: XMPPStream, didReceiveMessage message: XMPPMessage, from user: XMPPJID) {
        if message.isChatMessageWithBody() {
            
            //        print("XMPPStream didReceiveMessage --->\(message)")
            //let displayName = user.displayName
            
            //	JSQSystemSoundPlayer.jsq_playMessageReceivedSound()
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
                if string(dictTest, "type") != "" {
                    let type = string(dictTest, "type")
                    if type == "msg" {
                    }else if type == "starttyping" {
                        lblTyping.text = "typing..."
                    }else if type == "stoptyping"  {
                        lblTyping.text = "Online"
                    }else if type == "msgstatus"  {
                        
                        
                        ///
                        var arrTemp = NSMutableArray()
                        arrTemp = self.arrMessages
                        
                        for jjj in 0 ..< arrTemp.count {
                            let dictTmp_00 = arrTemp.object(at: jjj) as!  NSDictionary
                            let dictTmp = dictTmp_00.mutableCopy() as!  NSMutableDictionary// NSMutableArray
                            let arr111_0 = dictTmp.object(forKey: "data") as! NSArray
                            
                            let arr111 = arr111_0.mutableCopy() as! NSMutableArray
                            
                            for i in 0 ..< arr111.count {
                                var dict_0 = NSDictionary()
                                dict_0 = arr111.object(at: i) as! NSDictionary
                                var dict = NSMutableDictionary()
                                dict = dict_0.mutableCopy() as! NSMutableDictionary
                                if string(dict as NSDictionary, "id") == string(dictTest, "id") {
                                    dict.setValue(string(dictTest, "status"), forKey: "status")
                                    arr111.replaceObject(at: i, with: dict)
                                    self.tblView.beginUpdates()
                                    // Insert or delete rows
                                    let indexPath = IndexPath(item: i, section: jjj)
                                    self.tblView.reloadRows(at: [indexPath], with: .automatic)
                                    self.tblView.endUpdates()
                                    
                                    
                                }
                            }
                            
                            dictTmp.setValue(arr111 , forKey:"data")
                            arrMessages.replaceObject(at: jjj , with: dictTmp)
                            
                        }
                        
                    } else {
                        lblTyping.text = ""
                    }
                }
            }
            /*   if let msg: String = message.forName("body")?.stringValue {
             if let from: String = message.attribute(forName: "from")?.stringValue {
             
             //  print("msg >>>>>>> \(msg)")
             
             var data = NSData()
             data = msg.data(using: String.Encoding.utf8)! as NSData
             var decoded:[String: AnyObject] = [:]
             /*
             response = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err1];
             */
             do {
             decoded = try JSONSerialization.jsonObject(with: data as Data, options: []) as! [String: AnyObject]
             // here "decoded" is the dictionary decoded from JSON data
             } catch let error as NSError {
             print(error)
             }
             var strMsg = ""
             if decoded.count > 0 {
             if decoded["text"] != nil {
             strMsg = decoded["text"] as! String
             } else if decoded[ChatConstants().senderMsg] != nil {
             strMsg = decoded[ChatConstants().senderMsg] as! String
             } else {
             strMsg = msg
             }
             } else {
             strMsg = msg
             }
             
             /*    if let attachment: String = message.attribute(forName: "attachment")?.stringValue {
             if let data = Data(base64Encoded: attachment) {
             let fara = String(data: data, encoding: .utf8)
             let message = JSQMessage(senderId: from, senderDisplayName: from, date: NSDate() as Date!, media: fara as! JSQMessageMediaData)
             messages.add(message)
             }else {
             let message = JSQMessage(senderId: from, senderDisplayName: from, date: NSDate() as Date!, text: strMsg)
             messages.add(message)
             
             }
             
             }else {
             
             }*/
             //     let message = JSQMessage(senderId: from, senderDisplayName: from, date: NSDate() as Date!, text: strMsg)
             //   messages.add(message)
             
             
             //					let message = JSQMessage(senderId: from, senderDisplayName: from, date: NSDate(), text: msg)
             //self.lblStatus.text = MessagesStringFile().onlineTxt()
             //  self.finishReceivingMessage(animated: true)
             }
             }
             }
             */
        }
    }
    func setDefoultTimeSendMessage(){
        if fromChattingType == chatingType.individual {
            //            self.groupcontactClassTemp.group_id
            //            self.ContactTemp.xmpp_id
            changeBadgeCountInDict(key: "messagecontact", count: 0, Interval: Int(NSDate().timeIntervalSince1970), id: self.ContactTemp.xmpp_id, idKey: "xmpp_id")
        } else {
            changeBadgeCountInDict(key: "groupcontact", count: 0, Interval: Int(NSDate().timeIntervalSince1970), id: self.groupcontactClassTemp.group_id, idKey: "group_id")
        }
        
    }
    
    func oneStreamGetNewMessage(_ dict: NSDictionary) {
        
        
        
        if string(dict, "delivery_type") == self.isGroupType {
            
            
            OneMessage.sendMessage(converDictToJson(dict: NSMutableDictionary(dictionary: ["type":"msgstatus","status":"S","id": string(dict,"id"), "from":string(getUserDetail(),"xmpp_id"),"from_user_id":getSap_id()])), to: self.toUser, completionHandler: { (stream, message) -> Void in
                
            })
            
            if fromChattingType == chatingType.individual {
                
                DBManagerChat.sharedInstance.prepareToInsert(query: "update ChatTable set status='S' where group_id=0 and msg_to='\(ContactTemp.pernr)' and delivery_type='I' and direction='in'", completionHandler: { (arr) in
                })
            } else  if fromChattingType == chatingType.group {
                DBManagerChat.sharedInstance.prepareToInsert(query: "update ChatTable set status='S' where group_id=\(groupcontactClassTemp.group_id) and delivery_type='G' and direction='in'", completionHandler: { (arr) in
                })
            }
            
            //     print("msg_to --->",string(dict,"msg_from"), self.ContactTemp.pernr)
            if self.fromChattingType == chatingType.individual {
                // if  string(dict,"msg_to").replacingOccurrences(of: "E", with: "") ==  self.ContactTemp.pernr.replacingOccurrences(of: "E", with: ""){
                if  string(dict,"msg_to") ==  self.ContactTemp.pernr{
                    let dict00 = dict.mutableCopy() as! NSMutableDictionary
                    self.arrAllMessageArr.add(dict00)
                    self.gatMessageForReply(dict12: dict00)
                    
                    self.objectAddInmyArr(dict: dict00 )
                    
                    OneMessage.sendMessage(converDictToJson(dict: NSMutableDictionary(dictionary: ["type":"msgstatus","status":"S","id":string(dict,"id"),"from":string(getUserDetail(),"xmpp_id")])), to: self.toUser, completionHandler: {(stream, message) -> Void in
                    })
                    
                }
            }else {
                if  string(dict,"group_id") ==  self.groupcontactClassTemp.group_id{
                    //  self.arrMessages.add(dict)
                    let dict00 = dict.mutableCopy() as! NSMutableDictionary
                    
                    self.gatMessageForReply(dict12: dict00)
                    
                    self.objectAddInmyArr(dict: dict00)
                    
                }
            }
            
        }
        DispatchQueue.main.async {
            self.tblView.reloadData()
            self.moveToLastComment()
        }
    }
    
    func onePresenceDidReceivePresence(status: String) {
        lblTyping.text = status
    }
    
    //MARK:- ---------------------------------------tableview---------------------------
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tblView == tableView {
            return arrMessages.count
        }else {
            return 1
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tblView == tableView {
            let view = UIView()
            view.frame.origin.x = 0
            view.frame.origin.y = 0
            view.frame.size.width = tableView.frame.size.width
            view.frame.size.height = 30
            //view.backgroundColor = UIColor.clear
            
            let lbl = UILabel(frame: view.frame)
            view.addSubview(lbl)
            
            let dict11 = arrMessages.object(at: section) as! NSDictionary
            lbl.text = string(dict11, "harish_day")
            
            lbl.textAlignment = .center
            
            lbl.numberOfLines = 0
            lbl.sizeToFit()
            
            lbl.center = view.center
            lbl.textColor = UIColor.darkGray
            
            lbl.backgroundColor = UIColor.white
            
            lbl.frame.size.width = lbl.frame.size.width + 15
            
            lbl.border(nil, lbl.frame.size.height/2, 0.0)
            
            lbl.font = UIFont.systemFont(ofSize: 12)
            
            return view
        } else {
            return nil
        }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tblView == tableView {
            let dict11 = arrMessages.object(at: section) as! NSDictionary
            
            //            let str = string(dict11, "msg_timestamp")
            //            let date = Date(timeIntervalSince1970: TimeInterval(string(dict11, "msg_timestamp"))!)
            //            let dateFormatter = DateFormatter()
            //            dateFormatter.dateFormat = "dd-MM-yyyy"
            //            dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
            return string(dict11, "harish_day")
        }else {
            return nil
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tblView == tableView {
            return 30
        }else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tblGroupContacts == tableView {
            return 82
        } else if tableView == tblContact {
            return tblContact.rowHeight
        }  else if tblViewTopic == tableView {
            return 50
        }else if tblView == tableView {
            let dict11 = arrMessages.object(at: indexPath.section) as! NSDictionary
            let arr = dict11.object(forKey: "data") as! NSArray
            let dict = arr.object(at: indexPath.row) as! NSDictionary
            
            //let dict = dictTmp0.ob
            
            var height = 0.0
            let msg :String = string(dict, "msg")
            let te = string(dict, "topic")
            var  message = msg
            if te.length > 1{
                message = message + "\nTopic: \(te)"
            }
            if let str = stringDecode(message) {
                message = str
            }
            
            if string(dict, "direction") == "in"  && fromChattingType != chatingType.individual {
                message = message + "name \n"
            }
            if getMSGType(dict) == "F" {
                let fileType = string(dict, "file_name")
                if fileType.range(of:".jpg") != nil  ||  fileType.range(of:".png") != nil  {
                    
                    height = Double(heightTextVIewconstraintedWidth(width: CGFloat(widthTextview), font: font, msg: message))
                    height = height +  widthTextview + 8
                }else {
                    let  msg1 = "test /n" + message
                    
                    height = Double(heightTextVIewconstraintedWidth(width: CGFloat(widthTextview), font: font, msg: msg1))
                    height = height + 30 // 35 is icone size
                }
                
            }else{
                
                height = Double(heightTextVIewconstraintedWidth(width: CGFloat(widthTextview), font: font, msg: message))
                if let _: NSDictionary = dict.object(forKey: "reply_data") as? NSDictionary {
                    let fileType = string(dictReply, "file_name")
                    if fileType.range(of:".jpg") != nil  ||  fileType.range(of:".png") != nil  {
                        height = height + 70
                        
                    }else {
                        height = height + 50
                        
                    }
                    
                }
                //     print("height msg -----height------\(height)   width ==  \(widthTextview)")
                
            }
            height  = height + 30
            
            return CGFloat(height)
        }else {
            return 0.0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tblGroupContacts == tableView {
            if maPersonContact != nil {
                return (maPersonContact?.count)!
            } else {
                return 0
            }
        } else if tblViewTopic == tableView {
            return arrTopic.count
        } else if tableView == tblContact {
            
            print("arrContact.count -\(arrContact.count)-")
            
            return arrContact.count
        } else  if tblView == tableView  {
            let dict11 = arrMessages.object(at: section) as! NSDictionary
            let arr = dict11.object(forKey: "data") as! NSArray
            
            
            return arr.count
        }else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if tblGroupContacts == tableView {
            
            let ob = maPersonContact?[indexPath.row] as? groupdetailClass
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "GroupChatContactsCell", for: indexPath) as! GroupChatContactsCell
            
            cell.lblName.text = ob?.ename
            cell.lblGroupName.text = ob?.btrtlTxt
            cell.lblMobileNumber.text = ob?.telnr
            
            cell.imgPicture.uiimage(ob?.pic, "profile.png", true, nil)
            
            cell.selectionStyle = .none
            return cell
        } else if tableView == tblView {
            let dict11 = arrMessages.object(at: indexPath.section) as! NSDictionary
            
            let arr = dict11.object(forKey: "data") as! NSArray
            
            let dict = arr.object(at: indexPath.row) as! NSDictionary
            
            
            //   print(dict)
            //  if dict.object(forKey: "direction") != nil {
            
            if string(dict, "direction").subString("out") {
                
                //  if "\(dict.object(forKey: "direction")!)".subString("out") {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRightCell", for: indexPath) as! ChatRightCell
                cell.delegate = self
                cell.imgData.frame.origin  = CGPoint(x: 0, y: 0)
                cell.imgReplyImgData.isHidden = true
                cell.viewSelf  = self.view
                cell.tvMesage.font = font
                
                cell.dict = dict
                
                if let msg1 :String = dict.object(forKey: "msg") as? String {
                    var message = msg1
                    
                    let te = string(dict, "topic")
                    
                    if te.length > 1{
                        message = message + "\nTopic: \(te)"
                    }
                    if let str = stringDecode(message) {
                        message = str
                    }
                    
                    cell.tvMesage.text = message
                    
                    //  cell.imgBg.backgroundColor = UIColor(red: 225/255, green: 255/255, blue: 199/255, alpha: 1)
                    
                    cell.tvMesage.frame = CGRect(x: 0, y: 0, width: widthTextview, height: 30)
                    //  cell.tvMesage.textAlignment  = .right
                    cell.viewBg.frame = CGRect(x: cell.frame.size.width - CGFloat(widthTextview + 15), y: 0.0, width: CGFloat(widthTextview + 16), height:  cell.imgBg.frame.size.height)
                    
                    cell.tvMesage.frame.size.width  = CGFloat(widthTextview)  //cell.lblDate.frame.size.width
                    cell.tvMesage.sizeToFit()
                    if cell.tvMesage.frame.size.width < 100 {
                        cell.tvMesage.frame.size.width = 100
                    }
                    cell.lblDate.frame.size.width = CGFloat(widthTextview)
                    cell.lblDate.text = UTCToLocalTime(date: string(dict, "time"))
                    cell.viewReplay.isHidden = true
                    var imageTrue = Bool()
                    cell.btnCellAction.isHidden = true
                    if getMSGType(dict) == "F" {
                        let fileType = string(dict, "file_name")
                        cell.tvMesage.frame.size.width = CGFloat(widthTextview)
                        imageTrue = false
                        if  fileType.range(of:".mp3") != nil ||  fileType.range(of:".caf") != nil  || fileType.range(of:".m4a") != nil {
                            cell.tvMesage.text = ""
                            var attributedString :NSMutableAttributedString!
                            attributedString = NSMutableAttributedString(attributedString:NSAttributedString(string: ""))
                            let textAttachment = NSTextAttachment()
                            
                            textAttachment.image = UIImage(named:"ic_thumb_audio48.png")
                            let oldWidth = textAttachment.image!.size.width;
                            let scaleFactor =  oldWidth / 25//(cell.tvMessage.frame.size.width - 10);
                            textAttachment.image = UIImage(cgImage: textAttachment.image!.cgImage!, scale: scaleFactor, orientation: .up)
                            let attrStringWithImage = NSAttributedString(attachment: textAttachment)
                            attributedString.append(attrStringWithImage)
                            
                            let attributetMSG = NSMutableAttributedString(attributedString:NSAttributedString(string: "Audio \n" + message))
                            attributedString.append(attributetMSG)
                            cell.tvMesage.attributedText = attributedString
                            cell.tvMesage.sizeToFit()
                            cell.imgData.frame = CGRect(x: 0.0, y: 0.0, width: widthTextview, height: 0.0)
                            
                        }else   if fileType.range(of:".jpg") != nil  ||  fileType.range(of:".png") != nil  {
                            cell.btnCellAction.isHidden = true
                            cell.tvMesage.text = message
                            
                            imageTrue = true
                            let url = WebServices.chatgetFile + string(dict, "file")
                            let URL =  NSURL(string: url)
                            cell.imgData.image = UIImage(named: "imageBG.png")
                            
                            cell.imgData.sd_setImage(with: URL as URL!, placeholderImage: UIImage(named: ""),  options: SDWebImageOptions.retryFailed)
                            cell.imgData.frame  = CGRect(x: 5, y: 8, width: widthTextview, height: widthTextview)
                            
                            cell.imgData.setImage(self.view, url, nil, true, nil)
                        }else if fileType.range(of:".mp4") != nil {
                            cell.tvMesage.text = ""
                            var attributedString :NSMutableAttributedString!
                            attributedString = NSMutableAttributedString(attributedString:cell.tvMesage.attributedText)
                            let textAttachment = NSTextAttachment()
                            
                            textAttachment.image = UIImage(named:"ic_thumb_video.png")
                            
                            let oldWidth = textAttachment.image!.size.width;
                            
                            let scaleFactor =  oldWidth / 25//(cell.tvMessage.frame.size.width - 10);
                            textAttachment.image = UIImage(cgImage: textAttachment.image!.cgImage!, scale: scaleFactor, orientation: .up)
                            let attrStringWithImage = NSAttributedString(attachment: textAttachment)
                            attributedString.append(attrStringWithImage)
                            
                            cell.tvMesage.text = "Video \n" + message
                            let attributetMSG = NSMutableAttributedString(attributedString:cell.tvMesage.attributedText)
                            attributedString.append(attributetMSG)
                            cell.tvMesage.attributedText = attributedString
                            cell.tvMesage.sizeToFit()
                            
                            cell.imgData.frame = CGRect(x: 0.0, y: 0.0, width: widthTextview, height: 0.0)
                            
                        }else if fileType.range(of:".vcf") != nil {
                            cell.tvMesage.text = ""
                            var attributedString :NSMutableAttributedString!
                            attributedString = NSMutableAttributedString(attributedString:cell.tvMesage.attributedText)
                            let textAttachment = NSTextAttachment()
                            
                            textAttachment.image = UIImage(named:"ic_thumb_contact.png")
                            
                            let oldWidth = textAttachment.image!.size.width;
                            
                            let scaleFactor =  oldWidth / 25//(cell.tvMessage.frame.size.width - 10);
                            textAttachment.image = UIImage(cgImage: textAttachment.image!.cgImage!, scale: scaleFactor, orientation: .up)
                            let attrStringWithImage = NSAttributedString(attachment: textAttachment)
                            attributedString.append(attrStringWithImage)
                            
                            cell.tvMesage.text = "Contact \n" + message
                            let attributetMSG = NSMutableAttributedString(attributedString:cell.tvMesage.attributedText)
                            attributedString.append(attributetMSG)
                            cell.tvMesage.attributedText = attributedString
                            cell.tvMesage.sizeToFit()
                            
                            cell.imgData.frame = CGRect(x: 0.0, y: 0.0, width: widthTextview, height: 0.0)
                            
                        }else {
                            cell.tvMesage.text = ""
                            var attributedString :NSMutableAttributedString!
                            attributedString = NSMutableAttributedString(attributedString:cell.tvMesage.attributedText)
                            let textAttachment = NSTextAttachment()
                            
                            textAttachment.image = UIImage(named:"pdf.png")
                            
                            let oldWidth = textAttachment.image!.size.width;
                            
                            let scaleFactor =  oldWidth / 25//(cell.tvMessage.frame.size.width - 10);  pdf.png
                            textAttachment.image = UIImage(cgImage: textAttachment.image!.cgImage!, scale: scaleFactor, orientation: .up)
                            let attrStringWithImage = NSAttributedString(attachment: textAttachment)
                            attributedString.append(attrStringWithImage)
                            
                            cell.tvMesage.text = "PDF Document \n" + message
                            let attributetMSG = NSMutableAttributedString(attributedString:cell.tvMesage.attributedText)
                            attributedString.append(attributetMSG)
                            cell.tvMesage.attributedText = attributedString
                            cell.tvMesage.sizeToFit()
                            cell.imgData.frame = CGRect(x: 0.0, y: 0.0, width: widthTextview, height: 0.0)
                            
                        }
                        //   cell.imgData.frame.size = CGSize(width: widthTextview, height: widthTextview)
                        if cell.tvMesage.frame.size.width < 100 {
                            cell.tvMesage.frame.size.width = 100
                        }
                        
                        if imageTrue {
                            
                            cell.tvMesage.frame = CGRect(x:0.0 , y: cell.imgData.frame.origin.y + cell.imgData.frame.size.height, width: cell.imgData.frame.size.width, height: cell.tvMesage.frame.size.height)
                            
                            cell.lblDate.frame = CGRect(x: 8 , y: cell.tvMesage.frame.origin.y + cell.tvMesage.frame.size.height, width: cell.lblDate.frame.size.width - 24, height: 20)
                            
                            cell.imgCheckBox.frame =  CGRect(x: CGFloat(widthTextview) - 8 , y: cell.tvMesage.frame.origin.y + cell.tvMesage.frame.size.height, width: 16, height: 16)
                            
                            cell.imgBg.frame = CGRect(x: 2.0, y: 0.0, width: CGFloat(widthTextview + 12), height: cell.lblDate.frame.origin.y +  cell.lblDate.frame.size.height + 2)
                            //  cell.imgBg.layer.cornerRadius = 10
                            
                            cell.viewBg.frame = CGRect(x: cell.frame.size.width -  CGFloat(widthTextview + 22), y: 0.0, width: CGFloat(widthTextview + 22), height:  cell.imgBg.frame.size.height + 5)
                        }else {
                            cell.imgCheckBox.frame.origin.x  = CGFloat(widthTextview) - 8
                            
                            cell.imgData.frame.size = CGSize(width: 0.0, height: 0.0)
                            
                            cell.lblDate.sizeToFit()
                            
                            cell.tvMesage.frame = CGRect(x: CGFloat(widthTextview) - cell.tvMesage.frame.size.width, y: 0, width: cell.tvMesage.frame.size.width, height: cell.tvMesage.frame.size.height)
                            
                            cell.imgCheckBox.frame =  CGRect(x:  CGFloat(widthTextview) - 16  , y: cell.tvMesage.frame.origin.y + cell.tvMesage.frame.size.height, width: 16, height: 16)
                            
                            
                            cell.lblDate.frame = CGRect(x: CGFloat(widthTextview) - (cell.lblDate.frame.size.width + 16), y: cell.tvMesage.frame.origin.y + cell.tvMesage.frame.size.height, width: cell.lblDate.frame.size.width, height: 20)
                            
                            /*  if (16 + cell.lblDate.frame.size.width) > (cell.tvMesage.frame.size.width) {
                             cell.imgBg.frame.size.width  = cell.lblDate.frame.size.width + 24
                             
                             cell.imgBg.frame = CGRect(x:CGFloat(widthTextview) - (cell.imgBg.frame.size.width - 4), y: 0.0, width: cell.imgBg.frame.size.width + 8, height: cell.lblDate.frame.origin.y +  cell.lblDate.frame.size.height + 5)
                             
                             }else {
                             
                             
                             }*/
                            cell.imgBg.frame = CGRect(x:CGFloat(widthTextview) - (cell.tvMesage.frame.size.width - 4), y: 0.0, width: cell.tvMesage.frame.size.width + 8, height: cell.lblDate.frame.origin.y +  cell.lblDate.frame.size.height + 6)
                            
                            //  cell.imgBg.layer.cornerRadius = 8
                            
                            cell.viewBg.frame = CGRect(x: cell.frame.size.width - CGFloat(widthTextview + 16), y: 0.0, width: CGFloat(widthTextview + 16), height:  cell.imgBg.frame.size.height)
                        }
                        //   cell.imgData.image = UIImage(named:"nature-wallpapers-38")
                        
                        
                        
                    }else {
                        
                        if let dictReply: NSDictionary = dict.object(forKey: "reply_data") as? NSDictionary {
                            cell.viewReplay.isHidden = false
                            cell.imgData.image = nil
                            cell.lblNameReply.text = string(dictReply, "name")
                            
                            cell.viewReplay.backgroundColor = UIColor(red: 233/255, green: 237/255, blue: 231/255, alpha: 1)
                            
                            cell.lblReplymsg.text = string(dictReply, "msg")
                            
                            cell.lblLineReply.frame.size.height = cell.imgReplyImgData.frame.origin.y + cell.imgReplyImgData.frame.size.height
                            
                            cell.imgData.image = nil
                            
                            let fileType = string(dictReply, "file_name")
                            
                            if  fileType.range(of:".mp3") != nil  || fileType.range(of:".caf") != nil  || fileType.range(of:".m4a") != nil {
                                cell.lblReplyMsgType.text  = "Audio"
                                cell.imgReplayIcon.image = UIImage(named:"ic_thumb_audio48.png")
                                cell.lblLineReply.frame.size.height = cell.imgReplayIcon.frame.origin.y + cell.imgReplayIcon.frame.size.height
                            }else   if fileType.range(of:".jpg") != nil  ||  fileType.range(of:".png") != nil  {
                                imageTrue = true
                                cell.lblReplyMsgType.text  = "Photo"
                                let url = WebServices.chatgetFile + string(dictReply, "file")
                                let URL =  NSURL(string: url)
                                cell.imgReplyImgData.image = UIImage(named: "imageBG.png")
                                cell.imgReplyImgData.sd_setImage(with: URL as URL!, placeholderImage: UIImage(named: ""),  options: SDWebImageOptions.retryFailed)
                                cell.imgReplayIcon.image = UIImage(named:"imageDemo.png")
                                cell.lblLineReply.frame.size.height = cell.imgReplyImgData.frame.origin.y + cell.imgReplyImgData.frame.size.height
                            }else if fileType.range(of:".mp4") != nil  {
                                cell.lblReplyMsgType.text  = "Video"
                                cell.imgReplayIcon.image = UIImage(named:"ic_thumb_video.png")
                                cell.lblLineReply.frame.size.height = cell.imgReplayIcon.frame.origin.y + cell.imgReplayIcon.frame.size.height
                            }else if  fileType.range(of:".vcf") != nil {
                                cell.imgReplayIcon.image = UIImage(named:"ic_thumb_contact.png")
                                cell.lblReplyMsgType.text  = "Contact"
                                cell.lblLineReply.frame.size.height = cell.imgReplayIcon.frame.origin.y + cell.imgReplayIcon.frame.size.height
                            }else if  fileType.range(of:".pdf") != nil  {
                                cell.imgReplayIcon.image = UIImage(named:"pdf.png")
                                cell.lblReplyMsgType.text  = "PDF Document"
                                cell.lblLineReply.frame.size.height = cell.imgReplayIcon.frame.origin.y + cell.imgReplayIcon.frame.size.height
                                
                            }else {
                                cell.lblReplyMsgType.sizeToFit()
                                cell.lblLineReply.frame.size.height = cell.lblReplyMsgType.frame.origin.y + cell.lblReplyMsgType.frame.size.height
                                
                            }
                            
                            cell.lblReplyMsgType.sizeToFit()
                            
                            //   cell.lblLineReply.frame.size.height = cell.imgReplyImgData.frame.origin.y + cell.imgReplyImgData.frame.size.height
                            //                            cell.viewReplay.frame.origin.x =  cell.tvMesage.frame.origin.x + 8
                            //                            cell.viewReplay.frame.size.height = cell.lblLineReply.frame.origin.y + cell.lblLineReply.frame.size.height
                            
                            cell.viewReplay.frame = CGRect(x: 8, y: 8.0, width: CGFloat(widthTextview) - 16.0, height: cell.lblLineReply.frame.origin.y + cell.lblLineReply.frame.size.height)
                            
                            
                            cell.imgData.frame = CGRect(x: 0.0, y: 0.0, width: 0.0, height: cell.viewReplay.frame.origin.y + cell.viewReplay.frame.size.height)
                            
                            
                            cell.tvMesage.frame = CGRect(x:0.0 , y: cell.imgData.frame.origin.y + cell.imgData.frame.size.height, width: CGFloat(widthTextview), height: cell.tvMesage.frame.size.height)
                            
                            cell.lblDate.frame = CGRect(x: 8 , y: cell.tvMesage.frame.origin.y + cell.tvMesage.frame.size.height, width: cell.lblDate.frame.size.width - 24, height: 18)
                            
                            cell.imgCheckBox.frame =  CGRect(x: CGFloat(widthTextview) - 8 , y: cell.tvMesage.frame.origin.y + cell.tvMesage.frame.size.height, width: 16, height: 16)
                            
                            cell.imgBg.frame = CGRect(x: 2.0, y: 0.0, width: CGFloat(widthTextview + 12), height: cell.lblDate.frame.origin.y +  cell.lblDate.frame.size.height + 2)
                            //  cell.imgBg.layer.cornerRadius = 10
                            
                            cell.viewBg.frame = CGRect(x: cell.frame.size.width -  CGFloat(widthTextview + 22), y: 0.0, width: CGFloat(widthTextview + 22), height:  cell.imgBg.frame.size.height + 2)
                            
                            
                        }else {
                            cell.imgCheckBox.frame.origin.x  = CGFloat(widthTextview) - 8
                            
                            cell.imgData.frame.size = CGSize(width: 0.0, height: 0.0)
                            
                            cell.lblDate.sizeToFit()
                            
                            cell.tvMesage.frame = CGRect(x: CGFloat(widthTextview) - cell.tvMesage.frame.size.width, y: 0, width: cell.tvMesage.frame.size.width, height: cell.tvMesage.frame.size.height)
                            
                            cell.imgCheckBox.frame =  CGRect(x:  CGFloat(widthTextview) - 16  , y: cell.tvMesage.frame.origin.y + cell.tvMesage.frame.size.height, width: 16, height: 16)
                            
                            
                            cell.lblDate.frame = CGRect(x: CGFloat(widthTextview) - (cell.lblDate.frame.size.width + 16), y: cell.tvMesage.frame.origin.y + cell.tvMesage.frame.size.height, width: cell.lblDate.frame.size.width, height: 20)
                            
                            
                            cell.imgBg.frame = CGRect(x:CGFloat(widthTextview) - (cell.tvMesage.frame.size.width - 4), y: 0.0, width: cell.tvMesage.frame.size.width + 8, height: cell.lblDate.frame.origin.y +  cell.lblDate.frame.size.height + 6)
                            
                            //   cell.imgBg.layer.cornerRadius = 8
                            cell.viewBg.frame = CGRect(x: cell.frame.size.width - CGFloat(widthTextview + 16), y: 0.0, width: CGFloat(widthTextview + 16), height:  cell.imgBg.frame.size.height)
                        }
                    }
                    
                    // if ic_tick_18.png
                    if "\(dict.object(forKey: "status")!)".subString("U") { // ic_clock_18.png
                        cell.imgCheckBox.image = UIImage(named:"ic_clock_18.png")
                    }else if "\(dict.object(forKey: "status")!)".subString("P") {
                        cell.imgCheckBox.image = UIImage(named:"ic_tick_18.png")
                    }else if "\(dict.object(forKey: "status")!)".subString("D") {
                        cell.imgCheckBox.image = UIImage(named:"ic_tick_double_18.png")
                    }else if "\(dict.object(forKey: "status")!)".subString("S") {
                        cell.imgCheckBox.image = UIImage(named:"ic_tick_double_blue_18.png")
                    } else {
                        cell.imgCheckBox.image = UIImage()
                    }
                    
                    cell.imgCheckBox.frame.origin.x  = CGFloat(widthTextview) - 8
                    
                    cell.btnCellAction.frame = cell.viewBg.frame
                }
                
                
                if cell.imageViewBG.isDescendant(of: cell.viewBg) {
                    cell.imageViewBG.removeFromSuperview()
                }
                let repsotionXFactor:CGFloat = cell.imgBg.frame.origin.x - 5.0 // data.type == .Mine ? 0.0 : -8.0
                let bgImageNewX =  repsotionXFactor
                let bgImageNewWidth =  cell.imgBg.frame.size.width + CGFloat(12.0)
                let bgImageNewHeight =  cell.lblDate.frame.origin.y + cell.lblDate.frame.size.height  + CGFloat(5.0)
                
                
                cell.imageViewBG = UIImageView(frame: CGRect(x:repsotionXFactor,y: 0.0,width:bgImageNewWidth ,height: bgImageNewHeight))
                cell.imageViewBG.image = UIImage(named: "bubbleMineRight")?.resizableImage(withCapInsets: UIEdgeInsetsMake(14, 14, 14, 28))
                //
                
                cell.viewBg.addSubview(cell.imageViewBG)
                cell.viewBg.sendSubview(toBack: cell.imageViewBG)
                
                cell.imageViewBG.frame = CGRect(x:bgImageNewX, y:0.0, width: bgImageNewWidth,height: bgImageNewHeight)
                
                
                
                cell.imgData.backgroundColor = UIColor.clear
                cell.imgBg.backgroundColor = UIColor.clear
                cell.viewBg.backgroundColor = UIColor.clear
                
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ChatLeftCell", for: indexPath) as! ChatLeftCell
                cell.delegate = self
                cell.dict = dict
                cell.section = indexPath.section
                cell.index = indexPath.row
                // cell.imgBG.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
                //  cell.imgBG.image = UIImage(named: "chat_bubble_white.png")
                cell.tvMessage.font = font
                cell.viewReplay.isHidden = true
                cell.viewSelf  = self.view
                if let msb :String = dict.object(forKey: "msg") as? String{
                    var message = msb
                    cell.tvMessage.attributedText = nil
                    cell.tvMessage.text = nil
                    
                    let te = string(dict, "topic")
                    
                    if te.length > 1{
                        message = message + "\nTopic: \(te)"
                    }
                    if let str =  stringDecode(message) {
                        message = str
                    }
                    
                    cell.tvMessage.textColor = UIColor.black
                    
                    //    cell.tvMessage.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.6)
                    cell.viewbg.frame = CGRect(x:  0, y: 0.0, width: CGFloat(widthTextview + 16), height:  cell.imgBG.frame.size.height)
                    
                    cell.imgData.frame.size = CGSize(width: 0.0, height: 0.0)
                    
                    cell.lblDate.frame.size.width = CGFloat(widthTextview)
                    
                    cell.lblDate.text = string(dict, "time") //time// "Today"
                    cell.lblDate.sizeToFit()
                    
                    
                    let attributedString = NSMutableAttributedString(string: "")
                    
                    
                    
                    
                    
                    cell.lblFromName.text = ""
                    cell.lblFromName.font = font
                    if fromChattingType == chatingType.group {
                        //  var attributeName = NSMutableAttributedString(string: "")
                        //                        nameSender =  string(dict, "name") + "\n "
                        //                        attributeName = NSMutableAttributedString(attributedString: NSAttributedString(string: nameSender))
                        cell.lblFromName.text = string(dict, "name")
                        //    attributeName = NSMutableAttributedString(string: nameSender, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 18.0)!])
                        
                        //   attributeName.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 1/255, green: 127/255, blue: 198/255, alpha: 1.0), range: NSMakeRange(0, nameSender.length))
                        //  attributedString.append(attributeName)
                    }
                    cell.lblFromName.sizeToFit()
                    
                    
                    
                    cell.btnCellAction.isHidden = true
                    
                    //    cell.btnCellAction.isHidden = false
                    
                    cell.lblFromName.frame = CGRect(x: 12.0, y: 4.0, width: Double(cell.lblFromName.frame.size.width), height: Double(cell.lblFromName.frame.size.height))
                    
                    cell.tvMessage.frame = CGRect(x: 8, y: Double(cell.lblFromName.frame.origin.y + cell.lblFromName.frame.size.height), width: widthTextview, height: 30)
                    
                    var imageTrue = Bool()
            
                    if getMSGType(dict) == "F" {
                        let fileType = string(dict, "file_name")
                        imageTrue = false
                        //  cell.tvMessage.frame.size.width = CGFloat(widthTextview)
                        
                        if  fileType.range(of:".mp3") != nil || fileType.range(of:".caf") != nil  || fileType.range(of:".m4a") != nil {
                            imageTrue = true
                            
                            let textAttachment = NSTextAttachment()
                            textAttachment.image = UIImage(named:"ic_thumb_audio48.png")
                            let oldWidth = textAttachment.image!.size.width
                            let scaleFactor =  oldWidth / 25//(cell.tvMessage.frame.size.width - 10);
                            textAttachment.image = UIImage(cgImage: textAttachment.image!.cgImage!, scale: scaleFactor, orientation: .up)
                            let attrStringWithImage = NSAttributedString(attachment: textAttachment)
                            attributedString.append(attrStringWithImage)
                            
                            attributedString.append( NSMutableAttributedString(attributedString:NSMutableAttributedString(attributedString:NSAttributedString(string: "Audio \n" + message))))
                            
                            //   attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 1/255, green: 127/255, blue: 198/255, alpha: 1.0), range: NSMakeRange(nameSender.length, attributedString.string.length))
                            
                            
                            cell.imgData.frame = CGRect(x: 8.0, y:  Double(cell.lblFromName.frame.origin.y + cell.lblFromName.frame.size.height), width: widthTextview, height: 0.0)
                            
                        }else if fileType.range(of:".mp4") != nil  {
                            imageTrue = true
                            let textAttachment = NSTextAttachment()
                            textAttachment.image = UIImage(named:"ic_thumb_video.png")
                            
                            let oldWidth = textAttachment.image!.size.width;
                            
                            let scaleFactor =  oldWidth / 25//(cell.tvMessage.frame.size.width - 10);
                            textAttachment.image = UIImage(cgImage: textAttachment.image!.cgImage!, scale: scaleFactor, orientation: .up)
                            let attrStringWithImage = NSAttributedString(attachment: textAttachment)
                            attributedString.append(attrStringWithImage)
                            attributedString.append(NSMutableAttributedString(attributedString:NSMutableAttributedString(attributedString:NSAttributedString(string: "Video \n" + message))))
                            
                            cell.imgData.frame = CGRect(x: 8.0, y:  Double(cell.lblFromName.frame.origin.y + cell.lblFromName.frame.size.height), width: widthTextview, height: 0.0)
                            
                        }else if fileType.range(of:".vcf") != nil {
                            imageTrue = true
                            
                            let textAttachment = NSTextAttachment()
                            
                            textAttachment.image = UIImage(named:"ic_thumb_contact.png")
                            
                            let oldWidth = textAttachment.image!.size.width;
                            
                            let scaleFactor =  oldWidth / 25//(cell.tvMessage.frame.size.width - 10);
                            textAttachment.image = UIImage(cgImage: textAttachment.image!.cgImage!, scale: scaleFactor, orientation: .up)
                            let attrStringWithImage = NSAttributedString(attachment: textAttachment)
                            attributedString.append(attrStringWithImage)
                            
                            cell.tvMessage.text = "Contact \n" + message
                            attributedString.append(NSMutableAttributedString(attributedString:NSMutableAttributedString(attributedString:NSAttributedString(string: "Contact \n" + message))))
                            
                            cell.imgData.frame = CGRect(x: 8.0, y:  Double(cell.lblFromName.frame.origin.y + cell.lblFromName.frame.size.height), width: widthTextview, height: 0.0)
                            
                        }else if fileType.range(of:".jpg") != nil  ||  fileType.range(of:".png") != nil  {
                            
                            imageTrue = false
                            attributedString.append(NSMutableAttributedString(attributedString:NSAttributedString(string: message)))
                            
                            let url = WebServices.chatgetFile + string(dict, "file")
                            cell.imgData.frame  = CGRect(x: 10, y:  Double(cell.lblFromName.frame.origin.y + cell.lblFromName.frame.size.height), width: widthTextview, height: widthTextview)
                            cell.imgData.setImage(self.view, url, "imageBG.png", true, nil)
                            cell.btnCellAction.isHidden = true
                            
                        }else {
                            imageTrue = true
                            let textAttachment = NSTextAttachment()
                            textAttachment.image = UIImage(named:"pdf.png")
                            let oldWidth = textAttachment.image!.size.width;
                            
                            let scaleFactor =  oldWidth / 25//(cell.tvMessage.frame.size.width - 10);
                            textAttachment.image = UIImage(cgImage: textAttachment.image!.cgImage!, scale: scaleFactor, orientation: .up)
                            let attrStringWithImage = NSAttributedString(attachment: textAttachment)
                            attributedString.append(attrStringWithImage)
                            attributedString.append(NSMutableAttributedString(attributedString:NSMutableAttributedString(attributedString:NSAttributedString(string: "PDF Document \n" + message))))
                            cell.imgData.frame = CGRect(x: 8.0, y:  Double(cell.lblFromName.frame.origin.y + cell.lblFromName.frame.size.height), width: widthTextview, height: 0.0)
                        }
                        
                        cell.tvMessage.attributedText = attributedString
                        cell.tvMessage.sizeToFit()
                        
                        if cell.tvMessage.frame.size.width < cell.lblFromName.frame.size.width + 10{
                            cell.tvMessage.frame.size.width = cell.lblFromName.frame.size.width + 10
                            
                        }
                        
                        if cell.tvMessage.frame.size.width < 100 {
                            cell.tvMessage.frame.size.width = 100
                        }
                        
                        if imageTrue {
                            
                            cell.imgBG.frame.size.width  = cell.tvMessage.frame.size.width + 16
                            
                            cell.tvMessage.frame = CGRect(x: 8.0, y:cell.imgData.frame.origin.y + cell.imgData.frame.size.height, width: cell.tvMessage.frame.size.width, height: cell.tvMessage.frame.size.height)
                            
                            
                        }else {
                            cell.imgBG.frame.size.width  =   CGFloat(widthTextview + 14)
                            cell.tvMessage.frame = CGRect(x: 8.0, y: cell.imgData.frame.origin.y + cell.imgData.frame.size.height, width: CGFloat(widthTextview + 14), height: cell.tvMessage.frame.size.height)
                        }
                        
                        cell.lblDate.frame = CGRect(x: 0.0, y: cell.tvMessage.frame.origin.y + cell.tvMessage.frame.size.height, width: cell.imgBG.frame.size.width - 5, height: 20)
                        
                        cell.lblDate.textAlignment = .right
                        cell.imgBG.frame = CGRect(x: 0.0, y: 1.0, width: cell.imgBG.frame.size.width, height: cell.lblDate.frame.origin.y +  cell.lblDate.frame.size.height + 5)
                        
                        
                        cell.viewbg.frame = CGRect(x: 0.0, y: 1.0, width: CGFloat(widthTextview + 20), height:  cell.imgBG.frame.size.height)
                        cell.imgBG.layer.cornerRadius = 10
                        
                        
                    }else {
                        attributedString.append(NSMutableAttributedString(string:message))
                        
                        cell.tvMessage.attributedText = attributedString
                        cell.tvMessage.sizeToFit()
                        
                        if cell.tvMessage.frame.size.width < cell.lblFromName.frame.size.width + 10{
                            cell.tvMessage.frame.size.width = cell.lblFromName.frame.size.width + 10
                            
                        }
                        if cell.tvMessage.frame.size.width < 100 {
                            cell.tvMessage.frame.size.width = 100
                        }
                        cell.imgData.frame = CGRect(x: 8.0, y:  Double(cell.lblFromName.frame.origin.y + cell.lblFromName.frame.size.height), width: 0.0, height: 0.0)
                        
                        
                        if let dictReply: NSDictionary = dict.object(forKey: "reply_data") as? NSDictionary {
                            cell.viewReplay.isHidden = false
                            
                            cell.lblNameReply.text = string(dictReply, "name")
                            cell.viewReplay.backgroundColor = UIColor(red: 233/255, green: 237/255, blue: 231/255, alpha: 1)
                            cell.lblReplyMsgType.frame.size.width = CGFloat(widthTextview)
                            cell.lblReplymsg.text = string(dictReply, "msg")
                            
                            cell.lblLineReply.frame.size.height = cell.imgReplyImgData.frame.origin.y + cell.imgReplyImgData.frame.size.height
                            cell.imgData.image = nil
                            let fileType = string(dictReply, "file_name")
                            
                            if  fileType.range(of:".mp3") != nil  || fileType.range(of:".caf") != nil  || fileType.range(of:".m4a") != nil {
                                cell.lblReplyMsgType.text  = "Audio"
                                cell.imgReplayIcon.image = UIImage(named:"ic_thumb_audio48.png")
                                cell.lblLineReply.frame.size.height = cell.imgReplayIcon.frame.origin.y + cell.imgReplayIcon.frame.size.height
                            }else   if fileType.range(of:".jpg") != nil  ||  fileType.range(of:".png") != nil  {
                                imageTrue = true
                                cell.lblReplyMsgType.text  = "Photo"
                                let url = WebServices.chatgetFile + string(dictReply, "file")
                                let URL =  NSURL(string: url)
                                cell.imgReplyImgData.image = UIImage(named: "imageBG.png")
                                cell.imgReplyImgData.sd_setImage(with: URL as URL!, placeholderImage: UIImage(named: ""),  options: SDWebImageOptions.retryFailed)
                                cell.imgReplayIcon.image = UIImage(named:"imageDemo.png")
                                cell.lblLineReply.frame.size.height = cell.imgReplyImgData.frame.origin.y + cell.imgReplyImgData.frame.size.height
                            }else if fileType.range(of:".mp4") != nil  {
                                cell.lblReplyMsgType.text  = "Video"
                                cell.imgReplayIcon.image = UIImage(named:"ic_thumb_video.png")
                                cell.lblLineReply.frame.size.height = cell.imgReplayIcon.frame.origin.y + cell.imgReplayIcon.frame.size.height
                                
                            }else if  fileType.range(of:".vcf") != nil {
                                cell.imgReplayIcon.image = UIImage(named:"ic_thumb_contact.png")
                                cell.lblReplyMsgType.text  = "Contact"
                                cell.lblLineReply.frame.size.height = cell.imgReplayIcon.frame.origin.y + cell.imgReplayIcon.frame.size.height
                                
                            }else if  fileType.range(of:".pdf") != nil  {
                                cell.imgReplayIcon.image = UIImage(named:"pdf.png")
                                cell.lblReplyMsgType.text  = "PDF Document"
                                cell.lblLineReply.frame.size.height = cell.imgReplayIcon.frame.origin.y + cell.imgReplayIcon.frame.size.height
                                
                            }else {
                                cell.lblLineReply.frame.size.height = cell.lblReplyMsgType.frame.origin.y + cell.lblReplyMsgType.frame.size.height
                                
                            }
                            cell.lblReplyMsgType.sizeToFit()
                            
                            
                            
                            cell.viewReplay.frame.origin.x =  cell.tvMessage.frame.origin.x + 8
                            
                            cell.viewReplay.frame.size.height = cell.lblLineReply.frame.origin.y + cell.lblLineReply.frame.size.height
                            
                            
                            cell.imgData.frame.size.height =  cell.viewReplay.frame.origin.y + cell.viewReplay.frame.size.height
                            
                            cell.imgData.image = nil
                            
                            cell.tvMessage.frame.size.width = CGFloat(widthTextview)
                            
                            
                            cell.imgBG.frame.size.width  = cell.tvMessage.frame.size.width + 16
                            cell.tvMessage.frame = CGRect(x: 8.0, y: cell.viewReplay.frame.origin.y + cell.viewReplay.frame.size.height, width: cell.tvMessage.frame.size.width, height: cell.tvMessage.frame.size.height)
                            cell.lblDate.frame = CGRect(x: 0.0, y: cell.tvMessage.frame.origin.y + cell.tvMessage.frame.size.height, width: cell.imgBG.frame.size.width - 5, height: 18)
                            
                            cell.lblDate.textAlignment = .right
                            cell.imgBG.frame = CGRect(x: 0.0, y: 1.0, width: cell.imgBG.frame.size.width, height: cell.lblDate.frame.origin.y +  cell.lblDate.frame.size.height + 5)
                            
                            
                            cell.viewbg.frame = CGRect(x: 0.0, y: 1.0, width: CGFloat(widthTextview + 20), height:  cell.imgBG.frame.size.height)
                            cell.imgBG.layer.cornerRadius = 10
                            
                        }else {
                            
                            cell.imgBG.frame.size.width  = cell.tvMessage.frame.size.width + 16
                            cell.tvMessage.frame = CGRect(x: 8.0, y: cell.imgData.frame.origin.y + cell.imgData.frame.size.height, width: cell.tvMessage.frame.size.width, height: cell.tvMessage.frame.size.height)
                            
                            cell.lblDate.frame = CGRect(x: 8.0, y: cell.tvMessage.frame.origin.y + cell.tvMessage.frame.size.height, width: cell.tvMessage.frame.size.width, height: 20)
                            cell.lblDate.textAlignment = .right
                            
                            cell.imgBG.frame = CGRect(x: 0.0, y: 1.0, width: cell.imgBG.frame.size.width, height: cell.lblDate.frame.origin.y +  cell.lblDate.frame.size.height + 5)
                            cell.imgBG.layer.cornerRadius = 8
                            
                            cell.viewbg.frame = CGRect(x: 0.0, y: 1.0, width: CGFloat(widthTextview + 16), height:  cell.imgBG.frame.size.height)
                        }
                        
                        
                    }
                }
                
                if cell.imageViewBG.isDescendant(of: cell.viewbg) {
                    cell.imageViewBG.removeFromSuperview()
                }
                let repsotionXFactor:CGFloat = -2.0 // data.type == .Mine ? 0.0 : -8.0
                let bgImageNewX =  repsotionXFactor
                let bgImageNewWidth = cell.lblDate.frame.origin.x + cell.lblDate.frame.size.width + CGFloat(12.0)
                let bgImageNewHeight =  cell.lblDate.frame.origin.y + cell.lblDate.frame.size.height  + CGFloat(5.0)
                
                cell.imageViewBG = UIImageView(frame: CGRect(x:0.0,y: 0.0,width:bgImageNewWidth  ,height: bgImageNewHeight))
                cell.imageViewBG.image = UIImage(named: "bubbleMine_whiteLeft")?.resizableImage(withCapInsets: UIEdgeInsetsMake(14, 28, 17, 17))
                //
                
                cell.viewbg.addSubview(cell.imageViewBG)
                cell.viewbg.sendSubview(toBack: cell.imageViewBG)
                
                cell.imageViewBG.frame = CGRect(x:bgImageNewX, y:0.0, width: bgImageNewWidth,height: bgImageNewHeight)
                
                cell.imgData.backgroundColor = UIColor.clear
                cell.viewbg.backgroundColor = UIColor.clear
                cell.imgBG.backgroundColor = UIColor.clear
                
                cell.btnCellAction.frame = cell.viewbg.frame
                
                
                return cell
            }
        } else if tableView == tblContact {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "PersonsCell", for: indexPath) as! PersonsCell
            let dict = arrContact.object(at: indexPath.row) as! ContactClass
            cell.lblName.text = dict.name
            cell.lblDepartment.text = dict.btrtlTxt
            cell.lblMobileNumber.text = dict.telnr
            
            if dict.check {
                cell.imgCheck.image = imgCheck
            } else {
                cell.imgCheck.image = imgUnCheck
                
            }
            
            return cell
            
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TopicCell", for: indexPath) as! TopicCell
            
            let dict = self.arrTopic.object(at: indexPath.row) as! topicClass
            cell.lblTopic.text = dict.topic
            
            if indexPath.row + 1 ==  arrTopic.count {
                self.UITableView_Auto_Height()
            }
            return cell
            
        }
    }
    
    func getMSGType(_ dict: NSDictionary)->String {
        var type = "T"
        if string(dict, "msg_type") != "" {
            type = string(dict, "msg_type")
        }else if string(dict, "type") != "" {
            type = string(dict, "type")
        }
        return type
    }
    
    func LeftCelllongPressGesture(section:Int, index:Int,point:CGPoint){
        //    func LeftCelllongPressGesture(section: Int, index: Int) {
        tabelsection = section
        tabelindex = index
   //     someFunc(point)
        print("tapIndexPath tap gesture ---- \(section) index ==\(index)")
       // "Are you sure to delete this message?"
         let alert = UIAlertController (title: "Shakti Chat", message: "", preferredStyle: UIAlertControllerStyle.alert)
         
         alert.addAction(UIAlertAction(title: "FORWARD", style: .default, handler: { action in
         //== MessagesStringFile().notifLogout()
             self.forwardLine()

         }))
         
         alert.addAction(UIAlertAction(title: "DELETE", style: .default, handler: { action in
         //== MessagesStringFile().notifLogout()
         self.wsdeletechat(section: section, index: index)
         
         }))
         alert.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: { action in
         
         //== MessagesStringFile().notifLogout()
         }))
         self.present(alert, animated: true, completion: nil)
       
    }
    func RightCelllongPressGesture(section:Int, index:Int,point:CGPoint){
        print("tapIndexPath tap gesture ---- \(section) index ==\(index)")
        tabelsection = section
        tabelindex = index
        
//        let myPoint = CGPoint(x: CGFloat(widthTextview), y: point.y)
//        
//        someFunc(myPoint)
        
              // "Are you sure to delete this message?"
         let alert = UIAlertController (title: "Shakti Chat", message:"" , preferredStyle: UIAlertControllerStyle.alert)
         
         alert.addAction(UIAlertAction(title: "FORWARD", style: .default, handler: { action in
         //== MessagesStringFile().notifLogout()
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForwardMsgView") as! ForwardMsgView
            let dict0 = (self.arrMessages.object(at: section) as! NSDictionary).mutableCopy() as! NSMutableDictionary
            let arr = dict0.object(forKey: "data") as! NSMutableArray
            if let dict : NSDictionary = arr.object(at: index) as? NSDictionary {
                print("\(section)---tabelindex \(index)Forward---->",dict)
                vc.dictMessage = dict
                self.navigationController?.pushViewController(vc, animated: true)
            }
         }))
         alert.addAction(UIAlertAction(title: "DELETE", style: .default, handler: { action in
         //== MessagesStringFile().notifLogout()
         self.wsdeletechat(section: section, index: index)
         
         }))
         alert.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: { action in
         
         //== MessagesStringFile().notifLogout()
         }))
         
         
         self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tblGroupContacts == tableView {
        } else if tableView == tblContact {
            
            let obj = arrContact.object(at: indexPath.row) as! ContactClass
            
            if obj.check {
                obj.check = false
            } else {
                obj.check = true
            }
            
            arrContactTemp.replaceObject(at: indexPath.row, with: obj)
            
            tblContact.reloadData()
            
        } else if tableView != tblView {
            let dict = self.arrTopic.object(at: indexPath.row) as! topicClass
            print(dict.id)
            topic_id = dict.id
            topic_name = dict.topic
            btnTopic.setTitle(dict.topic, for: .normal)
            viewTopic.removeFromSuperview()
            btnTopicCross.isHidden = false
            btnTopic.backgroundColor = UIColor.green
        }else {
            let dict = arrMessages.object(at: indexPath.row) as! NSDictionary
            print("dict ==== \(dict)")
        }
    }
    @IBAction func btnNoTopic(_ sender: Any) {
        topic_id = ""
        topic_name = ""
        btnTopic.setTitle("Topic", for: .normal)
        viewTopic.removeFromSuperview()
        
        btnTopicCross.isHidden = true
        btnTopic.backgroundColor = UIColor.white
        
    }
    @IBOutlet var btnTopicCross: UIButton!
    
    @IBAction func actionTopicCross(_ sender: Any) {
        btnNoTopic("")
    }
    func btnRightFileAction(dict:NSMutableDictionary) {
        btnFileAction(dict: dict)
        
    }
    func btnLeftFileAction(dict: NSMutableDictionary) {
        btnFileAction(dict: dict)
    }
    
    func btnFileAction(dict: NSMutableDictionary) {
        
      //  if string(dict, "msg_type") == "F" {
        if getMSGType(dict) == "F" {

            let fileType = string(dict, "file_name")
            
            if fileType.range(of:".mp3") != nil || fileType.range(of:".mp4") != nil  || fileType.range(of:".caf") != nil  || fileType.range(of:".m4a") != nil  {
                wbView.isHidden = true
                let urlStr = WebServices.chatgetFile + string(dict, "file")
                print(urlStr)
                
                if fileAlreadyExist(fileName: string(dict, "file_name")) {
                    //file is already there in document directory.
                    
                    playDownload(fileName: string(dict, "file_name"))
                    
                } else {
                    downloadFile(url: urlStr, fileName: string(dict, "file_name"))
                }
                
                
                
            }else if  fileType.range(of:".vcf") != nil  {
                
                let msg = string(dict, "msg")
                let arr = msg.components(separatedBy: "\n")
                
                if arr.count >= 2 {
                    let name = arr[0]
                    let phn = arr[1]
                    
                    let newContact = CNMutableContact()
                    newContact.givenName = name
                    //newContact.familyName = name
                    //newContact.nickname = name
                    newContact.phoneNumbers.append(CNLabeledValue(label: "home", value: CNPhoneNumber(stringValue: phn)))
                    
                    contactVC = CNContactViewController(forUnknownContact: newContact)
                    contactVC?.contactStore = CNContactStore()
                    contactVC?.delegate = self
                    contactVC?.allowsActions = true
                    
                    let navigationVC = UINavigationController(rootViewController: contactVC!)
                    let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissContactVC))
                    let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
                    contactVC?.setToolbarItems([flexibleSpace, cancelButton, flexibleSpace], animated: false)
                    navigationVC.setToolbarHidden(false, animated: false)
                    navigationVC.modalPresentationStyle = UIModalPresentationStyle.currentContext
                    self.present(navigationVC, animated: true, completion: nil)
                }
            }else   if  fileType.range(of:".jpg") != nil  ||   fileType.range(of:".png") != nil   {
                // let urlStr = WebServices.chatgetFile + string(dict, "file")
                //                self.view.addSubview(viewZoomSub) //viewZoomSub
                //                viewZoomSub.frame = self.view.frame
                //                viewZoomSub.setImage(urlStr, nil, true, nil)
            } else if fileType != "" {
                wbView.isHidden = false
                let urlStr = WebServices.chatgetFile + string(dict, "file")
                
                let viewUrl = URL(string: urlStr)
                let viewUrlRequest = URLRequest(url: viewUrl!)
                wbView.loadRequest(viewUrlRequest)
                wbView.scalesPageToFit = true
                wbView.allowsInlineMediaPlayback = true
                wbView.frame = CGRect(x: 10, y: 40, width: self.view.frame.size.width - 20, height: self.view.frame.size.height - 80)
                viewMedia.frame = self.view.frame
                viewMedia.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
                self.view.addSubview(viewMedia)
                
            }
        }
        
        
    }
    var ReplayId = "0"
    let lbl = UILabel()
    var dictReply = NSMutableDictionary()
    var tabelsection = -1 , tabelindex = -1
    func someFunc(_ point:CGPoint) {
        becomeFirstResponder()
        let menu = UIMenuController.shared
        let deleteItem = UIMenuItem(title: "Delete", action: #selector(ChatMohanViewController.deleteLine))
        let FrowardlItem = UIMenuItem(title: "Froward", action: #selector(ChatMohanViewController.forwardLine))
        //        let ShareItem = UIMenuItem(title: "Share", action: #selector(ChatMohanViewController.forwardLine))
        let cancelItem = UIMenuItem(title: "Cancel", action: #selector(ChatMohanViewController.anceLine))
        
        menu.menuItems = [deleteItem,FrowardlItem,cancelItem]
        //.setTargetRect(CGRect(x: point.x, y: point.y, width: 20, height: 20), in: self.view)
        
        menu.setTargetRect(CGRect(x:point.x,y: point.y,width:50,height: 50), in: self.view)
        menu.setMenuVisible(true, animated: true)
    }
    
    func deleteLine() {
        self.wsdeletechat(section: tabelsection, index: tabelindex)
        //Do something here
    }
    func forwardLine() {
        //  ForwardMsgView
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForwardMsgView") as! ForwardMsgView
        let dict0 = (arrMessages.object(at: tabelsection) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        let arr = dict0.object(forKey: "data") as! NSMutableArray
        if let dict : NSDictionary = arr.object(at: tabelindex) as? NSDictionary {
            print("\(tabelsection)---tabelindex \(tabelindex)Forward---->",dict)
            vc.dictMessage = dict
            self.navigationController?.pushViewController(vc, animated: true)
        }
        //Do something here
    }
    func anceLine() {
        //Do something here
    }
    
    //    func canBecomeFirstResponder() -> Bool {
    //        return true
    //    }
    
    override var canBecomeFirstResponder: Bool {
        
        return true
    }
    
    func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
        // You need to only return true for the actions you want, otherwise you get the whole range of
        //  iOS actions. You can see this by just removing the if statement here.
        if action == #selector(ChatMohanViewController.deleteLine) {
            return true
        }
        return false
    }
    
    func btnLeftReplayAction(dict:NSMutableDictionary){
        
        dictReply = dict
        lblNameReply.text = string(dict, "name")
        lblReplymsg.text = string(dict, "msg")
        ReplayId = string(dict, "id")
        
        lblNameReply.frame.origin.y = 0
        lblReplymsg.frame.origin.y = lblNameReply.frame.origin.y + lblNameReply.frame.size.height
        lblReplyMsgType.sizeToFit()
        lblReplyMsgType.frame.origin.y = lblReplymsg.frame.origin.y + lblReplymsg.frame.size.height
        
        lblLineReply.frame.size.height = lblReplyMsgType.frame.origin.y + lblReplyMsgType.frame.size.height
        
        if !viewReplay.isDescendant(of: viewMessage) {
            viewReplay.frame = CGRect(x: tvMessage.frame.origin.x + 1, y: 9.0, width: tvMessage.frame.size.width, height: lblLineReply.frame.origin.y + lblLineReply.frame.size.height)
            
            viewReplay.backgroundColor = UIColor(red: 233/255, green: 237/255, blue: 231/255, alpha: 1)
            
            viewMessage.addSubview(viewReplay)
            
            
            tvMessage.frame.origin.y = viewReplay.frame.origin.y + viewReplay.frame.size.height
            viewMessage.frame.size.height = tvMessage.frame.origin.y + tvMessage.frame.size.height
            
            viewMessage.frame.origin.y =  viewMessage.frame.origin.y - viewReplay.frame.size.height
            
            tblView.frame.size.height = self.view.frame.size.height - (tblView.frame.origin.y + viewMessage.frame.size.height + keyBoardHeight)
        }
        
        
        moveToLastComment()
        messageBgImage()
    }
    
    
    func btnRightReplayAction(dict: NSMutableDictionary) {
        
        dictReply = dict
        lblNameReply.text = "You"
        lblReplymsg.text = string(dict, "msg")
        ReplayId = string(dict, "id")
        
        lblNameReply.frame.origin.y = 0
        lblReplymsg.frame.origin.y = lblNameReply.frame.origin.y + lblNameReply.frame.size.height
        lblReplyMsgType.sizeToFit()
        lblReplyMsgType.frame.origin.y = lblReplymsg.frame.origin.y + lblReplymsg.frame.size.height
        
        lblLineReply.frame.size.height = lblReplyMsgType.frame.origin.y + lblReplyMsgType.frame.size.height
        
        if !viewReplay.isDescendant(of: viewMessage) {
            viewReplay.frame = CGRect(x: tvMessage.frame.origin.x + 1, y: 9.0, width: tvMessage.frame.size.width, height: lblLineReply.frame.origin.y + lblLineReply.frame.size.height)
            
            viewReplay.backgroundColor = UIColor(red: 233/255, green: 237/255, blue: 231/255, alpha: 1)
            
            viewMessage.addSubview(viewReplay)
            
            
            tvMessage.frame.origin.y = viewReplay.frame.origin.y + viewReplay.frame.size.height
            viewMessage.frame.size.height = tvMessage.frame.origin.y + tvMessage.frame.size.height
            
            viewMessage.frame.origin.y =  viewMessage.frame.origin.y - viewReplay.frame.size.height
            
            tblView.frame.size.height = self.view.frame.size.height - (tblView.frame.origin.y + viewMessage.frame.size.height + keyBoardHeight)
        }
        
        
        moveToLastComment()
        messageBgImage()
    }
    
    
    func dismissContactVC () {
        if contactVC != nil {
            contactVC?.dismiss(animated: true, completion: nil)
            contactVC = nil
        }
    }
    
    func btnMSGIsReplay(section:Int, index:Int){
        
        let dict0 = (arrMessages.object(at: section) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        let arr = dict0.object(forKey: "data") as! NSMutableArray
        
        if let dict_101 : NSMutableDictionary = arr.object(at: index) as? NSMutableDictionary {
            // if let dict_102 : NSMutableDictionary = dict_101.object(forKey: "reply_data") as? NSMutableDictionary { }
            
            var break111 = false
            
            for ii in 0 ..< arrMessages.count {
                
                let dict = arrMessages.object(at: ii) as! NSDictionary
                let arr_211 = dict.object(forKey: "data") as! NSMutableArray
                for jjj in 0 ..< arr_211.count {
                    let dict_10 = arr_211.object(at: jjj) as! NSDictionary
                    if Int(string(dict_10, "id")) == Int(string(dict_101, "reply_id")) {
                        
                        
                        // Make the last row visible
                        self.tblView.selectRow(at: NSIndexPath(row: jjj, section: ii) as IndexPath, animated: true, scrollPosition: UITableViewScrollPosition.middle)
                        self.tblView?.scrollToRow(at: NSIndexPath(row: jjj, section: ii) as IndexPath, at: UITableViewScrollPosition.bottom, animated: true)
                        
                        
                        break111 = true
                        
                        break
                    }
                    
                }
                if break111 {
                    break
                }
            }
        }
        
    }
    
    
    
    
    //MARK:-
    func UITableView_Auto_Height() {
        if(self.tblViewTopic.contentSize.height < self.tblViewTopic.frame.height){
            var frame: CGRect = self.tblViewTopic.frame
            frame.size.height = self.tblViewTopic.contentSize.height
            self.tblViewTopic.frame = frame
        }
    }
    
    
    
    
    
    //MARK:- textView delegate
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if tvMessage.text == "" {
            lblchatMsg.isHidden = false
        }
        
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let newLength: Int = textView.text!.characters.count + text.characters.count - range.length
        if textView == tvMessage {
            if text == "\n" {
                textView.resignFirstResponder()
                typingStatus(type: "stoptyping")
                
                return false
            }
            if newLength == 0 {
                btnSendVoiceMessage.isHidden = false
                btnSendTextMessage.isHidden = true
                lblchatMsg.isHidden = false
                typingStatus(type: "stoptyping")
            }
            else {
                if newLength == 1{
                    typingStatus(type: "starttyping")
                }
                btnSendVoiceMessage.isHidden = true
                btnSendTextMessage.isHidden = false
                lblchatMsg.isHidden = true
            }
            
        }
        else {
            if text == "\n" {
                textView.resignFirstResponder()
                return false
            }
        }
        return true
    }
    //MARK:-  tbl View Topic
    
    @IBAction func actionTopic(_ sender: Any) {
        viewTopic.frame = self.view.frame
        viewTopic.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        self.view.addSubview(viewTopic)
        
    }
    
    @IBAction func actionRemoveTopicView(_ sender: Any) {
        
        viewTopic.removeFromSuperview()
        btnTopic.setTitle("Topic : None", for: .normal)
        
        
    }
    func heightTextVIewconstraintedWidth(width: CGFloat, font: UIFont, msg: String) -> CGFloat {
        let  tvc  = UITextView(frame: CGRect(x: 0, y: 0, width: width, height: width))
        tvc.text = msg
        tvc.font = font
        tvc.sizeToFit()
        tvc.isScrollEnabled = false
        tvc.frame.size.height = tvc.contentSize.height
        
        let height = tvc.frame.size.height //  + 33
        
        return height
    }
    
    
    @IBAction func actionPopup(_ sender: Any) {
        viewPopup.removeFromSuperview()
    }
    
    @IBAction func actionAttachment(_ sender: Any) {
        viewPopup.removeFromSuperview()
        
        self.view.addSubview(viewPopup)
    }
    
    
    
    @IBAction func actionImage(_ sender: Any) {
        viewPopup.removeFromSuperview()
        strVideo = ""
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        
    }
    
    
    @IBAction func btnDocument(_ sender: Any) {
        mySpecialFunction()
        
        
    }
    
    
    @IBAction func actionVideo(_ sender: Any) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            imagePicker.videoQuality = .typeLow
            imagePicker.mediaTypes = [kUTTypeMovie as String]
            self.present(imagePicker, animated: true, completion: nil)
            strVideo = "yes"
        }
        viewPopup.removeFromSuperview()
    }
    
    
    
    //MARK:- ---- UIDocumentPickerViewController ----
    
    
    @available(iOS 8.0, *)
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        
        
        let cico = url as URL
        print("The Url is : ", cico)
        
        
        do {
            let weatherData = try NSData(contentsOf: cico, options: NSData.ReadingOptions())
            print(weatherData.length)
            
            imgData = weatherData as Data
            self.file_name =  "temp_\("\(NSDate().timeIntervalSince1970)".replacingOccurrences(of: ".", with: "")).pdf"
            //    file_nameTemp = "pdf"
            
            self.view.addSubview(viewPopup2)
            
        } catch {
            print(error)
        }
    }
    
    
    @available(iOS 8.0, *)
    public func documentMenu(_ documentMenu:     UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
        
    }
    
    
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        
        print("we cancelled")
        
        dismiss(animated: true, completion: nil)
        
        
    }
    
    func mySpecialFunction(){
        viewPopup.removeFromSuperview()
        let importMenu = UIDocumentMenuViewController(documentTypes: [String(kUTTypePDF), String(kUTTypeImage), String(kUTTypeMP3),String(kUTTypeGIF),String(kUTTypePNG), String(kUTTypeXML) ], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        self.present(importMenu, animated: true, completion: nil)
    }
    
    //MARK:- ---------------------------------- Audio File URL  --------------------------------
    
    //================================ Rahul ===================================
    
    
    
    // MARK:- AVRecorder Setup
    //  var soundFileURL:URL!
    
    func setupRecorder() {
        
        
        fileName = "temp_\("\(Int(NSDate().timeIntervalSince1970))").caf"
        let path = getCacheDirectory() + fileName
        
        soundFileUrl = URL(fileURLWithPath: path)
        
        let recordSettings = [AVSampleRateKey : NSNumber(value: Float(44100.0) as Float), AVFormatIDKey : NSNumber(value: Int32(kAudioFormatAppleIMA4) as Int32),
                              AVNumberOfChannelsKey : NSNumber(value: 2 as Int32),
                              AVEncoderAudioQualityKey : NSNumber(value: Int32(AVAudioQuality.max.rawValue) as Int32)];
        
        
        
        
        var error: NSError?
        if let soundFU = soundFileUrl{
            do {
                soundRecorder =  try AVAudioRecorder(url: soundFU, settings: recordSettings)
            } catch let error1 as NSError {
                error = error1
                soundRecorder = nil
            }
        }
        if let err = error {
            print("AVAudioRecorder error: \(err.localizedDescription)")
        } else {
            
            soundRecorder.delegate = self
            soundRecorder.isMeteringEnabled = true
            soundRecorder.prepareToRecord()
        }
    }
    
    
    
    func getCacheDirectory() -> String {
        
        let paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory,.userDomainMask, true)
        
        return paths[0]
    }
    var soundFileUrl : URL?
    func getFileURL() -> URL {
        
        let path = getCacheDirectory() + fileName
        
        let filePath = URL(fileURLWithPath: path)
        
        return filePath
    }
    
    
    
    
    
    
    
    // MARK:- Prepare AVPlayer
    
    func preparePlayer() {
        
        var error: NSError?
        
        do {
            soundPlayer = try AVAudioPlayer(contentsOf: soundFileUrl!)
            do {
                try AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSessionPortOverride.speaker)
            } catch _ {
            }
            
        } catch let error1 as NSError {
            error = error1
            soundPlayer = nil
        }
        
        if let err = error {
            print("AVAudioPlayer error: \(err.localizedDescription)")
        } else {
            soundPlayer.delegate = self
            soundPlayer.prepareToPlay()
            soundPlayer.volume = 1.0
        }
    }
    
    
    // MARK:- AVAudioPlayer delegate methods
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        //recordButton.isEnabled = true
        //playButton.setTitle("Play", for: UIControlState())
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("Error while playing audio \(error!.localizedDescription)")
    }
    
    ///MARK:- AVAudioRecorder delegate methods
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        //playButton.isEnabled = true
        //recordButton.setTitle("Record", for: UIControlState())
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("Error while recording audio \(error!.localizedDescription)")
    }
    
    @IBAction func recording(_ sender: UIButton) {
        setupRecorder()
        print("recording")
        //start recording here.
        
        
        tvMessage.text = ""
        //tvMessage.resignFirstResponder()
        
        lblRecording.isHidden = false
        soundRecorder.record()
        
        
        
    }
    
    @IBAction func pausedRecording(_ sender: UIButton) {
        
        print("pausedRecording...")
        
        //stop recording here
        
        
        lblRecording.isHidden = true
        
        //to play recording.
        //      preparePlayer()
        if soundFileUrl != nil {
            print("soundPlayer -\(soundRecorder)-")
            
            soundRecorder.stop()
            do {
                let dt: Data = try Data(contentsOf: soundFileUrl!)
                print("dt.count  SEND AUDIO -\(dt.count))-")
                //            print("soundRecorder.format -----\(soundRecorder.format.commonFormat)-")
                
                if dt.count < 7000 {
                    //very less recording to send
                } else {
                    //can proceed further.  aac //  fileName
                    self.file_name = fileName // "temp_\("\(Int(NSDate().timeIntervalSince1970))").mp3 "
                    imgData = dt
                    
                    //  encodeAudio(audioURL: soundFileUrl!)
                    viewPopup2.frame = self.view.frame
                    self.view.addSubview(viewPopup2)
                }
                
            } catch {
                print("error -\(error)-")
            }
        }
    }
    
    
    func showAudioRecordView() {
        
        lblRecording.isHidden = true
        btnSendVoiceMessage.isHidden = false
        
        tvMessage.isHidden = false
        btnSendTextMessage.isHidden = true
    }
    
    
    @IBOutlet var lblRecording: UILabel!
    @IBOutlet var btnSendTextMessage: UIButton!
    @IBOutlet var btnSendVoiceMessage: UIButton!
    
    
    //================================ Rahul ===================================
    
    
    
    func fileAlreadyExist(fileName: String) -> Bool {
        
        let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        // lets create your destination file url
        let destinationUrl = documentsDirectoryURL.appendingPathComponent(fileName)
        
        //
        //
        
        print(destinationUrl)
        
        // to check if it exists before downloading it
        if FileManager.default.fileExists(atPath: destinationUrl.path) {
            
            return true
            
        } else {
            return false
        }
    }
    
    //MARK: DOWNLOAD FILE.
    
    var fileNameR = ""
    
    @IBOutlet var progressDownloadIndicator: UIProgressView!
    
    func downloadFile(url: String, fileName: String) { //to download the media file in document directory.
        
        
        
        print("download url -\(url)-")
        
        
        if let audioUrl = URL(string: url) {
            
            // then lets create your document folder url
            let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            // lets create your destination file url
            let destinationUrl = documentsDirectoryURL.appendingPathComponent(fileName)
            
            //
            //
            
            
            print(destinationUrl)
            
            // to check if it exists before downloading it
            if FileManager.default.fileExists(atPath: destinationUrl.path) {
                
                print("The file already exists at path")
                
                Http.alert("", "The file already exists at path")
                
            } else {
                
                
                Http.startActivityIndicator()
                
                fileNameR = fileName
                
                // you can use NSURLSession.sharedSession to download the data asynchronously
                
                let config = URLSessionConfiguration.default
                let session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
                
                // Don't specify a completion handler here or the delegate won't be called
                let task = session.downloadTask(with: audioUrl)
                task.resume()
            }
        }
    }
    
    //MARK: PLAY DOWNLOADED FILE.
    var player: AVAudioPlayer?
    
    func playDownload(fileName: String) {
        
        // then lets create your document folder url
        let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        // lets create your destination file url
        
        let destinationUrl = documentsDirectoryURL.appendingPathComponent(fileName)
        
        
        print(destinationUrl)
        
        
        
        /*
         do {
         try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
         try AVAudioSession.sharedInstance().setActive(true)
         
         
         player = try AVAudioPlayer(contentsOf: destinationUrl)
         guard let player = player else { return }
         
         player.play()
         
         } catch let error {
         print(error.localizedDescription)
         }
         viewMedia.frame = self.view.frame
         viewMedia.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
         self.view.addSubview(viewMedia)
         */
        moviePlayer = MPMoviePlayerController(contentURL: destinationUrl)
        
        if let player = moviePlayer {
            player.view.frame = CGRect(x: 5, y: 150, width: self.view.frame.size.width - 10, height: 100)
            
            
            
            if fileName.range(of:".mp4") != nil || fileName.range(of:".m4a") != nil { //video
                
                player.view.frame = CGRect(x: 5, y: 150, width: self.view.frame.size.width - 10, height: 200)
                
                
            } else {
                player.view.frame = CGRect(x: 5, y: 150, width: self.view.frame.size.width - 10, height: 100)
                
            }
            
            player.view.backgroundColor = UIColor.clear
            player.prepareToPlay()
            do {
                try AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSessionPortOverride.speaker)
            } catch _ {
            }
            
            
            player.scalingMode = .aspectFill
            player.controlStyle = .embedded
            player.repeatMode = .none
            
            
            viewMedia.addSubview(player.view)
            viewMedia.frame = self.view.frame
            viewMedia.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
            self.view.addSubview(viewMedia)
            
            
            
        }
        
    }
    
    
    //MARK: NSURLSessionDownloadDelegate
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        //   let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        
        //   print("download task did write data")
        
        //  print("progress -\(progress)-")
        
        OperationQueue.main.addOperation {
            // self.progressDownloadIndicator.progress = progress
            
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        
        
        Http.stopActivityIndicator()
        
        print("Dowloading is finished.")
        
        //Http.alert("", "Dowloading is finished.")
        
        do {
            
            let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            //
            let destinationUrl = documentsDirectoryURL.appendingPathComponent(fileNameR)
            print(destinationUrl)
            
            // after downloading your file you need to move it to your destination url
            try FileManager.default.moveItem(at: location, to: destinationUrl)
            print("File moved to documents folder")
            
            //to play file instantly after downloading.
            
            OperationQueue.main.addOperation {
                self.playDownload(fileName: self.fileNameR)
            }
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    //MARK:-===================================================================
    
    
    
    func getNewImage(fileName: String)-> UIImageView{
        // then lets create your document folder url
        let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        // lets create your destination file url
        
        let destinationUrl = documentsDirectoryURL.appendingPathComponent(fileName)
        
        
        print(destinationUrl)
        let image = UIImageView()
        
        let data = Data()
        do {
            try  data.write(to: destinationUrl, options: .atomic)
            image.image = UIImage(data: data)
            return image
            print("saved at:", destinationUrl.path)
        } catch   {
            return image
            print(error.localizedDescription)
        }
        
    }
    
    
    //MARK: EPContactsPicker delegates
    func epContactPicker(_: EPContactsPicker, didContactFetchFailed error : NSError)
    {
        print("Failed with error \(error.description)")
    }
    
    func epContactPicker(_: EPContactsPicker, didCancel error : NSError)
    {
        print("User canceled the selection");
    }
    
    func epContactPicker(_: EPContactsPicker, didSelectMultipleContacts contacts: [EPContact]) {
        print("The following contacts are selected")
        for contact in contacts {
            
            for i in 0..<contact.phoneNumbers.count {
                
                let str = "\(contact.phoneNumbers[i])"
                
                let aaa = str.replacingOccurrences(of: " ", with: "")
                print("aaa     ----\(aaa)")
                
                if aaa.characters.count <= 10{
                    arrContectList.add(aaa)
                } else {
                    let cc = aaa.characters.count - 10
                    let rrr =   aaa.chopPrefix(cc)
                    arrContectList.add(rrr)
                }
            }
        }
        
        print(arrContectList)
    }
    
    func epContactPicker(_: EPContactsPicker, didSelectContact contact : EPContact)
    {
        print("Contact \(contact.phoneNumbers) has been selected")
        print("contact ----\(contact.displayName())")
        
        let name = contact.displayName()
        
        let arr = contact.phoneNumbers
        
        if arr.count > 0 {
            let phn = arr[0]
            
            let contact = createContact(contact.displayName(), "", phn)
            
            do {
                try uploadContacts(contacts: [contact], name, "", phn)
            } catch { }
        }
    }
    
    func uploadContacts(contacts: [CNContact], _ givenName:String, _ familyName:String, _ phn:String) throws {
        
        guard let directoryURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return
        }
        
        var filename = NSUUID().uuidString
        
        // Create a human friendly file name if sharing a single contact.
        if let contact = contacts.first, contacts.count == 1 {
            
            if let fullname = CNContactFormatter().string(from: contact) {
                filename = fullname.components(separatedBy: " ").joined(separator: "")//.componentsSeparated(by: " ").joined(separator: "")
            }
        }
        
        //        let fileURL = directoryURL.appendingPathComponentname.URLByAppendingPathExtension("vcf")
        
        self.file_name =  "\(Date().getStringDate("yyyy_MM_dd_HH_mm_ss_SSSS")).vcf"
        // file_nameTemp = "vcf"
        
        //    let fileURL = URL(string: "\(directoryURL)/\(self.file_name)")
        
        let data = try CNContactVCardSerialization.data(with: contacts)
        
        imgData = data
        
        
        let nnnn = "\(givenName)\n\(phn)"
        
        print("nnnn-\(nnnn)-")
        
        actionSend1 (nnnn)
    }
    
    func createContact (_ givenName:String, _ familyName:String, _ phn:String) -> CNContact {
        
        // Creating a mutable object to add to the contact
        let contact = CNMutableContact()
        
        contact.imageData = NSData() as Data // The profile picture as a NSData object
        
        contact.givenName = givenName
        contact.familyName = familyName
        
        //let homeEmail = CNLabeledValue(label:CNLabelHome, value:CNPhoneNumber(stringValue: "123456"))
        //let workEmail = CNLabeledValue(label:CNLabelWork, value:CNPhoneNumber(stringValue: "1234561"))
        
        //contact.emailAddresses = [homeEmail as! CNLabeledValue<NSString>, workEmail as! CNLabeledValue<NSString>]
        
        contact.phoneNumbers = [CNLabeledValue(
            label:CNLabelPhoneNumberiPhone,
            value:CNPhoneNumber(stringValue:phn))]
        
        return contact
    }
    
    @IBAction func actionContact(_ sender: Any) {
        viewPopup.removeFromSuperview()
        arrContectList = NSMutableArray()
        let contactPickerScene = EPContactsPicker(delegate: self, multiSelection:false, subtitleCellType: SubtitleCellValue.phoneNumber)
        let navigationController = UINavigationController(rootViewController: contactPickerScene)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func actionSend1 (_ msg:String) {
        viewPopup2.removeFromSuperview()
        setDefoultTimeSendMessage()
        var maxId = DBManagerChat.sharedInstance.getLastId(query: "select * from ChatTable")
        
        //   var maxId = DBManager.shared.getLastId()
        
        maxId = maxId + 1
        
        
        uploadData(url: WebServices.uploadFile, data: imgData, params: ["sap_id":getSap_id(), "msg":msg], completionHandler: { (json) in
            
            if json != nil {
                let dictJSN = json as? NSDictionary
                
                print("uploadFile---->\(String(describing: dictJSN))<--dictJSN")
                var delivery_type = "G"
                if self.fromChattingType ==  chatingType.individual {
                    delivery_type = "I"
                }
                
                
                let direction = "out", downloading = "0", file_path = string(dictJSN!, "file"), group_id = "0" , msg_timestamp = "\(Int(self.timeInterval))" , msg_type = "F", status = "U", date = dateFormateToGate(format: "MMMM dd, yyyy"), extra = "", file = string(dictJSN!, "file"), file_name = self.file_name, group_name = "", time = localToUTCTime(date: dateFormateToGate(format: "h:mm a")), type = "F"
                
                
                
                let query111 = "insert into ChatTable (Incid, delivery_type, direction, downloading, file_path, group_id, id, msg, msg_from, msg_timestamp, msg_to, msg_type, name, pk_chat_id, status, topic, topic_id, xmpp_user, date, extra, file, file_name, group_name, time, type, reply_id) values (null, '\(delivery_type)', '\(direction)', '\(downloading)', '\(file_path)', '\(group_id)', '\(maxId)', '\(msg)', '\(getSap_id())', '\(msg_timestamp)', '\(self.ContactTemp.pernr)', '\(msg_type)', '\(self.ContactTemp.name)', '\(self.ContactTemp.pk_user_id)', '\(status)', '\(self.topic_name)', '\(self.topic_id)', '\(self.ContactTemp.xmpp_id)', '\(date)', '\(extra)', '\(file)', '\(file_name)', '\(group_name)', '\(time)', '\(type)','\(self.ReplayId)')"
                
                DBManagerChat.sharedInstance.prepareToInsert(query: query111, completionHandler: { (count) in
                    
                })
                let dict1 = NSMutableDictionary(dictionary:["delivery_type":self.isGroupType, "direction":"out", "downloading":0, "file_path":string(dictJSN!, "file"), "group_id":"0", "id":maxId, "msg":msg, "msg_from":"\(getSap_id())", "msg_timestamp":"\(Int(self.timeInterval))", "msg_to":  self.ContactTemp.pernr, "msg_type": "F", "name":  self.ContactTemp.name, "pk_chat_id": self.ContactTemp.pk_user_id, "status": "U", "topic": self.topic_name, "topic_id": self.topic_id, "xmpp_user": self.ContactTemp.xmpp_id, "date":date,"extra":"300_300","file":string(dictJSN!, "file"),"file_name":self.file_name,"group_name":"","time":time,"type":"F","reply_id":self.ReplayId])
                
                
                //  self.ReplayId = "0"
                
                //                self.gatMessageForReply(dict12: dict1)
                //                self.objectAddInmyArr(dict: dict1)
                //              //  self.arrMessages.add(dict1)
                //                self.dictTemp = dict1
                self.objectAddInmyArr(dict: dict1)
                let params1  = NSMutableDictionary (dictionary:["sap_id": getSap_id(), "data" : converDictToJson(dict: NSMutableArray(array: [dict1])) ,"device_type":"IOS"])
                self.SyncMessageMultiDataWebServices(params: params1)
                
                
                //   self.tvTitle.text = ""
            }
            
        })
    }
    
    
    
    //===================================== Rahul 13 Oct. ============================================
    
    @IBOutlet var viewContact: UIView!
    @IBOutlet var tblContact: UITableView!
    @IBOutlet var tfSearch: UITextField!
    
    
    let imgCheck = UIImage(named: "ic_checkbox_checked_24.png")
    let imgUnCheck = UIImage(named: "ic_checkbox_blank_24.png")
    
    
    var arrContact = NSMutableArray()
    var arrContactTemp = NSMutableArray()
    
    func getContactArrayFromDefault() {
        let defaults = UserDefaults.standard
        
        if let dict: NSDictionary =  defaults.object(forKey: "ContactJson") as? NSDictionary {
            
            if let arr = dict.object(forKey: "messagecontact") as? NSArray {
                
                for i in 0..<arr.count {
                    
                    let dict = arr.object(at: i) as! NSDictionary
                    
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
                    ob.badgeCount = number(dict, "badge_count").intValue
                    
                    ob.check = false
                    
                    if let arr =   maPersonContact{
                        for i in 0 ..< arr.count {
                            let ob1 = maPersonContact?[i] as? groupdetailClass
                            //     print("pernr10---->",string(dict, "pernr"),ob1?.pernr)
                            if string(dict, "pernr") == ob1?.pernr {
                                ob.check = true
                            }
                        }
                    }
                    
                    self.arrContact.add(ob)
                }
            }
            
            
            arrContactTemp = self.arrContact
            
            tblContact.reloadData()
        }
        
    }
    
    
    
    let arrSearch = NSArray()
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == tfSearch {
            
            let newLength: Int = textField.text!.characters.count + string.characters.count - range.length
            
            if string == "\n" {
                
                textField.resignFirstResponder()
                return false
                
            } else {
                if newLength == 0 {
                    
                    self.arrContact = arrContactTemp
                    tblContact.reloadData()
                }else {
                    search(strSearch: textField.text! + string)
                }
            }
        }
        return true
    }
    
    func search(strSearch:String) {
        
        let arr =  NSMutableArray()
        
        for i in 0 ..< arrContactTemp.count {
            
            let dict = arrContactTemp.object(at: i) as! ContactClass
            
            if dict.name.subString(strSearch) {
                arr.add(dict)
            }
        }
        arrContact = arr
        
        tblContact.reloadData()
    }
    
    
    @IBAction func btnAddContact(_ sender: Any) {
        
        viewContact.frame = self.view.frame
        self.view.addSubview(viewContact)
    }
    
    @IBAction func btnRemoveConact(_ sender: Any) {
        
        viewContact.removeFromSuperview()
    }
    
    @IBAction func btnSave(_ sender: Any) {
        wsAddContact()
        
    }
    
    func getSelectedMembers() -> String {
        // let arrTemp = NSMutableArray()
        
        
        var strReturn = ""
        
        var y = 0
        
        while y < arrContact.count {
            
            
            let obj = arrContact.object(at: y) as! ContactClass
            
            if obj.check {
                
                if y == 0 {
                    
                    strReturn = obj.pk_user_id
                    
                } else {
                    
                    strReturn += "," + obj.pk_user_id
                }
                
                
                
            }
            
            y += 1
        }
        return strReturn
    }
    
    
    // var dictTemp  =  NSMutableDictionary()
    
    
    
    
    func SyncMessageMultiDataWebServices( params:NSMutableDictionary ){
        self.uploadData(url:WebServices.syncMessageMulti , data: nil, params: params as? [String : String] , completionHandler: { (json) in
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
                                
                                //    DBManager.shared.updateChatMsg(query: "update ChatTable set status=?, id=? where Incid=?", values: ["P",string(dictTemp, "pk_chat_id"),string(dictTemp, "id")])
                                
                                DBManagerChat.sharedInstance.prepareToInsert(query: "update ChatTable set status='P', id=\(string(dictTemp, "pk_chat_id")) where Incid=\(string(dictTemp, "id"))", completionHandler: { (arr) in
                                })
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
            
        })
    }
    func wsAddContact() {
        
        let params  = NSMutableDictionary (dictionary:[
            
            "sap_id": getSap_id() ,
            "members" : getSelectedMembers() ,
            "group_id" : groupcontactClassTemp.group_id])
        
        Http.instance().json(WebServices.addmember, params, "POST", ai: true, popup: true, prnt: true, nil) { (json,param) in
            
            if json != nil {
                if let  dictTmp  = json as? NSDictionary {
                    let arrTmp = NSMutableArray()
                    var str = ""
                    
                    if let grupdetail:NSArray = dictTmp.object(forKey: "data") as? NSArray {
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
                            
                            let name1 = string(dict, "ename")
                            if name1 != "" {
                                str = str + name1 + ","
                            }
                            arrTmp.add(ob)
                            
                        }
                    }
                    self.lblTyping.text = str
                    
                    self.maPersonContact = arrTmp
                    self.tblGroupContacts.reloadData()
                }
                
                
                //  var str = ""
                //
                
                
                //                for i in 0 ..< self.arrContact.count {
                //                    let ob = self.arrContact[i] as? ContactClass
                //                    if let name = ob?.name {
                //                        if name != "" {
                //                            str = str + name + ","
                //                        }
                //
                //                    }
                //                }
                
                self.viewContact.removeFromSuperview()
                
            }
        }
    }
    func getTopicList(){
        let defaults = UserDefaults.standard
        
        if let dict:NSDictionary =  defaults.object(forKey: "ContactJson") as? NSDictionary { //data is already
            
            if let arr:NSArray =   dict.object(forKey: "topics") as? NSArray  {
                for i in 0..<arr.count {
                    let dict = arr.object(at: i) as! NSDictionary
                    let ob = topicClass()
                    ob.topic = string(dict, "topic")
                    ob.id = string(dict, "id")
                    
                    self.arrTopic.add(ob)
                }
            }
        }
    }
    
    func wsdeletechat(section:Int, index:Int) {
        let dict0 = (arrMessages.object(at: section) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        let arr = dict0.object(forKey: "data") as! NSMutableArray
        
        let params = NSMutableDictionary()
        
        if let dict : NSMutableDictionary = arr.object(at: index) as? NSMutableDictionary {
            params["pk_chat_id"] = string(dict, "pk_chat_id")
            params["direction"] = string(dict, "direction")
            print("section --\(section)-index--\(index)--delete data --->\(dict)")
            Http.instance().json(WebServices.BaseUrl + "chat/deletechat", params, "POST", ai: true, popup: true, prnt: true, nil) { (json, params) in
                if (json != nil) {
                    
                    if string(json as! NSDictionary, "status") == "1" {
                        
                        //   let arr: NSMutableArray = arrMessages as? NSMutableArray
                        
                        arr.removeObject(at: index)
                        let arrMessagesTmp = (self.arrMessages.object(at: section) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                        arrMessagesTmp.setValue(arr, forKey: "data")
                        self.arrMessages.replaceObject(at: section, with: arrMessagesTmp)
                        
                        let indexPath = IndexPath(item: index, section: section)
                        self.tblView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
                        DispatchQueue.main.async {
                            self.tblView.reloadData()
                        }
                        
                        DBManagerChat.sharedInstance.deleteMessage(query: "DELETE FROM ChatTable WHERE IncId='\(string(dict, "IncId"))'", completionHandler: { (isOk) in
                            
                        })
                        //                        if  DBManager.shared.deleteChatMessage(withquery: "DELETE FROM ChatTable WHERE IncId=?", values: [Int(string(dict, "IncId"))]) {
                        //
                        //                        }
                        
                        
                    }
                    
                }
            }
            
        }
    }
    func uploadData(url: String?, data: Data?, params: [String: String]?, completionHandler: @escaping (Any?) -> Swift.Void)
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
            
            body.append("Content-Disposition: form-data; name=\"attachment\"; filename=\"\(self.file_name)\"\r\n".data(using: String.Encoding.utf8)!)
            
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
    
    func gatMessageForReply(dict12: NSMutableDictionary)  {
        for ii in 0 ..< arrAllMessageArr.count {
            let dict = arrAllMessageArr.object(at: ii) as! NSDictionary
            if Int(string(dict, "id")) == Int(string(dict12, "reply_id")) {
                dict12.setValue(dict, forKey: "reply_data")
            }
        }
        
    }
    var arrAllMessageArr = NSMutableArray()
    func getDetailFromDataBase() {
        
        //        if ContactTemp.pernr10[0] != "E" {
        //            ContactTemp.pernr10 = "E" + ContactTemp.pernr10
        //        }
        var query = "select * from ChatTable where group_id='\(groupcontactClassTemp.group_id)' and delivery_type='G'"
        // var value = ["\(groupcontactClassTemp.group_id)","G"]
        if fromChattingType == chatingType.individual {
            let sss = "E" + "\(ContactTemp.pernr)"
            print("sss -\(sss)----\(ContactTemp.pernr)")
            
            query = "select * from ChatTable where delivery_type='I' and (msg_to='\(ContactTemp.pernr)' OR msg_to='\(getSap_id())')"
            
            //             query = "select * from ChatTable where msg_to='\(ContactTemp.pernr)' and delivery_type='I' (msg_to='P' OR msg_to='D')"

            //   query = "select * from ChatTable where msg_to=? and delivery_type=?"
            //   value = ["\(ContactTemp.pernr10)","I"]
        }
        
        
        //  Http.instance().stopActivityIndicator()
        DBManagerChat.sharedInstance.DatabaseToGatValues(query: query, completionHandler: { (arrData) in
            if arrData != nil {
                
                if let arr_00 :NSMutableArray = arrData as? NSMutableArray {
                    print("arr_00 ----------\(arr_00)----arr_00")
                    
                    var arr = arr_00
                    self.arrAllMessageArr = arr
                    let arr_00 = NSMutableArray()
                    
                    for ii in 0 ..< self.arrAllMessageArr.count {
                        let dict = (self.arrAllMessageArr.object(at: ii) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                        
                        if Int(string(dict, "reply_id")) != 0 {
                            self.gatMessageForReply(dict12: dict)
                        }
                        arr_00.add(dict)
                    }
                    arr = arr_00
                    
                    if arr.count == 0 {
                        return
                    }
                    
                    let arrData = NSMutableArray()
                    var arrTmp = NSMutableArray()
                    
                    for ii in 0 ..< arr.count {
                        
                        var dictTmp1 = NSMutableDictionary()
                        let dictTmp0 = arr.object(at: ii) as! NSMutableDictionary
                        // dictTmp1 = dictTmp0
                        // let intervalPresent =  TimeInterval(string(dictTmp0, "msg_timestamp"))
                        
                        if arr.count - 1 > ii {
                            dictTmp1 = arr.object(at: ii+1) as! NSMutableDictionary
                        }else {
                            dictTmp1 = dictTmp0
                        }
                        // var intervalTo = TimeInterval(string(dictTmp1, "msg_timestamp"))
                        
                        //                        if arr.count - 1 == ii {
                        //                            print("intervalTo----\(String(describing: intervalTo))--intervalTo")
                        //
                        //                            intervalTo = intervalPresent! + 100000   ///  use to get  1 day differance
                        //                            print("intervalTo----\(intervalTo!)--intervalTo")
                        //                        }
                        
                        //    let date = Date(timeIntervalSince1970: intervalPresent!)
                        //  let date1 = Date(timeIntervalSince1970: intervalTo!)
                        
                        //                        let differance00 = ii == 0 ? 0 : dtCount
                        
                        arrTmp.add(dictTmp0)
                        
                        //string(dictTmp0, "date")) date1-->\(string(dictTmp1, "date")
                        
                        
                        let dateH1 = string(dictTmp0, "date").getDate("MMMM dd, yyyy")
                        let dateH2 = string(dictTmp1, "date").getDate("MMMM dd, yyyy")
                        
                        var dtCount = dateH1.daysBetweenDate(toDate: dateH2)
                        if arr.count - 1 == ii {
                            dtCount = 1
                        }
                        
                        if dtCount != 0 {
                            let dict = NSMutableDictionary()
                            let dict0 = (arrTmp.object(at: arrTmp.count - 1) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                            
                            dict["date"] = string(dict0, "date")
                            dict["data"] = arrTmp
                            self.workOnTimestamp(dict)
                            arrData.add(dict)
                            arrTmp = NSMutableArray()
                        }
                        
                        
                    }
                    self.pageCount = arrData.count - 1
                    self.arrAllMSGRecord = arrData
                    let dict_100 = (self.arrAllMSGRecord.object(at: arrData.count - 1) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                    self.arrMessages = NSMutableArray()
                    self.arrMessages.add(dict_100)
                    
                    //  self.arrMessages = arrData
                    DispatchQueue.main.async {
                        self.tblView.reloadData()
                        self.moveToLastComment()
                        //         print("total - \(self.arrAllMSGRecord.count)-arrMessages ----------\(self.arrMessages)----arrMessages")
                    }
                }
            }
            
        })
        self.moveToLastComment()
        
    }
    
    
    
    
    
    func typingStatus(type:String){
        
        let dictParams = NSMutableDictionary()
        dictParams["from_user_xmpp"] = string(getUserDetail(), "xmpp_id")//"c_830"
        dictParams["group_id"] = groupcontactClassTemp.group_id
        dictParams["delivery_type"] = isGroupType
        dictParams["from_user_id"] =   fromUser
        dictParams["from_user_name"] = string(getUserDetail(), "name")
        dictParams["type"] = type //"starttyping"
        
        //   var jsonData = NSData()
        let strTest111 = converDictToJson(dict: dictParams)
        
        
        OneMessage.sendMessage(strTest111, to: self.toUser, completionHandler: { (stream, message) -> Void in
        })
    }
    func getWeekDay (_ day:Int) -> String {
        if day == 1 {
            return "sonday"
        } else if day == 2 {
            return "monday"
        } else if day == 3 {
            return "tuesday"
        } else if day == 4 {
            return "wednesday"
        } else if day == 5 {
            return "thursday"
        } else if day == 6 {
            return "friday"
        } else if day == 7 {
            return "saturday"
        }
        
        return ""
    }
    func workOnTimestamp (_ md:NSMutableDictionary) {
        // let msg_timestamp = string(md, "msg_timestamp")
        
        
        let dateH1 = string(md, "date").getDate("MMMM dd, yyyy")
        let curDate = Date()
        
        
        let dtCount = dateH1.daysBetweenDate(toDate: curDate)
        
        
        if dtCount == 0 {
            md["harish_day"] = "Today"
            
        }else if dtCount == 1 {
            md["harish_day"] = "Yesterday"
            
        }else {
            md["harish_day"] = dateH1.getStringDate("E, dd MMM")
        }
        
        
        // let date = Date(timeIntervalSince1970: TimeInterval(msg_timestamp)!)
        
        //let calendar = Calendar(identifier: .gregorian)
        
        
        //  let dif = date.all(from: curDate)
        
        //  print("Harish dif-[\(dif.day!)]-[\(date)]-")
        /*  print("date ===>\(date.getStringDate("E, dd MMM"))")
         if dif.day! < -7 {
         md["harish_day"] = date.getStringDate("E, dd MMM")
         } else {
         let curDay = calendar.component(.weekday, from: curDate)
         let dateDay = calendar.component(.weekday, from: date)
         
         let diff = curDay - dateDay
         
         if diff == 0 {
         md["harish_day"] = "Today"
         } else if diff == 1 {
         md["harish_day"] = "Yesterday"
         } else {
         md["harish_day"] = getWeekDay (dateDay)
         }
         }*/
    }
    
    func encodeVideo(videoURL: URL)  {
        let avAsset = AVURLAsset(url: videoURL as URL)
        
        let startDate = NSDate()
        
        //Create Export session
        let exportSession = AVAssetExportSession(asset: avAsset, presetName: AVAssetExportPresetPassthrough)
        
        // exportSession = AVAssetExportSession(asset: composition, presetName: mp4Quality)
        //Creating temp path to save the converted video
        
        
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let myDocumentPath = NSURL(fileURLWithPath: documentsDirectory).appendingPathComponent("temp.mp4")?.absoluteString
        //   let url = NSURL(fileURLWithPath: myDocumentPath!)
        
        let documentsDirectory2 = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as NSURL
        
        let filePath = documentsDirectory2.appendingPathComponent("\("\(Int(NSDate().timeIntervalSince1970))").mp4")
        deleteFile(filePath: filePath! as NSURL)
        
        //Check if the file already exists then remove the previous file
        if FileManager.default.fileExists(atPath: myDocumentPath!) {
            do {
                try FileManager.default.removeItem(atPath: myDocumentPath!)
            }
            catch _ {
                
            }
        }
        
        
        
        exportSession!.outputURL = filePath
        exportSession!.outputFileType = AVFileTypeMPEG4
        exportSession!.shouldOptimizeForNetworkUse = true
        let start = CMTimeMakeWithSeconds(0.0, 0)
        let range = CMTimeRangeMake(start, avAsset.duration)
        exportSession?.timeRange = range
        
        exportSession!.exportAsynchronously(completionHandler: {() -> Void in
            switch exportSession!.status {
            case .failed:
                print("error--->\(String(describing: exportSession?.error))")
            case .cancelled:
                print("Export canceled")
            case .completed:
                //Video conversion finished
                var endDate = NSDate()
                
                var time = endDate.timeIntervalSince(startDate as Date)
                print(time)
                print("Successful!")
                if let url_12 = exportSession?.outputURL {
                    print(url_12)
                    
                    do {
                        let videoData = try NSData(contentsOf: url_12, options: NSData.ReadingOptions())
                        self.imgData = videoData as Data
                        print("iii=====\(self.imgData.count)")
                        
                    } catch {
                        print(error)
                    }
                    
                }
                
            default:
                break
            }
            
        })
        
        
    }
    func encodeAudio(audioURL: URL)  {
        let avAsset = AVURLAsset(url: audioURL as URL)
        
        let startDate = NSDate()
        
        //Create Export session
        let exportSession = AVAssetExportSession(asset: avAsset, presetName: AVAssetExportPresetPassthrough)
        
        // exportSession = AVAssetExportSession(asset: composition, presetName: mp4Quality)
        //Creating temp path to save the converted video
        
        
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let myDocumentPath = NSURL(fileURLWithPath: documentsDirectory).appendingPathComponent("temp.caf")?.absoluteString
        //   let url = NSURL(fileURLWithPath: myDocumentPath!)
        
        let documentsDirectory2 = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as NSURL
        
        let filePath = documentsDirectory2.appendingPathComponent("\("\(Int(NSDate().timeIntervalSince1970))").mp3")
        deleteFile(filePath: filePath! as NSURL)
        
        //Check if the file already exists then remove the previous file
        if FileManager.default.fileExists(atPath: myDocumentPath!) {
            do {
                try FileManager.default.removeItem(atPath: myDocumentPath!)
            }
            catch let error {
                print(error)
            }
        }
        
        
        
        exportSession!.outputURL = filePath
        exportSession!.outputFileType = AVFileTypeMPEGLayer3
        exportSession!.shouldOptimizeForNetworkUse = true
        let start = CMTimeMakeWithSeconds(0.0, 0)
        let range = CMTimeRangeMake(start, avAsset.duration)
        exportSession?.timeRange = range
        
        exportSession!.exportAsynchronously(completionHandler: {() -> Void in
            switch exportSession!.status {
            case .failed:
                print("error--->\(String(describing: exportSession?.error))")
            case .cancelled:
                print("Export canceled")
            case .completed:
                //Video conversion finished
                let endDate = NSDate()
                
                let time = endDate.timeIntervalSince(startDate as Date)
                print(time)
                print("Successful!")
                if let url_12 = exportSession?.outputURL {
                    print(url_12)
                    
                    do {
                        let videoData = try NSData(contentsOf: url_12, options: NSData.ReadingOptions())
                        self.imgData = videoData as Data
                        self.file_name = "\("\(Int(NSDate().timeIntervalSince1970))").mp3"
                        print("iii=====\(self.imgData.count)")
                        
                    } catch {
                        print(error)
                    }
                    
                }
                
            default:
                break
            }
            
        })
    }
    //
    
    func deleteFile(filePath:NSURL) {
        guard FileManager.default.fileExists(atPath: filePath.path!) else {
            return
        }
        
        do {
            try FileManager.default.removeItem(atPath: filePath.path!)
        }catch{
            fatalError("Unable to delete file: \(error) : \(#function).")
        }
    }
}
//MARK:-  webservices

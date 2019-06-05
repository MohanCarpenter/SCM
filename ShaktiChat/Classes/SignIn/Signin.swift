//
//  ViewController.swift
//  ShaktiChat
//
//  Created by kavya_mac_1 on 9/5/17.
//  Copyright © 2017 himanshuPal_kavya. All rights reserved. Was not something to give
//
class chatObject:NSObject{
    var toName = ""
    var from_name = ""
    var to_id  = ""
    var frome_id = ""
    var to_xmpp_id = ""
    var from_xmpp_id = ""
    
    
}

import UIKit

class Signin: UIViewController , UITextFieldDelegate{
    
    @IBOutlet var tfPassword: UITextField!
    @IBOutlet var tfName: UITextField!
    @IBOutlet var scrlView: UIScrollView!
    @IBOutlet var btnUserType: UIButton!
    @IBOutlet var viewPopUp: UIView!
    @IBOutlet var btnCustomer: UIButton!
    @IBOutlet var btnforgotPass: UIButton!

    @IBOutlet var btnVender: UIButton!
    @IBOutlet var btnEmployee: UIButton!
    var isOverAppUpdated = true
    //  var loginId = ""
    var toChat = ""
    var passswd = ""
    var loginUser = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        scrlView.contentSize = CGSize(width: 0.0, height: btnforgotPass.frame.origin.y +  btnforgotPass.frame.size.height)
        tfName.delegate = self
        tfPassword.delegate = self
        UITextField.appearance().tintColor = .white
        viewPopUp.frame = self.view.frame
        viewPopUp.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        btnUserType.setTitle("User Type", for: .normal)
        
        if UserDefaults.standard.object(forKey:"InactiveTime" ) != nil {
            if let datee : Date  = UserDefaults.standard.value(forKey: "InactiveTime") as? Date {
                print("datee --",datee)
                let dtCount = datee.hourBetweenDate(toDate:Date())
                print("dtCount-->\(dtCount)<-")
                if dtCount > 1 && dtCount == 1{
                    
                    let defaults = UserDefaults.standard
                    defaults.removeObject(forKey: "name")
                    defaults.removeObject(forKey: "password")
                    defaults.removeObject(forKey: "usertype")
                    defaults.removeObject(forKey: "userdetail")
                    defaults.removeObject(forKey: chatRangId.chatMinId)
                    defaults.removeObject(forKey: chatRangId.chatMaxId)
                    defaults.removeObject(forKey: "ContactJson")
                    defaults.synchronize()
                }
            }
            UserDefaults.standard.removeObject(forKey: "InactiveTime")
            UserDefaults.standard.synchronize()
        }
        checkUpdateversion()
        
        
        //        let defaults = UserDefaults.standard
        //        if (defaults.object(forKey: "name") != nil) {
        //            tfName.text = defaults.object(forKey: "name") as? String
        //            tfPassword.text = defaults.object(forKey: "password") as? String
        //            userType = defaults.object(forKey: "usertype") as! String
        //
        //            if userType == "V" {
        //            btnUserType.setTitle("Vender", for: .normal)
        //            }else if userType == "E" {
        //                btnUserType.setTitle("Employee", for: .normal)
        //            }else if userType == "C" {
        //              btnUserType.setTitle("Customer", for: .normal)
        //            }
        //            wsSignIn()
        //        }
        
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK:-
    
    func checkUpdateversion(){
        Http.instance().json(WebServices.updateVersion,  nil, "GET", ai: true, popup: true, prnt: true, nil) { (json,param) in
            
            if let result:NSDictionary = json as? NSDictionary{
                if string(result , "status") == "1"  {
                    if let text:String = Bundle.main.infoDictionary?["CFBundleVersion"]  as? String {
                        print("CFBundleVersion -->\(text)>-")
                        if let version : Float = Float(text) {
                            print("version -->\(version)>-")
                            if number(result, "version_ios").floatValue <= version { // NSNumber(value: Float(text)!)
                               // Http.alert("version_ios", string(result, "version_ios"))
                            }else {
                                self.isOverAppUpdated = false
                            }
                        }
                    }
                }
            }
            
            let defaults = UserDefaults.standard
            if (defaults.object(forKey: "name") != nil) && self.isOverAppUpdated{
                self.tfName.text = defaults.object(forKey: "name") as? String
                self.tfPassword.text = defaults.object(forKey: "password") as? String
                self.userType = defaults.object(forKey: "usertype") as! String
                
                if self.userType == "V" {
                    self.btnUserType.setTitle("Vender", for: .normal)
                }else if self.userType == "E" {
                    self.btnUserType.setTitle("Employee", for: .normal)
                }else if self.userType == "C" {
                    self.btnUserType.setTitle("Customer", for: .normal)
                }
                self.wsSignIn()
            }
        }
        
        
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField.frame.origin.y >= 200) {
            scrlView.setContentOffset(CGPoint(x: 0, y: CGFloat(Int(textField.frame.origin.y - 200))) , animated: true)
        }
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == tfName {
            tfPassword.becomeFirstResponder()
        } else if textField == tfPassword {
            tfPassword.resignFirstResponder()
            scrlView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let length = (textField.text?.characters.count)! + string.characters.count - range.length
        if textField == tfName {
            return (length > 40) ? false : true
        } else if textField == tfPassword {
            return (length > 20) ? false : true
        }
        return true
    }
    
    
    
    
    func checkValidation() -> String? {
        if !self.isOverAppUpdated {
            return "Updated version are available please update the app from app store."
        }else if userType == "" {
            return "Please select usertype."
        }else if tfName.text?.characters.count == 0 {
            return "Please enter user_id"
        }  else if tfPassword.text?.characters.count == 0 {
            return "Please enter password."
        }
        return nil
    }
    
    
    
    @IBAction func actionSignin(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: chatRangId.chatMinId)
        UserDefaults.standard.removeObject(forKey: chatRangId.chatMaxId)
        
        if let str = checkValidation() {
            Http.alert("", str)
        } else {
            wsSignIn()
        }
        
        
    }
    
    
    
    //MARK:- SignIn API
    func wsSignIn() {
        
        let params  = NSMutableDictionary (dictionary:[
            "PERNR": tfName.text!,
            "PASS": tfPassword.text! ,
            "category" : userType
            ])
        
        
        Http.instance().json(WebServices().api_login, params, "POST", ai: true, popup: true, prnt: true, nil) { (json,param) in
            
            if json != nil {
                let json = json as! NSArray
                let result = json.object(at: 0) as! NSDictionary
                if string(result , "status") == "success"  {
                    let name = string(result, "ename")
                    
                    self.getUserDetail(name)
                }else{
                    if string(result , "status") == "error"  {
                        Http.alert("", "Invalid Username and Password")
                    }else {
                        Http.alert("", string(result, "status"))
                    }
                }
            }
        }
    }
    var xmpp_pass = ""
    func getUserDetail( _ name : String){
        
        let params  = NSMutableDictionary (dictionary:[
            //=651&name=Rohit Patidar&password=FAZA
            "sap_id": userType +  tfName.text!,
            "password": tfPassword.text!,
            "name" : name,
            "device_id" : UIDevice.current.identifierForVendor!.uuidString ,
            "device_type" : "IOS" ,
            "device_name" : UIDevice.current.modelName
            
            ])
        
        Http.instance().json(WebServices.api_getUserDetail, params, "POST", ai: true, popup: true, prnt: true, nil) { (json,param) in
            
            
            if json != nil {
                if string(json as! NSDictionary, "status") == "1" {
                    if let result: NSDictionary = json as? NSDictionary {
                        if let result: NSDictionary = result.object(forKey: "data") as? NSDictionary {
                            print(result)
                            // kAppDelegate.userDetail = result.mutableCopy() as! NSDictionary
                            //  print(kAppDelegate.userDetail)
                            let defaults = UserDefaults.standard
                            defaults.set(result, forKey: "userdetail")
                            defaults.set(self.tfName.text!, forKey: "name")
                            defaults.set(self.tfPassword.text!, forKey: "password")
                            defaults.set(self.userType, forKey: "usertype")
                            
                            defaults.removeObject(forKey: "sap_id")
                            defaults.set(self.userType + self.tfName.text!, forKey: "sap_id")
                            
                            if result.object(forKey: "xmpp_id") != nil {
                                self.loginUser = "\(result.object(forKey: "xmpp_id")!)\(ChatConstants().chatHostName)"
                                defaults.set(result.object(forKey: "xmpp_id"), forKey: "xmpp_id")
                            }
                            if result.object(forKey: "xmpp_pass") != nil {
                                self.passswd = "\(result.object(forKey: "xmpp_pass")!)"
                                defaults.set(result.object(forKey: "xmpp_pass"), forKey: "xmpp_pass")
                            }
                            
                            defaults.synchronize()
                            self.loginWithXmpp()
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "RootVendor") as! RootVendor
                            self.navigationController?.pushViewController(vc, animated: true)
                            
                        }
                    }
                }else{
                    if let result: NSDictionary = json as? NSDictionary {
                        Http.alert("", string(result, "data"))
                    }
                }
            }
        }
    }
    
    
    func loginWithXmpp() {
        UserDefaults.standard.removeObject(forKey: kXMPP.myJID)
        UserDefaults.standard.removeObject(forKey: kXMPP.myPassword)//kXMPP.myPassword
        
        //        let userId = "c_1" //"c_505"//  PredefinedConstants().appDelegate.dictUserDetails.hmGetString(forKey: "_id")
        //        let id = userId + ChatConstants().chatHostName
        // let name = "mohan" // kAppDelegate.dictUserDetails.hmGetString(forKey: "full_name")
        print("loginUser--> \(loginUser) -- passswd--->\(passswd)")
        
        OneChat.sharedInstance.connect(username: loginUser, password: passswd) { (stream, error) -> Void in
            
            
            if let _ = error {
                print("Error connecting \(error?.description)")
                if error!.description == "<failure xmlns=\"urn:ietf:params:xml:ns:xmpp-sasl\"><not-authorized></not-authorized></failure>" {
                    print("honey test test")
                    UserDefaults.standard.removeObject(forKey: kXMPP.myJID)
                    UserDefaults.standard.removeObject(forKey: kXMPP.myPassword)
                    //PredefinedConstants().appDelegate.registerUserOnOpenFire(id, strPwd: userId)
                    //      PredefinedConstants().appDelegate.honeyRegisterUserOnOpenFireWithNameHoney(id: id, strPwd: userId, strUserName: name)
                }
            }
        }
    }
    
    
    @IBAction func actionClosePopup(_ sender: Any) {
        viewPopUp.removeFromSuperview()
    }
    @IBAction func actionVender(_ sender: Any) {
        userType = "V"
        btnUserType.setTitle("Vender", for: .normal)
        viewPopUp.removeFromSuperview()
        
    }
    @IBAction func actionEmployee(_ sender: Any) {
        userType = "E"
        btnUserType.setTitle("Employee", for: .normal)
        viewPopUp.removeFromSuperview()
        
    }
    @IBAction func actionCustomer(_ sender: Any) {
        userType = "C"
        btnUserType.setTitle("Customer", for: .normal)
        viewPopUp.removeFromSuperview()
        
    }
    var userType = ""
    @IBAction func actionUserType(_ sender: Any) {
        self.view.addSubview(viewPopUp)
        
    }
    
    @IBAction func actionForgotPassword(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    
}

func getSap_id() -> String { // "sap_id"
    let defaults = UserDefaults.standard
    if let sap_id:String  = defaults.object(forKey:"sap_id") as? String {
        
        var id = sap_id.replacingOccurrences(of: "E", with: "")
        id = id.replacingOccurrences(of: "V", with: "")
        id = id.replacingOccurrences(of: "C", with: "")
        
        if let usertype:String  = defaults.object(forKey:"usertype") as? String {
            id =  usertype + id
        }
        return id
    }
    return ""
}
func getUserDetail() -> NSDictionary {
    var dict = NSDictionary()
    let defaults = UserDefaults.standard
    if let dict1:NSDictionary  = defaults.object(forKey:"userdetail") as? NSDictionary {
        dict = dict1
    }
    return dict
}

public extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
        case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
        case "iPhone10,3", "iPhone10,6":                return "iPhone X"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad6,11", "iPad6,12":                    return "iPad 5"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4":                      return "iPad Pro 9.7 Inch"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro 12.9 Inch"
        case "iPad7,1", "iPad7,2":                      return "iPad Pro 12.9 Inch 2. Generation"
        case "iPad7,3", "iPad7,4":                      return "iPad Pro 10.5 Inch"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
    
}

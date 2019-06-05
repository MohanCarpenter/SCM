//
//  WebServices.swift
//  PlanMyParty
//
//  Created by vishal gupta on 13/06/17.
//  Copyright © 2017 hp. All rights reserved.
//  WebServices.syncMessageMulti

import UIKit
// let BaseUrl  = "http://shaktipumps.co.in/api/"

class WebServices: NSObject {
    // http://shakti.techinventions.in/
    // http://shaktipumps.co.in
//   static let BaseUrl  = "http://shaktipumps.co.in/api/" // live
    static let BaseUrl  = "http://shakti.techinventions.in/shaktichat/api/"

  //  http://shaktipumps.co.in/api/user/getUser
    
    let api_login = "https://spprdsrvr1.shaktipumps.com:8423/sap/bc/bsp/sap/zmessageapp1/login.htm"
    
    let api_ResetPassword = "https://spprdsrvr1.shaktipumps.com:8423/sap/bc/bsp/sap/zmessageapp1/Reset_Password.htm"
    
    let contact = "https://spprdsrvr1.shaktipumps.com:8423/sap/bc/bsp/sap/zmessageapp1/contacts_sync_copy.htm"

    
    
    static let api_getUserDetail = BaseUrl + "user/getUser"

     static let chatgetFile = BaseUrl + "chat/getFile/"
    
    
    static let syncMessageMulti = BaseUrl + "chat/syncMessageMulti"
    
    
    static let updatecontacts = BaseUrl + "user/updatecontacts"
    static let uploadFile = BaseUrl + "chat/uploadFile"
    static let addmember =  BaseUrl + "user/addmember"
    static let getChatMessage = BaseUrl + "chat/getChatMessage"
    static let logout =  BaseUrl + "user/logout"
    static let updateVersion =  "http://shaktipumps.co.in/" + "public/api.php?method=1"
    static let updateLatLong =  "http://shaktipumps.co.in/" + "public/api.php?method=2"
    
    // http://shaktipumps.co.in/ public/api.php?method=2
    
    // http://shaktipumps.co.in/public/api.php?method=1
    /*
     let api_getUserDetail = "http://shaktipumps.co.in/shaktichat/api/user/getUser"
     let chatgetFile = BaseUrl11 + "http://shaktipumps.co.in/shaktichat/api/chat/getFile/"
     static let syncMessageMulti = "http://shaktipumps.co.in/shaktichat/api/chat/syncMessageMulti"
     static let updatecontacts = "http://shaktipumps.co.in/shaktichat/api/user/updatecontacts"
     static let uploadFile = "http://shaktipumps.co.in/shaktichat/api/chat/uploadFile"
     static let addmember =  "http://shaktipumps.co.in/shaktichat/api/user/addmember"
     static let getChatMessage =  "http://shaktipumps.co.in/shaktichat/api/chat/getChatMessage"
     static let logout =   "http://shaktipumps.co.in/shaktichat/api/user/logout"
     */
}
let kAppDelegate = UIApplication.shared.delegate as! AppDelegate
let headerColor = UIColor(red: 1/255, green: 127/255, blue: 196/255, alpha: 1.0)
let lightblueColor = UIColor(red: 48/255, green: 200/255, blue: 255/255, alpha: 1.0)

class Language: NSObject {
    /*
     en = English
     es = Spanish
     ca = Catala
     */
    
    func  firstName(Languagekey:String) -> String {
        
        if  Languagekey == "es"{
           return ""
        }else if  Languagekey == "ca"{
           return ""
        }else{
        return "Please enter name."
        }
     }


}

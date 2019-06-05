//
//  AppDelegate.swift
//  ShaktiChat
//
//  Created by kavya_mac_1 on 9/5/17.
//  Copyright © 2017 himanshuPal_kavya. All rights reserved.
//

//user  for login

/*SAMPLE USERS.
 PERNR-651
 PASS- FAZA
 CATEGORY- E
 -------------------------
 PERNR-285
 PASS- IPNA
 CATEGORY- E
 */




// import xmpp_messenger_ios
import UIKit
import UserNotifications
import CoreLocation



//let kAppDelegate = UIApplication.shared.delegate as! AppDelegate

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate , CLLocationManagerDelegate{
    var locManager:CLLocationManager? = CLLocationManager()

    var window: UIWindow?
   var userDetail = NSDictionary()
    var dictChatInfo = NSMutableDictionary()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        OneChat.start(true, delegate: nil) { (stream, error) -> Void in
            if let _ = error {
                //handle start errors here
                print("errors from appdelegate")
            } else {
                print("Yayyyy")
                //Activate online UI
            }
        }
        
        
        if #available(iOS 10.0, *) {
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            UNUserNotificationCenter.current().delegate = self

        } else {
            // Fallback on earlier versions
        }
        
        DBManagerChat.sharedInstance.CreateOpenDB()
        getcurrentLocation()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {

        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
      
        UserDefaults.standard.set(Date(), forKey: "InactiveTime")
        UserDefaults.standard.synchronize()

        print("applicationDidEnterBackground ------------------------------(😊😊😊😊😊😊)")

    
   //    OneChat.stop()
//        UserDefaults.standard.removeObject(forKey: kXMPP.myJID)
//        UserDefaults.standard.removeObject(forKey: kXMPP.myPassword)

        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
       print("applicationWillEnterForeground ----------------------------------(😊😊😊😊😊😊)")

        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        if OneChat.sharedInstance.isConnected() {
            
        } else {
                print("dictChatInfo>>>>>>>>>\(dictChatInfo)")
              
                if getUserDetail().object(forKey: "xmpp_id") != nil {
                   // OneChat.stop()
                    UserDefaults.standard.removeObject(forKey: kXMPP.myJID)
                    UserDefaults.standard.removeObject(forKey: kXMPP.myPassword)
                    OneChat.start(true, delegate: nil) { (stream, error) -> Void in
                        if let _ = error {
                            //handle start errors here
                            print("errors from appdelegate")
                        } else {
                            print("Yayyyy")
                            //Activate online UI
                        }
                    }
                    UserDefaults.standard.removeObject(forKey: kXMPP.myJID)
                    UserDefaults.standard.removeObject(forKey: kXMPP.myPassword)
                    let userId = string(getUserDetail(), "xmpp_id") //  getUserDetail()
                    
                    let id = userId + ChatConstants().chatHostName
                    UserDefaults.standard.removeObject(forKey: kXMPP.myJID)
                    UserDefaults.standard.removeObject(forKey: kXMPP.myPassword)
                    OneChat.sharedInstance.connect(username: id, password: string(getUserDetail(), "xmpp_pass")) { (stream, error) -> Void in
                        if let _ = error {
                            print("Error connecting \(String(describing: error?.description))")
                            if error!.description == "<failure xmlns=\"urn:ietf:params:xml:ns:xmpp-sasl\"><not-authorized></not-authorized></failure>" {
                                print("mohan test test")
                                UserDefaults.standard.removeObject(forKey: kXMPP.myJID)
                                UserDefaults.standard.removeObject(forKey: kXMPP.myPassword)
                                // self.honeyRegisterUserOnOpenFireWithNameHoney(id: id, strPwd: userId, strUserName: name)
                                //self.registerUserOnOpenFire(id, strPwd: userId)
                            }
                        }
                    }
                }
           
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {

      print("applicationDidBecomeActive )------------------------------(😊😊😊😊😊😊)")

//        if DBManager.shared.createDatabase() {
//            print("create Database successfull")
//
//        }
//        if DBManager.shared.createmessagecontact() {
//            print("createmessagecontact create Database successfull")
//
//        }
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {


//      OneChat.stop()

        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification,withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        // Print message ID.
        print("Message userInfo willPresent:---> \(userInfo)")
      //  completionHandler([])
        completionHandler([.alert, .badge, .sound])
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse,withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
//        if let messageID = userInfo[gcmMessageIDKey] {
//        }
        print("Message userInfo didReceive:---> \(userInfo)")

        // Print full message.
     //   print("userNotificationCenter----",userInfo)
  //      NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReceiveRemoteNotification"), object: nil, userInfo: userInfo)
        
        completionHandler()
    }

    
    
    func getcurrentLocation() {
        
        let region = CLBeaconRegion(proximityUUID: NSUUID(uuidString: "8EBB5704-9697-02C9-D073-BF9162B72D7B")! as UUID, identifier: "iBeacon-6713")
        
        locManager?.delegate = self
        locManager?.desiredAccuracy = kCLLocationAccuracyBest
        locManager?.startMonitoringSignificantLocationChanges()
        locManager?.requestWhenInUseAuthorization()
        //locManager?.allowsBackgroundLocationUpdates = true
        
        locManager?.startRangingBeacons(in: region)
        
        // Check authorizationStatus
        let authorizationStatus = CLLocationManager.authorizationStatus()
        // List out all responses
        
        switch authorizationStatus {
        case .authorizedAlways:
            print("authorized")
        case .authorizedWhenInUse:
            print("authorized when in use")
        case .denied:
            print("denied")
        case .notDetermined:
            print("not determined")
        case .restricted:
            print("restricted")
        }
        
        // Get the location
        locManager?.startUpdatingLocation()
        
        if(CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways) {
            // Extract the location from CLLocationManager
            let userLocation = locManager?.location
            
            // Check to see if it is nil
            if userLocation != nil {
                ////print("location is \(userLocation)")
            } else {
                ////print("location is nil")
            }
        } else {
            locManager?.requestAlwaysAuthorization()
            ////print("not authorized")
        }
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(status == CLAuthorizationStatus.notDetermined) {
            print("Auth status unkown still!")
            locManager?.requestAlwaysAuthorization()

        }else {
            
        }

    }
    
  

    
    
    var boolLocation = false
    
    func updateLocation(){
        self.performSelector(inBackground: #selector(updateLocationBGLoop), with: nil)
    }
    func updateLocationBGLoop(){
        while boolLocation {
            self.performSelector(inBackground: #selector(sendUpdateLocationInBG), with: nil)
            sleep(UInt32(30))
        }
    }
    
    
    func sendUpdateLocationInBG(){
        
        var lattud = 0.0 , longtud = 0.0
        
        if locManager?.location?.coordinate.latitude != nil &&
            locManager?.location?.coordinate.longitude != nil {
            
            lattud = (locManager?.location?.coordinate.latitude)!
            longtud = (locManager?.location?.coordinate.longitude)!
            // http://shaktipumps.co.in/public/api.php?method=2&
            
            
            //sap_id= E285& latitude =22.758454& longitude =75.8454545

            Http.instance().json(WebServices.updateLatLong,  ["latitude":"\(lattud)","longitude":"\(longtud)","sap_id":getSap_id(),"method":"2"], "POST", ai: false, popup: true, prnt: false, nil) { (json,param) in
                
              //  print("updateLatLong--\(WebServices.updateLatLong)---",json,param)
            }
            
            
        }
        
        
        
    }
    
    func driverLocation() {
         self.performSelector(inBackground: #selector(updateDriverLocation), with: nil)
    }
    
    func updateDriverLocation() {
    }
    
    
}


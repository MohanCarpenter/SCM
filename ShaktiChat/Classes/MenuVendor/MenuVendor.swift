//
//  LeftMenuView.swift
//  ResideMenuDemo
//
//  Created by Rahul Khatri on 24/07/17.
//  Copyright © 2017 KavyaSoftech. All rights reserved.
//

import UIKit

class MenuVendor: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var imgProfile: ImageView!
    @IBOutlet var lblName: UILabel!
    
    @IBOutlet var lblId: UILabel!
    var arrMenu = NSMutableArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuItems()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {
        
        
        let defaults = UserDefaults.standard
        if (defaults.object(forKey: "userdetail") != nil) {
            let userdetail = defaults.object(forKey: "userdetail") as? NSDictionary
            lblName.text =  string(userdetail!, "name")
            
            let imgurl = string(userdetail!, "profile_pic")
            let URL =  NSURL(string: imgurl)
            imgProfile.sd_setImage(with: URL as URL!, placeholderImage: UIImage(named: "bar_default"),  options: SDWebImageOptions.retryFailed)
            let id = defaults.object(forKey: "name") as! String
            lblId.text = "ID: " + id
            
            
        }
        
       
        
    }
    
    func menuItems() {
        
        arrMenu.add(["title": "Profile", "img": "ic_user"])
        arrMenu.add(["title": "Logout", "img": "ic_exit"])
        
    }

    @IBAction func actionProfile (_ sender: Any) {
        
        let storyboard = UIStoryboard.init(name: "Customer", bundle: nil)
        self.sideMenuViewController.setContentViewController(storyboard.instantiateViewController(withIdentifier: "Profile"), animated: true)
        self.sideMenuViewController.hideViewController()
    }
    
    //MARK: TABLEVIEW DELEGATE AND DATASOURCE.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCellVendor") as! MenuCellVendor
        
        let dict = arrMenu.object(at: indexPath.row) as! NSDictionary
        cell.lblMenu.text = string(dict, "title")
        cell.imgMenu.image = UIImage(named: (string(dict, "img")))

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {  //Profile
            self.sideMenuViewController.setContentViewController(self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC"), animated: true)
            self.sideMenuViewController.hideViewController()
            
        } else if indexPath.row == 1 { //logout
            
            
              Http.alert("", "Want to logout?", [self,"YES","NO"])
            
           
            
        }/* else if indexPath.row == 5 { //LOGOUT
            /*kAppDelegate.removeSessionFromDefault(forUser: kAppDelegate.userType)
            let arr = self.navigationController?.viewControllers
            var boolSegue = true
            if arr != nil {
                for vc in arr! {
                    if vc is Welcome {
                        UserInfo.logout ()
                        boolSegue = false
                        _ = self.navigationController?.popToViewController(vc, animated: false)
                        break;
                    }
                }
            }
            if boolSegue {
                
                let storyboard = UIStoryboard.init(name: "Registration", bundle: nil)
                self.sideMenuViewController.setContentViewController(storyboard.instantiateViewController(withIdentifier: "Welcome"), animated: true)
            }*/
            
            
        }
        */
        
        
        
                
    }
    
    //MARK:- ResetPassword API
    func wsLogout() {
        
        let defaults = UserDefaults.standard
        let id = defaults.object(forKey: "name") as! String
        let userType = defaults.object(forKey: "usertype") as! String
        
        let params = NSMutableDictionary()
        
        params["sap_id"] = userType + id
        
        
        Http.instance().json(WebServices.logout, params, "POST", ai: true, popup: true, prnt: true, nil) { (json, params) in
            if (json != nil) {
                print(json!)
                let defaults = UserDefaults.standard
                defaults.removeObject(forKey: "name")
                defaults.removeObject(forKey: "password")
                defaults.removeObject(forKey: "usertype")
                defaults.removeObject(forKey: "userdetail")
                defaults.removeObject(forKey: chatRangId.chatMinId)
                defaults.removeObject(forKey: chatRangId.chatMaxId)
                defaults.removeObject(forKey: "ContactJson")

                defaults.synchronize()
                UIApplication.shared.applicationIconBadgeNumber = 0

                self.sideMenuViewController.hideViewController()
                self.sideMenuViewController.setContentViewController(self.storyboard?.instantiateViewController(withIdentifier: "Signin"), animated: true)
            }
        }
    }
    
    override func alertZero() {
        wsLogout()
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "name")
        defaults.removeObject(forKey: "password")
        defaults.removeObject(forKey: "usertype")
        defaults.removeObject(forKey: "userdetail")
        defaults.synchronize()
        self.sideMenuViewController.hideViewController()
        self.sideMenuViewController.setContentViewController(self.storyboard?.instantiateViewController(withIdentifier: "Signin"), animated: true)
    }
    override func alertOne() {
        
    }
    
    
    
    
    
    
    

    
    

} //class end.

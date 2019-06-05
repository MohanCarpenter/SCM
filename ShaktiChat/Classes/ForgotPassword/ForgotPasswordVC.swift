//
//  ForgotPasswordVC.swift
//  ShaktiChat
//
//  Created by kavya_mac_1 on 9/6/17.
//  Copyright © 2017 himanshuPal_kavya. All rights reserved.
//

import UIKit

class ForgotPasswordVC: UIViewController , UITextFieldDelegate{

    @IBOutlet var tfpernr: UITextField!
    @IBOutlet var tfMobileNo: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
tfpernr.attributedPlaceholder = NSAttributedString(string:"PERNR", attributes: [NSForegroundColorAttributeName: lightblueColor ])
      
tfMobileNo.attributedPlaceholder = NSAttributedString(string:"Mobile No.", attributes: [NSForegroundColorAttributeName: lightblueColor ])
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
  
    @IBAction func actionChangePassword(_ sender: Any) {
        if let str = checkValidation() {
            Http.alert("", str)
        } else {
            wsResetPassword()
        }
    }
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == tfpernr {
            tfMobileNo.becomeFirstResponder()
        } else if textField == tfMobileNo {
            tfMobileNo.resignFirstResponder()
            // scrlView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
            let validCharacterSet = NSCharacterSet(charactersIn: "0123456789").inverted
            let filter = string.components(separatedBy: validCharacterSet)
            if filter.count == 1 {
                let newLength: Int = textField.text!.characters.count + string.characters.count - range.length
                return (newLength > 10) ? false : true
            } else {
                return false
            }
        
        
    
        return true
    }
    
    
    func checkValidation() -> String? {
        if tfpernr.text?.characters.count == 0 {
            return "Enter Pernr"
        }  else if tfMobileNo.text?.characters.count == 0 {
            return "Enter Mobile Number"
        }
        if (tfMobileNo.text?.characters.count)! < 10 {
            return "Please enter valid mobile number."
        }
        return nil
    }

    
    //MARK:- ResetPassword API
    func wsResetPassword() {
        let params = NSMutableDictionary()
        
        params["PERNR"] = tfpernr.text
        params["TELNR"] = tfMobileNo.text
        
        Http.instance().json(WebServices().api_ResetPassword, params, "POST", ai: true, popup: true, prnt: true, nil) { (json, params) in
            if (json != nil) {
            let json = json as! NSArray
            let aa = json.object(at: 0)
                if string(aa as! NSDictionary , "status") == "success"  {
                     _ = self.navigationController?.popViewController(animated: false)
                    Http.alert("","Password is changed")
                }
            }
        }
    }
    
}

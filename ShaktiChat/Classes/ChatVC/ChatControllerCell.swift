//
//  ChatControllerCell.swift
//  XMPP
//
//  Created by mac on 19/09/17.
//  Copyright © 2017 Shubhank. All rights reserved.
//

import UIKit

class ChatControllerCell: UITableViewCell {
    @IBOutlet var imgTo: UIImageView!
    @IBOutlet var imgFrom: UIImageView!
    @IBOutlet weak var viewFrom: UIView!
    
    @IBOutlet weak var lblCheckBox: UILabel!
    @IBOutlet weak var lblDateTo: UILabel!
    @IBOutlet weak var lblDateFrom: UILabel!

    @IBOutlet weak var viewTo: UIView!
    @IBOutlet weak var tvToMesage: UITextView!
    @IBOutlet weak var tvFromMessage: UITextView!
    var loginId = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        tvToMesage.frame.size.width =  viewTo.frame.size.width
        tvFromMessage.frame.size.width =  tvFromMessage.frame.size.width

     /*   print("✓ loginId \(loginId) with chat to \(dict.to) from \(dict.from)  dict==\(dict.message)")
        
        //  DispatchQueue.global().async {
        //            do {
        //                try image = UIImage()!
        //            } catch {
        //                print("Failed")
        //            }
        //  DispatchQueue.main.async(execute: {
        // })
        //  }
        let descString: NSMutableAttributedString = NSMutableAttributedString(string:  String(format: " ✓ " ))
        descString.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 100/255, green: 150/255, blue: 255/255, alpha: 1.0), range: NSMakeRange(0, descString.length))
        
        
        let attrString: NSMutableAttributedString = NSMutableAttributedString(string: self.convertDataFormat(strDate: dict.date))
        
        attrString.addAttribute(NSForegroundColorAttributeName, value: UIColor.darkGray, range: NSMakeRange(0, attrString.length))
        descString.append(attrString)
        lblDateTo?.attributedText = descString
        lblDateFrom.textColor = UIColor.darkGray
        
     
        tvToMesage.backgroundColor  = UIColor.lightGray
        lblDateTo.backgroundColor  = UIColor.cyan
        viewTo.backgroundColor  = UIColor.black
        viewTo.layer.cornerRadius = 5
        viewFrom.layer.cornerRadius = 5
        
        
        tvToMesage.frame.size.width =  viewTo.frame.size.width
        tvFromMessage.frame.size.width =  tvFromMessage.frame.size.width
        // lblDateTo.text = dict.date + " ✓ "
        //        lblDateTo.sizeToFit()
        //        lblDateFrom.sizeToFit()
        lblDateFrom.text = self.convertDataFormat(strDate: dict.date)
        lblCheckBox.isHidden = true
        
        if self.loginId == dict.to {
            viewTo.isHidden = false
            viewFrom.isHidden = true
            tvToMesage.text = dict.message
            tvToMesage.sizeToFit()
            
            lblDateTo.frame.origin.y = tvToMesage.frame.origin.y + tvToMesage.frame.size.height
            
            lblCheckBox.frame.origin.y  = tvToMesage.frame.origin.y  + tvToMesage.frame.size.height
            viewTo.frame.size.height = lblDateTo.frame.origin.y + lblDateTo.frame.size.height
            
        //    self.tblView.rowHeight = viewTo.frame.origin.y + viewTo.frame.size.height
            
        }else{
            
            viewTo.isHidden = true
            viewFrom.isHidden = false
            tvFromMessage.text = dict.message
            tvFromMessage.sizeToFit()
            lblDateFrom.frame.origin.y = tvFromMessage.frame.origin.y + tvFromMessage.frame.size.height
            
            viewFrom.frame.size.height = lblDateFrom.frame.origin.y + lblDateFrom.frame.size.height
            
        //    self.tblView.rowHeight = viewFrom.frame.origin.y + viewFrom.frame.size.height
        }
        */
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func convertDataFormat(strDate:String) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-mm-dd HH:mm:ss"
        if  let date = formatter.date(from: strDate) {
            formatter.dateFormat = "hh:mm a"
            return formatter.string(from: date)
        }
        
        return ""
    }
}
/*
 print("✓ loginId \(loginId) with chat to \(dict.to) from \(dict.from)  dict==\(dict.message)")
 
 //  DispatchQueue.global().async {
 //            do {
 //                try image = UIImage()!
 //            } catch {
 //                print("Failed")
 //            }
 //  DispatchQueue.main.async(execute: {
 // })
 //  }
 let descString: NSMutableAttributedString = NSMutableAttributedString(string:  String(format: " ✓ " ))
 descString.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 100/255, green: 150/255, blue: 255/255, alpha: 1.0), range: NSMakeRange(0, descString.length))
 
 
 let attrString: NSMutableAttributedString = NSMutableAttributedString(string: self.convertDataFormat(strDate: dict.date))
 
 attrString.addAttribute(NSForegroundColorAttributeName, value: UIColor.darkGray, range: NSMakeRange(0, attrString.length))
 descString.append(attrString)
 cell.lblDateTo?.attributedText = descString
 cell.lblDateFrom.textColor = UIColor.darkGray
 
 if indexPath.row == 0{
 cell.tvToMesage.textContainer.lineFragmentPadding = 0
 }
 cell.tvToMesage.backgroundColor  = UIColor.lightGray
 cell.lblDateTo.backgroundColor  = UIColor.cyan
 cell.viewTo.backgroundColor  = UIColor.black
 cell.viewTo.layer.cornerRadius = 5
 cell.viewFrom.layer.cornerRadius = 5
 
 
 cell.tvToMesage.frame.size.width =  cell.viewTo.frame.size.width
 cell.tvFromMessage.frame.size.width =  cell.tvFromMessage.frame.size.width
 // cell.lblDateTo.text = dict.date + " ✓ "
 //        cell.lblDateTo.sizeToFit()
 //        cell.lblDateFrom.sizeToFit()
 cell.lblDateFrom.text = self.convertDataFormat(strDate: dict.date)
 cell.lblCheckBox.isHidden = true
 
 if self.loginId == dict.to {
 cell.viewTo.isHidden = false
 cell.viewFrom.isHidden = true
 cell.tvToMesage.text = dict.message
 cell.tvToMesage.sizeToFit()
 
 cell.lblDateTo.frame.origin.y = cell.tvToMesage.frame.origin.y + cell.tvToMesage.frame.size.height
 
 cell.lblCheckBox.frame.origin.y  = cell.tvToMesage.frame.origin.y  + cell.tvToMesage.frame.size.height
 cell.viewTo.frame.size.height = cell.lblDateTo.frame.origin.y + cell.lblDateTo.frame.size.height
 
 self.tblView.rowHeight = cell.viewTo.frame.origin.y + cell.viewTo.frame.size.height
 
 }else{
 
 cell.viewTo.isHidden = true
 cell.viewFrom.isHidden = false
 cell.tvFromMessage.text = dict.message
 cell.tvFromMessage.sizeToFit()
 cell.lblDateFrom.frame.origin.y = cell.tvFromMessage.frame.origin.y + cell.tvFromMessage.frame.size.height
 
 cell.viewFrom.frame.size.height = cell.lblDateFrom.frame.origin.y + cell.lblDateFrom.frame.size.height
 
 self.tblView.rowHeight = cell.viewFrom.frame.origin.y + cell.viewFrom.frame.size.height
 }
 
 
 */

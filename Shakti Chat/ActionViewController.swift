//
//  ActionViewController.swift
//  Shakti Chat
//
//  Created by mac on 16/11/17.
//  Copyright © 2017 himanshuPal_kavya. All rights reserved.
//

import UIKit
import Foundation

import MobileCoreServices

class ActionViewController: UIViewController , UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate{
    @IBOutlet var tblContact: UITableView!
    var arrmessagecontact = NSMutableArray()
    var arrMessageTemp = NSMutableArray()
    let defaultsApp = UserDefaults.init(suiteName: "group.com.shakti.shaktichat")
    @IBOutlet var tfSearch: UITextField!

    @IBOutlet weak var imageView: UIImageView!
    var file_name = ""
    var data_File = Data()
    var strMessage = ""
    var msg_type = ""
    @IBOutlet var btnSend: UIButton!
    func showAlert(MSG: Any){
        let alert = UIAlertController (title: "Share Extension1", message: "\(MSG)" , preferredStyle: UIAlertControllerStyle.alert)
        
        self.present(alert, animated: true, completion: nil)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
          
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            //== MessagesStringFile().notifLogout()
            
        }))
    }

    override func viewDidLoad() {
        super.viewDidLoad()

   
        tblContact.delegate = self
        tblContact.dataSource = self
        tfSearch.delegate = self
        
        setListContact()
        getShareDetail()
    }
    override func viewDidAppear(_ animated: Bool) {
        btnSend.alpha = 0.65
        btnSend.isUserInteractionEnabled = false

        tfSearch.attributedPlaceholder = NSAttributedString(string: "Send to", attributes: [NSForegroundColorAttributeName : UIColor.white])
    }

    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK:- 
    
    func setListContact(){
        if let dict:NSDictionary =  defaultsApp?.object(forKey: "updatecontacts") as? NSDictionary { //data is already
            
            
            if let messagecontact:NSMutableArray = dict.object(forKey: "messagecontact") as? NSMutableArray  {
                arrmessagecontact = messagecontact.mutableCopy() as! NSMutableArray
                
                tblContact.reloadData()
            }
            
            if let temp:NSArray = dict.object(forKey: "groupcontact") as? NSArray {
                if let grupdetail :NSMutableArray = temp.mutableCopy() as? NSMutableArray {
                    let mergedArray = arrmessagecontact.addingObjects(from: grupdetail as! [Any])
                    arrmessagecontact = mergedArray as! NSMutableArray
                }
            }
            let arr =  NSMutableArray()
            for ii in 0 ..< arrmessagecontact.count {
                let dict = arrmessagecontact.object(at: ii) as? NSMutableDictionary
                let dict_121:NSMutableDictionary = dict?.mutableCopy() as! NSMutableDictionary
                if dict?.object(forKey: "timeInterval") == nil {
                    dict_121.setValue(0, forKey: "timeInterval")
                }else {
                    dict_121.setValue(number(dict!, "timeInterval").intValue, forKey: "timeInterval")
                }
                arr.add(dict_121)
            }
            arrmessagecontact = arr
            
            //   showAlert(MSG: "\(arrmessagecontact)")
            
            arrMessageTemp = arrmessagecontact
            
            let arrMessageTemp1 = arrmessagecontact as! [NSMutableDictionary]
            
            arrmessagecontact = arrMessageTemp1.sorted(by: {  $0.object(forKey: "timeInterval") as! Int > $1.object(forKey: "timeInterval") as! Int }) as! NSMutableArray
            
            arrMessageTemp = self.arrmessagecontact
            
            
            //convert dict to object rahul
        }
    }
    func getShareDetail(){
        var imageFound = false
        for item in self.extensionContext!.inputItems as! [NSExtensionItem] {
            for provider in item.attachments! as! [NSItemProvider] {
                if provider.hasItemConformingToTypeIdentifier(kUTTypeImage as String) {
                    provider.loadItem(forTypeIdentifier: kUTTypeImage as String, options: nil, completionHandler: { (imageURL, error) in
                        OperationQueue.main.addOperation {
                                if let imageURL = imageURL as? URL {
                                    self.data_File = try! Data(contentsOf: imageURL)
                                    self.msg_type = "F"
                                    self.file_name = "temp_\(Int(Date().timeIntervalSince1970)).jpg"
                            }
                        }
                    })
                    
                    imageFound = true
                    break
                }else if provider.hasItemConformingToTypeIdentifier(kUTTypeText as String) {
                    provider.loadItem(forTypeIdentifier: kUTTypeText as String, options: nil, completionHandler: { (imageURL, error) in
                        OperationQueue.main.addOperation {
                            self.strMessage = "\(String(describing: imageURL!))"
                            self.msg_type = "T"
                        //    self.showAlert(MSG: "kUTTypeText .count----\(String(describing: imageURL!))")
                        }
                    })
                    
                    imageFound = true
                    break
                }else if provider.hasItemConformingToTypeIdentifier(kUTTypeAudio as String) {
                    provider.loadItem(forTypeIdentifier: kUTTypeAudio as String, options: nil, completionHandler: { (imageURL, error) in
                        OperationQueue.main.addOperation {
                            if let imageURL = imageURL as? URL {
                                self.data_File = try! Data(contentsOf: imageURL)
                                self.msg_type = "F"
                                self.file_name = "temp_\(Int(Date().timeIntervalSince1970)).mp3"
                              //  self.showAlert(MSG: "file_name----\(String(describing: self.file_name))")
                            }
                        }
                    })
                    
                    imageFound = true
                    break
                }else if provider.hasItemConformingToTypeIdentifier(kUTTypeMovie as String) {
                    provider.loadItem(forTypeIdentifier: kUTTypeMovie as String, options: nil, completionHandler: { (imageURL, error) in
                        OperationQueue.main.addOperation {
                            
                            if let imageURL = imageURL as? URL {
                                self.data_File = try! Data(contentsOf: imageURL)
                                self.msg_type = "F"
                                self.file_name = "temp_\(Int(Date().timeIntervalSince1970)).mp4"
                             //   self.showAlert(MSG: "file_name----\(String(describing: self.file_name))")
                            }
                        }
                    })
                    
                    imageFound = true
                    break
                }
                
                // Movie
                
            }
            
            if (imageFound) {
                // We only handle one image, so stop looking for more.
                break
            }
        }
    }
    
    @IBAction func btnSearch(_ sender: Any) {
        tfSearch.becomeFirstResponder()
        
    }
    
    @IBAction func cancel() {
        self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
        
    }
    
    
    @IBAction func done() {
        
     
        defaultsApp?.removeObject(forKey:"toSendData")

        let arrTmp = NSMutableArray()
        for dict in self.arrmessagecontact {
            if let dictTmp:NSDictionary  = dict as? NSDictionary {
                if dictTmp.object(forKey: "check") != nil {
                    arrTmp.add(dictTmp)
                }
            }
        }
        print("arrTmp -----\(arrTmp)----arrTmp")
        
        let dict = NSMutableDictionary(dictionary: [ "data_File":self.data_File, "toSend":arrTmp, "file_name":file_name, "msg_type":msg_type, "msg":self.strMessage ])
        defaultsApp?.set(dict, forKey: "toSendData")
        defaultsApp?.synchronize()
        self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
        
    }

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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            return arrmessagecontact.count
        }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactCell
        let dict = self.arrmessagecontact.object(at: indexPath.row) as! NSDictionary
        
//        cell.imgProfile.sd_setImage(with: URL(string: checkIsNull(dict, "pic")), placeholderImage: UIImage(named: "bar_default"),  options: SDWebImageOptions.retryFailed)
//        
        
        cell.imgProfile.layer.cornerRadius = cell.imgProfile.frame.size.height/2
        cell.imgProfile.clipsToBounds = true
        

        if let name:String = dict.object(forKey: "name") as? String {
            cell.lblName.text = name
        }else if let name:String = dict.object(forKey: "groupName") as? String {
            cell.lblName.text = name
        }
        if let pic:String = dict.object(forKey: "pic") as? String {
            if let url : URL = URL(string: pic) {
                URLSession.shared.dataTask(with: url) { data, response, error in
                    guard
                        let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                        let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                        let data = data, error == nil,
                        let image = UIImage(data: data)
                        else {
                            if let _:String = dict.object(forKey: "group_type") as? String {   // group_type
                                cell.imgProfile.image = UIImage(named: "group_icon1.png")
                            }else {
                                cell.imgProfile.image = UIImage(named: "profile09.png")
                            }
                            return
                    }
                    DispatchQueue.main.async() {
                        cell.imgProfile.image = image
                    }
                    }.resume()
            }
        }else {
            if let _:String = dict.object(forKey: "group_type") as? String {   // group_type
                cell.imgProfile.image = UIImage(named: "group_icon1.png")
            }else {
                cell.imgProfile.image = UIImage(named: "profile09.png")
            }        }

        if dict.object(forKey: "check") != nil {
            cell.imgCheck.image = UIImage(named: "ic_checkbox_checked.png")

        }else {
             cell.imgCheck.image = nil

        }
        return cell
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
        if isCheck && self.msg_type != "" {
            btnSend.alpha = 1.0
            btnSend.isUserInteractionEnabled = true
            
        }else {
            btnSend.alpha = 0.65
            btnSend.isUserInteractionEnabled = false
            
        }
        
        arrmessagecontact = arr
        tblContact.reloadData()
        
    }
    //MARK:-

    
    
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
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    func number (_ dict:NSDictionary, _ key:String) -> NSNumber {
        if let title = dict[key] as? NSNumber {
            return title
        } else if let title = dict[key] as? String {
            
            if let title1 = Int(title) as Int? {
                return NSNumber(value: title1)
            } else if let title1 = Float(title) as Float? {
                return NSNumber(value: title1)
            } else if let title1 = Double(title) as Double? {
                return NSNumber(value: title1)
            } else if let title1 = Bool(title) as Bool? {
                return NSNumber(value: title1)
            }
            
            return 0
        } else {
            return 0
        }
    }
    
    func checkIsNull(_ dict:NSDictionary, _ str: String)-> String{
        
        if dict.object(forKey: str) != nil &&  !(dict.object(forKey: str) is NSNull) {
            return "\(dict.object(forKey: str)!)"
        }else {
            return ""
        }
        
    }

    
    public func localToUTCTime(date:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.calendar = NSCalendar.current
        dateFormatter.timeZone = TimeZone.current
        
        if let dt = dateFormatter.date(from: date) {
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            dateFormatter.dateFormat = "H:mm:ss"
            return dateFormatter.string(from: dt)
        }else {
            print("")
        }
        return date
    }
    
    func dateFormateToGate(format:String)->String {
        let formatter = DateFormatter()
        formatter.dateFormat = format // "yyyy-mm-dd hh:mm:ss"
        return "\(formatter.string(from: Date()))"
    }

}

extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}

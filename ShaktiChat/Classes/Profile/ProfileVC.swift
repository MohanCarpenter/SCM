//
//  ProfileVC.swift
//  ShaktiChat
//
//  Created by kavya_mac_1 on 9/8/17.
//  Copyright © 2017 himanshuPal_kavya. All rights reserved.
//

import UIKit



import Photos
class ProfileVC: UIViewController ,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate{

    @IBOutlet var imgProfile: ImageView!
    
    @IBOutlet var viewinpopup: View!
    @IBOutlet var tfname: TextField!
    @IBOutlet var tfpernr: TextField!
    @IBOutlet var viewPopUp: UIView!
    @IBOutlet var lblVersion: UILabel!
    var nameid = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewPopUp.frame = self.view.frame
        viewPopUp.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        let defaults = UserDefaults.standard
        if (defaults.object(forKey: "userdetail") != nil) {
           let userdetail = defaults.object(forKey: "userdetail") as? NSDictionary
            tfname.text =  string(userdetail!, "name")
             nameid = defaults.object(forKey: "name") as! String
            let usertype = defaults.object(forKey: "usertype") as! String
            tfpernr.text =  usertype  + nameid
        let imgurl = string(userdetail!, "profile_pic")
        let URL =  NSURL(string: imgurl)
        imgProfile.sd_setImage(with: URL as URL!, placeholderImage: UIImage(named: "bar_default"),  options: SDWebImageOptions.retryFailed)
        }
        
        
    
        if let text = Bundle.main.infoDictionary?["CFBundleVersion"]  as? String {
            print("app version --\(text)")
//            let s = "Hello 😃."
//            let e = encode(s)
//            print(e) // Hello \ud83d\ude03.
//            
//            if let d = decode(e) {
//                print(d) // Hello 😃.
//            }
            lblVersion.text = "Version: \(text)"
            
            
         //   lblVersion.text = "Version: \(text)  This is \"u00B7"
            
        }
        
    
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func actionBack(_ sender: Any) {
        

        self.sideMenuViewController.setContentViewController(self.storyboard?.instantiateViewController(withIdentifier: "PersonsVC"), animated: true)
        self.sideMenuViewController.hideViewController()
        
    }
    
    @IBAction func actionEditImg(_ sender: Any) {
        self.view.addSubview(viewPopUp)
        self.test(viewTest: viewinpopup)
    }
    
     var imgProfilePicture:UIImage? = nil
  
    
    func camera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    func photoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    // Mark : Pickerview Delegate
    
    func getFileName(info: [String : Any]) -> String {
        
        if let imageURL = info[UIImagePickerControllerReferenceURL] as? URL {
            let result = PHAsset.fetchAssets(withALAssetURLs: [imageURL], options: nil)
            let asset = result.firstObject
            let fileName = asset?.value(forKey: "filename")
            let fileUrl = URL(string: fileName as! String)
            if let name = fileUrl?.deletingPathExtension().lastPathComponent {
                print(name)
                return name
            }
        }
        return ""
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
  
        let fileName = getFileName(info: info)
        print(fileName)
        
        var img:UIImage? = info[UIImagePickerControllerOriginalImage] as? UIImage
        if let iii = info[UIImagePickerControllerEditedImage] as? UIImage {
            img = iii
        }
        
        if (img != nil) {
            
            imgProfilePicture = img
            imgProfile.image = img
            self.ws_UpdateImg()
        }
         viewPopUp.removeFromSuperview()
        picker.dismiss(animated: true, completion: nil);
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actionremovePopup(_ sender: Any) {
          viewPopUp.removeFromSuperview()
    }
    @IBAction func actionGallery(_ sender: Any) {
        self.photoLibrary()
    }
    @IBAction func actionCamera(_ sender: Any) {
        self.camera()
    }
    
    
    func test(viewTest: UIView) {
        let orignalT: CGAffineTransform = viewTest.transform
        viewTest.transform = CGAffineTransform.identity.scaledBy(x: 0.0, y: 0.0)
        UIView.animate(withDuration: 0.5, animations: {
            
            viewTest.transform = orignalT
        }, completion:nil)
    }
    
    
    
    func ws_UpdateImg(){
        
        Http.startActivityIndicator()
        let dictImage: [String: UIImage] = ["image":imgProfile.image!]
        HMWebService.createRequest(forImageAndGetResponse:  WebServices.BaseUrl + "user/updatepic", methodType: .POST, andHeaderDict: [ : ], andParameterDict: dictImage, andImageNameAsKeyAndImageAsItsValue: dictImage,imgName:tfpernr.text!, onCompletion: { (dictResponse, error, reply) in
            
            Http.stopActivityIndicator()
            if (dictResponse?.count)! > 0 {
                
                let JSON: NSDictionary = dictResponse! as [String: Any] as NSDictionary
                if string(JSON , "status") == "1"  {
                    let data  =  JSON.object(forKey: "data") as! NSDictionary
                    let imgurl = string(data, "image")
                    
                    let defaults = UserDefaults.standard
                    if (defaults.object(forKey: "userdetail") != nil) {
                        var dictData = defaults.object(forKey: "userdetail") as? NSMutableDictionary
                        var  tempdict = NSMutableDictionary()
                        tempdict = dictData?.mutableCopy()as! NSMutableDictionary
                        
                        tempdict.removeObject(forKey: "profile_pic")
                        tempdict.setObject(imgurl, forKey: "profile_pic" as NSCopying)
                        
                     //   dictData = tempdict.mutableCopy() as? NSMutableDictionary
                        defaults.set(tempdict, forKey: "userdetail")
                        defaults.synchronize()
                    }
                    
                }
            }
        })
    }
    

}

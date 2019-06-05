//
//  WelcomeVC.swift
//  ShaktiChat
//
//  Created by kavya_mac_1 on 9/6/17.
//  Copyright © 2017 himanshuPal_kavya. All rights reserved.
//

import UIKit

class WelcomeVC: UIViewController {
    var timer = Timer()
    @IBOutlet var imgLogo: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    override func viewWillAppear(_ animated: Bool) {

        imgLogo.rotate360Degrees()
        
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self,selector: #selector(self.startTimer), userInfo: nil, repeats: true)
        
    }
    
    func startTimer() {
        // dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) { () -> Void in
         imgLogo.layer.removeAllAnimations()
        timer.invalidate()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Signin") as! Signin
        self.navigationController?.pushViewController(vc, animated: false)
        // }
    }
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  

}
extension UIView {
    func rotate360Degrees(duration: CFTimeInterval = 1) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(M_PI * 2)
        rotateAnimation.isRemovedOnCompletion = false
        rotateAnimation.duration = duration
        rotateAnimation.repeatCount=Float.infinity
        self.layer.add(rotateAnimation, forKey: nil)
    }
}

import Foundation
import UIKit

class ActivityIndicator {
    var container: UIView? = nil
    var loadingView: UIView? = nil
    var activityIndicator: UIActivityIndicatorView? = nil
    
    static let sharedInstance: ActivityIndicator = { ActivityIndicator() }()
    
    var appDelegate:AppDelegate? = nil// = UIApplication.shared.delegate as! AppDelegate
    
    //let lockQueue = dispatch_queue_create("com.test.LockQueue", nil)
    //let lockQueue = DispatchQueue("com.test.LockQueue", nil)
    
    let lockQueue = DispatchQueue.init(label: "com.test.LockQueue")
    var noofrequest = 0
    
    func showActivityIndicator() {
        DispatchQueue.main.async {
            self.lockQueue.sync {
                print("showActivityIndicator-\(self.noofrequest)-")
                
                self.noofrequest += 1
                
                if self.noofrequest == 1 {
                    
                    if self.container == nil {
                        self.container = UIView()
                    }
                    
                    if self.loadingView == nil {
                        self.loadingView = UIView()
                    }
                    
                    if self.activityIndicator == nil {
                        self.activityIndicator = UIActivityIndicatorView()
                    }
                    
                    if self.appDelegate == nil {
                        self.appDelegate = UIApplication.shared.delegate as? AppDelegate
                    }
                    
                    self.container?.frame = (self.appDelegate?.window?.frame)!
                    self.container?.center = (self.appDelegate?.window?.center)!
                    
                    self.container?.backgroundColor = self.UIColorFromHex(rgbValue: 0xffffff, alpha: 0.3)
                    
                    self.loadingView?.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
                    self.loadingView?.center = (self.appDelegate?.window?.center)!
                    self.loadingView?.backgroundColor = self.UIColorFromHex(rgbValue: 0x444444, alpha: 0.7)
                    self.loadingView?.clipsToBounds = true
                    self.loadingView?.layer.cornerRadius = 10
                    
                    self.activityIndicator?.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
                    self.activityIndicator?.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
                    self.activityIndicator?.center = CGPoint(x: (self.loadingView?.frame.size.width)! / 2, y: (self.loadingView?.frame.size.height)! / 2)
                    
                    self.loadingView?.addSubview(self.activityIndicator!)
                    self.container?.addSubview(self.loadingView!)
                    self.appDelegate?.window?.addSubview(self.container!)
                    self.activityIndicator?.startAnimating()
                }
            }
        }
    }
    
    func hideActivityIndicator() {
        DispatchQueue.main.async {
            self.lockQueue.sync {
                print("hideActivityIndicator-\(self.noofrequest)-")
                
                if self.noofrequest == 1 {
                    self.activityIndicator?.stopAnimating()
                    self.container?.removeFromSuperview()
                }
                
                self.noofrequest -= 1
            }
        }
    }
    
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0) -> UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
}










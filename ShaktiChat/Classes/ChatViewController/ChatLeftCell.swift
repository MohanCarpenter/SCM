//
//  ChatLeftCell.swift
//  ShaktiChat
//
//  Created by mac on 26/09/17.
//  Copyright © 2017 himanshuPal_kavya. All rights reserved.
//

import UIKit
public protocol ChatLeftCellDelegate {
    func btnLeftFileAction(dict:NSMutableDictionary)
    func btnLeftReplayAction(dict:NSMutableDictionary)
    func LeftCelllongPressGesture(section:Int, index:Int,point:CGPoint)
    func btnMSGIsReplay(section:Int, index:Int)
    
}
class ChatLeftCell: UITableViewCell {
    var delegate: ChatLeftCellDelegate!

    @IBOutlet var imgBG: UIImageView!
    @IBOutlet var viewbg: UIView!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblFromName: UILabel!

    @IBOutlet var imgData: ImageZoom!
    var dict = NSDictionary()
    @IBOutlet var tvMessage: UITextView!
    @IBOutlet var btnCellAction: UIButton!
    @IBOutlet var imgDataFile: UIImageView!
    @IBOutlet var btnCellReplay: UIButton!

    var imageViewBG = UIImageView()
    var section = 0
    var index = 0
    var viewSelf = UIView()
    @IBOutlet var viewReplay: UIView!
    @IBOutlet weak var lblLineReply: UILabel!
    @IBOutlet weak var lblReplymsg: UILabel!
    @IBOutlet weak var lblReplyMsgType: UILabel!
    @IBOutlet weak var imgReplayIcon: UIImageView!
    @IBOutlet weak var lblNameReply: UILabel!
    @IBOutlet weak var imgReplyImgData: UIImageView!

    @IBOutlet var imgReplyImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
         let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(LeftCelllongPressGesture(gesture:)))
        
        longPressGesture.minimumPressDuration = 1.0
        viewbg.addGestureRecognizer(longPressGesture)


        
    }
    func LeftCelllongPressGesture(gesture: UIGestureRecognizer){
        if gesture.state != UIGestureRecognizerState.ended {
//            imgBG.backgroundColor = UIColor.black.withAlphaComponent(0.1)

           
        }else if gesture.state != UIGestureRecognizerState.began {

        }
//            imgBG.backgroundColor = UIColor.clear

  //     delegate.LeftlongPressGestureRecognizer(gesture: gesture)
               let tapLocation = gesture.location(in: viewSelf)
        print("tapLocation---\(tapLocation.y) -- tapLocation---\(tapLocation)")
        let myPoint = CGPoint(x: 25.0, y: tapLocation.y)
        delegate.LeftCelllongPressGesture(section: section, index: index, point: myPoint)
//        if let tapIndexPath = btnCellAction.indexPathForRow(at: tapLocation) {
//            delegate.LeftCelllongPressGesture(section: tapIndexPath.section, index: tapIndexPath.row)
//
//        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    @IBAction func btnMSGIsReplay(_ sender: Any) {
        delegate.btnMSGIsReplay(section: section, index: index)
    
    }
    @IBAction func btnCellReplay(_ sender: Any) {

        delegate.btnLeftReplayAction(dict:dict.mutableCopy() as! NSMutableDictionary)
    }
    @IBAction func btnFileAction(_ sender: Any) {
        
        delegate.btnLeftFileAction(dict: dict.mutableCopy() as! NSMutableDictionary)
    }

}

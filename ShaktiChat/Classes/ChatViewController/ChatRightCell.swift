//
//  ChatRightCell.swift
//  ShaktiChat
//
//  Created by mac on 26/09/17.
//  Copyright © 2017 himanshuPal_kavya. All rights reserved.
//

import UIKit
public protocol ChatRightCellDelegate {
    func btnRightFileAction(dict:NSMutableDictionary)
    func RightCelllongPressGesture(section:Int, index:Int,point:CGPoint)
    func btnRightReplayAction(dict:NSMutableDictionary)

}
class ChatRightCell: UITableViewCell {
    var delegate: ChatRightCellDelegate!
    @IBOutlet var btnCellAction: UIButton!
  //  @IBOutlet var imgDataFile: UIImageView!
    @IBOutlet var imgBg: UIImageView!
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var tvMesage: UITextView!
    @IBOutlet weak var imgData: ImageZoom!
    @IBOutlet weak var imgCheckBox: UIImageView!
    var dict = NSDictionary()
    var section = 0
    var index = 0
    @IBOutlet var viewReplay: UIView!

    @IBOutlet weak var lblLineReply: UILabel!
    @IBOutlet weak var lblReplymsg: UILabel!
    @IBOutlet weak var lblReplyMsgType: UILabel!
    @IBOutlet weak var imgReplayIcon: UIImageView!
    @IBOutlet weak var lblNameReply: UILabel!
    @IBOutlet weak var imgReplyImgData: UIImageView!
    var viewSelf = UIView()

    var imageViewBG = UIImageView()
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(RightCelllongPressGesture(gesture:)))
        
        longPressGesture.minimumPressDuration = 1.0
        viewBg.addGestureRecognizer(longPressGesture)

        
        // Initialization code
    //    imageViewBG.image = UIImage(named: "bubbleSomeone")

    }
    func RightCelllongPressGesture(gesture: UIGestureRecognizer){
        let tapLocation = gesture.location(in: viewSelf)
        print("tapLocation---\(tapLocation.y) -- tapLocation---\(tapLocation)")
        delegate.RightCelllongPressGesture(section: section, index: index, point: tapLocation)
        
        
     //   delegate.RightCelllongPressGesture(section: section, index: index)

       // delegate.RightlongPressGestureRecognizer(gesture: gesture)
        //        let tapLocation = gesture.location(in: btnCellAction)
        //
        //        if let tapIndexPath = btnCellAction.indexPathForRow(at: tapLocation) {
        //            delegate.LeftCelllongPressGesture(section: tapIndexPath.section, index: tapIndexPath.row)
        //
        //        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    @IBAction func btnRightFileAction(_ sender: Any) {
        delegate.btnRightFileAction(dict: dict.mutableCopy() as! NSMutableDictionary)
    }
    @IBAction func btnCellReplay(_ sender: Any) {
        
        delegate.btnRightReplayAction(dict:dict.mutableCopy() as! NSMutableDictionary)
    }
}

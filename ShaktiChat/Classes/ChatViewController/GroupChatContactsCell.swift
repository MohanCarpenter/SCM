//
//  GroupChatContactsCell.swift
//  ShaktiChat
//
//  Created by Avinash somani on 11/10/17.
//  Copyright © 2017 himanshuPal_kavya. All rights reserved.
//

import UIKit

class GroupChatContactsCell: UITableViewCell {

    @IBOutlet var imgPicture: UIImageView!
    
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblGroupName: UILabel!
    @IBOutlet var lblMobileNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        imgPicture.border(nil, imgPicture.frame.size.height/2, 0.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

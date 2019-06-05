//
//  ForwardListCell.swift
//  ShaktiChat
//
//  Created by mac on 20/11/17.
//  Copyright © 2017 himanshuPal_kavya. All rights reserved.
//

import UIKit

class ForwardListCell: UITableViewCell {

    @IBOutlet var imgProfile: UIImageView!
   //@IBOutlet var lblMobileNumber: UILabel!
    @IBOutlet var lblDepartment: UILabel!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var imgCheck: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

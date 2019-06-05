//
//  PersonsCell.swift
//  ShaktiChat
//
//  Created by kavya_mac_1 on 9/6/17.
//  Copyright © 2017 himanshuPal_kavya. All rights reserved.
//

import UIKit

class PersonsCell: UITableViewCell {
    @IBOutlet var imgProfile: UIImageView!

    @IBOutlet var lblBatchCount: Label!
    @IBOutlet var lblMobileNumber: UILabel!
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

//
//  LeftMenuCell.swift
//  ResideMenuDemo
//
//  Created by Rahul Khatri on 25/07/17.
//  Copyright © 2017 KavyaSoftech. All rights reserved.
//

import UIKit

class MenuCellVendor: UITableViewCell {
    
    @IBOutlet var lblMenu: UILabel!
    @IBOutlet var imgMenu: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}

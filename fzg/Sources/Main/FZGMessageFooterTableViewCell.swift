//
//  FZGMessageFooterTableViewCell.swift
//  fzg
//
//  Created by JohnLee on 2018/9/7.
//  Copyright © 2018年 fuiou. All rights reserved.
//

import UIKit

class FZGMessageFooterTableViewCell: UITableViewCell {

    @IBOutlet weak var sureButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        sureButton.layer.borderWidth = 1
        sureButton.layer.borderColor = UIColor.black999.cgColor
        sureButton.layer.cornerRadius = 4
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//
//  FZGNoDataTableFooterView.swift
//  fzg
//
//  Created by JohnLee on 2018/9/17.
//  Copyright © 2018年 fuiou. All rights reserved.
//

import UIKit
import Cartography

class FZGNoDataTableFooterView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //初始化类方法
    class func footerView() -> FZGNoDataTableFooterView {
        return Bundle.main.loadNibNamed("FZGNoDataTableFooterView", owner: nil, options: nil)?.first as! FZGNoDataTableFooterView
    }
    

}

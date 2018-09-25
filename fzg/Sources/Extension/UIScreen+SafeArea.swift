//
//  UIScreen+SafeArea.swift
//  fzg
//
//  Created by JohnLee on 2018/9/25.
//  Copyright © 2018年 fuiou. All rights reserved.
//

import Foundation
import UIKit

public extension UIScreen {
    
    public static var safeArea: UIEdgeInsets {
        if #available(iOS 11, *), hasNotch {
            return UIApplication.shared.keyWindow!.safeAreaInsets
        }
        return UIEdgeInsetsMake(20.0, 0.0, 0.0, 0.0)
    }

    public static var hasNotch: Bool {
        if #available(iOS 11, *) {
            guard let window = UIApplication.shared.keyWindow else { return false }
            let insets = window.safeAreaInsets
            // if top or bottom insets are greater than zero, it means that
            // the screen has a safe area (e.g. iPhone X)
            return insets.top > 0 || insets.bottom > 0
        } else {
            return false
        }
    }
    
}

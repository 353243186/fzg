//
//  UIImage+Color.swift
//  fzg
//
//  Created by JohnLee on 2018/9/6.
//  Copyright © 2018年 fuiou. All rights reserved.
//

import Foundation
import UIKit

extension UIImage{
    static func imageWithColor(_ color: UIColor, size: CGSize) -> UIImage? {
        let rect = CGRect.init(origin: CGPoint.zero, size: size)
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

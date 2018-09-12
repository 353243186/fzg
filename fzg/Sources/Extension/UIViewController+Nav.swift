//
//  UIViewController+Nav.swift
//  fzg
//
//  Created by JohnLee on 2018/9/6.
//  Copyright © 2018年 fuiou. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{
        //设置导航栏背景色,hasLine:是否需要边界线
    
    /// 设置导航栏背景色
    ///
    /// - Parameters:
    ///   - color: 颜色值
    ///   - hasLine: 是否需要边界线.默认需要
    func setNavigationBarBackColor(_ color: UIColor, hasLine: Bool = true) {
        if hasLine{
            self.navigationController?.navigationBar.barTintColor = color
        }else{
            self.navigationController?.navigationBar.setBackgroundImage(UIImage.imageWithColor(color, size: CGSize.init(width: 1, height: 1)), for: .default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
        }
    }
    
    //MARK:给导航栏左右添加图片按钮
    /// 给导航栏左边添加图片按钮
    ///
    /// - Parameters:
    ///   - imageName: 图片名称
    ///   - isOriginalImage: 是否需要原型图片，原型图片不随导航栏风格改变颜色,默认不需要
    ///   - imageWidth: 图片大小
    func showLeftButtonWithImage(_ image: UIImage, isOriginalImage: Bool = false, target: Any?, action: Selector?) {
        let image = isOriginalImage ? image.withRenderingMode(.alwaysOriginal) : image
        let barItem = UIBarButtonItem.init(image: image, style: .plain, target: target, action: action)
        self.navigationItem.leftBarButtonItem = barItem
    }

    // 给导航栏右边添加图片按钮
    //
    // - Parameters:
    //   - imageName: 图片名称
    //   - isOriginalImage: 是否需要原型图片，原型图片不随导航栏风格改变颜色
    //   - imageWidth: 图片大小
    func showRightButtonWithImage(_ image: UIImage, isOriginalImage: Bool = false, target: Any?, action: Selector?) {
        let image = isOriginalImage ? image.withRenderingMode(.alwaysOriginal) : image
        let barItem = UIBarButtonItem.init(image: image, style: .plain, target: target, action: action)
        self.navigationItem.rightBarButtonItem = barItem
    }
    
    //MARK:给导航栏右边添加文字按钮
    func showRightButtonWithTitle(_ title: String, target: Any?, action: Selector?) {
        let barItem = UIBarButtonItem.init(title: title, style: .plain, target: target, action: action)
        self.navigationItem.rightBarButtonItem = barItem
    }
    
    //MARK:显示系统样式提示框（UIAlertController）
    
    /// 显示系统样式提示框：UIAlertController
    ///
    /// - Parameters:
    ///   - title: 提示信息标题
    ///   - message: 提示信息
    ///   - animated: 是否存在动画
    func showAlert(_ title: String?, message: String? = nil, animated: Bool = true) -> Void {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction.init(title: "确定", style: UIAlertActionStyle.default))
        self.present(alertController, animated: animated, completion: nil)
    }
    
    //MARK:显示系统样式提示框（带一个操作）
    
    /// 显示带一个操作的系统样式提示框
    ///
    /// - Parameters:
    ///   - action: 预设的一个操作action
    ///   - title: 提示信息标题
    ///   - message: 提示信息
    ///   - animated: 是否存在动画
    func showAlertWithAction(_ action: UIAlertAction, title: String?, message: String? = nil, animated: Bool = true) -> Void {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(action)
        self.present(alertController, animated: animated, completion: nil)
    }
    
    
    //MARK:显示系统样式提示框（带一组操作）
    
    /// 显示带一组操作的系统样式提示框
    ///
    /// - Parameters:
    ///   - actions: 预设的一组操作action
    ///   - title: 提示信息标题
    ///   - message: 提示信息
    ///   - animated: 是否存在动画
    func showAlertWithActions(_ actions: Array<UIAlertAction>, title: String?, message: String? = nil, animated: Bool = true ) -> Void {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        for action in actions {
            alertController.addAction(action)
        }
        self.present(alertController, animated: animated, completion: nil)
    }
    
    
}

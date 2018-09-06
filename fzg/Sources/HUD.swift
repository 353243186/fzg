//
//  CRMBProgressHUD.swift
//  iTour
//
//  Created by user on 29/12/17.
//  Copyright © 2017年 cleven. All rights reserved.
//

import UIKit
import MBProgressHUD


fileprivate let hudShowTime: TimeInterval = 1.5
public class HUD:NSObject {
    static fileprivate var hud: MBProgressHUD?

    fileprivate class func createHud(view: UIView? = UIApplication.shared.keyWindow, isMask: Bool = false) -> MBProgressHUD? {
        guard let supview = view ?? UIApplication.shared.keyWindow else {return nil}
        let hud = MBProgressHUD.showAdded(to: supview
            , animated: true)
        hud.frame = CGRect(x: 0, y: ScreenInfo.navigationHeight, width: ScreenInfo.Width, height: ScreenInfo.Height - ScreenInfo.navigationHeight)
        hud.animationType = .zoom
        if isMask {
            hud.backgroundView.color = UIColor(white: 0.0, alpha: 0.4)
        } else {
            hud.backgroundView.color = UIColor.clear
            hud.bezelView.backgroundColor = UIColor(white: 0.0, alpha: 0.9)
            hud.contentColor = UIColor.white
        }
        hud.removeFromSuperViewOnHide = true
        hud.show(animated: true)
        return hud
    }
    
    
    fileprivate class func showHudTips(message: String?, icon: String?, view: UIView?, completion: (() -> (Void))?) {
        let hud = createHud(view: view, isMask: false)
        hud?.label.text = message
        hud?.label.numberOfLines = 0
        if let icon = icon {
            hud?.customView = UIImageView(image: UIImage(named: icon))
        }
        hud?.mode = .customView
        DispatchQueue.main.asyncAfter(deadline: .now() + hudShowTime) {
            hud?.hide(animated: true)
            completion?()
        }
    }
}

extension HUD {
    public class func loading(on view: UIView? = UIApplication.shared.keyWindow,
                              message: String? = nil,
                              isMask: Bool = false) {
        let hud = createHud(view: view, isMask: isMask)
        hud?.mode = .indeterminate
        hud?.label.text = message
        self.hud = hud
    }
    
    public class func text(_ message: String?,
                           on view: UIView? = UIApplication.shared.keyWindow,
                           isMask: Bool = false,
                           delay: Double = 1.5,
                           completion: (() -> (Void))? = nil) {
        let hud = createHud(view: view, isMask: isMask)
        hud?.mode = .text
        hud?.detailsLabel.font = UIFont.systemFont(ofSize: 16.0)
        hud?.detailsLabel.text = message
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            hud?.hide(animated: true)
            completion?()
        }
        self.hud = hud
    }
    
    
    public class func success(_ message: String?,
                              on view: UIView? = UIApplication.shared.keyWindow,
                              completion: (() -> (Void))? = nil) {
        self.showHudTips(message: message,
                         icon: "mb_success_tips",
                         view: view,
                         completion: completion)
    }
    
    public class func error(_ message: String?,
                            on view : UIView? = UIApplication.shared.keyWindow,
                            completion: (() -> (Void))? = nil) {
        self.showHudTips(message: message,
                         icon: "mb_error_tips",
                         view: view,
                         completion: completion)
    }
    
    public class func hide() {
        hud?.hide(animated: true)
        self.hud = nil
    }
}


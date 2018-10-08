//
//  FZGNavigationViewController.swift
//  fzg
//
//  Created by JohnLee on 2018/9/6.
//  Copyright © 2018年 fuiou. All rights reserved.
//

import UIKit

class FZGNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
    self.navigationBar.setBackgroundImage(UIImage.imageWithColor(UIColor.accentColor, size: CGSize(width: 1,height: 1)), for:.default)
        self.navigationBar.isTranslucent = false
        self.navigationBar.tintColor = UIColor.white
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]/*, NSFontAttributeName: UIFont(magicIdentifier: "style.text.normal.font_spec_bold").allCaps()]*/
//
//        let navButtonAppearance = UIBarButtonItem.appearance(whenContainedInInstancesOf: [UINavigationBar.self])
//
//        let attributes = [NSFontAttributeName : UIFont(magicIdentifier: "style.text.normal.font_spec").allCaps()]
//        navButtonAppearance.setTitleTextAttributes(attributes, for: UIControlState.normal)
//        navButtonAppearance.setTitleTextAttributes(attributes, for: UIControlState.highlighted)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        // 支持侧滑返回
        if !viewController.isMember(of: FZGMainViewController.self){
            self.interactivePopGestureRecognizer?.delegate = viewController as? UIGestureRecognizerDelegate
        }
//        self.interactivePopGestureRecognizer?.delegate = viewController as? UIGestureRecognizerDelegate
        let backButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "message_back"), style: .plain, target: self, action: #selector(FZGNavigationViewController.backToLastVC))
        viewController.navigationItem.leftBarButtonItem = backButtonItem
    }
    
    
    
    @objc private func backToLastVC() {
        if self.viewControllers.count > 1 {
            self.popViewController(animated: true)
        }
        else {
            self.dismiss(animated: true, completion: nil)
        }
    }

}

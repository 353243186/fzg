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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

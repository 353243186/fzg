//
//  FZGLaunchViewController.swift
//  fzg
//
//  Created by JohnLee on 2018/9/6.
//  Copyright © 2018年 fuiou. All rights reserved.
//

import UIKit
import CocoaLumberjackSwift

class FZGLaunchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        AppDelegate.currentDelegate().pushToLoginViewController()
        checkVersion()
    }

    private func checkVersion() {
        let param = ["version": FZGTools.getShortVersionString(),
                     "appType": "iOS"]
        FZGNetManager.instance.postJSONDataWithUrl(FZGNetManager.checkVersionUrl, parameters: param, successed: { (value, status) in
            HUD.hide()
            if value["retCode"] == "0000"{
                AppDelegate.currentDelegate().pushToMainViewController()
            }else{
                AppDelegate.currentDelegate().pushToLoginViewController()
                
            }
            DDLogInfo(value.description)
        }) { (error) in
            HUD.hide()
            DDLogError(error.debugDescription)
            HUD.error("服务器连接失败！")
        }
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

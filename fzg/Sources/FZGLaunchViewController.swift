//
//  FZGLaunchViewController.swift
//  fzg
//
//  Created by JohnLee on 2018/9/6.
//  Copyright © 2018年 fuiou. All rights reserved.
//

import UIKit
import CocoaLumberjackSwift
import Cartography
import CloudPushSDK

class FZGLaunchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
        let logo = UIImageView.init(image:#imageLiteral(resourceName: "login_logo"))
        view.addSubview(logo)
        constrain(view, logo) { (view, logo) in
            logo.centerX == view.centerX
            logo.centerY == view.centerY
        }
        checkVersion()
//        checkToken()
    }
    
    private func checkToken() {
        guard let user = FZGTools.defaultsUser(), let token = FZGTools.defaultsToken() else{
            AppDelegate.currentDelegate().pushToLoginViewController()
            return
        }
        let param = ["loginId": user,
                     "deviceId": CloudPushSDK.getDeviceId(),
                     "token": token]
        FZGNetManager.instance.postJSONDataWithUrl(FZGNetManager.checkTokenUrl, parameters: param, successed: { (value, status) in
            HUD.hide()
            if value["retCode"] == "0000"{
                AppDelegate.currentDelegate().pushToMainViewController()
            }else{
                AppDelegate.currentDelegate().pushToLoginViewController()
            }
        }) { (error) in
            HUD.hide()
            DDLogError(error.debugDescription)
            AppDelegate.currentDelegate().pushToLoginViewController()
        }
    }

    private func checkVersion() {
        let param = ["version": FZGTools.getShortVersionString(),
                     "appType": "iOS",
                     "deviceVer": UIDevice.current.systemVersion,
                     "appId": CloudPushSDK.getDeviceId()
                     ]
        FZGNetManager.instance.postJSONDataWithUrl(FZGNetManager.checkVersionUrl, parameters: param, successed: { (value, status) in
            HUD.hide()
            if value["retCode"].string == "0000"{
                if let updateFlag = value["updateFlag"].string{
                    let cancelAction = UIAlertAction.init(title: "暂不更新", style: .cancel) {(_) in
                        self.checkToken()
                    }
                    let sureAction = UIAlertAction.init(title: "确定", style: .destructive) {(_) in
                        let url = URL.init(string: "itms-apps://itunes.apple.com/app/id1242707264")
                        UIApplication.shared.openURL(url!)
                    }
                    // 升级标志: 0：不需要升级；1：需要升级；2：强制升级
                    if updateFlag == "0"{
                        self.checkToken()
                    }else if updateFlag == "1"{
                        self.showAlertWithActions([cancelAction, sureAction], title: "版本更新", message: value["retCode"].string)
                    }else if updateFlag == "2"{
                        self.showAlertWithAction(sureAction, title: "版本更新")
                    }
                }else{
                    self.checkToken()
                }
            }else{
                DDLogError(value["retMsg"].string ?? "")
                self.checkToken()
            }
            
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

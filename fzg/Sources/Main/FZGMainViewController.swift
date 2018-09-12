//
//  FZGMainViewController.swift
//  fzg
//
//  Created by JohnLee on 2018/9/6.
//  Copyright © 2018年 fuiou. All rights reserved.
//

import UIKit
import CoreData
import CloudPushSDK
import CocoaLumberjackSwift

class FZGMainViewController: UIViewController {

    @IBOutlet weak var accountLabel: UILabel!
    @IBAction func checkTransactionRecords(_ sender: Any) {
        
        let transactionRecordsView = FZGWebViewController.init(FZGNetManager.historyUrl)
        transactionRecordsView.hasToken = true
        self.navigationController?.pushViewController(transactionRecordsView, animated: true)
    }
    @IBAction func aboutFuiou(_ sender: Any) {
        let aboutView = FZGWebViewController.init(FZGNetManager.aboutUrl)
        self.navigationController?.pushViewController(aboutView, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "富掌柜"
        self.showLeftButtonWithImage(#imageLiteral(resourceName: "email"), target: self, action: #selector(pushToMessageCenter))
//        self.showRightButtonWithImage(#imageLiteral(resourceName: "refresh"), isOriginalImage: true, target: self, action: #selector(refresh))
        showRightButtonWithTitle("登出", target: self, action: #selector(logoutButtonClick))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func pushToMessageCenter() {
        self.navigationController?.pushViewController(FZGMessageCenterViewController(), animated: true) 
    }
    
    @objc private func logoutButtonClick() {
        
        let cancelAction = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        let sureAction = UIAlertAction.init(title: "确定", style: .destructive) {(_) in
            self.logout()
        }
        self.showAlertWithActions([cancelAction, sureAction], title: "确定要退出当前账户吗？")
    }
    
    private func logout() {
        guard let loginId = FZGTools.defaultsUser() else { return  }
        
        let param = ["loginId": loginId,
                     "deviceId": CloudPushSDK.getDeviceId()
        ]
        HUD.loading()
        FZGNetManager.instance.postJSONDataWithUrl(FZGNetManager.logoutUrl, parameters: param, successed: { (value, status) in
            HUD.hide()
            if value["retCode"] == "0000"{
                FZGTools.deleteValue(forKey: userKey)
                FZGTools.deleteValue(forKey: userTypeKey)
                FZGTools.deleteValue(forKey: tokenKey)
                AppDelegate.currentDelegate().pushToLoginViewController()
            }else{
                HUD.error("\(value["retMsg"].string ?? "服务器连接失败！")")
            }
            DDLogInfo(value.description)
        }) { (error) in
            HUD.hide()
            DDLogError(error.debugDescription)
            HUD.error("服务器连接失败！")
        }
            
    }


}

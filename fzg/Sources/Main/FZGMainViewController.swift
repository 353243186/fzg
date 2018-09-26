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
import Cartography

class FZGMainViewController: UIViewController {

    @IBOutlet weak var accountLabel: UILabel!
    
    @IBOutlet weak var topImageView: UIImageView!
    var applicationDidReceiveNotificationToken : NSObjectProtocol? = nil
    
    @IBAction func mesaageButtonClick(_ sender: Any) {
        pushToMessageCenter()
    }
    
    deinit {
        if let token = applicationDidReceiveNotificationToken {
            NotificationCenter.default.removeObserver(token)
        }
    }
    
    @IBAction func checkTransactionRecords(_ sender: Any) {
        
        let transactionRecordsView = FZGWebViewController.init(FZGNetManager.historyUrl)
        transactionRecordsView.hasToken = true
//        transactionRecordsView.title = ""
        self.navigationController?.pushViewController(transactionRecordsView, animated: true)
    }
//    @IBAction func aboutFuiou(_ sender: Any) {
//        let aboutView = FZGWebViewController.init(FZGNetManager.aboutUrl)
//        self.navigationController?.pushViewController(aboutView, animated: true)
//    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        accountLabel.text = FZGTools.defaultsMerchantName()
        navigationItem.leftBarButtonItem = nil
        showRightButtonWithImage(#imageLiteral(resourceName: "homepage_logout"), isOriginalImage: true, target: self, action: #selector(logoutButtonClick))
        let notificationName = Notification.Name("FZGDidReceiveNotification")
        
        applicationDidReceiveNotificationToken = NotificationCenter.default.addObserver(forName: notificationName, object: nil, queue: nil) { [weak self](notification) in
            if let contentString = notification.object as? String{
                self?.showTips(contentString)
            }

        }
    }
    
    private func showTips(_ tips: String) {
        let tipLabel = UILabel()
        tipLabel.text = tips
        tipLabel.textColor = UIColor.withHex(hexInt: 0x913c23)
        tipLabel.textAlignment = .center
        tipLabel.backgroundColor = UIColor.yellow 
        self.view.addSubview(tipLabel)
//        let group =  constrain(topImageView,tipLabel) { (topImageView, tipLabel) in
//            tipLabel.left == tipLabel.superview!.left
//            tipLabel.bottom == tipLabel.superview!.top
//            tipLabel.right == tipLabel.superview!.right
//            tipLabel.height == 20
//        }
//        self.view.layoutIfNeeded()
        constrain(topImageView, tipLabel) { (topImageView, tipLabel) in
            tipLabel.left == topImageView.left
            tipLabel.top == topImageView.bottom
            tipLabel.right == topImageView.right
            tipLabel.height == 20
        }
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.5) {
            UIView.animate(withDuration: 0.5, animations: {
                tipLabel.isHidden = true
            }, completion: { (_) in
                tipLabel.removeFromSuperview()
            })
        }
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
        guard let loginId = FZGTools.defaultsAccount() else { return  }
        
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
//                self.clearCoreData()
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
    
    //清除
    private func clearCoreData() {
        let request = NSFetchRequest<NSFetchRequestResult>.init(entityName: "TransDetail")
        let managedObjectContext = AppDelegate.currentDelegate().managedObjectContext
        do {
            let historys = try managedObjectContext.fetch(request)
            for history in historys {
                managedObjectContext.delete(history as! NSManagedObject)
            }
    
        } catch  {
            DDLogError("数据库错误：\(error.localizedDescription)")
        }
    }


}

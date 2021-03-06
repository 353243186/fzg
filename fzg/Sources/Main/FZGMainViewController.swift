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
    private var applicationDidReceiveNotificationToken : NSObjectProtocol? = nil
    private var applicationWillEnterForegroundNotificationToken : NSObjectProtocol? = nil
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBAction func mesaageButtonClick(_ sender: Any) {
        pushToMessageCenter()
    }
    
    deinit {
        if let token = applicationDidReceiveNotificationToken {
            NotificationCenter.default.removeObserver(token)
        }
        if let token = applicationWillEnterForegroundNotificationToken{
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
        self.navigationController?.navigationBar.setBackgroundImage(UIImage.imageWithColor(UIColor.accentColor, size: CGSize(width: 1,height: 1)), for:.default)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        
        messageView.isHidden = true
        accountLabel.text = FZGTools.defaultsMerchantName()
        navigationItem.leftBarButtonItem = nil
        showRightButtonWithImage(#imageLiteral(resourceName: "homepage_logout"), isOriginalImage: true, target: self, action: #selector(logoutButtonClick))
        let notificationName = Notification.Name(didReceiveNotificationName)
        
        applicationDidReceiveNotificationToken = NotificationCenter.default.addObserver(forName: notificationName, object: nil, queue: nil) { [weak self](notification) in
            if let contentString = notification.object as? String{
                self?.showTips(contentString)
            }

        }
        
        let notificationName1 = Notification.Name(willEnterForegroundNotificationName)
        
        applicationDidReceiveNotificationToken = NotificationCenter.default.addObserver(forName: notificationName1, object: nil, queue: nil) { [weak self](notification) in
            self?.loadLatestTransDetail()
        }
        
        
    }
    
    func showTips(_ tips: String) {
        messageView.isHidden = false
        messageLabel.text = tips
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadLatestTransDetail()
    }
    
    //读取最新消息
    @objc private func loadLatestTransDetail() {
        let request = NSFetchRequest<NSFetchRequestResult>.init(entityName: "TransDetail")
        let sortDescriptor = NSSortDescriptor.init(key: "txTime", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        if let account = FZGTools.defaultsAccount(){
            // 只读取24小时内的消息
            let yesterday = Date.init(timeIntervalSinceNow: -24 * 60 * 60)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let dateString = dateFormatter.string(from: yesterday)
            
            let predicate = NSPredicate.init(format: "account = '\(account)' AND txTime > '\(dateString)'")
            request.predicate = predicate
        }
        
        do {
            let historys = try AppDelegate.currentDelegate().managedObjectContext.fetch(request)
            
            if historys.count > 0 {
                if let transDetail = historys[0] as? TransDetail{
                    messageView.isHidden = false
                    messageLabel.text = transDetail.body
                }
                
            }
        } catch  {
            DDLogError("数据库错误：\(error.localizedDescription)")
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func pushToMessageCenter() {
        self.navigationController?.pushViewController(FZGMessageCenterViewController(), animated: true)
    }
    
    @objc private func logoutButtonClick() {
//        FZGAudioManager.shared.playWithIsBroadCast("1", amt: 11111004.7) { (_) in
//
//        }
//        return
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

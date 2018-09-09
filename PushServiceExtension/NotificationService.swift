//
//  NotificationService.swift
//  PushServiceExtension
//
//  Created by JohnLee on 2018/9/9.
//  Copyright © 2018年 fuiou. All rights reserved.
//

import UserNotifications
import ExtensionComponents
import CoreData


class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    
    // MARK: - Core Data stack
    //数据库上下文，根据iOS版本
    lazy var managedObjectContext : NSManagedObjectContext = {
        //        if #available(iOS 10.0, *) {
        //            return self.persistentContainer.viewContext
        //        } else {//ios9以前
        let url = Bundle.main.url(forResource: "fzg", withExtension: "momd")
        let managedObjectModel = NSManagedObjectModel.init(contentsOf: url!)
        let persistentStoreCoordinator = NSPersistentStoreCoordinator.init(managedObjectModel: managedObjectModel!)
        
        let appDocumentDirectory = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.fuiou.fzg")
        let storeUrl = appDocumentDirectory?.appendingPathComponent("fzg.data")
        let option = [NSMigratePersistentStoresAutomaticallyOption : true, NSInferMappingModelAutomaticallyOption : false ]
        
        do {
            let store = try  persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeUrl, options: option)
        } catch  {
            print("数据库错误:\(error.localizedDescription)")
        }
        
        let context = NSManagedObjectContext.init(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentStoreCoordinator
        
        return context
        //        }
    }()
//    "mchntName":"商户名称",
//    "mchntCd":"商户号",
//    "busiCd":"业务代码",
//    "amt":"交易金额(分)",
//    "txTime":"2018-08-13 19:17:45",
//    "txnSt":"状态",
//    "orderNo":"订单号",
//    "cardNo":"",
//    "txnSsn":"富友流水号",
//    "termId":"终端号",
//    "traceNo":"跟踪号",
//    "transactionId":"渠道流水号",
//    "goodsDes":"交易信息"
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        print("--------------\(bestAttemptContent?.userInfo.description)")
        if let extras = bestAttemptContent?.userInfo["Extras"] as? [AnyHashable : Any]{
            print("---开始解析通知内容")
//            let managedObjectContext = FZGDataAccess.instance.managedObjectContext
            let TransDetail = NSEntityDescription.insertNewObject(forEntityName: "TransDetail", into: managedObjectContext)
            if let value = extras["mchntName"] as? String{
                TransDetail.setValue(value, forKey: "mchntName")
            }
            if let value = extras["mchntCd"] as? String{
                TransDetail.setValue(value, forKey: "mchntCd")
            }
            if let value = extras["busiCd"] as? String{
                TransDetail.setValue(value, forKey: "busiCd")
            }
            if let value = extras["amt"] as? String, let amtDoubleValue = Double.init(value){
                TransDetail.setValue(amtDoubleValue / 100.0, forKey: "amt")
            }
            if let value = extras["txTime"] as? String{
                TransDetail.setValue(value, forKey: "txTime")
            }
            if let value = extras["txnSt"] as? String{
                TransDetail.setValue(value, forKey: "txnSt")
            }
            if let value = extras["orderNo"] as? String{
                TransDetail.setValue(value, forKey: "orderNo")
            }
            if let value = extras["txnSsn"] as? String{
                TransDetail.setValue(value, forKey: "txnSsn")
            }
            if let value = extras["termId"] as? String{
                TransDetail.setValue(value, forKey: "termId")
            }
            if let value = extras["transactionId"] as? String{
                TransDetail.setValue(value, forKey: "transactionId")
            }
            if let value = extras["goodsDes"] as? String{
                TransDetail.setValue(value, forKey: "goodsDes")
            }
            
            print("---开始保存通知内容")
            //保存通知内容
            do {
                try managedObjectContext.save()
            } catch  {
                print("---数据库错误，保存失败：\(error.localizedDescription)")
            }
            if let value = extras["amt"] as? String, let amtDoubleValue = Double.init(value){
                FZGSpeechUtteranceManager.shared.speechWeather(with: "微信收款\(amtDoubleValue / 100.0)元")
            }
            
        }

        
        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
            bestAttemptContent.title = "\(bestAttemptContent.title) [modified]"
            
            contentHandler(bestAttemptContent)
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}

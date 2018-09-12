 //
//  NotificationService.swift
//  PushServiceExtension
//
//  Created by JohnLee on 2018/9/9.
//  Copyright © 2018年 fuiou. All rights reserved.
//

import UserNotifications
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
    
//    mchntName:商户名称；txnSt：交易状态；amt:交易金额（单位是分）；termId:终端号；mchntCd：商户号；busiCd：交易类型（业务代码）；loginIdList：???；txnSsn:富友流水号；chnlCd：渠道商户号；m: ???;busiCdDesc：交易类型描述；termName：终端别称；txTime：交易时间；orderNo：订单号；cardNo：卡号；
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)

        if let userInfo = bestAttemptContent?.userInfo{
            print("---开始解析通知内容")
            let transDetail = NSEntityDescription.insertNewObject(forEntityName: "TransDetail", into: managedObjectContext)
            if let value = userInfo["mchntName"] as? String{
                transDetail.setValue(value, forKey: "mchntName")
            }
            if let value = userInfo["termName"] as? String{
                transDetail.setValue(value, forKey: "termName")
            }
            if let value = userInfo["termId"] as? String{
                transDetail.setValue(value, forKey: "termId")
            }
            if let value = userInfo["txTime"] as? String{
                transDetail.setValue(value, forKey: "txTime")
            }
            if let value = userInfo["busiCd"] as? String{
                transDetail.setValue(value, forKey: "busiCd")
            }
            if let value = userInfo["cardNo"] as? String{
                transDetail.setValue(value, forKey: "cardNo")
            }
            if let value = userInfo["mchntCd"] as? String{
                transDetail.setValue(value, forKey: "mchntCd")
            }
            if let value = userInfo["orderNo"] as? String{
                transDetail.setValue(value, forKey: "orderNo")
            }
            if let value = userInfo["amt"] as? Double{
                transDetail.setValue(value / 100.0, forKey: "amt")
            }
            if let value = userInfo["txnSsn"] as? String{
                transDetail.setValue(value, forKey: "txnSsn")
            }
            if let value = userInfo["txnSt"] as? String{
                transDetail.setValue(value, forKey: "txnSt")
            }
            
            if let value = userInfo["transactionId"] as? String{
                transDetail.setValue(value, forKey: "transactionId")
            }
            if let value = userInfo["goodsDes"] as? String{
                transDetail.setValue(value, forKey: "goodsDes")
            }
            
            print("---开始保存通知内容")
            //保存通知内容
            do {
                try managedObjectContext.save()
            } catch  {
                print("---数据库错误，保存失败：\(error.localizedDescription)")
            }
            
            FZGSpeechUtteranceManager.shared.speechWeather(with: bestAttemptContent?.body ?? "富掌柜交易成功")
//            func getspeechStringWithBusiCd(_ busiCd: String, amt: Double) -> String {
//                if busiCd == "TX02"{
//                    return "银行卡收款\(amt)元"
//                }else if busiCd == "TX03"{
//                    return "富掌柜退款\(amt)元"
//                }else if busiCd == "TX09"{
//                    return "微信收款\(amt)元"
//                }else if busiCd == "TX15"{
//                    return "支付宝收款\(amt)元"
//                }else if busiCd == "TX18"{
//                    return "富掌柜退款\(amt)元"
//                }else{
//                    return "富掌柜交易成功"
//                }
//            }
//
//            if let busiCd = userInfo["busiCd"] as? String, let amt = userInfo["amt"] as? Double{
//                FZGSpeechUtteranceManager.shared.speechWeather(with: getspeechStringWithBusiCd(busiCd, amt: amt))
//            }
        }
        
        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
//            bestAttemptContent.title = "bestAttemptContent.title"
            
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

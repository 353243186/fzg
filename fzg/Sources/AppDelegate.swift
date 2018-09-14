//
//  AppDelegate.swift
//  fzg
//
//  Created by JohnLee on 2018/9/5.
//  Copyright © 2018年 fuiou. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import CocoaLumberjackSwift
import UserNotifications
import CloudPushSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    private let testAppKey = "25060647"
    private let testAppSecret = "17646e2d5f2fa5b54f35565b25cf34aa"
    
    var fromDead = false // 标记是否是被杀死的应用被后台吊起
    class func currentDelegate() ->AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    ///跳转登录
    func pushToLoginViewController() {
        let loginViewController = FZGLoginViewController()
        self.window?.rootViewController = loginViewController
    }
    
    ///跳转启动页
    func pushToLaunchViewController() {
        let launchViewController = FZGLaunchViewController()
        self.window?.rootViewController = launchViewController
    }
    
    ///跳转主页
    func pushToMainViewController() {
        let mainViewController = FZGNavigationViewController.init(rootViewController: FZGMainViewController())
        self.window?.rootViewController = mainViewController
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //启动IQKeyboardManager
        IQKeyboardManager.shared.enable = true
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        if launchOptions != nil{
            fromDead = true
        }
        self.window?.rootViewController = FZGLaunchViewController()

        self.window?.makeKeyAndVisible()
        
//        DDLog.add(DDTTYLogger.sharedInstance) // TTY = Xcode console
        DDLog.add(DDASLLogger.sharedInstance) // ASL = Apple System Logs
        
        // APNs注册，获取deviceToken并上报
        registerAPNs(application)
        // 初始化阿里云推送SDK
        initCloudPushSDK()
        // 监听推送通道打开动作
        listenOnChannelOpened()
        // 监听推送消息到达
        registerMessageReceive()
        // 点击通知将App从关闭状态启动时，将通知打开回执上报
        //CloudPushSDK.handleLaunching(launchOptions)(Deprecated from v1.8.1)
        CloudPushSDK.sendNotificationAck(launchOptions)
        
        return true
    }
    
    
    // 向APNs注册，获取deviceToken用于推送
    func registerAPNs(_ application: UIApplication) {
        if #available(iOS 10, *) {
            // iOS 10+
            let center = UNUserNotificationCenter.current()
            // 创建category，并注册到通知中心
            createCustomNotificationCategory()
            center.delegate = self
            // 请求推送权限
            center.requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { (granted, error) in
                if (granted) {
                    // User authored notification
                    print("User authored notification.")
                    // 向APNs注册，获取deviceToken
                    DispatchQueue.main.async {
                        application.registerForRemoteNotifications()
                    }
                } else {
                    // User denied notification
                    print("User denied notification.")
                }
            })
        } else if #available(iOS 8, *) {
            // iOS 8+
            application.registerUserNotificationSettings(UIUserNotificationSettings.init(types: [.alert, .badge, .sound], categories: nil))
            application.registerForRemoteNotifications()
        } else {
            // < iOS 8
            application.registerForRemoteNotifications(matching: [.alert,.badge,.sound])
        }
    }
    
    // 创建自定义category，并注册到通知中心
    @available(iOS 10, *)
    func createCustomNotificationCategory() {
        let action1 = UNNotificationAction.init(identifier: "action1", title: "test1", options: [])
        let action2 = UNNotificationAction.init(identifier: "action2", title: "test2", options: [])
        let category = UNNotificationCategory.init(identifier: "test_category", actions: [action1, action2], intentIdentifiers: [], options: UNNotificationCategoryOptions.customDismissAction)
        UNUserNotificationCenter.current().setNotificationCategories([category])
    }
    
    // 初始化推送SDK
    func initCloudPushSDK() {
        // 打开Log，线上建议关闭
        CloudPushSDK.turnOnDebug()
        CloudPushSDK.asyncInit(testAppKey, appSecret: testAppSecret) { (res) in
            if (res!.success) {
                print("Push SDK init success, deviceId: \(CloudPushSDK.getDeviceId()!)")
            } else {
                print("Push SDK init failed, error: \(res!.error!).")
            }
        }
    }
    
    // 监听推送通道是否打开
    func listenOnChannelOpened() {
        let notificationName = Notification.Name("CCPDidChannelConnectedSuccess")
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(channelOpenedFunc(notification:)),
                                               name: notificationName,
                                               object: nil)
    }
    
    @objc func channelOpenedFunc(notification : Notification) {
        print("Push SDK channel opened.")
    }
    
    // 注册消息到来监听
    func registerMessageReceive() {
        let notificationName = Notification.Name("CCPDidReceiveMessageNotification")
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onMessageReceivedFunc(notification:)),
                                               name: notificationName,
                                               object: nil)
    }

    // 处理推送消息
    @objc func onMessageReceivedFunc(notification : Notification) {
        print("Receive one message.")
        let pushMessage: CCPSysMessage = notification.object as! CCPSysMessage
        let title = String.init(data: pushMessage.title, encoding: String.Encoding.utf8)
        let body = String.init(data: pushMessage.body, encoding: String.Encoding.utf8)
        print("Message title: \(title!), body: \(body!).")
    }

    // MARK: - notification
    // APNs注册成功
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        CloudPushSDK.registerDevice(deviceToken) { (res) in
            if (res!.success) {
                print("Upload deviceToken to Push Server, deviceToken: \(CloudPushSDK.getApnsDeviceToken()!)")
                print("my deviceID: \(CloudPushSDK.getDeviceId())")
            } else {
                print("Upload deviceToken to Push Server failed, error: \(String(describing: res?.error))")
            }
        }
    }
    
    // APNs注册失败
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Get deviceToken from APNs failed, error: \(error).")
    }
    // App处于启动状态时，通知打开回调（iOS 9）
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        saveTransDetailInfo(userInfo: userInfo)
        print("Receive one notification.")
        let aps = userInfo["aps"] as! [AnyHashable : Any]
        let alert = aps["alert"] ?? "none"
        let badge = aps["badge"] ?? 0
        let sound = aps["sound"] ?? "none"
        let extras = userInfo["Extras"]
        
        // 设置角标数为0
        application.applicationIconBadgeNumber = 0;
        // 同步角标数到服务端
        // self.syncBadgeNum(0)
        CloudPushSDK.sendNotificationAck(userInfo)
        print("Notification, alert: \(alert), badge: \(badge), sound: \(sound), extras: \(String(describing: extras)).")
//       FZGSpeechUtteranceManager.shared.speechWeather(with: "微信成功收款54.67元")
    }
    

    
    // App处于前台时收到通知(iOS 10+)
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Receive a notification in foreground.")
        handleiOS10Notification(notification)
        // 通知不弹出
        completionHandler([])
        // 通知弹出，且带有声音、内容和角标
//        completionHandler([.alert, .badge, .sound])
    }
    

    
    // 触发通知动作时回调，比如点击、删除通知和点击自定义action(iOS 10+)
    @available(iOS 10, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userAction = response.actionIdentifier
        if userAction == UNNotificationDefaultActionIdentifier {
            print("User opened the notification.")
            // 处理iOS 10通知，并上报通知打开回执
            handleiOS10Notification(response.notification)
            let content: UNNotificationContent = response.notification.request.content
            if let clickTransDetailId = content.userInfo["txnSsn"] as? String,
                let transDetail = searchTransDetailWithId(clickTransDetailId) {
                
                guard let user = FZGTools.defaultsUser(), let token = FZGTools.defaultsToken() else{
                    return
                }
                let param = ["loginId": user,
                             "deviceId": CloudPushSDK.getDeviceId(),
                             "token": token]
                FZGNetManager.instance.postJSONDataWithUrl(FZGNetManager.checkTokenUrl, parameters: param, successed: { (value, status) in
                    HUD.hide()
                    if value["retCode"] == "0000"{
                        self.pushToNotificationViewWithTransDetail(transDetail)
                    }else{
                        
                    }
                }) { (error) in
                    HUD.hide()
                    DDLogError(error.debugDescription)
                }
                
//                if fromDead{
//                    FZGSpeechUtteranceManager.shared.speechWeather(with: "打开")
//                }
            }
            
        }
        
        if userAction == UNNotificationDismissActionIdentifier {
            print("User dismissed the notification.")
        }
        
        let customAction1 = "action1"
        let customAction2 = "action2"
        if userAction == customAction1 {
            print("User touch custom action1.")
        }
        
        if userAction == customAction2 {
            print("User touch custom action2.")
        }
        
        completionHandler()
    }
    
    private func pushToNotificationViewWithTransDetail(_ transDetail :TransDetail) {
        let controller = FZGMessageDetailViewController.init(transDetail)
        controller.fromNotificatoinCenter = true
        
        let notificationRootViewController = FZGNavigationViewController.init(rootViewController: controller)
        
        //
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
            self.window?.rootViewController = notificationRootViewController
        })
    }
    
    private func saveTransDetailInfo(userInfo: [AnyHashable : Any]) {
       print("---开始解析通知内容(ios9)")
        //            let managedObjectContext = FZGDataAccess.instance.managedObjectContext
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
//        if let value = userInfo["amt"] as? String, let amtDoubleValue = Double.init(value){
//            FZGSpeechUtteranceManager.shared.speechWeather(with: "微信收款\(amtDoubleValue / 100.0)元")
//        }
        
    }
    
    //读取
    private func searchTransDetailWithId(_ id: String) -> TransDetail? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "TransDetail")
        //        let sortDescriptor = NSSortDescriptor.init(key: "time", ascending: false)
        //        request.sortDescriptors = [sortDescriptor]
        let predicate = NSPredicate.init(format: "txnSsn = '\(id)'", "")
        fetchRequest.predicate = predicate;
        
        do {
            let results = try managedObjectContext.fetch(fetchRequest)
            
            if results.count > 0 {
                return results[0] as? TransDetail
            }else{
                return nil
            }
        } catch  {
            DDLogError("数据库错误：\(error.localizedDescription)")
        }
        return nil
    }
    
    // 处理iOS 10通知(iOS 10+)
    @available(iOS 10.0, *)
    func handleiOS10Notification(_ notification: UNNotification) {
        let content: UNNotificationContent = notification.request.content
        let userInfo = content.userInfo
        // 通知时间
        let noticeDate = notification.date
        // 标题
        let title = content.title
        // 副标题
        let subtitle = content.subtitle
        // 内容
        let body = content.body
        // 角标
        let badge = content.badge ?? 0
        // 取得通知自定义字段内容，例：获取key为"Extras"的内容
        let extras = userInfo["Extras"]
        // 设置角标数为0
        UIApplication.shared.applicationIconBadgeNumber = 0
        // 同步角标数到服务端
        // self.syncBadgeNum(0)
        // 通知打开回执上报
        CloudPushSDK.sendNotificationAck(userInfo)
        print("Notification, date: \(noticeDate), title: \(title), subtitle: \(subtitle), body: \(body), badge: \(badge), extras: \(String(describing: extras)).")
    }
    
    /* 同步角标数到服务端 */
    func syncBadgeNum(_ badgeNum: UInt) {
        CloudPushSDK.syncBadgeNum(badgeNum) { (res) in
            if (res!.success) {
                print("Sync badge num: [\(badgeNum)] success")
            } else {
                print("Sync badge num: [\(badgeNum)] failed, error: \(String(describing: res?.error))")
            }
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        if #available(iOS 10.0, *) {
            self.saveContext()
        } else {
            // Fallback on earlier versions
        }
    }
    
    

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
            let option = [NSMigratePersistentStoresAutomaticallyOption : true, NSInferMappingModelAutomaticallyOption : true ]
            
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
    
    
    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "fzg")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = managedObjectContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}


//
//  FZGTools.swift
//  fzg
//
//  Created by JohnLee on 2018/9/9.
//  Copyright © 2018年 fuiou. All rights reserved.
//

import UIKit
let userKey = "user"
let userIdKey = "userId"
let userTypeKey = "userType"
let tokenKey = "token"
let userNameKey = "userName"
class FZGTools: NSObject {
    //获取设备型号
    static var deviceModel : String {
        return UIDevice.current.model
    }
    
    //设置defaults缓存
    class func setDefaultsValue(_ value: Any?, forKey keyName: String){
        let userDefaults = UserDefaults.standard
        userDefaults.set(value, forKey: keyName)
        userDefaults.synchronize()
    }
    //缓存账号名
    class func setDefaultsAccount(_ account:String){
        let userDefaults = UserDefaults.init(suiteName: "group.com.fuiou.fzg")
        userDefaults?.set(account, forKey: userKey)
        userDefaults?.synchronize()
    }
    
    //返回缓存的账号名
    class func defaultsAccount() -> String?{
        let userDefaults = UserDefaults.init(suiteName: "group.com.fuiou.fzg")
        return userDefaults?.value(forKey: userKey) as? String
    }
    
    //返回缓存的商户名
    class func defaultsMerchantName() -> String?{
        return defaultsValue(forKey: userNameKey) as? String
    }
    
    //返回缓存的商户id
    class func defaultsMerchantId() -> String?{
        return defaultsValue(forKey: userIdKey) as? String
    }

    //返回缓存的token
    class func defaultsToken() -> Any?{
        return defaultsValue(forKey: tokenKey)
    }
    
    //返回缓存的账户类型
    class func defaultsUserType() -> Any?{
        return defaultsValue(forKey: userTypeKey)
    }
    
    //获取defaults缓存
    class func defaultsValue(forKey key: String) -> Any?{
        let userDefaults = UserDefaults.standard
        return userDefaults.value(forKey: key)
    }
    
    //删除defaults缓存
    class func deleteValue(forKey key: String){
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: key)
        userDefaults.synchronize()
    }
    
    //通过颜色获取矢量图片
    class func imageWithColor(_ color:UIColor, size:CGSize = CGSize.init(width: 1.0, height: 1.0)) ->UIImage{
        
        let rect = CGRect(x:0, y:0, width: size.width, height: size.height)
        
        UIGraphicsBeginImageContext(rect.size)
        
        let context = UIGraphicsGetCurrentContext()
        
        context!.setFillColor(color.cgColor)
        
        context!.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image!
        
    }
    
    //有关的版本信息
    private func versionCheck() {
        //        let infoDictionary = Bundle.main.infoDictionary
        //        let appDisplayName = infoDictionary?["CFBundleDisplayName"] //程序名称
        //        let majorVersion = infoDictionary? ["CFBundleShortVersionString"]//主程序版本号
        //        let minorVersion = infoDictionary? ["CFBundleVersion"]//版本号（内部标示）
        //        //设备信息
        //        let iosVersion = UIDevice.current.systemVersion //ios版本
        //        let identifierNumber = UIDevice.current.identifierForVendor //设备udid
        //        let systemName = UIDevice.current.systemName //设备名称
        //        let model = UIDevice.current.model //设备型号
        //        let localizedModel = UIDevice.current.localizedModel //设备区域化型号如A1533
        //
        //        let appVersion = majorVersion as! String
        //        print(appVersion)
    }
    //获取内部版本号
    static func getBundleVersion() -> String {
        let infoDictionary = Bundle.main.infoDictionary
        return infoDictionary? ["CFBundleVersion"] as! String
    }
    
    //获取外部部版本号
    static func getShortVersionString() -> String {
        let infoDictionary = Bundle.main.infoDictionary
        return infoDictionary? ["CFBundleShortVersionString"] as! String
    }
}

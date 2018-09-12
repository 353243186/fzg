//
//  FZGNetManager.swift
//  fzg
//
//  Created by JohnLee on 2018/9/6.
//  Copyright © 2018年 fuiou. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CocoaLumberjackSwift

//成功block
typealias succeedHander = (_ response: JSON, _ statusCode: NSInteger) ->Void
//失败block
typealias failedHander = (_ error: Error?) ->Void

class FZGNetManager: NSObject {
    static let BaseUrl = "http://futest1.fuiou.com:24010/bdc_platfrom"
    static let loginUrl = "\(BaseUrl)/login"
    static let logoutUrl = "\(BaseUrl)/logout"
    static let verifyCodeUrl = "\(BaseUrl)/getVerifyCode"
    static let checkVersionUrl = "\(BaseUrl)/appVerUpdate"
    static let checkTokenUrl = "\(BaseUrl)/checkToken"
    static let aboutUrl = "http://fzgwx-test.fuiou.com/static/about.html"
    static let historyUrl = "http://fzgwx-test.fuiou.com/t/appTxnDetail"

    
    //单例模式下唯一实例化方法
    static let instance = FZGNetManager()
    //私有方法重写init()方法，单例模式下防止以此方法创建新的实例
    private override init() {}
    //失败hander
    private var failedHander:failedHander?
    //成功hander
    private var succeedHander:succeedHander?
    //get方法
    func getJSONDataWithUrl(_ url: String, parameters: Parameters? = nil, successed:@escaping succeedHander, failed: @escaping failedHander) {

        Alamofire.request(url, method: .get, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            DDLogInfo("\nurl = \(url)\nresponse = \(response)")
            switch response.result{
            case.success(let value):
                if let statusCode = response.response?.statusCode, statusCode == 200{
                    successed(JSON(value), statusCode)
                }
            case .failure(let error):
                failed(error)
            }
        }
        
    }
    
    //post方法
    func postJSONDataWithUrl(_ url: String, parameters: Parameters? = nil, successed:@escaping succeedHander, failed: @escaping failedHander) {
        
//        var headers = ZMUserSession.shared()?.transportSession.accessToken?.httpHeaders  as? HTTPHeaders
//        headers?["Content-Type"] = "application/json"
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            DDLogInfo("url = \(url)\nresponse = \(response)")
            switch response.result {
            case.success(let value):
                if let statusCode = response.response?.statusCode{
                    successed(JSON(value), statusCode)
                }
            case .failure(let error):
                failed(error)
            }
        }
    }
    
    //delete方法
    func deleteJSONDataWithUrl(_ url: String, parameters: Parameters? = nil, successed:@escaping succeedHander, failed: @escaping failedHander) {
        
        Alamofire.request(url, method: .delete, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result{
            case.success(let value):
                if let statusCode = response.response?.statusCode, statusCode == 200{
                    successed(JSON(value), statusCode)
                }
            case .failure(let error):
                failed(error)
            }
        }
        
    }
    
    //put方法
    func putWithUrl(_ url: String, parameters: Parameters? = nil, successed:@escaping succeedHander, failed: @escaping failedHander) {
        
        Alamofire.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            
            switch response.result{
            case.success(let value):
                if let statusCode = response.response?.statusCode{
                    successed(JSON(value), statusCode)
                }
            case .failure(let error):
                failed(error)
            }
        }
    }
}

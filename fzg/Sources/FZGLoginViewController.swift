//
//  FZGLoginViewController.swift
//  fzg
//
//  Created by JohnLee on 2018/9/6.
//  Copyright © 2018年 fuiou. All rights reserved.
//

import UIKit
import Cartography
import CocoaLumberjackSwift
import Kingfisher
import Alamofire
import CloudPushSDK

let userKey = "user"
let userIdKey = "userId"
let userTypeKey = "userType"
let tokenKey = "token"
let userNameKey = "userName"
class FZGLoginViewController: UIViewController {

    lazy var topImageBackView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "banner")
        return imageView
    }()
    
    lazy var logoView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "login_logo")
        return imageView
    }()
    
    class LeftView: UIView {
        var image: UIImage?{
            didSet{
                imageView.image = image
            }
        }
        
        private var imageView = UIImageView()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            imageView.contentMode = .center
            addSubview(imageView)
            constrain(self, imageView) { (contain, imageView) in
                imageView.width == imageView.height
                imageView.top == contain.top
                imageView.right == contain.right
                imageView.bottom == contain.bottom
            }
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    
    lazy var accountTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "请输入登录账户名"
        textField.backgroundColor = UIColor.white
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.separateLineColor.cgColor
        let leftView = LeftView.init(frame: CGRect.init(x: 0, y: 0, width: 65, height: 45))
        leftView.image = #imageLiteral(resourceName: "userIcon")
        textField.leftView = leftView
        textField.leftViewMode = .always
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    lazy var passwordTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "请输入登录账户密码"
        textField.isSecureTextEntry = true
        textField.backgroundColor = UIColor.white
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.separateLineColor.cgColor
        let leftView = LeftView.init(frame: CGRect.init(x: 0, y: 0, width: 65, height: 45))
        leftView.image = #imageLiteral(resourceName: "lock")
        textField.leftView = leftView
        textField.leftViewMode = .always
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    lazy var authCodeTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "请输入验证码"
        textField.backgroundColor = UIColor.white
//        textField.layer.borderWidth = 1
//        textField.layer.borderColor = UIColor.separateLineColor.cgColor
        let leftView = LeftView.init(frame: CGRect.init(x: 0, y: 0, width: 65, height: 45))
        leftView.image = #imageLiteral(resourceName: "list")
        textField.leftView = leftView
        textField.leftViewMode = .always
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    lazy var refreshButton : UIButton = {
        let button = UIButton()
        return button
    }()
    
    lazy var tipLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.red
        label.numberOfLines = 0
        return label
    }()
    
    lazy var loginButton : UIButton = {
        let button = UIButton()
        button.setTitle("立即登录", for: .normal)
        button.backgroundColor = UIColor.withHex(hexInt: 0x1ba3e7)
        return button
    }()
    
    let separateLine = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
        [logoView, accountTextField, passwordTextField, authCodeTextField, refreshButton, tipLabel, loginButton, separateLine].forEach(view.addSubview)
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        refreshButton.addTarget(self, action: #selector(getAuthCode), for: .touchUpInside)
        separateLine.backgroundColor = UIColor.separateLineColor
        makeConstains()
        getAuthCode()
    }
    
    @objc private func getAuthCode() {
        let url = "\(FZGNetManager.verifyCodeUrl)/\(CloudPushSDK.getDeviceId() ?? "")"
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseData { (response) in
            switch response.result {
            case.success(let value):
                if response.response?.statusCode == 200{
                    let image = UIImage.init(data: value)
                    self.refreshButton.setBackgroundImage(image, for: .normal)
                }
            case .failure(let error):
                DDLogError(error.localizedDescription)
            }
        }
    }
    
    private func makeConstains() {
        constrain(view, logoView,accountTextField, passwordTextField, authCodeTextField) { (contain, logoView,accountTextField, passwordTextField, authCodeTextField) in
            logoView.centerX == contain.centerX
            logoView.top == contain.top + 70
            logoView.width == 320
            logoView.height == 320 * 203 / 720
            
            accountTextField.left == contain.left - 1
            accountTextField.top == logoView.bottom + 70
            accountTextField.right == contain.right + 1
            accountTextField.height == 47
            
            passwordTextField.left == contain.left - 1
            passwordTextField.top == accountTextField.bottom - 1
            passwordTextField.right == contain.right + 1
            passwordTextField.height == 47
            
            authCodeTextField.left == contain.left - 1
            authCodeTextField.top == passwordTextField.bottom
//            authCodeTextField.right == contain.right + 1
            authCodeTextField.height == 46

        }
        
        constrain(view, authCodeTextField, refreshButton, separateLine) { (contain, authCodeTextField, refreshButton, separateLine) in
            refreshButton.right == contain.right - 12
            refreshButton.top == authCodeTextField.top + 1
            refreshButton.left == authCodeTextField.right
            refreshButton.height == 44
            refreshButton.width == 100

            separateLine.left == contain.left
            separateLine.right == contain.right
            separateLine.top == authCodeTextField.bottom
            separateLine.height == 1
        }
        
        constrain(view, authCodeTextField, tipLabel, loginButton) { (contain, authCodeTextField, tipLabel, loginButton) in
            tipLabel.left == contain.left + 20
            tipLabel.right == contain.right - 16
            tipLabel.top == authCodeTextField.bottom + 12
            
            loginButton.left == contain.left
            loginButton.top == authCodeTextField.bottom + 85
            loginButton.right == contain.right
            loginButton.height == 45
        }
        
    }
    
    
    @objc private func login() {
        
        guard let loginId = accountTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), loginId != "" else{
            tipLabel.text = "请输入登录账号"
            return
        }

        guard let userPwd = passwordTextField.text, userPwd.trimmingCharacters(in: .whitespacesAndNewlines) != "" else{
            tipLabel.text = "请输入登陆账户密码"
            return
        }

        guard let verifyCode = authCodeTextField.text, verifyCode.trimmingCharacters(in: .whitespacesAndNewlines) != "" else{
            tipLabel.text = "请输入验证码"
            return
        }
        
        let param = ["loginId": loginId,
                     "userPwd": userPwd.md5(),
                     "verifyCode": verifyCode,
                     "deviceId": CloudPushSDK.getDeviceId(),
                     "appType": "iOS",
                     "ver": FZGTools.getShortVersionString(),
                     "deviceVer": UIDevice.current.systemVersion,
                     "appModel": FZGTools.deviceModel
                     ]
        HUD.loading()
        FZGNetManager.instance.postJSONDataWithUrl(FZGNetManager.loginUrl, parameters: param, successed: { (value, status) in
            HUD.hide()
            if value["retCode"].string == "0000"{
                FZGTools.setDefaultsValue(loginId, forKey: userKey)
//                if let userType = value[""].string{
//                    FZGTools.setDefaultsValue(userType, forKey: userTypeKey)
//                }
                if let mchntCd = value["mchntCd"].string{
                    FZGTools.setDefaultsValue(mchntCd, forKey: userIdKey)
                }
                if let mchntName = value["mchantName"].string{
                    FZGTools.setDefaultsValue(mchntName, forKey: userNameKey)
                }
                if let token = value["token"].string{
                    FZGTools.setDefaultsValue(token, forKey: tokenKey)
                }
                AppDelegate.currentDelegate().pushToMainViewController()
            }else{
                self.tipLabel.text = value["retMsg"].string
//                HUD.error("\(value["retMsg"].string ?? "服务器连接失败！")")
            }
            
//            AppDelegate.currentDelegate().pushToMainViewController()
            DDLogInfo(value.description)
        }) { (error) in
            HUD.hide()
            self.tipLabel.text = "服务器连接失败！"
            DDLogError(error.debugDescription)
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

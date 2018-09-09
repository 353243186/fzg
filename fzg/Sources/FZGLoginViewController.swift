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


//let tokenKey = "token"
let userKey = "user"
let userTypeKey = "user"
class FZGLoginViewController: UIViewController {

    lazy var topImageBackView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "banner")
        return imageView
    }()
    
    lazy var logoView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "logn")
        return imageView
    }()
    
    lazy var accountTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "请输入登录账户名"
        textField.backgroundColor = UIColor.white
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.black999.cgColor
        textField.layer.cornerRadius = 4
        let imageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 45, height: 45))
        imageView.image = #imageLiteral(resourceName: "userIcon")
        imageView.contentMode = .center
        textField.leftView = imageView
        textField.leftViewMode = .always
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    lazy var passwordTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "请输入登录账户密码"
        textField.backgroundColor = UIColor.white
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.black999.cgColor
        textField.layer.cornerRadius = 4
        let imageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 45, height: 45))
        imageView.image = #imageLiteral(resourceName: "lock")
        imageView.contentMode = .center
        textField.leftView = imageView
        textField.leftViewMode = .always
        return textField
    }()
    
    lazy var authCodeTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "请输入验证码"
        textField.isSecureTextEntry = true
        textField.backgroundColor = UIColor.white
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.black999.cgColor
        textField.layer.cornerRadius = 4
        let imageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 45, height: 45))
        imageView.image = #imageLiteral(resourceName: "list")
        imageView.contentMode = .center
        textField.leftView = imageView
        textField.leftViewMode = .always
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
        button.setTitle("提 交", for: .normal)
        button.backgroundColor = UIColor.accentColor
        button.layer.cornerRadius = 6
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.backgroundColor
        [topImageBackView, accountTextField, passwordTextField, authCodeTextField, refreshButton, tipLabel, loginButton].forEach(view.addSubview)
        topImageBackView.addSubview(logoView)
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        refreshButton.addTarget(self, action: #selector(getAuthCode), for: .touchUpInside)
        makeConstains()
        getAuthCode()
    }
    
    @objc private func getAuthCode() {
        Alamofire.request(FZGNetManager.verifyCodeUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseData { (response) in
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
        constrain(view, topImageBackView,accountTextField, passwordTextField, authCodeTextField) { (contain, topImageBackView,accountTextField, passwordTextField, authCodeTextField) in
            topImageBackView.left == contain.left
            topImageBackView.top == contain.top
            topImageBackView.right == contain.right
            topImageBackView.height == 229
            
            accountTextField.left == contain.left + 16
            accountTextField.top == topImageBackView.bottom + 64
            accountTextField.right == contain.right - 16
            accountTextField.height == 45
            
            passwordTextField.left == contain.left + 16
            passwordTextField.top == accountTextField.bottom + 12
            passwordTextField.right == contain.right - 16
            passwordTextField.height == 45
            
            authCodeTextField.left == contain.left + 16
            authCodeTextField.top == passwordTextField.bottom + 12
            authCodeTextField.height == 45

        }
        
        constrain(view, authCodeTextField, refreshButton) { (contain, authCodeTextField, refreshButton) in
            refreshButton.left == authCodeTextField.right
            refreshButton.right == contain.right - 16
            refreshButton.centerY == authCodeTextField.centerY
            refreshButton.height == authCodeTextField.height
            refreshButton.width == 100

        }
        
        constrain(view, authCodeTextField, tipLabel, loginButton) { (contain, authCodeTextField, tipLabel, loginButton) in
            tipLabel.left == authCodeTextField.left
            tipLabel.left == contain.right - 16
            tipLabel.top == authCodeTextField.bottom + 12
            
            loginButton.left == contain.left + 16
            loginButton.top == tipLabel.bottom + 12
            loginButton.right == contain.right - 16
            loginButton.height == 45
        }
        
        constrain(topImageBackView, logoView) { (topImageBackView, logoView) in
            logoView.width == logoView.height
            logoView.height == 79
            logoView.centerX == topImageBackView.centerX
            logoView.centerY == topImageBackView.centerY
        }
    }
    
    
    @objc private func login() {
        
        guard let loginId = accountTextField.text, loginId.trimmingCharacters(in: .whitespacesAndNewlines) != "" else{
            HUD.error("请输入账号")
            return
        }

        guard let userPwd = passwordTextField.text, userPwd.trimmingCharacters(in: .whitespacesAndNewlines) != "" else{
            HUD.error("请输入密码")
            return
        }

        guard let verifyCode = authCodeTextField.text, verifyCode.trimmingCharacters(in: .whitespacesAndNewlines) != "" else{
            HUD.error("请输入验证码")
            return
        }
        
        let param = ["loginId": loginId,
                     "userPwd": userPwd.md5(),
                     "verifyCode": verifyCode,
                     "deviceId": CloudPushSDK.getDeviceId(),
                     "appType": "iOS",
                     "ver": FZGTools.getShortVersionString(),
                     "appModel": FZGTools.deviceModel
                     ]
        HUD.loading()
        FZGNetManager.instance.postJSONDataWithUrl(FZGNetManager.loginUrl, parameters: param, successed: { (value, status) in
            HUD.hide()
            if value["retCode"] == "0000"{
                AppDelegate.currentDelegate().pushToMainViewController()
            }else{
                self.tipLabel.text = value["retMsg"].string
                HUD.error("\(value["retMsg"].string ?? "服务器连接失败！")")
            }
            
//            AppDelegate.currentDelegate().pushToMainViewController()
            DDLogInfo(value.description)
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

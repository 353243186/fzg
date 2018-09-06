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
        return textField
    }()
    
    lazy var passwordTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "请输入登录账户名"
        return textField
    }()
    
    lazy var authCodeTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "请输入验证码"
        return textField
    }()
    
    lazy var tipLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.red
        return label
    }()
    
    lazy var loginButton : UIButton = {
        let button = UIButton()
        button.setTitle("提 交", for: .normal)
        button.backgroundColor = UIColor.withHex(hexInt: 0x134591)
        button.layer.cornerRadius = 4
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.backgroundColor
        [topImageBackView, accountTextField, passwordTextField, authCodeTextField, tipLabel, loginButton].forEach(view.addSubview)
        topImageBackView.addSubview(logoView)
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        makeConstains()
    }
    
    private func makeConstains() {
        constrain(view, topImageBackView,accountTextField, passwordTextField, authCodeTextField) { (contain, topImageBackView,accountTextField, passwordTextField, authCodeTextField) in
            topImageBackView.left == contain.left
            topImageBackView.top == contain.top
            topImageBackView.right == contain.right
            topImageBackView.height == 229
            
            accountTextField.left == contain.left + 16
            accountTextField.top == topImageBackView.bottom + 32
            accountTextField.right == contain.right - 16
            accountTextField.height == 45
            
            passwordTextField.left == contain.left + 16
            passwordTextField.top == accountTextField.bottom + 12
            passwordTextField.right == contain.right - 16
            passwordTextField.height == 45
            
            authCodeTextField.left == contain.left + 16
            authCodeTextField.top == passwordTextField.bottom + 12
            authCodeTextField.right == contain.right - 16
            authCodeTextField.height == 45

        }
        
        constrain(view, authCodeTextField, tipLabel, loginButton) { (contain, authCodeTextField, tipLabel, loginButton) in
            tipLabel.left == authCodeTextField.left
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
        HUD.loading()
        let param = ["loginId": "fuiou",
                     "userPwd": "123456"
                     ]
        FZGNetManager.instance.postJSONDataWithUrl(FZGNetManager.loginUrl, parameters: param, successed: { (response, status) in
            HUD.hide()
            DDLogInfo(response.description)
            
        }) { (error) in
            HUD.hide()
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

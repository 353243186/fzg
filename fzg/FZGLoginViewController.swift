//
//  FZGLoginViewController.swift
//  fzg
//
//  Created by JohnLee on 2018/9/6.
//  Copyright © 2018年 fuiou. All rights reserved.
//

import UIKit

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
        return label
    }()
    
    lazy var loginButton : UIButton = {
        let button = UIButton()
        button.setTitle("提交", for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.backgroundColor
        [topImageBackView, accountTextField, passwordTextField, authCodeTextField, tipLabel, loginButton].forEach(view.addSubview)
        topImageBackView.addSubview(loginButton)
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

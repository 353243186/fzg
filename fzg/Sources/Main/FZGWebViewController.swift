//
//  FZGWebViewController.swift
//  fzg
//
//  Created by JohnLee on 2018/9/12.
//  Copyright © 2018年 fuiou. All rights reserved.
//

import UIKit
import WebKit
import Cartography
import CloudPushSDK
import CocoaLumberjackSwift

class FZGWebViewController: UIViewController, WKNavigationDelegate /*WKScriptMessageHandler*/ {

    ///本地URL
    var localUrlString : String?
    ///网页URL
    var startUrlString : String
    ///网页主容器
    lazy var mainWebView : WKWebView = {
        let configuration = WKWebViewConfiguration()
        let userContentController = WKUserContentController()
//        userContentController.add(self, name: "tzios")
        configuration.userContentController = userContentController
        let webView = WKWebView.init(frame: CGRect.zero, configuration: configuration)
        webView.navigationDelegate = self
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        return webView
    }()
    
    ///进度条
    lazy var progressView : UIProgressView = {
        let view = UIProgressView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 3))
        view.progress = 0.0
        view.tintColor = UIColor.green
        return view
    }()
    
    ///更多按钮
    private var rightButton = UIButton()
    
    ///是否携带token，默认不携带
    var hasToken = false
    
    ///是否显示导航栏，默认显示
    var showNavBar = true
    
    init(_ startUrlString: String) {
        self.startUrlString = startUrlString
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //全清缓存
        self.clearCacheWithLocalStorage(true)
        setSubviews()
        self.navigationController?.navigationBar.topItem?.title = "";
        //若有本地页面，加载本地网页
        if let urlString = self.localUrlString {
            let fileURL = URL.init(fileURLWithPath: urlString)
            mainWebView.stopLoading()
            mainWebView.loadFileURL(fileURL, allowingReadAccessTo: fileURL)
            return
        }
        
//        2、加载两个H5页面；
//        一个福掌柜介绍：
//        http://fzgwx-test.fuiou.com/static/about.html
//        一个带参H5交易查询：
//        http://fzgwx-test.fuiou.com/t/appTxnDetail?appId=&token=
//        传appid
        //加载网页
        if hasToken{
            if let appId = CloudPushSDK.getDeviceId(){
                startUrlString.append("?appId=\(appId)")
            }
            if let tokenString = FZGTools.defaultsToken() as? String{
                startUrlString.append("&token=\(tokenString)")
            }
        }
        if let url = URL.init(string: startUrlString){
            let request = URLRequest.init(url: url)
            mainWebView.stopLoading()
            mainWebView.load(request)
        }
        
    }
    
    private func setSubviews() {
        self.view.addSubview(mainWebView)
        constrain(mainWebView) { (mainWebView) in
            mainWebView.edges == mainWebView.superview!.edges
        }
        mainWebView.addSubview(progressView)
        
        //        self.showLeftButtonWithImageName("back", imageWidth: 22)
//        if showNavBar {
//            //设置导航栏右侧按钮
//            rightButton.frame.size.width = 44
//            rightButton.addTarget(self, action: #selector(rightButtonMethod), for: .touchUpInside)
//            let svgImage = SVGKImage.init(named: "more_white")
//            svgImage?.size = CGSize(width: 30, height: 30)
//            rightButton.setImage(svgImage?.uiImage, for: .normal)
//
//            let barItem = UIBarButtonItem.init(customView: rightButton)
//            self.navigationItem.rightBarButtonItem = barItem
//        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if showNavBar{//若显示导航栏
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }else{
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
    
    //重写父类方法
//    override func rightButtonMethod() {
//            //清除缓存但不包括LocalStorage
//            self.clearCacheWithLocalStorage(false)
//            self.mainWebView.reload()
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    ///监听代理方法
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "estimatedProgress" {
            
            self.progressView.setProgress(Float(mainWebView.estimatedProgress), animated: true)
            if mainWebView.estimatedProgress >= 1.0 {
                UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseOut, animations: {
                    //                    self.progressView.transform = CGAffineTransform(scaleX: 1, y: 1.4)
                    self.progressView.alpha = 0.0
                }, completion: { (finish) in
                    self.progressView.isHidden = true
                    self.progressView.progress = 0
                })
                
                
            }
        }
    }
    
    //MARK:WKNavigationDelegate
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.progressView.isHidden = false
        self.progressView.alpha = 1
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.progressView.isHidden = true
        self.progressView.progress = 0
        if self.title == nil || self.title == ""{
            self.title = self.mainWebView.title
        }
    }
    
    //MARK:H5调用原生方法,WKScriptMessageHandler
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
//        if message.name == "tzios" {
//            let paramsString = message.body as! NSString
//            if paramsString.contains("nativeLogout"){
//                TZMTools.deleteValue(forKey: tokenKey)
//                AppDelegate.currentDelegate().pushToLaunchViewController()
//            }else if paramsString.contains("nativeClose"){
//                self.navigationController?.popViewController(animated: true)
//            }else{
//            }
//        }
    }
    
    
    /// 清除网页缓存
    ///
//    / - Parameter localStorage: 是否清除本地缓存
    private func clearCacheWithLocalStorage(_ localStorage: Bool) {
        var websiteDataTypes : Set<String>
        if localStorage {
            websiteDataTypes = WKWebsiteDataStore.allWebsiteDataTypes()
            DDLogInfo("清除全部网页缓存")
        }else{
            websiteDataTypes = [
                WKWebsiteDataTypeDiskCache,
                WKWebsiteDataTypeOfflineWebApplicationCache,
                WKWebsiteDataTypeMemoryCache,
                //            WKWebsiteDataTypeLocalStorage,
                WKWebsiteDataTypeCookies,
                WKWebsiteDataTypeSessionStorage,
                WKWebsiteDataTypeIndexedDBDatabases,
                WKWebsiteDataTypeWebSQLDatabases
            ]
            DDLogInfo("清除部分网页缓存")
        }
        let sinceDate = Date.init(timeIntervalSince1970: 0)
        WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes, modifiedSince: sinceDate) {
        }
    }
    
    deinit {
        //移除网络进度监听
        mainWebView.removeObserver(self, forKeyPath: "estimatedProgress")
        
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

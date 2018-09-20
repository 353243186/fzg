//
//  FZGMessageCenterViewController.swift
//  fzg
//
//  Created by JohnLee on 2018/9/7.
//  Copyright © 2018年 fuiou. All rights reserved.
//

import UIKit
import CoreData
import CocoaLumberjackSwift

class FZGMessageCenterViewController: UITableViewController {

    //coreData数据库上下文
    lazy var managedObjectContext : NSManagedObjectContext = {
        let context = AppDelegate.currentDelegate().managedObjectContext
        return context
    }()
    
    //数据
    var historys = Array<Any>()
    //拉刷新控制器
//    let refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
//        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        title = "消息推送"
        tableView.tableFooterView = FZGNoDataTableFooterView.footerView()
        self.showRightButtonWithImage(#imageLiteral(resourceName: "message_clear"), target: self, action: #selector(rightNavBarClick))
        
        //添加刷新
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(loadTransDetails),
                                 for: .valueChanged)
        refreshControl?.attributedTitle = NSAttributedString(string: "下拉刷新数据")
        
        let notificationName = Notification.Name("FZGDidReceiveNotification")

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(loadTransDetails),
                                               name: notificationName,
                                               object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadTransDetails()
    }
    
    @objc private func rightNavBarClick() {
        let cancelAction = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        let sureAction = UIAlertAction.init(title: "确定", style: .destructive) {(_) in
            self.clearHisrory()
        }
        self.showAlertWithActions([cancelAction, sureAction], title: "确定要删除当前所有消息吗？")
    }
    
    //清除
    private func clearHisrory() {
        let request = NSFetchRequest<NSFetchRequestResult>.init(entityName: "TransDetail")
        if let account = FZGTools.defaultsAccount(){
            let predicate = NSPredicate.init(format: "account = '\(account)'")
            request.predicate = predicate
        }
        let managedObjectContext = AppDelegate.currentDelegate().managedObjectContext
        do {
            let historys = try managedObjectContext.fetch(request)
            for history in historys {
                managedObjectContext.delete(history as! NSManagedObject)
            }
            tableView.reloadData()
            tableView.tableFooterView = FZGNoDataTableFooterView.footerView()
            
        } catch  {
            DDLogError("数据库错误：\(error.localizedDescription)")
        }
    }
    
    //读取
    @objc private func loadTransDetails() {
        let request = NSFetchRequest<NSFetchRequestResult>.init(entityName: "TransDetail")
        let sortDescriptor = NSSortDescriptor.init(key: "txTime", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        if let account = FZGTools.defaultsAccount(){
            // 只读取24小时内的消息
            let yesterday = Date.init(timeIntervalSinceNow: -24 * 60 * 60)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let dateString = dateFormatter.string(from: yesterday)
            
            let predicate = NSPredicate.init(format: "account = '\(account)' AND txTime > '\(dateString)'")
            request.predicate = predicate
        }
        
        do {
            historys = try managedObjectContext.fetch(request)
            
            if historys.count > 0 {
                tableView.tableFooterView = UIView()
                refreshControl?.endRefreshing()
                tableView.reloadData()
            }else{
                refreshControl?.endRefreshing()
                tableView.tableFooterView = FZGNoDataTableFooterView.footerView()
            }
        } catch  {
            refreshControl?.endRefreshing()
            tableView.tableFooterView = FZGNoDataTableFooterView.footerView()
            DDLogError("数据库错误：\(error.localizedDescription)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }
    


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return historys.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")
        if cell == nil{
            cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "UITableViewCell")
            cell?.accessoryType = .disclosureIndicator
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
            cell?.textLabel?.textColor = UIColor.black333
            cell?.detailTextLabel?.textColor = UIColor.black333
            cell?.separatorInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        }
//        tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        let transDetail = historys[indexPath.row] as! TransDetail
        let imageColor = getColorWithBusiCd(transDetail.busiCd)
        let image = FZGTools.imageWithColor(imageColor, size: CGSize.init(width: 10, height: 10))
        cell?.imageView?.image = image
        cell?.imageView?.layer.cornerRadius = 5
        cell?.imageView?.clipsToBounds = true
        let amtString = String.init(format: "%.2f", transDetail.amt)
        cell?.textLabel?.text = "\(transDetail.busiCdDesc ?? "")  ¥\(amtString)"
        cell?.detailTextLabel?.text = transDetail.txTime
        return cell!
    }
    
    private func getColorWithBusiCd(_ busiCd: String?) -> UIColor {
        if busiCd == "TX02" || busiCd == "TX09" || busiCd == "TX15"{
            return UIColor.withHex(hexInt: 0x009e3e)
        }else if busiCd == "TX03" || busiCd == "TX18"{
            return UIColor.withHex(hexInt: 0xe60012)
        }else{
            return UIColor.gray
        }
    }
    
    private func getBusiNameWithBusiCd(_ busiCd: String?) -> String {
        if busiCd == "TX02"{
            return "银行卡收款"
        }else if busiCd == "TX03"{
            return "银行卡退款"
        }else if busiCd == "TX09"{
            return "微信收款"
        }else if busiCd == "TX15"{
            return "支付宝收款"
        }else if busiCd == "TX18"{
            return "扫码退款"
        }else{
            return "富掌柜交易"
        }
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let transDetail = historys[indexPath.row] as! TransDetail
        let controller = FZGMessageDetailViewController.init(transDetail)
        self.navigationController?.pushViewController(controller, animated: true)
    }

}

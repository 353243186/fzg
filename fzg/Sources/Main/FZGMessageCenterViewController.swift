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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
//        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        title = "消息"
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadTransDetails()
    }
    
    //清除
//    func clearHisrory() {
//        for history in historys {
//            managedObjectContext.delete(history as! NSManagedObject)
//        }
//        historys.removeAll()
//        self.mainTableView.reloadData()
//        self.mainTableView.tableFooterView = tableFooterView
//    }
    
    //读取
    private func loadTransDetails() {
        let request = NSFetchRequest<NSFetchRequestResult>.init(entityName: "TransDetail")
        let sortDescriptor = NSSortDescriptor.init(key: "txTime", ascending: false)
        request.sortDescriptors = [sortDescriptor]
//        let predicate = NSPredicate.init(format: "txnSsn = '\(id)'", "")
//        fetchRequest.predicate = predicate;
        do {
            historys = try managedObjectContext.fetch(request)
            
            if historys.count > 0 {
                tableView.reloadData()
            }else{
//                self.mainTableView.tableFooterView = tableFooterView
            }
        } catch  {
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
        cell?.imageView?.image = #imageLiteral(resourceName: "message")
//        TX09->微信收款    TX15->支付宝收款   TX02->银行卡收款    TX18->扫码退款    TX03->银行卡退款
//        其余的都叫富掌柜交易成功
        
        cell?.textLabel?.text = "\(getBusiNameWithBusiCd(transDetail.busiCd))\(transDetail.amt)元"
        cell?.detailTextLabel?.text = transDetail.txTime
        return cell!
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

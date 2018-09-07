//
//  FZGMessageCenterViewController.swift
//  fzg
//
//  Created by JohnLee on 2018/9/7.
//  Copyright © 2018年 fuiou. All rights reserved.
//

import UIKit

class FZGMessageCenterViewController: UITableViewController {

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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")
        if cell == nil{
            cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "UITableViewCell")
            cell?.accessoryType = .disclosureIndicator
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
            cell?.textLabel?.textColor = UIColor.black333
            cell?.detailTextLabel?.textColor = UIColor.black333
        }
//        tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell?.imageView?.image = #imageLiteral(resourceName: "message")
        cell?.textLabel?.text = "微信收款0.01元"
        cell?.detailTextLabel?.text = "2018-12-12"
        return cell!
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.pushViewController(FZGMessageDetailViewController(), animated: true)
    }

}

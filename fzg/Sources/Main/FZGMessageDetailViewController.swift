//
//  FZGMessageDetailViewController.swift
//  fzg
//
//  Created by JohnLee on 2018/9/7.
//  Copyright © 2018年 fuiou. All rights reserved.
//

import UIKit

class FZGMessageDetailViewController: UITableViewController {

    private var transDetail : TransDetail
    
    init(_ transDetail: TransDetail) {
        self.transDetail = transDetail
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        title = "交易详情"
        tableView.tableFooterView = UIView()
        self.tableView.register(UINib.init(nibName: "FZGMessageTitleTableViewCell", bundle: nil), forCellReuseIdentifier: "FZGMessageTitleTableViewCell")
        self.tableView.register(UINib.init(nibName: "FZGMessageTableViewCell", bundle: nil), forCellReuseIdentifier: "FZGMessageTableViewCell")
        self.tableView.register(UINib.init(nibName: "FZGMessageFooterTableViewCell", bundle: nil), forCellReuseIdentifier: "FZGMessageFooterTableViewCell")
//        register(FZGMessageTitleTableViewCell.self, forCellReuseIdentifier: "FZGMessageTitleTableViewCell")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source



    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FZGMessageTitleTableViewCell", for: indexPath) as! FZGMessageTitleTableViewCell
            cell.amountLabel.text = "¥\(transDetail.amt)"
            cell.separatorInset = UIEdgeInsets.init(top: 0, left: UIScreen.main.bounds.width, bottom: 0, right: 0)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FZGMessageTableViewCell", for: indexPath) as! FZGMessageTableViewCell
            cell.titleLabel.text = "商户名称"
            cell.valueLabel.text = transDetail.mchntName
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FZGMessageTableViewCell", for: indexPath) as! FZGMessageTableViewCell
            cell.titleLabel.text = "商户名称2"
            cell.valueLabel.text = transDetail.mchntName
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FZGMessageTableViewCell", for: indexPath) as! FZGMessageTableViewCell
            cell.titleLabel.text = "终端号"
            cell.valueLabel.text = transDetail.termId
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FZGMessageTableViewCell", for: indexPath) as! FZGMessageTableViewCell
            cell.titleLabel.text = "交易时间"
            cell.valueLabel.text = transDetail.txTime
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FZGMessageTableViewCell", for: indexPath) as! FZGMessageTableViewCell
            cell.titleLabel.text = "交易类型"
            cell.valueLabel.text = transDetail.busiCd
            return cell
        case 6:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FZGMessageTableViewCell", for: indexPath) as! FZGMessageTableViewCell
            cell.titleLabel.text = "交易卡号"
            cell.valueLabel.text = transDetail.cardNo
            return cell
        case 7:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FZGMessageTableViewCell", for: indexPath) as! FZGMessageTableViewCell
            cell.titleLabel.text = "交易参考号"
            cell.valueLabel.text = transDetail.traceNo
            return cell
        case 8:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FZGMessageTableViewCell", for: indexPath) as! FZGMessageTableViewCell
            cell.titleLabel.text = "交易单号"
            cell.valueLabel.text = transDetail.orderNo
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FZGMessageFooterTableViewCell", for: indexPath) as! FZGMessageFooterTableViewCell
            cell.separatorInset = UIEdgeInsets.init(top: 0, left: UIScreen.main.bounds.width, bottom: 0, right: 0)
            cell.sureButton.addTarget(self, action: #selector(sureButtonClick), for: .touchUpInside)
            return cell
        }
    }
 
    @objc private func sureButtonClick() {
        self.navigationController?.popViewController(animated: true)
        self.navigationController?.dismiss(animated: true, completion: nil)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  FZGMainViewController.swift
//  fzg
//
//  Created by JohnLee on 2018/9/6.
//  Copyright © 2018年 fuiou. All rights reserved.
//

import UIKit
import CoreData

class FZGMainViewController: UIViewController {

    @IBOutlet weak var accountLabel: UILabel!
    @IBAction func checkTransactionRecords(_ sender: Any) {
        
    }
    @IBAction func aboutFuiou(_ sender: Any) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "富掌柜"
        self.showLeftButtonWithImage(#imageLiteral(resourceName: "email"), target: self, action: #selector(pushToMessageCenter))
        self.showRightButtonWithImage(#imageLiteral(resourceName: "refresh"), isOriginalImage: true, target: self, action: #selector(refresh))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func pushToMessageCenter() {
        self.navigationController?.pushViewController(FZGMessageCenterViewController(), animated: true) 
    }
    
    @objc private func refresh() {
        
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

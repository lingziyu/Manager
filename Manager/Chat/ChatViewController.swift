//
//  ChatViewController.swift
//  Manager
//
//  Created by 冰洁  杨 on 2018/3/18.
//  Copyright © 2018年 冰洁  杨. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let cvc = segue.destination as? ChatDetailViewController{
            cvc.hidesBottomBarWhenPushed = true
            cvc.tabBarController?.tabBar.isHidden = true;
        }
        
    }
    

}

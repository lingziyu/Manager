//
//  SettingViewController.swift
//  Manager
//
//  Created by 冰洁  杨 on 2018/3/25.
//  Copyright © 2018年 冰洁  杨. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    
    override func viewWillAppear(_ animated: Bool) {
        if let bar = self.tabBarController {
            bar.tabBar.isHidden = true
        }
        self.navigationController?.isNavigationBarHidden=false;
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       
        

        // Do any additional setup after loading the view.
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

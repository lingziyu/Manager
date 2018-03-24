//
//  DataClassifyViewController.swift
//  Manager
//
//  Created by 冰洁  杨 on 2018/3/8.
//  Copyright © 2018年 冰洁  杨. All rights reserved.
//

import UIKit

class DataTypeChooseViewController: UIViewController {


    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden=true;
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Choose Data Type"{
            if let dataType = (sender as? UIButton)?.currentTitle{
                if let cvc = segue.destination as? DataViewController{
                    cvc.chartTitle = dataType
                }
            }
            
        }
    }
    

}

//
//  LoginViewController.swift
//  Manager
//
//  Created by 冰洁  杨 on 2018/3/24.
//  Copyright © 2018年 冰洁  杨. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var name: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(LoginViewController.handleTap)))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor.white.cgColor
        border.frame = CGRect(x: 0, y: name.frame.size.height - width/2, width:  name.frame.size.width, height: name.frame.size.height)
        border.borderWidth = width
        name.layer.addSublayer(border)
        name.layer.masksToBounds = true
        
        let border2 = CALayer()
        let width2 = CGFloat(2.0)
        border2.borderColor = UIColor.white.cgColor
        border2.frame = CGRect(x: 0, y: password.frame.size.height - width2/2, width:  password.frame.size.width, height: password.frame.size.height)
        border2.borderWidth = width2
        password.layer.addSublayer(border2)
        password.layer.masksToBounds = true
        
        password.returnKeyType = UIReturnKeyType.go
        
        name.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
        
        
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @objc func handleTap(sender: UITapGestureRecognizer){
        if sender.state == .ended {
            name.resignFirstResponder()
            password.resignFirstResponder()
        }
        sender.cancelsTouchesInView = false
        
    }

    
}

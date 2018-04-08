//
//  LoginViewController.swift
//  Manager
//
//  Created by 冰洁  杨 on 2018/3/24.
//  Copyright © 2018年 冰洁  杨. All rights reserved.
//

import UIKit
import Alamofire


class LoginViewController: UIViewController {
  
    
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var name: UITextField!
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        
        
        
        
        if let bar = self.tabBarController {
            bar.tabBar.isHidden = true
        }
        self.navigationController?.isNavigationBarHidden=true;

        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(LoginViewController.handleTap)))
        
        if let name = UserDefaults.standard.string(forKey: "name"), let password = UserDefaults.standard.string(forKey: "password"){
            self.name.text = name;
            self.password.text = password
            
            
            let sb = UIStoryboard(name: "Main", bundle:nil)
            let vc = sb.instantiateViewController(withIdentifier: "TabBar") as! UITabBarController
            self.present(vc, animated: true, completion: nil)
            
            
        }

    

        
        
    }
    
    
    @IBAction func signup(_ sender: UIButton) {
        let parameters : [String: Any] = [
            "userId":name.text ?? "",
            "password":password.text ?? "",
            ]
        
        
        Alamofire.request("http://120.79.245.126:8010/register", method: .post, parameters: parameters,encoding: JSONEncoding.default)
            .responseJSON { response in
                switch response.result {
                case .success:
                    debugPrint(response)
                    if let json = response.result.value {
                        let dict = json as? Dictionary<String,AnyObject>
                        
                        let alertController = UIAlertController(title: "注册成功!",
                                                                message: nil, preferredStyle: .alert)
                        
//                        print(dict)
                        
                        if(dict!["code"]as? Int==0){
//                            let auth = dict!["auth"] as! String
                            
                            UserDefaults.standard.setValue(self.name.text, forKey: "name")
                            UserDefaults.standard.setValue(self.password.text, forKey: "password")
//                            UserDefaults.standard.setValue(auth, forKey: "auth")
                            
                           
                            
                            //显示提示框
                            self.present(alertController, animated: true, completion: nil)
                            //两秒钟后自动消失
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                                self.presentedViewController?.dismiss(animated: false, completion: nil)
                                
                                let sb = UIStoryboard(name: "Main", bundle:nil)
                                let vc = sb.instantiateViewController(withIdentifier: "TabBar") as! UITabBarController
                                self.present(vc, animated: true, completion: nil)
                            }
                            
                        }else{
                            
                            
                        }
                    }
                    
                case .failure(let error):
                    print(error)
                    let alertController = UIAlertController(title: "注册失败!",
                                                            message: nil, preferredStyle: .alert)
                    //显示提示框
                    self.present(alertController, animated: true, completion: nil)
                    //两秒钟后自动消失
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                        self.presentedViewController?.dismiss(animated: false, completion: nil)
                    }
                }
        }
        
    }
    
    

    @IBAction func login(_ sender: Any) {
        
        
        let parameters : [String: Any] = [
            "userId":name.text ?? "",
            "password":password.text ?? "",
        ]
        

        Alamofire.request("http://120.79.245.126:8010/login", method: .post, parameters: parameters,encoding: JSONEncoding.default)
            .responseJSON { response in
                switch response.result {
                case .success:
                    debugPrint(response)
                    if let json = response.result.value {
                        let dict = json as? Dictionary<String,AnyObject>
                        
                        if(dict!["code"]as? Int==0){
                            let auth = dict!["auth"] as! String
                           
                            UserDefaults.standard.setValue(self.name.text, forKey: "name")
                            UserDefaults.standard.setValue(self.password.text, forKey: "password")
                            UserDefaults.standard.setValue(auth, forKey: "auth")
                            
                            
                            let sb = UIStoryboard(name: "Main", bundle:nil)
                            let vc = sb.instantiateViewController(withIdentifier: "TabBar") as! UITabBarController
                            self.present(vc, animated: true, completion: nil)
                            
                        }else{
                            
                            
                        }
                    }
                    
                case .failure(let error):
                    print(error)
                }
        }
        
        
        
        
        
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

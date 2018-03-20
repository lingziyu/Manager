//
//  ChatDetailViewController.swift
//  Manager
//
//  Created by 冰洁  杨 on 2018/3/18.
//  Copyright © 2018年 冰洁  杨. All rights reserved.
//

import UIKit
import Alamofire

class ChatDetailViewController: UIViewController , ChatDataSource,UITextFieldDelegate {

    override func viewWillAppear(_ animated: Bool) {
        if let bar = self.tabBarController {
            bar.tabBar.isHidden = true
        }
       
    }
    
    
    var Chats:NSMutableArray!
    var tableView:TableView!
    var me:UserInfo!
    var you:UserInfo!
    var txtMsg:UITextField!
    var sendView:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        setupChatTable()
        setupSendPanel()
        
        //监听键盘弹出通知
        NotificationCenter.default
            .addObserver(self,selector: #selector(keyboardWillShow(_:)),
                         name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        //监听键盘隐藏通知
        NotificationCenter.default
            .addObserver(self,selector: #selector(keyboardWillHide(_:)),
                         name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        //单击监听
        let tapSingle=UITapGestureRecognizer(target:self,action:#selector(ChatDetailViewController.tapSingleDid))

        self.view.addGestureRecognizer(tapSingle)
        
        
        
        
        Alamofire.request("http://120.79.245.126:8010/getChat")
            .responseJSON { response in
                switch response.result {
                case .success:
                    
                    if let json = response.result.value {
                        
                        let dict = json as! Dictionary<String,AnyObject>
                        let code = dict["code"] as! Int
                        switch (code){
                        case 0:
                            let ruffDatas = dict["chatRecords"] as! Array<Dictionary<String,AnyObject>>
                            for ruffData in ruffDatas {
                                let body = ruffData["content"] as! String
                                let user = ruffData["type"] as! Int == 0 ?  self.me: self.you
//                                let dateFormatter = DateFormatter()
//                                // dateFormat需要和输入的字符串相匹配，否则返回nil
//                                dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"

                                let date = Date()
                                let mtype = (ruffData["type"] as! Int == 0 ) ? ChatType.mine : ChatType.someone
                                let chat =  MessageItem(body: body as NSString, user: user!, date:date, mtype: mtype)

                                self.Chats.add(chat)
                            }
                            self.tableView.chatDataSource = self
                            self.tableView.reloadData()

                            
                        case 200:
                            print("无权限访问")
                            
                        case 400:
                            print("服务端错误")
                            
                            
                        default:
                            print("Error Code")
                        }
                        
                    }
                    
                case .failure(let error):
                    print(error)
                }
        }

        
    }
    
     @objc func tapSingleDid(){
        txtMsg?.resignFirstResponder()
        
    }
    
    
    func setupSendPanel()
    {
        let screenWidth = UIScreen.main.bounds.width
        sendView = UIView(frame:CGRect(x: 0,y: self.view.frame.size.height - 56,width: screenWidth,height: 56))
        sendView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        sendView.backgroundColor=UIColor.gray
        
        txtMsg = UITextField(frame:CGRect(x: 7,y: 10,width: screenWidth - 95,height: 36))
        txtMsg.backgroundColor = UIColor.white
        txtMsg.textColor=UIColor.black
        txtMsg.font=UIFont.boldSystemFont(ofSize: 12)
        txtMsg.layer.borderColor = UIColor.white.cgColor
        txtMsg.returnKeyType = UIReturnKeyType.send
        txtMsg.layer.cornerRadius = 6.0
        
        
        //Set the delegate so you can respond to user input
        txtMsg.delegate=self
        sendView.addSubview(txtMsg)
        
        let sendButton = UIButton(frame:CGRect(x: screenWidth - 80,y: 10,width: 72,height: 36))
        sendButton.backgroundColor=UIColor(red: 0x86/255, green: 0xbe/255, blue: 0xbb/255, alpha: 1)
        sendButton.addTarget(self, action:#selector(ChatDetailViewController.sendMessage) ,
                             for:UIControlEvents.touchUpInside)
        sendButton.layer.cornerRadius=6.0
        sendButton.setTitle("发送", for:UIControlState())
        sendView.addSubview(sendButton)
        self.view.addSubview(sendView)
        
        
        self.tableView.toDown()
        


    }
    
    func textFieldShouldReturn(_ textField:UITextField) -> Bool
    {
        sendMessage()
        return true
    }
    
    @objc func sendMessage()
    {
        //composing=false
        let sender = txtMsg
        let mytext = sender!.text! as String
        let thisChat =  MessageItem(body:mytext as NSString, user:me, date:Date(),mtype:ChatType.mine)
        Chats.add(thisChat)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        
        let parameters = [
            "content": sender!.text!,
            "type": 0,
            "date" :formatter.string(from: Date())
            ] as [String : Any]
        
        Alamofire.request("http://120.79.245.126:8010/saveChat", method: .post, parameters: parameters,encoding: JSONEncoding.default)
        
        sender?.text = ""
        

        
        let inputText = Dictionary<String,String>(dictionaryLiteral: ("text",mytext))
        let perception = Dictionary<String,Any>(dictionaryLiteral: ("inputText",inputText))
        
        let userInfo = Dictionary<String,String>(dictionaryLiteral: ("apiKey","618dab2198c6445687244c75f0e96b78"),("userId", "174483"))
        let para = Dictionary<String,Any>(dictionaryLiteral: ("perception",perception),("userInfo",userInfo),("reqType", 0))
        
//        print(para)
        Alamofire.request("http://openapi.tuling123.com/openapi/api/v2", method: .post, parameters: para,encoding: JSONEncoding.default)
            .responseJSON { response in
                switch response.result {
                case .success:
                    
                    if let json = response.result.value {
                        let dict = json as! Dictionary<String,AnyObject>
//                        print(dict["results"])
                        let results = dict["results"] as! Array<Dictionary<String,AnyObject>>
                        for result   in results  {
                                if result["resultType"] as! String == "text"{
                                    let values = result["values"]as? Dictionary<String,String>
                                    
                                    let body = values!["text"]
                                    let user = self.you
                                    
//
                                    let date = Date()
                                    
                                    let mtype = ChatType.someone
                                    
                                    let chat =  MessageItem(body: body! as NSString, user: user!, date:date, mtype: mtype)
                                    self.Chats.add(chat)
                                    self.tableView.reloadData()

                                    let parameters = [
                                        "content": body! as String,
                                        "type": 1,
                                        "date" :formatter.string(from: date)
                                        ] as [String : Any]
                                    
                                    Alamofire.request("http://120.79.245.126:8010/saveChat", method: .post, parameters: parameters,encoding: JSONEncoding.default)


                                }
                            }

                    }
                    
                case .failure(let error):
                    print(error)
                }
        }
        
        
        
        
        
        
        
//        let thatChat =  MessageItem(body:"你说的是：\(sender!.text!)" as NSString, user:you, date:Date(), mtype:ChatType.someone)
       
        
        
        self.tableView.chatDataSource = self
        self.tableView.reloadData()
        
        //self.showTableView()
//        sender?.resignFirstResponder()
      
    }
    
    func setupChatTable()
    {
        self.tableView = TableView(frame:CGRect(x: 0, y: 20, width: self.view.frame.size.width,
                                                height: self.view.frame.size.height - 76), style: .plain)
        
        tableView.autoresizesSubviews = true
        //创建一个重用的单元格
        self.tableView!.register(TableViewCell.self, forCellReuseIdentifier: "ChatCell")
        me = UserInfo(name:"head" ,logo:("head.png"))
        you  = UserInfo(name:"plant", logo:("plant.png"))
        
        
        Chats = NSMutableArray()
        
        //set the chatDataSource
        self.tableView.chatDataSource = self
        
        //call the reloadData, this is actually calling your override method
        self.tableView.reloadData()
        
        self.view.addSubview(self.tableView)
    }
    
    func rowsForChatTable(_ tableView:TableView) -> Int
    {
        return self.Chats.count
    }
    
    func chatTableView(_ tableView:TableView, dataForRow row:Int) -> MessageItem
    {
        return Chats[row] as! MessageItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // 键盘显示
    @objc  func keyboardWillShow(_ notification: Notification) {

        let userInfo = (notification as NSNotification).userInfo!
        //键盘尺寸
        let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey]
            as! NSValue).cgRectValue
        var contentInsets:UIEdgeInsets
        //判断是横屏还是竖屏
        let statusBarOrientation = UIApplication.shared.statusBarOrientation
        if UIInterfaceOrientationIsPortrait(statusBarOrientation) {
            contentInsets = UIEdgeInsetsMake(2, 0.0, (keyboardSize.height), 0.0);
        } else {
            contentInsets = UIEdgeInsetsMake(64.0, 0.0, (keyboardSize.width), 0.0);
        }
        //tableview的contentview的底部大小
        self.tableView!.contentInset = contentInsets;
        self.tableView!.scrollIndicatorInsets = contentInsets;
        self.sendView.frame = CGRect(x: 0, y: self.view.frame.size.height - 313, width: UIScreen.main.bounds.width , height: 56)
        
        self.tableView.frame = CGRect(x: 0, y: 20, width: self.view.frame.size.width,
                                                height: self.view.frame.size.height - 120)

        self.tableView.toDown()
        

      
    }
    
    // 键盘隐藏
    @objc func keyboardWillHide(_ notification: Notification) {
        //还原tableview的contentview大小
        
        let contentInsets:UIEdgeInsets = UIEdgeInsetsMake(64.0, 0.0, 0, 0.0);
        self.tableView!.contentInset = contentInsets
        self.tableView!.scrollIndicatorInsets = contentInsets
        
        
        sendView.frame = CGRect(x: 0,y: self.view.frame.size.height - 56,width: self.view.frame.size.height,height: 56)
        self.tableView.frame = CGRect(x: 0, y: 20, width: self.view.frame.size.width,
                                      height: self.view.frame.size.height - 76)

       
        self.tableView.toDown()

        
    }

    
    
 
}

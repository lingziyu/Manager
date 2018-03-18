//
//  ChatDetailViewController.swift
//  Manager
//
//  Created by 冰洁  杨 on 2018/3/18.
//  Copyright © 2018年 冰洁  杨. All rights reserved.
//

import UIKit

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
        
        func swipedView(){
            let tapAlert = UIAlertController(title: "Swiped", message: "You just swiped the swipe view", preferredStyle: UIAlertControllerStyle.alert)
            tapAlert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
            self.present(tapAlert, animated: true, completion: nil)
        }
//
//        let swipeDownGesture = UISwipeGestureRecognizer(target: self.tableView, action: Selector(("handleDownGesture:")))
//        swipeDownGesture.direction = UISwipeGestureRecognizerDirection.down
//        self.view.addGestureRecognizer(swipeDownGesture)
        
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
        let thisChat =  MessageItem(body:sender!.text! as NSString, user:me, date:Date(), mtype:ChatType.mine)
        let thatChat =  MessageItem(body:"你说的是：\(sender!.text!)" as NSString, user:you, date:Date(), mtype:ChatType.someone)
        
        Chats.add(thisChat)
        Chats.add(thatChat)
        
        self.tableView.chatDataSource = self
        self.tableView.reloadData()
        
        //self.showTableView()
//        sender?.resignFirstResponder()
        sender?.text = ""
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
        
        let zero =  MessageItem(body:"最近去哪玩了？", user:you,  date:Date(timeIntervalSinceNow:-90096400), mtype:.someone)
        
        let zero1 =  MessageItem(body:"去了趟苏州，明天发照片给你哈？", user:me,  date:Date(timeIntervalSinceNow:-90086400), mtype:.mine)
        
        let first =  MessageItem(body:"你看这风景怎么样，我周末去苏州拍的！", user:me,  date:Date(timeIntervalSinceNow:-90000600), mtype:.mine)
        
//        let second =  MessageItem(image:UIImage(named:"sz.png")!,user:me, date:Date(timeIntervalSinceNow:-90000290), mtype:.mine)
        
        let third =  MessageItem(body:"太赞了，我也想去那看看呢！",user:you, date:Date(timeIntervalSinceNow:-90000060), mtype:.someone)
        
        let fouth =  MessageItem(body:"嗯，下次我们一起去吧！",user:me, date:Date(timeIntervalSinceNow:-90000020), mtype:.mine)
        
        let fifth =  MessageItem(body:"三年了，我终究没能看到这个风景",user:you, date:Date(timeIntervalSinceNow:0), mtype:.someone)
        
        
        Chats = NSMutableArray()
        Chats.addObjects(from: [first, third, fouth, fifth, zero, zero1])
        
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
//
//  func handleSwipeGesture(sender: UISwipeGestureRecognizer){
//    txtMsg.resignFirstResponder()
//
//    }
    
 
}

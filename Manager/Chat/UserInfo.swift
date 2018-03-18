//
//  UserInfo.swift
//  Manager
//
//  Created by 冰洁  杨 on 2018/3/18.
//  Copyright © 2018年 冰洁  杨. All rights reserved.
//

import Foundation
/*
 用户信息类
 */
class UserInfo:NSObject
{
    var username:String = ""
    var avatar:String = ""
    
    init(name:String, logo:String)
    {
        self.username = name
        self.avatar = logo
    }
}

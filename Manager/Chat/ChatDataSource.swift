//
//  ChatDataSource.swift
//  Manager
//
//  Created by 冰洁  杨 on 2018/3/18.
//  Copyright © 2018年 冰洁  杨. All rights reserved.
//

import Foundation
/*
 数据提供协议
 */
protocol ChatDataSource
{
    /*返回对话记录中的全部行数*/
    func rowsForChatTable( _ tableView: TableView) -> Int
    /*返回某一行的内容*/
    func chatTableView(_ tableView: TableView, dataForRow:Int)-> MessageItem
}

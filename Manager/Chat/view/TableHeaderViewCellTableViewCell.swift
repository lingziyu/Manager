//
//  TableHeaderViewCellTableViewCell.swift
//  Manager
//
//  Created by 冰洁  杨 on 2018/3/18.
//  Copyright © 2018年 冰洁  杨. All rights reserved.
//

import UIKit

class TableHeaderViewCell:UITableViewCell
{
    var height:CGFloat = 30.0
    var label:UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(reuseIdentifier cellId:String)
    {
        super.init(style: UITableViewCellStyle.default, reuseIdentifier:cellId)
        self.backgroundColor = UIColor(red: 0xff, green: 0xff, blue: 0xff, alpha: 0)
    }
    
    class func getHeight() -> CGFloat
    {
        return 30.0
    }
    
    func setDate(_ value:Date)
    {
        self.height  = 30.0
        let dateFormatter =  DateFormatter()
        dateFormatter.dateFormat = "yyyy年MM月dd日"
        let text =  dateFormatter.string(from: value)
        
        if (self.label != nil)
        {
            self.label.text = text
            return
        }
        self.selectionStyle = UITableViewCellSelectionStyle.none
        self.label = UILabel(frame:CGRect(x: CGFloat(self.height), y: CGFloat(0), width: self.frame.size.width, height: height))
        
        self.label.text = text
        self.label.font = UIFont.boldSystemFont(ofSize: 12)
        
        self.label.textAlignment = NSTextAlignment.center
//        self.label.shadowOffset = CGSize(width: 0, height: 1)
//        self.label.shadowColor = UIColor.white
        
        self.label.textColor = UIColor.white
        self.label.alpha = 0.6
        
        self.label.backgroundColor = UIColor.clear
        
        self.addSubview(self.label)
    }
}

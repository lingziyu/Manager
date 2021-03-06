//
//  File.swift
//  Manager
//
//  Created by 冰洁  杨 on 2018/3/8.
//  Copyright © 2018年 冰洁  杨. All rights reserved.
//

import Foundation
import Charts

class YAisValueFormatter: NSObject, IAxisValueFormatter {
    var dataType:String?

    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        guard let numberFormatter = numberFormatter
            else {
                return ""
        }
        
        if dataType == "温度"{
            return numberFormatter.string(for: value)! + "℃"
        }
        else if dataType == "湿度"{
            return numberFormatter.string(for: value)! + "%"
        }
        else if dataType == "光照"{
            return numberFormatter.string(for: value)! + "Lx"
        }
        return ""
    }
    
    fileprivate var numberFormatter: NumberFormatter?
    
    convenience init(type:String, numberFormatter: NumberFormatter) {
        self.init()
        self.numberFormatter = numberFormatter
        self.dataType = type

    }
    
    
}



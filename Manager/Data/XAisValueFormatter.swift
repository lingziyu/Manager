//
//  File.swift
//  Manager
//
//  Created by 冰洁  杨 on 2018/3/8.
//  Copyright © 2018年 冰洁  杨. All rights reserved.
//

import Foundation
import Charts

class XAisValueFormatter: NSObject, IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        guard let numberFormatter = numberFormatter
            else {
                return ""
        }
        
        return numberFormatter.string(for: value)! + ":00"
    }
    
    fileprivate var numberFormatter: NumberFormatter?
    
    convenience init(numberFormatter: NumberFormatter) {
        self.init()
        self.numberFormatter = numberFormatter
    }
    
   
}


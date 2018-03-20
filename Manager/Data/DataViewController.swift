//
//  ViewController.swift
//  Manager
//
//  Created by 冰洁  杨 on 2018/3/6.
//  Copyright © 2018年 冰洁  杨. All rights reserved.
//

import UIKit
import Charts
import Alamofire


class DataViewController: UIViewController {
    var numbers : [Double] = []
    var time: [Double] = []
    var chartTitle: String?
 
    @IBOutlet weak var lineChartTitle: UILabel!{
        didSet{
            if chartTitle != nil {
                lineChartTitle.text = chartTitle
            }
        }
    }
    
    @IBOutlet weak var chtChart: LineChartView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numbers.append(37)
        time.append(9)
        numbers.append(38)
        time.append(10)
        numbers.append(32)
         time.append(11)
        numbers.append(26)
         time.append(12)
        numbers.append(30)
         time.append(13)
        numbers.append(28)
         time.append(14)
        numbers.append(22)
         time.append(15)
        numbers.append(23)
        time.append(16)

        updateGraph()
        
        
        
    }
    
    
    func updateGraph(){
        var lineChartEntry  = [ChartDataEntry]() //this is the Array that will eventually be displayed on the graph.
        
        
        //here is the for loop
        for i in 0..<numbers.count {
            
            let value = ChartDataEntry(x: time[i], y: numbers[i]) // here we set the X and Y status in a data chart entry
            lineChartEntry.append(value) // here we add it to the data set
        }
        
        chtChart.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
        chtChart.chartDescription?.enabled = false
        chtChart.rightAxis.enabled = false
        chtChart.xAxis.drawGridLinesEnabled  = false
        chtChart.xAxis.labelPosition = XAxis.LabelPosition.bottom
        chtChart.legend.enabled = false
        
        

        if chartTitle != nil{
            let xtimeFormatter = NumberFormatter()
            xtimeFormatter.numberStyle = .decimal
            xtimeFormatter.locale = Locale.current
            let xTimeFormatter = XAisValueFormatter(numberFormatter: xtimeFormatter)
            chtChart.xAxis.valueFormatter = xTimeFormatter
            
            let ytimeFormatter = NumberFormatter()
            ytimeFormatter.numberStyle = .decimal
            ytimeFormatter.locale = Locale.current
            let yTimeFormatter = YAisValueFormatter(type:chartTitle!, numberFormatter: xtimeFormatter)
            chtChart.leftAxis.valueFormatter = yTimeFormatter
            
            
            let line1 = LineChartDataSet(values: lineChartEntry, label: chartTitle) //Here we convert lineChartEntry to a LineChartDataSet
            line1.setCircleColor(UIColor(red: 0x86/255, green: 0xbe/255, blue: 0xbb/255, alpha: 1))
            line1.circleHoleColor = UIColor.black
            line1.colors = [UIColor(red: 0x86/255, green: 0xbe/255, blue: 0xbb/255, alpha: 1)] //Sets the colour
            line1.drawCircleHoleEnabled = false
            line1.cubicIntensity = 0.4
            line1.drawFilledEnabled = true
            line1.mode = .horizontalBezier
            line1.fillColor = UIColor(red: 0x86/255, green: 0xbe/255, blue: 0xbb/255, alpha: 0.8)
            
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            numberFormatter.locale = Locale.current
            let valuesNumberFormatter = ChartValueFormatter(type:chartTitle!, numberFormatter: numberFormatter)
            line1.valueFormatter = valuesNumberFormatter
            
            
            let data = LineChartData() //This is the object that will be added to the chart
            data.setDrawValues(true)
            
            data.addDataSet(line1) //Adds the line to the dataSet
      
            
        
            chtChart.data = data //finally - it adds the chart data to the chart and causes an update
//        chtChart.chartDescription?.text = "My awesome chart" // Here we set the description for the graph
              }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


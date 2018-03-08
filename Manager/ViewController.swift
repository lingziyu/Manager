//
//  ViewController.swift
//  Manager
//
//  Created by 冰洁  杨 on 2018/3/6.
//  Copyright © 2018年 冰洁  杨. All rights reserved.
//

import UIKit
import Charts

class ViewController: UIViewController {
    var numbers : [Double] = []
    var time: [Double] = []
    var chartTitle: String? = "温度"
 

    @IBOutlet weak var chtChart: LineChartView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numbers.append(37)
        numbers.append(38)
        numbers.append(32)
        numbers.append(30)
        numbers.append(25)
        numbers.append(20)
        numbers.append(22)
        numbers.append(23)
       
        updateGraph()
        
    }
    func updateGraph(){
        var lineChartEntry  = [ChartDataEntry]() //this is the Array that will eventually be displayed on the graph.
        
        
        //here is the for loop
        for i in 0..<numbers.count {
            
            let value = ChartDataEntry(x: Double(i), y: numbers[i]) // here we set the X and Y status in a data chart entry
            lineChartEntry.append(value) // here we add it to the data set
        }
        if chartTitle != nil{
            let line1 = LineChartDataSet(values: lineChartEntry, label: chartTitle) //Here we convert lineChartEntry to a LineChartDataSet
            line1.setCircleColor(UIColor(red: 0x86/255, green: 0xbe/255, blue: 0xbb/255, alpha: 1))
            line1.circleHoleColor = UIColor.black
            line1.colors = [UIColor(red: 0x86/255, green: 0xbe/255, blue: 0xbb/255, alpha: 1)] //Sets the colour
            line1.drawCircleHoleEnabled = false

            chtChart.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
            chtChart.chartDescription?.enabled = false
            chtChart.rightAxis.enabled = false
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


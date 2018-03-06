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
    @IBAction func btnbutton(_ sender: Any) {
        let input  = Double(txtTextBox.text!) //gets input from the textbox - expects input as double/int
        numbers.append(input!) //here we add the data to the array.
        updateGraph()
    }
    @IBOutlet weak var txtTextBox: UITextField!
 

    @IBOutlet weak var chtChart: LineChartView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    func updateGraph(){
        var lineChartEntry  = [ChartDataEntry]() //this is the Array that will eventually be displayed on the graph.
        
        
        //here is the for loop
        for i in 0..<numbers.count {
            
            let value = ChartDataEntry(x: Double(i), y: numbers[i]) // here we set the X and Y status in a data chart entry
            lineChartEntry.append(value) // here we add it to the data set
        }
        
        let line1 = LineChartDataSet(values: lineChartEntry, label: "Number") //Here we convert lineChartEntry to a LineChartDataSet
        line1.colors = [NSUIColor.blue] //Sets the colour to blue
        
        let data = LineChartData() //This is the object that will be added to the chart
        data.addDataSet(line1) //Adds the line to the dataSet
        
        
        chtChart.data = data //finally - it adds the chart data to the chart and causes an update
        chtChart.chartDescription?.text = "My awesome chart" // Here we set the description for the graph
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


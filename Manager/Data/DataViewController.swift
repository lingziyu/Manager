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
import Foundation
import NVActivityIndicatorView


class DataViewController: UIViewController {
    var numbers : [Double] = []
    var time: [Double] = []
    var chartTitle: String?
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden=false;

    }
    
    @IBOutlet weak var lineChartTitle: UILabel!{
        didSet{
            if chartTitle != nil {
                lineChartTitle.text = chartTitle
            }
        }
    }
    
    @IBOutlet weak var chtChart: LineChartView!
    struct RuffData:Codable  {
        let date:String
        let value:Int
        let type:DataType
    }
    
    enum DataType:String,Codable {
        case temp
        case illum
        case humid
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.chtChart.noDataText = "数据加载中……"

       

        let cellWidth = Int(self.view.frame.width / 3)
        let cellHeight = Int(self.view.frame.height / 8)
        let x = Int(Int(self.view.frame.width / 2) - cellWidth / 2)
        let y = Int(Int(self.view.frame.height / 2) - cellHeight / 2)
        let frame = CGRect(x: x, y: y, width: cellWidth, height: cellHeight)
        let activityIndicatorView = NVActivityIndicatorView(frame: frame,
                                                            type: NVActivityIndicatorType.lineScale,color: UIColor(red: 0x86/255, green: 0xbe/255, blue: 0xbb/255, alpha: 1), padding: 10)
        self.view.addSubview(activityIndicatorView)
        
        
        activityIndicatorView.startAnimating()
        
        Alamofire.request("http://120.79.245.126:8010/getData")
            .responseJSON { response in
                switch response.result {
                case .success:
          
                    if let json = response.result.value {

                        let dict = json as! Dictionary<String,AnyObject>
                        let code = dict["code"] as! Int
                        switch (code){
                        case 0:
                            let ruffDatas = dict["ruffData"] as! Array<Dictionary<String,AnyObject>>
                            for ruffData in ruffDatas {
                                self.time.append(ruffData["date"] as! Double)
                            
                                switch(self.chartTitle){
                                case "湿度"?:
                                    self.numbers.append(ruffData["humid"] as! Double)
                                case "温度"?:
                                    self.numbers.append(ruffData["temp"] as! Double)
                                case "光照"?:
                                    self.numbers.append(ruffData["illum"] as! Double)
                                case .none:
                                    print("no data")
                                case .some(_):
                                    print("no data")
                                }
                            }
                            activityIndicatorView.stopAnimating()
                            self.chtChart.noDataText = "暂无数据"
                            self.updateGraph()

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
                    self.chtChart.noDataText = "暂无数据"
                }
        }


        
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


extension String {
    func mySubString(to index: Int) -> String {
        return String(self[..<self.index(self.startIndex, offsetBy: index)])
    }
    
    func mySubString(from index: Int) -> String {
        return String(self[self.index(self.startIndex, offsetBy: index)...])
    }
}


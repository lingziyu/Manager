//
//  PlantRecognizeViewController.swift
//  Manager
//
//  Created by 冰洁  杨 on 2018/3/21.
//  Copyright © 2018年 冰洁  杨. All rights reserved.
//

import UIKit
import Photos
import MobileCoreServices
import Alamofire
import NVActivityIndicatorView


class PlantRecognizeViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func Album(_ sender: Any) {
        //判断设置是否支持图片库
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            //初始化图片控制器
            let picker = UIImagePickerController()
            //设置代理
            picker.delegate = self
            //指定图片控制器类型
            picker.sourceType = .photoLibrary
            
            //弹出控制器，显示界面
            self.present(picker, animated: true, completion: {
                () -> Void in
            })
        }else{
            print("读取相册错误")
        }
    }
    
    var flag = false;
  
    
    @IBOutlet weak var result: UILabel!
    enum ImageSource {
        case remote(URL, UIImage)
        case local(Data, UIImage)
        
        // convenience method since both cases have the UIImage
        var image: UIImage {
            switch self {
            case .remote(_, let image): return image
            case .local(_, let image): return image
            }
        }
    }
    @IBAction func takePhoto(_ sender: UIButton) {
        flag = true;
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.mediaTypes = [kUTTypeImage as String]
        picker.allowsEditing = true
        picker.delegate = self
        present(picker,animated: true)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.presentingViewController?.dismiss(animated: true)
        
    }
    var localId:String?
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = ((info[UIImagePickerControllerEditedImage] ??
            info[UIImagePickerControllerOriginalImage]) as? UIImage) {
            
            
            if(flag){
                PHPhotoLibrary.shared().performChanges({
                    let result = PHAssetChangeRequest.creationRequestForAsset(from: image)
                    let assetPlaceholder = result.placeholderForCreatedAsset
                    //保存标志符
                    self.localId = assetPlaceholder?.localIdentifier
                    
                }) { (isSuccess: Bool, error: Error?) in
                    if isSuccess {
                      //通过标志符获取对应的资源
                        let assetResult = PHAsset.fetchAssets(
                            withLocalIdentifiers: [self.localId!], options: nil)
                        let asset = assetResult[0]
                        let options = PHContentEditingInputRequestOptions()
                        options.canHandleAdjustmentData = {(adjustmeta: PHAdjustmentData)
                            -> Bool in
                            return true
                        }
                        
                        //获取保存的缩略图
                        PHImageManager.default().requestImage(for: asset,
                                                              targetSize: CGSize(width:300, height:300), contentMode: PHImageContentMode.default,
                                                              options: nil, resultHandler: { (image, _:[AnyHashable : Any]?) in
    //                                                            print("获取缩略图成功：\(image)")
                        })
                        
                    }
                }
            }
            
            
            
            DispatchQueue.main.async(execute: {
                self.cameraButton.setBackgroundImage(image, for: .normal)
                self.cameraButton.setImage(UIImage(), for: .normal)
            })
            
            let cellWidth = Int(self.view.frame.width / 3)
            let cellHeight = Int(self.view.frame.height / 8)
            let x = Int(Int(self.view.frame.width / 2) - cellWidth / 2)
            let y = Int(Int(self.view.frame.height) - Int(Double(cellHeight) * 1.5))
            let frame = CGRect(x: x, y: y, width: cellWidth, height: cellHeight)
            let activityIndicatorView = NVActivityIndicatorView(frame: frame,
                                                                type: NVActivityIndicatorType.lineScale,color: UIColor.white, padding: 10)
            self.view.addSubview(activityIndicatorView)
            
            
            activityIndicatorView.startAnimating()
            self.result.text = "识别中……"

            
            
            let imgData = UIImageJPEGRepresentation(image, 1.0)
            let baseImg = imgData?.base64EncodedString()
            
            
            
            
            
            let parameters : [String: Any] = [
                "image":baseImg!
            ]
            
            let headers : HTTPHeaders = ["Content-Type":"application/x-www-form-urlencoded"]
            
            
            //        print(para)
            Alamofire.request("https://aip.baidubce.com/rest/2.0/image-classify/v1/plant?access_token=24.1d984e2d4fa44df80793808a5e759b2a.2592000.1524226461.282335-10943870", method: .post, parameters: parameters,encoding: URLEncoding.httpBody, headers:headers)
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        debugPrint(response)
                        if let json = response.result.value {
                            let dict = json as? Dictionary<String,AnyObject>
                            print(dict ?? "")
                            if let resultsArray = dict!["result"] as? Array<Dictionary<String,AnyObject>>{
                                let resultItem = resultsArray[0]
                                if let name = resultItem["name"] as? String{
                                    self.result.text = "识别结果：" + name
                                    activityIndicatorView.stopAnimating()

                                }
                            }else{
                                self.result.text = "识别结果：非植物"
                                activityIndicatorView.stopAnimating()
                            }
                        }
                        
                    case .failure(let error):
                        print(error)
                    }
            }
            
            
            
            
           
        }
       picker.presentingViewController?.dismiss(animated: true)

    }
    @IBOutlet weak var cameraButton: UIButton!{
        didSet{
            cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let bar = self.tabBarController {
            bar.tabBar.isHidden = true
        }
        
        self.navigationController?.isNavigationBarHidden=false;
    }
    

  
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension UIImage {
    
    func scaled(newSize:CGSize) -> UIImage {
        // here both true and false seems both work to resize
        //        let hasAlpha = false
        let hasAlpha = true
        let scale:CGFloat = 0.0 //system will auto get the real factor
        
        UIGraphicsBeginImageContextWithOptions(newSize, !hasAlpha, scale)
        
        self.draw(in: CGRect(origin: CGPoint() , size: newSize))
        let resizedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        return resizedImage
    }
    
    func resizeToWidth(newWidth:CGFloat) -> UIImage {
        let scale = newWidth / self.size.width
        print("scale=\(scale)")
        let newHeight = self.size.height * scale
        print("newHeight=\(newHeight)")
        
        let newSize = CGSize(width: newWidth, height: newHeight)
        
        return self.scaled(newSize: newSize)
    }
    
    func resizeToHeight(newHeight:CGFloat) -> UIImage {
        let scale = newHeight / self.size.width
        print("scale=\(scale)")
        let newWidth = self.size.height * scale
        print("newWidth=\(newWidth)")
        let newSize = CGSize(width: newWidth, height: newHeight)
        return self.scaled(newSize: newSize)
    }
}

//
//  add_images_in_vet.swift
//  RiteVet
//
//  Created by Dishant Rajput on 08/08/23.
//  Copyright © 2023 Apple . All rights reserved.
//

import UIKit
import SDWebImage
import Alamofire

import OpalImagePicker
import BSImagePicker
import Photos

class add_images_in_vet: UIViewController , UINavigationControllerDelegate , UIImagePickerControllerDelegate , OpalImagePickerControllerDelegate {

    var collectionView: UICollectionView?
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
    var str_image_type:String!
    var str_user_info_id:String!
    var str_title_name:String!
    var arr_image:NSArray!
    
    var imageStr:String!
    var imgData:Data!
    
    var arrImages : NSMutableArray! = []
    var arrImagesThumbnail : NSMutableArray! = []
    var data:Data!
    var arrTest : NSMutableArray! = []
    
    @IBOutlet weak var viewNavigation:UIView! {
        didSet {
            viewNavigation.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }
    @IBOutlet weak var btnBack:UIButton!
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = String(self.str_title_name)
            lblNavigationTitle.textColor = .white
        }
    }
    
    @IBOutlet weak var clView: UICollectionView! {
        didSet {
            screenSize = UIScreen.main.bounds
            screenWidth = screenSize.width
            screenHeight = screenSize.height
            
            // Do any additional setup after loading the view, typically from a nib
            // let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            // layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)

            // layout.minimumInteritemSpacing = 0
            // layout.minimumLineSpacing = 0
            
            clView!.backgroundColor = UIColor.init(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1)
        }
    }
    
    @IBOutlet weak var btn_upload:UIButton! {
        didSet {
            Utils.buttonDR(button: btn_upload, text: "Upload", backgroundColor: BUTTON_BACKGROUND_COLOR_BLUE, textColor: BUTTON_TEXT_COLOR, cornerRadius: 0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clView!.dataSource = self
        self.clView!.delegate = self
        self.clView!.reloadData()

        if (self.arr_image == nil) {
            
            self.arr_image = []
            Utils.buttonDR(button: btn_upload, text: "Upload", backgroundColor: BUTTON_BACKGROUND_COLOR_BLUE, textColor: BUTTON_TEXT_COLOR, cornerRadius: 0)
            
            self.btn_upload.isUserInteractionEnabled = true
            
            self.btn_upload.addTarget(self, action: #selector(openActionSheet), for: .touchUpInside)
            
        } else {
            
            if (self.arr_image.count == 10) {
                
                self.btn_upload.backgroundColor = .lightGray
                self.btn_upload.isUserInteractionEnabled = false
                
            } else if (self.arr_image.count > 10) {
                
                self.btn_upload.backgroundColor = .lightGray
                self.btn_upload.isUserInteractionEnabled = false
                
            } else {
                
                Utils.buttonDR(button: btn_upload, text: "Upload", backgroundColor: BUTTON_BACKGROUND_COLOR_BLUE, textColor: BUTTON_TEXT_COLOR, cornerRadius: 0)
                
                self.btn_upload.isUserInteractionEnabled = true
                
                self.btn_upload.addTarget(self, action: #selector(openActionSheet), for: .touchUpInside)
                
            }
            
        }
        
        
        self.btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        
        // print(self.arr_image as Any)
        
    }
    
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @objc func openActionSheet() {
        
        print(self.arr_image.count as Any)
        
        let imagePicker = OpalImagePickerController()
        imagePicker.imagePickerDelegate = self
        
        if (self.arr_image.count == 0 ) {
            imagePicker.maximumSelectionsAllowed = 10
        } else if (self.arr_image.count == 1 ) {
            imagePicker.maximumSelectionsAllowed = 9
        } else if (self.arr_image.count == 2 ) {
            imagePicker.maximumSelectionsAllowed = 8
        } else if (self.arr_image.count == 3 ) {
            imagePicker.maximumSelectionsAllowed = 7
        } else if (self.arr_image.count == 4 ) {
            imagePicker.maximumSelectionsAllowed = 6
        } else if (self.arr_image.count == 5 ) {
            imagePicker.maximumSelectionsAllowed = 5
        } else if (self.arr_image.count == 6 ) {
            imagePicker.maximumSelectionsAllowed = 4
        } else if (self.arr_image.count == 7 ) {
            imagePicker.maximumSelectionsAllowed = 3
        } else if (self.arr_image.count == 8 ) {
            imagePicker.maximumSelectionsAllowed = 2
        } else if (self.arr_image.count == 9 ) {
            imagePicker.maximumSelectionsAllowed = 1
        } else {
            imagePicker.maximumSelectionsAllowed = 0
        }
        
        imagePicker.allowedMediaTypes = Set([PHAssetMediaType.image])
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerDidCancel(_ picker: OpalImagePickerController) {
        //Cancel action?
    }
    
    func imagePicker(_ picker: OpalImagePickerController, didFinishPickingAssets assets: [PHAsset]) {
        
        print("Selected: \(assets)")
        
        print(assets.count)
        
        self.arrImagesThumbnail.add(self.getAssetThumbnail(asset: assets[0]))
        
        self.arrTest.removeAllObjects()
        
        for i in 0..<assets.count {
            self.arrImages.add(self.getAssetThumbnail(asset: assets[i]))
            
            let image = self.getAssetThumbnail(asset: assets[i])
            self.data = image.jpegData(compressionQuality: 1.0)
            
            self.arrTest.add(self.data as Any) // show on collection
        }
        
        // print(self.arrTest as Any)
        print(self.arrTest.count)
        
        //Dismiss Controller
        self.presentedViewController?.dismiss(animated: true, completion: nil)
        
        self.upload_image()
    }
    
    func getAssetThumbnail(asset: PHAsset) -> UIImage {
        
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: CGSize(width: 500, height: 500), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return thumbnail
        
    }
    
    @objc func upload_image() {
        Utils.RiteVetIndicatorShow()
        // yes image upload
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            var urlRequest = URLRequest(url: URL(string: BASE_URL_KREASE)!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0 * 1000)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
            
            // let indexPath = IndexPath.init(row: 0, section: 0)
            // let cell = self.tablView.cellForRow(at: indexPath) as! AddTableTableViewCell
            
            //Set Your Parameter
            let parameterDict = NSMutableDictionary()
            parameterDict.setValue("addmultiimage", forKey: "action")
            parameterDict.setValue(String(myString), forKey: "userId")
            
            parameterDict.setValue(String("2"), forKey: "UTYPE")
            parameterDict.setValue(String(self.str_image_type), forKey: "imageType")
            parameterDict.setValue(String(self.str_user_info_id), forKey: "userInfoId")
            
            print(parameterDict as Any)
            
            // Now Execute
            AF.upload(multipartFormData: { multiPart in
                for (key, value) in parameterDict {
                    
                    if let temp = value as? String {
                        multiPart.append(temp.data(using: .utf8)!, withName: key as! String)
                    }
                    
                    if let temp = value as? Int {
                        multiPart.append("\(temp)".data(using: .utf8)!, withName: key as! String)
                    }
                    
                    if let temp = value as? NSArray {
                        
                        temp.forEach({ element in
                            let keyObj = key as! String + "[]"
                            if let string = element as? String {
                                multiPart.append(string.data(using: .utf8)!, withName: keyObj)
                            } else
                            if let num = element as? Int {
                                let value = "\(num)"
                                multiPart.append(value.data(using: .utf8)!, withName: keyObj)
                            }
                        })
                        
                    }
                    
                }
                
                for i in 0..<self.arrTest.count {
                    print("\("multiImage")"+"\([i])")
                    
                    let image : UIImage = UIImage(data: self.arrTest![i] as! Data)!
                    
                    multiPart.append((image ).jpegData(compressionQuality: 0.5)!, withName: "\("multiImage")"+"\([i])", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/png")
                    
                }
                
                
//                multiPart.append(self.imgData, withName: "multiImage", fileName: "add_biography.png", mimeType: "image/png")
                
            }, with: urlRequest)
            .uploadProgress(queue: .main, closure: { progress in
                //Current upload progress of file
                print("Upload Progress: \(progress.fractionCompleted)")
            })
            .responseJSON(completionHandler: { data in
                
                switch data.result {
                    
                case .success(_):
                    do {
                        
                        let dictionary = try JSONSerialization.jsonObject(with: data.data!, options: .fragmentsAllowed) as! NSDictionary
                        
                        print("Success!")
                        print(dictionary)
                        
                        ERProgressHud.sharedInstance.hide()
                        
                        let alert = UIAlertController(title: "Success", message: (dictionary["msg"] as! String), preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in
                            self.navigationController?.popViewController(animated: true)
                        }))
                        
                        self.present(alert, animated: true, completion: nil)
//                        let JSON = dictionary
//                        print(JSON)
                        
                        /*var dict: Dictionary<AnyHashable, Any>
                        dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                        
                        let defaults = UserDefaults.standard
                        defaults.setValue(dict, forKey: "keyLoginFullData")*/
                        
                    }
                    catch {
                        // catch error.
                        print("catch error")
                        ERProgressHud.sharedInstance.hide()
                    }
                    break
                    
                case .failure(_):
                    print("failure")
                    ERProgressHud.sharedInstance.hide()
                    break
                    
                }
                
                
            })
            
        }
    }
    
}

extension add_images_in_vet: UICollectionViewDelegate {
    //Write Delegate Code Here
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "add_images_in_vet_collection_cell", for: indexPath as IndexPath) as! add_images_in_vet_collection_cell
        
        cell.backgroundColor = UIColor.white
        cell.layer.borderWidth = 0.5
        cell.backgroundColor = UIColor.clear
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.borderWidth = 0.8
        cell.layer.cornerRadius = 4
        cell.clipsToBounds = true
        
        let item = self.arr_image[indexPath.row] as? [String:Any]
        
        cell.imgDogProduct.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge

        cell.imgDogProduct.sd_setImage(with: URL(string: (item!["image"] as! String)), placeholderImage: UIImage(named: "plainBack"))
        
        
        
        
        return cell
        
    }
    
    //UICollectionViewDatasource methods
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arr_image.count
    }
}

extension add_images_in_vet: UICollectionViewDataSource {
    //Write DataSource Code Here
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        /*let item = arrDogFoodList[indexPath.row] as? [String:Any]
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DogFoodDetailsId") as? DogFoodDetails
        push!.dictGetAnimalFoodDetails = item as NSDictionary?
        self.navigationController?.pushViewController(push!, animated: true)*/
    }
    
}

extension add_images_in_vet: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        var sizes: CGSize
        
        let result = UIScreen.main.bounds.size
        NSLog("%f",result.height);
        
        // sizes = CGSize(width: 120, height: 120)
        // sizes = CGSize(width: result.width/2, height: result.width/2)
        
        sizes = CGSize(width: 120, height: 120)
        
        /*if result.height == 480 {
            sizes = CGSize(width: 190, height: 220)
        }
        else if result.height == 568 {
            sizes = CGSize(width: 80, height: 170)
        }
        else if result.height == 667.000000 // 8
        {
            sizes = CGSize(width: 120, height: 190)
        }
        else if result.height == 736.000000 // 8 plus
        {
            sizes = CGSize(width: 120, height: 190)
        }
        else if result.height == 812.000000 // 11 pro
        {
            sizes = CGSize(width: 120, height: 190)
        }
        else if result.height == 896.000000 // 11 , 11 pro max
        {
            sizes = CGSize(width: 120, height: 190)
        }
        else
        {
            sizes = CGSize(width: 120, height: 190)
        }
        */
        return sizes
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
                        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        // return 4
        let  result = UIScreen.main.bounds.size
        if result.height == 667.000000 { // 8
            return 4
        } else if result.height == 812.000000 { // 11 pro
            return 4
        } else {
            return 10
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        
        // return UIEdgeInsets(top: 4, left: 00, bottom: 4, right: 00)
        
        if collectionView.numberOfItems(inSection: section) == 1 {
            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: collectionView.frame.width - flowLayout.itemSize.width)
        } else {
            let result = UIScreen.main.bounds.size
            if result.height == 667.000000 { // 8
                return UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
            } else if result.height == 736.000000 { // 8 plus
                return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            } else if result.height == 896.000000 { // 11 plus
                return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            } else if result.height == 812.000000 { // 11 pro
                return UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
            } else {
                return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            }
        }
        
        
    }
    
}

class add_images_in_vet_collection_cell: UICollectionViewCell {
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lbloldPrice:UILabel!
    @IBOutlet weak var lblPrice:UILabel!
    @IBOutlet weak var imgDogProduct:UIImageView!
}

//
//  AddNewProduct.swift
//  RiteVet
//
//  Created by evs_SSD on 12/26/19.
//  Copyright © 2019 Apple . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import BottomPopup
import CRNotifications

class AddNewProduct: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIPickerViewDelegate,UITextFieldDelegate {

    let cellReuseIdentifier = "addNewProductTableCell"
    
    var imageStr:String!
    var imgData:Data!
    
    // picker array
    var arrCategory = ["1","2"]
    var pickerView:UIPickerView?
    
    // bottom view popup
    var height: CGFloat = 600 // height
    var topCornerRadius: CGFloat = 35 // corner
    var presentDuration: Double = 0.8 // present view time
    var dismissDuration: Double = 0.5 // dismiss view time
    let kHeightMaxValue: CGFloat = 600 // maximum height
    let kTopCornerRadiusMaxValue: CGFloat = 35 // 
    let kPresentDurationMaxValue = 3.0
    let kDismissDurationMaxValue = 3.0
    
    var strStoreCategoryId:String!
    var strSubStoreCategoryId:String!
    var productIdIs:String!
    
    var strImageEdit:String!
    
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var imgProfile:UIImageView!
    
    @IBOutlet weak var viewNavigation:UIView! {
          didSet {
              viewNavigation.backgroundColor = NAVIGATION_BACKGROUND_COLOR
          }
      }
      @IBOutlet weak var btnBack:UIButton!
    
      @IBOutlet weak var lblNavigationTitle:UILabel! {
          didSet {
              lblNavigationTitle.text = "ADD NEW PRODUCT"
              lblNavigationTitle.textColor = .white
          }
      }
      // 255 200 68
      @IBOutlet weak var tbleView: UITableView! {
          didSet {
              tbleView.delegate = self
              tbleView.dataSource = self
              tbleView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
              tbleView.backgroundColor = .clear
          }
      }
    
    var editStringOrNot:String!
    var dictGetForEdit:NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.init(patternImage: UIImage(named: "plainBack")!)
        
        btnBack.addTarget(self, action: #selector(backClick), for: .touchUpInside)
        
        // picker view delegate call
        self.pickerView = UIPickerView()
        self.pickerView?.delegate = self
        //self.pickerView?.dataSource = self
        
        let viewTapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(viewTapGesture)
        
        defaults.set(nil, forKey: "selectCategoryName") // cat name
        defaults.set("", forKey: "selectCategoryName") // cat name
        
        defaults.set(nil, forKey: "selectSubCategoryName") // sub cat name
        defaults.set("", forKey: "selectSubCategoryName") // sub cat name
        
        // self.strGetDetails = "0"
        
        if editStringOrNot == "1" {
            print("edit product")
            print(dictGetForEdit as Any)
            /*
             SKU = "anne 25";
             categoryId = 8;
             categoryName = Fish;
             description = "wehsheepan ";
             image = "http://demo2.evirtualservices.com/ritevet/site/img/uploads/products/1583221890riteVetImage.jpg";
             price = 10;
             productId = 117;
             productName = test;
             productUserId = 105;
             quantity = 4;
             shippingAmount = 100;
             specialPrice = 9;
             subcategoryId = 30;
             subcategoryName = "Fish Food";
             */
            let indexPath = IndexPath.init(row: 0, section: 0)
            let cell = tbleView.cellForRow(at: indexPath) as! AddNewProductTableCell
            
            
            // shipping charge
             let shippinFeeChange : Int = (dictGetForEdit["productUserId"] as! Int)
             let stringShippingFee = String(shippinFeeChange)
             
            // price
            // let priceChange : Int = (dictGetForEdit["price"] as! Int)
            let stringPrice = "\(self.dictGetForEdit["price"]!)"//String(priceChange)
            
            // special price
            // let specialPriceChange : Int = (dictGetForEdit["specialPrice"] as! Int)
            let stringSpecialPrice = "\(self.dictGetForEdit["specialPrice"]!)"//String(specialPriceChange)
            
            // quantity
            // let quantityChange : Int = (dictGetForEdit["quantity"] as! Int)
            let stringQuantity = "\(self.dictGetForEdit["quantity"]!)"//String(quantityChange)
            
            // category id
            // let categoryIdC : Int = (dictGetForEdit["categoryId"] as! Int)
            // let stringCategory = String(categoryIdC)
            strStoreCategoryId = "\(self.dictGetForEdit["categoryId"]!)"// stringCategory
            
            // sub category id
           // let subCategoryIdC : Int = (dictGetForEdit["subcategoryId"] as! Int)
            // let stringSubCategory = String(subCategoryIdC)
            strSubStoreCategoryId = "\(self.dictGetForEdit["subcategoryId"]!)"//stringSubCategory
            
            cell.txtSelectCategory.text = (dictGetForEdit["categoryName"] as! String)
            cell.txtSelectSubCategory.text = (dictGetForEdit["subcategoryName"] as! String)
            cell.txtProductName.text = (dictGetForEdit["productName"] as! String)
            cell.txtSKU.text = (dictGetForEdit["SKU"] as! String)
            cell.txtShippingFee.text = stringShippingFee
            cell.txtProductDescription.text = (dictGetForEdit["description"] as! String)
            cell.txtPrice.text = stringPrice
            cell.txtSpecialPrice.text = stringSpecialPrice
            cell.txtQuantity.text = stringQuantity
            
            cell.txt_seller_name.text = (dictGetForEdit["sellerName"] as! String)
            cell.txt_Seller_phone.text = (dictGetForEdit["sellerPhone"] as! String)
            cell.txt_Seller_email.text = (dictGetForEdit["sellerEmail"] as! String)
            cell.txt_seller_company_name.text = (dictGetForEdit["SellerCompanyName"] as! String)
            
            // productIdIs
            let productIdIs2 : Int = (dictGetForEdit["productId"] as! Int)
            let stringProductId = String(productIdIs2)
            productIdIs = stringProductId
            
            let defaults = UserDefaults.standard
            defaults.set(productIdIs, forKey: "keyEditedProductIdIs")
            
            imgProfile.sd_setImage(with: URL(string: (dictGetForEdit!["image"] as! String)), placeholderImage: UIImage(named: "plainBack"))
         
            strImageEdit = "0"
        }
        else {
            print("add product")
            strImageEdit = "0"
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    @objc func backClick() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    @objc func uploadImageOpenActionSheet() {
        let alert = UIAlertController(title: "Upload image", message: "Camera or Gallery", preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Camera", style: .default , handler:{ (UIAlertAction)in
            self.openCamera()
        }))

        alert.addAction(UIAlertAction(title: "Gallery", style: .default , handler:{ (UIAlertAction)in
            self.openGallery()
        }))

        alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler:{ (UIAlertAction)in
            //print("User click Dismiss button")
        }))

        self.present(alert, animated: true, completion: {
            //print("completion block")
        })
    }
    
    @objc func openCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera;
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func openGallery() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary;
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
        {
            
            //let buttonPosition = sender.convert(CGPoint.zero, to: self.tbleView)
            //let indexPath = self.tbleView.indexPathForRow(at:buttonPosition)
            //let cell = self.tbleView.cellForRow(at: indexPath!) as! AddNewProductTableCell
            
            if editStringOrNot == "1" {
                let image_data = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
                imgProfile.image = image_data // show image on image view
                let imageData:Data = image_data!.pngData()!
                imageStr = imageData.base64EncodedString()
                self.dismiss(animated: true, completion: nil)
                
                imgData = image_data!.jpegData(compressionQuality: 0.2)!
                
                strImageEdit = "1"
            }
            else {
            let image_data = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            imgProfile.image = image_data // show image on image view
            let imageData:Data = image_data!.pngData()!
            imageStr = imageData.base64EncodedString()
            self.dismiss(animated: true, completion: nil)
            
            imgData = image_data!.jpegData(compressionQuality: 0.2)!
                //print(type(of: imgData))
                //print(imgData)
            }
    }
    
    // MARK:- EDIT PRODUCT WITH IMAGE -
    // MARK:- ADD PRODUCT -
        @objc func editProductWBWithImage() {
            
            let indexPath = IndexPath.init(row: 0, section: 0)
            let cell = self.tbleView.cellForRow(at: indexPath) as! AddNewProductTableCell
            
            let myString1 = cell.txtPrice.text
            let myInt1 = Int(myString1!)
            
            let myString2 = cell.txtSpecialPrice.text
            let myInt2 = Int(myString2!)
            
            
            
            
            
            if cell.txtSelectCategory.text == "" {
                self.textFieldShouldNotBeEmpty()
            }
            else if cell.txtSelectSubCategory.text == "" {
                self.textFieldShouldNotBeEmpty()
            }
            else if cell.txtProductName.text == "" {
                self.textFieldShouldNotBeEmpty()
            }
            else if cell.txtSKU.text == "" {
                self.textFieldShouldNotBeEmpty()
            }
            else if cell.txtShippingFee.text == "" {
                self.textFieldShouldNotBeEmpty()
            }
            else if cell.txtProductDescription.text == "" {
                self.textFieldShouldNotBeEmpty()
            }
            else if cell.txtPrice.text == "" {
                self.textFieldShouldNotBeEmpty()
            }
            else if cell.txtSpecialPrice.text == "" {
                self.textFieldShouldNotBeEmpty()
            }
            else if cell.txtQuantity.text == "" {
                self.textFieldShouldNotBeEmpty()
            }
            else if myInt1! < myInt2! {
                let alertController = UIAlertController(title: nil, message: "Special price should be less then price", preferredStyle: .actionSheet)
                
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                        UIAlertAction in
                        //NSLog("OK Pressed")
                    }
                
                alertController.addAction(okAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
            
            
            else
            if imgProfile.image == nil {
                let alertController = UIAlertController(title: nil, message: "Please Upload One Product Image.", preferredStyle: .actionSheet)
                
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                        UIAlertAction in
                        //NSLog("OK Pressed")
                    }
                
                alertController.addAction(okAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
            else
            {
            
            if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]
                {
                 let x : Int = (person["userId"] as! Int)
                 let myString = String(x)
                   
                var urlRequest = URLRequest(url: URL(string: BASE_URL_KREASE)!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0 * 1000)
                urlRequest.httpMethod = "POST"
                urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
                
                // let indexPath = IndexPath.init(row: 0, section: 0)
                // let cell = self.tablView.cellForRow(at: indexPath) as! AddTableTableViewCell
                
                //Set Your Parameter
                let parameterDict = [
                   "action"        :   "editproduct",
                   "productId"      : String(productIdIs),
                   "SKU"            :   cell.txtSKU.text!,
                   "userId"       :   myString,
                   "categoryId"    :   String(strStoreCategoryId),
                   "subCategory"   :   String(strSubStoreCategoryId),
                   "productName"   :   cell.txtProductName.text!,
                   "quantity"      :  cell.txtQuantity.text!,
                   "price"        :   cell.txtPrice.text!,
                   "description"   :   cell.txtProductDescription.text!,
                   "shippingAmount"   :   cell.txtShippingFee.text!,
                   "specialPrice"   :   cell.txtSpecialPrice.text!,
               ]
                
//                        let parameters = [
//                           "action"        :   "editprofile",
//                           "userId"        :   String(myString)
//
//                       ]
                
                
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
                    multiPart.append(self.imgData, withName: "image", fileName: "add_club_logo.png", mimeType: "image/png")
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
                                
                                let defaults = UserDefaults.standard
                                                                defaults.set("editProduct", forKey: "keyEditProductDone")
                                    
                                
                                                                self.navigationController?.popViewController(animated: true)
                                                                    
                                                                    
                                                                    
                                                                    
                                                                Utils.RiteVetIndicatorHide()
                                
                            }
                            catch {
                                // catch error.
                                print("catch error")
                                CRNotifications.showNotification(type: CRNotifications.error, title: "Alert!", message:"strSuccessAlert", dismissDelay: 1.5, completion:{})
                            }
                            break
                            
                        case .failure(_):
                            print("failure")
                            ERProgressHud.sharedInstance.hide()
                            break
                            
                        }
                        
                        
                    })
                
                 /*let parameters = [
                    "action"        :   "editproduct",
                    "productId"      : String(productIdIs),
                    "SKU"            :   cell.txtSKU.text!,
                    "userId"       :   myString,
                    "categoryId"    :   String(strStoreCategoryId),
                    "subCategory"   :   String(strSubStoreCategoryId),
                    "productName"   :   cell.txtProductName.text!,
                    "quantity"      :  cell.txtQuantity.text!,
                    "price"        :   cell.txtPrice.text!,
                    "description"   :   cell.txtProductDescription.text!,
                    "shippingAmount"   :   cell.txtShippingFee.text!,
                    "specialPrice"   :   cell.txtSpecialPrice.text!,
                ] //Optional for extra parameter
                
                    // print(parameters as Any)
                    // print(self.imgData as Any)
                    
                AF.upload(multipartFormData: { multipartFormData in
                    multipartFormData.append(self.imgData, withName: "image",fileName: "riteVetImage.jpg", mimeType: "image/jpg")
                        for (key, value) in parameters {
                            multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                            } //Optional for extra parameters
                    },
                to:BASE_URL_KREASE)
                { (result) in
                    switch result {
                    case .success(_):

//
                        result.responseJSON { response in
                            print(response.result.value as Any)
                            // self.dismiss(animated: true, completion: nil)
                            self.dismiss(animated: true, completion: nil)
                            if let data = response.result.value
                            {
                                 let JSON = data as! NSDictionary
                                // print(JSON)
                                
                                
                                var strSuccess : String!
                                strSuccess = JSON["status"]as Any as? String
                                
                                var strSuccessAlert : String!
                                strSuccessAlert = JSON["msg"]as Any as? String
                                
                                if strSuccess == "success" {
                                    let defaults = UserDefaults.standard
                                                                    defaults.set("editProduct", forKey: "keyEditProductDone")
                                        
                                    
                                                                    self.navigationController?.popViewController(animated: true)
                                                                        
                                                                        
                                                                        
                                                                        
                                                                    Utils.RiteVetIndicatorHide()
                                } else {
                                    CRNotifications.showNotification(type: CRNotifications.error, title: "Alert!", message:strSuccessAlert, dismissDelay: 1.5, completion:{})
                                    
                                }
                                
                            }
                            else {
                                CRNotifications.showNotification(type: CRNotifications.error, title: "Alert!", message:"Server Issue", dismissDelay: 1.5, completion:{})
                                self.dismiss(animated: true, completion: nil)
                            }
                         
                        }

                    case .failure(let encodingError):
                        print(encodingError)
                        self.dismiss(animated: true, completion: nil)
                        CRNotifications.showNotification(type: CRNotifications.error, title: "Alert!", message:"Server Issue", dismissDelay: 1.5, completion:{})
                    }
                }*/
            }
        }
            
    }
    
    // MARK:- EDIT PRODUCT -
    @objc func editProductWB(_ sender:UIButton) {
            // editProductWBWithImage
        
        
        // strImageEdit
        
        if strImageEdit == "1" {
            self.editProductWBWithImage()
        } else {
            let buttonPosition = sender.convert(CGPoint.zero, to: self.tbleView)
            let indexPath = self.tbleView.indexPathForRow(at:buttonPosition)
            let cell = self.tbleView.cellForRow(at: indexPath!) as! AddNewProductTableCell
            
            let myString1 = cell.txtPrice.text
            let myInt1 = Int(myString1!)
            
            let myString2 = cell.txtSpecialPrice.text
            let myInt2 = Int(myString2!)
            
            
            
            
            
            if cell.txtSelectCategory.text == "" {
                self.textFieldShouldNotBeEmpty()
            }
            else if cell.txtSelectSubCategory.text == "" {
                self.textFieldShouldNotBeEmpty()
            }
            else if cell.txtProductName.text == "" {
                self.textFieldShouldNotBeEmpty()
            }
            else if cell.txtSKU.text == "" {
                self.textFieldShouldNotBeEmpty()
            }
            else if cell.txtShippingFee.text == "" {
                self.textFieldShouldNotBeEmpty()
            }
            else if cell.txtProductDescription.text == "" {
                self.textFieldShouldNotBeEmpty()
            }
            else if cell.txtPrice.text == "" {
                self.textFieldShouldNotBeEmpty()
            }
            else if cell.txtSpecialPrice.text == "" {
                self.textFieldShouldNotBeEmpty()
            }
            else if cell.txtQuantity.text == "" {
                self.textFieldShouldNotBeEmpty()
            }
            else if myInt1! < myInt2! {
                let alertController = UIAlertController(title: nil, message: "Special price should be less then price", preferredStyle: .actionSheet)
                
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                        UIAlertAction in
                        //NSLog("OK Pressed")
                    }
                
                alertController.addAction(okAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
            
            /*
            else
            if imgProfile.image == nil {
                let alertController = UIAlertController(title: nil, message: "Please Upload One Product Image.", preferredStyle: .actionSheet)
                
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                        UIAlertAction in
                        //NSLog("OK Pressed")
                    }
                
                alertController.addAction(okAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
                */
            else
            {
                var parameters:Dictionary<AnyHashable, Any>!
                let urlString = BASE_URL_KREASE
                
                if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]
                {
                 let x : Int = (person["userId"] as! Int)
                 let myString = String(x)
                
                    Utils.RiteVetIndicatorShow()
                       
                               parameters = [
                                   "action"        :   "editproduct",
                                   "productId"      : String(productIdIs),
                                   "SKU"            :   cell.txtSKU.text!,
                                   "userId"       :   myString,
                                   "categoryId"    :   String(strStoreCategoryId),
                                   "subCategory"   :   String(strSubStoreCategoryId),
                                   "productName"   :   cell.txtProductName.text!,
                                   "quantity"      :  cell.txtQuantity.text!,
                                   "price"        :   cell.txtPrice.text!,
                                   "description"   :   cell.txtProductDescription.text!,
                                   "shippingAmount"   :   cell.txtShippingFee.text!,
                                   "specialPrice"   :   cell.txtSpecialPrice.text!,
                               ]
                }
                               print("parameters-------\(String(describing: parameters))")
                               
                               AF.request(urlString, method: .post, parameters: parameters as? Parameters).responseJSON
                                   {
                                       response in
                           
                                       switch(response.result) {
                                       case .success(_):
                                          if let data = response.value {

                                           
                                           let JSON = data as! NSDictionary
                                           // print(JSON)
                                            
                                           var strSuccess : String!
                                           strSuccess = JSON["status"]as Any as? String
                                           
                                           if strSuccess == "success" //true
                                           {
                                            let defaults = UserDefaults.standard
                                            defaults.set("editProduct", forKey: "keyEditProductDone")
                
            
                                            self.navigationController?.popViewController(animated: true)
                                                
                                                
                                                
                                                
                                            Utils.RiteVetIndicatorHide()
                                           }
                                           else {
                                               Utils.RiteVetIndicatorHide()
                                           }
                                           
                                       }

                                       case .failure(_):
                                           print("Error message:\(String(describing: response.error))")
                                           Utils.RiteVetIndicatorHide()
                                           
                                           let alertController = UIAlertController(title: nil, message: SERVER_ISSUE_MESSAGE_ONE+"\n"+SERVER_ISSUE_MESSAGE_TWO, preferredStyle: .actionSheet)
                                           
                                           let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                                                   UIAlertAction in
                                                   NSLog("OK Pressed")
                                               }
                                           
                                           alertController.addAction(okAction)
                                           
                                           self.present(alertController, animated: true, completion: nil)
                                           
                                           break
                                        }
                                   }
                

            }
            
        }
        
        
        
            
    }
    
    // MARK:- ADD PRODUCT -
    @objc func addProductWB(_ sender:UIButton) {
        
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tbleView)
        let indexPath = self.tbleView.indexPathForRow(at:buttonPosition)
        let cell = self.tbleView.cellForRow(at: indexPath!) as! AddNewProductTableCell
        
        let myString1 = cell.txtPrice.text
        print(myString1 as Any)
        
        let myInt1 = Int(myString1!)
        print(myInt1 as Any)
        
        let myString2 = cell.txtSpecialPrice.text
        let myInt2 = Int(myString2!)
        
        
        
        
        
        if cell.txtSelectCategory.text == "" {
            self.textFieldShouldNotBeEmpty()
        }
        else if cell.txtSelectSubCategory.text == "" {
            self.textFieldShouldNotBeEmpty()
        }
        else if cell.txtProductName.text == "" {
            self.textFieldShouldNotBeEmpty()
        }
        else if cell.txtSKU.text == "" {
            self.textFieldShouldNotBeEmpty()
        }
        else if cell.txtShippingFee.text == "" {
            self.textFieldShouldNotBeEmpty()
        }
        else if cell.txtProductDescription.text == "" {
            self.textFieldShouldNotBeEmpty()
        }
        else if cell.txtPrice.text == "" {
            self.textFieldShouldNotBeEmpty()
        }
        else if cell.txtSpecialPrice.text == "" {
            self.textFieldShouldNotBeEmpty()
        }
        else if cell.txtQuantity.text == "" {
            self.textFieldShouldNotBeEmpty()
        }
        else if myInt1! < myInt2! {
            
            let alertController = UIAlertController(title: nil, message: "Special price should be less then price", preferredStyle: .actionSheet)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    //NSLog("OK Pressed")
                }
            
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        } else
        if imgProfile.image == nil {
            let alertController = UIAlertController(title: nil, message: "Please Upload One Product Image.", preferredStyle: .actionSheet)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    //NSLog("OK Pressed")
                }
            
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
        else
        {
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]
            {
                // let str:String = person["role"] as! String
                
            Utils.RiteVetIndicatorShow()
            
                let x : Int = person["userId"] as! Int
                let myString = String(x)
                
                var urlRequest = URLRequest(url: URL(string: BASE_URL_KREASE)!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0 * 1000)
                urlRequest.httpMethod = "POST"
                urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
                
                // let indexPath = IndexPath.init(row: 0, section: 0)
                // let cell = self.tablView.cellForRow(at: indexPath) as! AddTableTableViewCell
                
            let parameterDict = NSMutableDictionary()
            parameterDict.setValue("addproduct", forKey: "action")
            parameterDict.setValue(cell.txtSKU.text!, forKey: "SKU")
            parameterDict.setValue(String(myString), forKey: "userId")
            parameterDict.setValue(String(strStoreCategoryId), forKey: "categoryId")
            parameterDict.setValue(String(strSubStoreCategoryId), forKey: "subCategory")
            parameterDict.setValue(cell.txtProductName.text!, forKey: "productName")
            parameterDict.setValue(cell.txtQuantity.text!, forKey: "quantity")
            parameterDict.setValue(cell.txtPrice.text!, forKey: "price")
            parameterDict.setValue(cell.txtProductDescription.text!, forKey: "description")
            parameterDict.setValue(cell.txtShippingFee.text!, forKey: "shippingAmount")
            parameterDict.setValue(cell.txtSpecialPrice.text!, forKey: "specialPrice")
            parameterDict.setValue(cell.txt_seller_name.text!, forKey: "sellerName")
            parameterDict.setValue(cell.txt_Seller_email.text!, forKey: "sellerEmail")
            parameterDict.setValue(cell.txt_Seller_phone.text!, forKey: "sellerPhone")
            parameterDict.setValue(cell.txt_seller_company_name.text!, forKey: "SellerCompanyName")
             
                
                
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
                    multiPart.append(self.imgData, withName: "image", fileName: "add_club_logo.png", mimeType: "image/png")
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
                                
                                Utils.RiteVetIndicatorHide()
                                
                                var strSuccess : String!
                                strSuccess = dictionary["status"]as Any as? String
                                
                                var strSuccessAlert : String!
                                strSuccessAlert = dictionary["msg"]as Any as? String
                                
                                if strSuccess == "success" {
                                    let alert = UIAlertController(title: "Success", message: strSuccessAlert, preferredStyle: UIAlertController.Style.alert)
                                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
                                        
                                        self.navigationController?.popViewController(animated: true)
                                        
                                    }))
                                    
                                    self.present(alert, animated: true, completion: nil)
                                    
                                     
                                    /*let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BrowsePetStoreId") as? BrowsePetStore
                                     self.navigationController?.pushViewController(push!, animated: true)*/
                                    
                                    
                                } else {
                                    var strSuccessAlert : String!
                                    strSuccessAlert = dictionary["msg"]as Any as? String
                                    
                                    let alert = UIAlertController(title: "Alert", message: strSuccessAlert, preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                                         
                                        
                                    }))
                                    
                                    self.present(alert, animated: true, completion: nil)
                                }
                                
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
//            {
//             let x : Int = (person["userId"] as! Int)
//             let myString = String(x)
//
//             let parameters = [
//                "action"        :   "addproduct",
//                "SKU"            :   cell.txtSKU.text!,
//                "userId"       :   myString,
//                "categoryId"    :   String(strStoreCategoryId),
//                "subCategory"   :   String(strSubStoreCategoryId),
//                "productName"   :   cell.txtProductName.text!,
//                "quantity"      :  cell.txtQuantity.text!,
//                "price"        :   cell.txtPrice.text!,
//                "description"   :   cell.txtProductDescription.text!,
//                "shippingAmount"   :   cell.txtShippingFee.text!,
//                "specialPrice"   :   cell.txtSpecialPrice.text!,
//                "sellerName"      :  cell.txt_seller_name.text!,
//                "sellerEmail"      :  cell.txt_Seller_email.text!,
//                "sellerPhone"      :  cell.txt_Seller_phone.text!,
//                "SellerCompanyName"      :  cell.txt_seller_company_name.text!,
//            ] //Optional for extra parameter
//
//                print(parameters as Any)
//                // print(self.imgData as Any)
//
//            AF.upload(multipartFormData: { multipartFormData in
//                multipartFormData.append(self.imgData, withName: "image",fileName: "riteVetImage.jpg", mimeType: "image/jpg")
//                    for (key, value) in parameters {
//                        multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
//                        } //Optional for extra parameters
//                },
//            to:BASE_URL_KREASE)
//            { (result) in
//                switch result.result
//                { data in
//
//                    switch data.result {
//
//                    case .success(_):
//                        do {
//
//                            let dictionary = try JSONSerialization.jsonObject(with: data.data!, options: .fragmentsAllowed) as! NSDictionary
//
//                            print("Success!")
//                            print(dictionary)
//
//                            self.arrTest.removeAllObjects()
//
//                            // ERProgressHud.sharedInstance.hide()
//
//                            self.show_image_wb(str_show_indicator: "no")
//
//                            /*var strSuccess2 : String!
//                            strSuccess2 = dictionary["msg"]as Any as? String
//
//                            let alert = NewYorkAlertController(title: "Success", message: String(strSuccess2), style: .alert)
//
//                            alert.addImage(UIImage.gif(name: "success3"))
//
//                            let cancel = NewYorkButton(title: "Ok", style: .cancel) {
//                                _ in
//
//                            }
//                            alert.addButtons([cancel])
//
//                            self.present(alert, animated: true)*/
//
//                        }
//                        catch {
//                            // catch error.
//                            print("catch error")
//                            ERProgressHud.sharedInstance.hide()
//                        }
//                        break
//
//                    case .failure(_):
//                        print("failure")
//                        ERProgressHud.sharedInstance.hide()
//
//                        if let err = data.response {
//                            print(err)
//                            return
//                        }
//
//                        break
//
//                    }
//                }
//                /*{
//                case .success(_):
//
////                    upload.uploadProgress(closure: { (progress) in
////                        //print("Upload Progress: \(progress.fractionCompleted)")
////
////
////                        let alertController = UIAlertController(title: "Uploading image", message: "Please wait......", preferredStyle: .alert)
////
////                        let progressDownload : UIProgressView = UIProgressView(progressViewStyle: .default)
////
////                        progressDownload.setProgress(Float((progress.fractionCompleted)/1.0), animated: true)
////                        progressDownload.frame = CGRect(x: 10, y: 70, width: 250, height: 0)
////
////                        alertController.view.addSubview(progressDownload)
////                        self.present(alertController, animated: true, completion: nil)
////
////
////
////                    })
//
//                    upload.responseJSON { response in
//                        print(response.result.value as Any)
//                        // self.dismiss(animated: true, completion: nil)
//                        self.dismiss(animated: true, completion: nil)
//                        if let data = response.value {
//                             let JSON = data as! NSDictionary
//                            // print(JSON)
//
//
//                            var strSuccess : String!
//                            strSuccess = JSON["status"]as Any as? String
//
//                            var strSuccessAlert : String!
//                            strSuccessAlert = JSON["msg"]as Any as? String
//
//                            if strSuccess == "success" {
//                                /*let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BrowsePetStoreId") as? BrowsePetStore
//                                self.navigationController?.pushViewController(push!, animated: true)*/
//
//                                self.navigationController?.popViewController(animated: true)
//
//                            } else {
//                                CRNotifications.showNotification(type: CRNotifications.error, title: "Alert!", message:strSuccessAlert, dismissDelay: 1.5, completion:{})
//
//                            }
//
//                        }
//                        else {
//                            CRNotifications.showNotification(type: CRNotifications.error, title: "Alert!", message:"Server Issue", dismissDelay: 1.5, completion:{})
//                            self.dismiss(animated: true, completion: nil)
//                        }
//
//
//                        // var strSuccessAlert : String!
//                        // strSuccessAlert = response.result.value!["msg"]as Any as? String
//
//
//
//                        // self.navigationController?.popViewController(animated: true)
//                        // self.listofAllSchoolImages()
//                    }
//
//                case .failure(let encodingError):
//                    print(encodingError)
//                    self.dismiss(animated: true, completion: nil)
//                    CRNotifications.showNotification(type: CRNotifications.error, title: "Alert!", message:"Server Issue", dismissDelay: 1.5, completion:{})
//                }*/
//            }
//        }
    }
        
}
    
    @objc func textFieldShouldNotBeEmpty() {
        CRNotifications.showNotification(type: CRNotifications.error, title: "Alert!", message:"Fields should not be Empty.", dismissDelay: 1.5, completion:{})
    }
    
    
    @objc func didStringsPicker() {
        
      
        
    }
    
    @objc func showViewControllerTappedSubCategory(_ sender: UIButton) {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = tbleView.cellForRow(at: indexPath) as! AddNewProductTableCell
        
        if cell.txtSelectCategory.text == "" {
            
            let alert = UIAlertController(title: "Alert!", message: "Please select category first.",preferredStyle: UIAlertController.Style.alert)

            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
                //Cancel Action
                
            }))
           
            
            self.present(alert, animated: true, completion: nil)
            
        } else {
            
            guard let popupVC = self.storyboard?.instantiateViewController(withIdentifier: "secondVC") as? ExamplePopupViewController else { return }
            popupVC.height = self.height
            popupVC.topCornerRadius = self.topCornerRadius
            popupVC.presentDuration = self.presentDuration
            popupVC.dismissDuration = self.dismissDuration
            //popupVC.shouldDismissInteractivelty = dismissInteractivelySwitch.isOn
            popupVC.popupDelegate = self
            popupVC.strGetDetails = "subCategorySection"
            //popupVC.getArrListOfCategory =
            self.present(popupVC, animated: true, completion: nil)
            
        }
        
        
    }
    
    @objc func showViewControllerTapped(_ sender: UIButton) {
        
        
        Utils.RiteVetIndicatorShow()
        
        let urlString = BASE_URL_KREASE
        
        var parameters:Dictionary<AnyHashable, Any>!
        
        parameters = [
            "action"        :   "category"
        ]
        
        
        print("parameters-------\(String(describing: parameters))")
        
        AF.request(urlString, method: .post, parameters: parameters as? Parameters).responseJSON
        {
            response in
            
            switch(response.result) {
            case .success(_):
                if let data = response.value {
                    
                    
                    let JSON = data as! NSDictionary
                    //print(JSON)
                    
                    var strSuccess : String!
                    strSuccess = JSON["status"]as Any as? String
                    
                    if strSuccess == "success" //true
                    {
                        // arrBrowsePetStore
                        
                        self.tbleView!.dataSource = self
                        self.tbleView!.delegate = self
                        
                        let ar : NSArray!
                        ar = (JSON["response"] as! Array<Any>) as NSArray
                        //self.arrListOfCategory = (ar as! Array<Any>)
                        
                        
                        
                        guard let popupVC = self.storyboard?.instantiateViewController(withIdentifier: "secondVC") as? ExamplePopupViewController else { return }
                        popupVC.height = self.height
                        popupVC.topCornerRadius = self.topCornerRadius
                        popupVC.presentDuration = self.presentDuration
                        popupVC.dismissDuration = self.dismissDuration
                        //popupVC.shouldDismissInteractivelty = dismissInteractivelySwitch.isOn
                        popupVC.popupDelegate = self
                        popupVC.strGetDetails = "categorySection"
                        popupVC.getArrListOfCategory = ((JSON["response"] as! Array<Any>) as NSArray as! Array<Any>)
                        
                        self.present(popupVC, animated: true, completion: nil)
                        
                        self.tbleView!.reloadData()
                        
                        Utils.RiteVetIndicatorHide()
                    }
                    else
                    {
                        Utils.RiteVetIndicatorHide()
                    }
                    
                }
                
            case .failure(_):
                print("Error message:\(String(describing: response.error))")
                Utils.RiteVetIndicatorHide()
                
                let alertController = UIAlertController(title: nil, message: SERVER_ISSUE_MESSAGE_ONE+"\n"+SERVER_ISSUE_MESSAGE_TWO, preferredStyle: .actionSheet)
                
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    NSLog("OK Pressed")
                }
                
                alertController.addAction(okAction)
                
                self.present(alertController, animated: true, completion: nil)
                
                break
            }
        }
        
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}


extension AddNewProduct: UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:AddNewProductTableCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! AddNewProductTableCell
        
        cell.backgroundColor = .clear
        
       
        
        Utils.textFieldDR(text: cell.txtSelectCategory, placeHolder: "Select Category*", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: cell.txtSelectSubCategory, placeHolder: "Select Sub Category*", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: cell.txtProductName, placeHolder: "Product Name*", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: cell.txtSKU, placeHolder: "SKU / Product Number*", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: cell.txtShippingFee, placeHolder: "Shipping Fee*", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: cell.txtProductDescription, placeHolder: "Product Description*", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: cell.txtPrice, placeHolder: "Price*", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: cell.txtSpecialPrice, placeHolder: "Special Price*", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: cell.txtUploadImage, placeHolder: "Upload Image*", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: cell.txtQuantity, placeHolder: "Product Quantity*", cornerRadius: 20, color: .white)
        
        
        Utils.textFieldDR(text: cell.txt_Seller_email, placeHolder: "Seller emil*", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: cell.txt_Seller_phone, placeHolder: "Seller phone*", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: cell.txt_seller_company_name, placeHolder: "Seller company name*", cornerRadius: 20, color: .white)
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            Utils.textFieldDR(text: cell.txt_seller_name, placeHolder: "Seller first name*", cornerRadius: 20, color: .white)
            Utils.textFieldDR(text: cell.txt_seller_last_name, placeHolder: "Seller last name*", cornerRadius: 20, color: .white)
            
            cell.txt_seller_name.text = (person["fullName"] as! String)
            cell.txt_seller_last_name.text = (person["lastName"] as! String)
            cell.txt_Seller_email.text = (person["email"] as! String)
            cell.txt_Seller_phone.text = (person["contactNumber"] as! String)
            
            cell.txt_seller_name.backgroundColor = .lightGray
            cell.txt_seller_last_name.backgroundColor = .lightGray
            cell.txt_Seller_email.backgroundColor = .lightGray
            cell.txt_Seller_phone.backgroundColor = .lightGray
            
            cell.txt_seller_name.textColor = .white
            cell.txt_seller_last_name.textColor = .white
            cell.txt_Seller_email.textColor = .white
            cell.txt_Seller_phone.textColor = .white
            
            cell.txt_seller_name.isUserInteractionEnabled = false
            cell.txt_seller_last_name.isUserInteractionEnabled = false
            cell.txt_Seller_email.isUserInteractionEnabled = false
            cell.txt_Seller_phone.isUserInteractionEnabled = false
        }
        
        cell.txtSelectCategory.delegate = self
        
        cell.btnSubmit.layer.cornerRadius = 20
        cell.btnSubmit.clipsToBounds = true
        cell.btnSubmit.backgroundColor = BUTTON_BACKGROUND_COLOR_BLUE
        
        if editStringOrNot == "1" {
            cell.btnSubmit.addTarget(self, action: #selector(editProductWB), for: .touchUpInside)
        }
        else {
            cell.btnSubmit.addTarget(self, action: #selector(addProductWB), for: .touchUpInside)
        }
        
       
        cell.btnUploadImageHiddenButton.addTarget(self, action: #selector(uploadImageOpenActionSheet), for: .touchUpInside)
        
        cell.btnCategory.addTarget(self, action: #selector(showViewControllerTapped(_:)), for: .touchUpInside)
        
        cell.btnSubCategory.addTarget(self, action: #selector(showViewControllerTappedSubCategory(_:)), for: .touchUpInside)

        
        /*
        // id
        if let myString = defaults.string(forKey: "selectCategoryId") {
            print("defaults savedString: \(myString)")
            //defaults.set(nil, forKey: "selectCategoryId") // name
            //defaults.set("", forKey: "selectCategoryId") // name
            
            //defaults.set(nil, forKey: "selectSubCategoryName") // sub cat name
            //defaults.set("", forKey: "selectSubCategoryName") // sub cat name
            //cell.txtSelectSubCategory.text = ""
            
            /*
             var strStoreCategoryId:String!
             var strSubStoreCategoryId:String!
             */
            
            strStoreCategoryId = myString
            
        }
        else
        {
            
        }
        
        // name
        if let myString = defaults.string(forKey: "selectCategoryName") {
            print("defaults savedString: \(myString)")
            cell.txtSelectCategory.text = myString
            // cell.txtSelectSubCategory.text = ""
            //defaults.set(nil, forKey: "selectCategoryName") // name
            //defaults.set("", forKey: "selectCategoryName") // name
        }
        
        
        
        // sub category
        // id
        if let myString2 = defaults.string(forKey: "selectSubCategoryId") {
            print("defaults savedString: \(myString2)")
            //defaults.set(nil, forKey: "selectSubCategoryId") // name
            //defaults.set("", forKey: "selectSubCategoryId") // name
            
            /*
                        var strStoreCategoryId:String!
                        var strSubStoreCategoryId:String!
                        */
            
            strSubStoreCategoryId = myString2
            
        }
        
        // name
        if let myString2 = defaults.string(forKey: "selectSubCategoryName") {
            print("defaults savedString: \(myString2)")
            cell.txtSelectSubCategory.text = myString2
            
            //defaults.set(nil, forKey: "selectSubCategoryName") // name
            //defaults.set("", forKey: "selectSubCategoryName") // name
        }
        else
        {
            cell.txtSelectSubCategory.text = ""
        }
        */
        return cell
    }
    
    
    
    
    @objc func btnSubmitClickMethod(_ sender: UIButton) {
     let buttonPosition = sender.convert(CGPoint.zero, to: self.tbleView)
        let indexPath = self.tbleView.indexPathForRow(at:buttonPosition)
        
        let cell = self.tbleView.cellForRow(at: indexPath!) as! AddNewProductTableCell

        
               Utils.RiteVetIndicatorShow()
               
                   let urlString = BASE_URL_KREASE
                   
                   var parameters:Dictionary<AnyHashable, Any>!
               /*
         action:addproduct
         SKU:3
         userId:4
         categoryId:23
         subCategory:22
         productName:Test
         quantity:10
         price:25.99
         description:sdfsdfsdf
         */
        
        /*
        var strStoreCategoryId:String!
        var strSubStoreCategoryId:String!
        */
        
           if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]
           {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
                       parameters = [
                           "action"        :   "addproduct",
                           "SKU"            :   cell.txtSKU.text!,
                           "userId"       :   myString,
                           "categoryId"    :   String(strStoreCategoryId),
                           "subCategory"   :   String(strSubStoreCategoryId),
                           "productName"   :   cell.txtProductName.text!,
                           "quantity"      :  cell.txtQuantity.text!,
                           
                           "sellerName"      :  cell.txt_seller_name.text!,
                           "sellerEmail"      :  cell.txt_Seller_email.text!,
                           "sellerPhone"      :  cell.txt_Seller_phone.text!,
                           "SellerCompanyName"      :  cell.txt_seller_company_name.text!,
                           
                           "price"        :   cell.txtPrice.text!,
                           "description"   :   cell.txtProductDescription.text!
                       ]
        }
                    
                       print("parameters-------\(String(describing: parameters))")
                       
                       AF.request(urlString, method: .post, parameters: parameters as? Parameters).responseJSON
                           {
                               response in
                   
                               switch(response.result) {
                               case .success(_):
                                  if let data = response.value {

                                   
                                   let JSON = data as! NSDictionary
                                   print(JSON)
                                    
                                      var strSuccess : String!
                                      strSuccess = JSON["status"]as Any as? String
                                   
                                      var strSuccess_2 : String!
                                      strSuccess_2 = JSON["msg"]as Any as? String
                                      
                                   if strSuccess == "success" {
                                   
                                    Utils.RiteVetIndicatorHide()
                                       
                                       let alert = UIAlertController(title: "Success", message: strSuccess_2, preferredStyle: UIAlertController.Style.alert)
                                       alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
                                           
                                           self.navigationController?.popViewController(animated: true)
                                           
                                       }))
                                       
                                       self.present(alert, animated: true, completion: nil)
                                       
                                   }
                                   else
                                   {
                                       Utils.RiteVetIndicatorHide()
                                   }
                                   
                               }

                               case .failure(_):
                                   print("Error message:\(String(describing: response.error))")
                                   Utils.RiteVetIndicatorHide()
                                   
                                   let alertController = UIAlertController(title: nil, message: SERVER_ISSUE_MESSAGE_ONE+"\n"+SERVER_ISSUE_MESSAGE_TWO, preferredStyle: .actionSheet)
                                   
                                   let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                                           UIAlertAction in
                                           NSLog("OK Pressed")
                                       }
                                   
                                   alertController.addAction(okAction)
                                   
                                   self.present(alertController, animated: true, completion: nil)
                                   
                                   break
                                }
                           }
        
           
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 1600
    }
}

extension AddNewProduct: UITableViewDelegate {
    
}

extension AddNewProduct: BottomPopupDelegate {
    
    func bottomPopupViewLoaded() {
        print("bottomPopupViewLoaded")
    }
    
    func bottomPopupWillAppear() {
        print("bottomPopupWillAppear")
    }
    
    func bottomPopupDidAppear() {
        print("bottomPopupDidAppear")
    }
    
    func bottomPopupWillDismiss() {
        print("bottomPopupWillDismiss")
        // one
    }
    
    func bottomPopupDidDismiss() {
        print("bottomPopupDidDismiss")
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! AddNewProductTableCell
        
         // id
               if let myString = defaults.string(forKey: "selectCategoryId") {
                   print("defaults savedString: \(myString)")
                   //defaults.set(nil, forKey: "selectCategoryId") // name
                   //defaults.set("", forKey: "selectCategoryId") // name
                   
                   //defaults.set(nil, forKey: "selectSubCategoryName") // sub cat name
                   //defaults.set("", forKey: "selectSubCategoryName") // sub cat name
                   //cell.txtSelectSubCategory.text = ""
                   
                   /*
                    var strStoreCategoryId:String!
                    var strSubStoreCategoryId:String!
                    */
                   
                   strStoreCategoryId = myString
                   
               }
               else
               {
                   
               }
               
               // name
               if let myString = defaults.string(forKey: "selectCategoryName") {
                   print("defaults savedString: \(myString)")
                   cell.txtSelectCategory.text = myString
                   cell.txtSelectSubCategory.text = ""
                   //defaults.set(nil, forKey: "selectCategoryName") // name
                   //defaults.set("", forKey: "selectCategoryName") // name
               }
               
               
               
               // sub category
               // id
               if let myString2 = defaults.string(forKey: "selectSubCategoryId") {
                   print("defaults savedString: \(myString2)")
                   //defaults.set(nil, forKey: "selectSubCategoryId") // name
                   //defaults.set("", forKey: "selectSubCategoryId") // name
                   
                   /*
                               var strStoreCategoryId:String!
                               var strSubStoreCategoryId:String!
                               */
                   
                   strSubStoreCategoryId = myString2
                   
               }
               
               // name
               if let myString2 = defaults.string(forKey: "selectSubCategoryName") {
                   print("defaults savedString: \(myString2)")
                   cell.txtSelectSubCategory.text = myString2
                   
                   //defaults.set(nil, forKey: "selectSubCategoryName") // name
                   //defaults.set("", forKey: "selectSubCategoryName") // name
               }
               else
               {
                   cell.txtSelectSubCategory.text = ""
               }
               
       
    }
    
    func bottomPopupDismissInteractionPercentChanged(from oldValue: CGFloat, to newValue: CGFloat) {
        print("bottomPopupDismissInteractionPercentChanged fromValue: \(oldValue) to: \(newValue)")
    }
}


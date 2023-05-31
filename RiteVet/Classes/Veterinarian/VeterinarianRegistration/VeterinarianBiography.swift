//
//  VeterinarianBiography.swift
//  RiteVet
//
//  Created by Apple  on 28/11/19.
//  Copyright © 2019 Apple . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RSLoadingView
import CRNotifications
import SDWebImage

class VeterinarianBiography: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate {

    let cellReuseIdentifier = "veterinarianBiographyTableCell"
    
    var btnCheckUncheckCode:UIButton!
    
    var arrSubscription = [
                            "1",
                            ]
    
    var imageStr:String!
    var imgData:Data!
    
    var strUploadYourProfilePicture:String!
    var strUploadYourBusinessPicture:String!
    var strUploadEstimatedPriceList:String!
    var strUploadTranscript:String!
    var strUploadLicense:String!
    var strUploadSupportDocumentation:String!
    
    var strChekcTerm:String!
    
    @IBOutlet weak var viewNavigation:UIView! {
        didSet {
            viewNavigation.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }
    @IBOutlet weak var btnBack:UIButton!
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "VETERINARIAN REGISTRATION"
            lblNavigationTitle.textColor = .white
        }
    }
    
    
    @IBOutlet weak var tbleView: UITableView! {
        didSet {
            tbleView.delegate = self
            tbleView.dataSource = self
            tbleView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
            tbleView.backgroundColor = .clear
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /****** VIEW BG IMAGE *********/
        self.view.backgroundColor = UIColor.init(patternImage: UIImage(named: "plainBack")!)
        
        btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        
        strChekcTerm = "0"
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        /*if let person = UserDefaults.standard.value(forKey: "saveVeterinarianRegistration") as? [String:Any] {
         print(person as Any)
            
            let cell = tbleView.cellForRow(at: NSIndexPath(row: 0, section: 0) as IndexPath) as! VeterinarianBiographyTableCell
            
            //let ownPicture : String = (person["ownPicture"] as! String)
            
            //print((person["ownPicture"] as! String))
            
            cell.imgUploadProfilePicture.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.imgUploadProfilePicture.sd_setImage(with: URL(string: (person["ownPicture"] as! String)), placeholderImage: UIImage(named: "plainBack")) // my profile image
            
            cell.imgUploadYourBusinessProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.imgUploadYourBusinessProfile.sd_setImage(with: URL(string: (person["BImage"] as! String)), placeholderImage: UIImage(named: "plainBack")) // business profile image
            
            cell.imgUploadEstimatedPriceList.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
            cell.imgUploadEstimatedPriceList.sd_setImage(with: URL(string: (person["estimatePrice"] as! String)), placeholderImage: UIImage(named: "plainBack")) // estimated price list
            
            cell.imgUploadUploadTranscript.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
            cell.imgUploadUploadTranscript.sd_setImage(with: URL(string: (person["uploadTranscript"] as! String)), placeholderImage: UIImage(named: "plainBack")) // transcript
            
            cell.imgUploadLicense.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
            cell.imgUploadLicense.sd_setImage(with: URL(string: (person["uploadLicense"] as! String)), placeholderImage: UIImage(named: "plainBack")) // license
            
            cell.imgUploadSupportDocumentation.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
            cell.imgUploadSupportDocumentation.sd_setImage(with: URL(string: (person["uploadDocument"] as! String)), placeholderImage: UIImage(named: "plainBack")) // support documantation
            
        }*/
        
        self.welcome4()
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }

}

extension VeterinarianBiography: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSubscription.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:VeterinarianBiographyTableCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! VeterinarianBiographyTableCell
        
        cell.backgroundColor = .clear
        
        cell.lblTitle.text = "Veterinarian Biography"
        
        cell.txtView.text = "Message"
        cell.txtView.layer.cornerRadius = 20
        cell.txtView.clipsToBounds = true
        
        Utils.textFieldDR(text: cell.txtUpload, placeHolder: "Upload your Picture", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: cell.txtUploadYourBusinessPicture, placeHolder: "Upload Business Picture", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: cell.txtEstimatedPriceList, placeHolder: "Estimated Price List", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: cell.txtUploadTranscript, placeHolder: "Upload Transcript", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: cell.txtLicense, placeHolder: "License", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: cell.txtSupportDocumentation, placeHolder: "Supporting Document", cornerRadius: 20, color: .white)
       
        Utils.buttonDR(button: cell.btnNext, text: "NEXT", backgroundColor: BUTTON_BACKGROUND_COLOR_BLUE, textColor: BUTTON_TEXT_COLOR, cornerRadius: 20)
        
        //cell.btnCheckUncheck.addTarget(self, action: #selector(btnCheckUncheckClickMethod), for: .touchUpInside)
        //cell.btnCheckUncheck.tag = 0
        
        cell.btnCheckUncheck.isHidden = true
        
        btnCheckUncheckCode = UIButton(frame: CGRect(x: 15, y: 528, width: 34, height: 34))
        btnCheckUncheckCode.tag = 0
        btnCheckUncheckCode.setImage(UIImage(named: "tickWhite"), for: .normal)
        btnCheckUncheckCode.addTarget(self, action: #selector(btnCheckUncheckClickMethod), for: .touchUpInside)
        cell.addSubview(btnCheckUncheckCode)
        
        
        
        
        cell.btnUploadYourPicture.addTarget(self, action: #selector(uploadProfilePictureClickMethod), for: .touchUpInside)
        cell.btnUploadYourBusinessProfile.addTarget(self, action: #selector(uploadYourBusinessProfilePictureClickMethod), for: .touchUpInside)
        cell.btnEstimatedPriceList.addTarget(self, action: #selector(estimatedPriceListClickMethod), for: .touchUpInside)
        cell.btnUploadTranscript.addTarget(self, action: #selector(transcriptClickMethod), for: .touchUpInside)
        cell.btnLicense.addTarget(self, action: #selector(licenseClickMethod), for: .touchUpInside)
        cell.btnUploadSupportDocumantation.addTarget(self, action: #selector(SupportDocumentationClickMethod), for: .touchUpInside)
        
        cell.btnNext.addTarget(self, action: #selector(nextClick(_:)), for: .touchUpInside)
        
        return cell
    }
    
    /*
    var strUploadYourProfilePicture:String!
    var strUploadYourBusinessPicture:String!
    var strUploadEstimatedPriceList:String!
    var strUploadTranscript:String!
    var strUploadLicense:String!
    var strUploadSupportDocumentation:String!
    */
    
    /*
     strUploadYourProfilePicture
     strUploadYourBusinessPicture
     strUploadEstimatedPriceList
     strUploadTranscript
     strUploadLicense
     strUploadSupportDocumentation
     */
    
    @objc func uploadProfilePictureClickMethod() {
        strUploadYourProfilePicture = "1"
        self.uploadImageOpenActionSheet(strWhoIam: "1")
    }
    @objc func uploadYourBusinessProfilePictureClickMethod() {
        strUploadYourBusinessPicture = "2"
        self.uploadImageOpenActionSheet(strWhoIam: "2")
    }
    @objc func estimatedPriceListClickMethod() {
        strUploadEstimatedPriceList = "3"
        self.uploadImageOpenActionSheet(strWhoIam: "3")
    }
    @objc func transcriptClickMethod() {
        strUploadTranscript = "4"
        self.uploadImageOpenActionSheet(strWhoIam: "4")
    }
    @objc func licenseClickMethod() {
        strUploadLicense = "5"
        self.uploadImageOpenActionSheet(strWhoIam: "5")
    }
    @objc func SupportDocumentationClickMethod() {
        strUploadSupportDocumentation = "6"
        self.uploadImageOpenActionSheet(strWhoIam: "6")
    }
    
    @objc func uploadImageOpenActionSheet(strWhoIam:String) {
        
        if strWhoIam == "1" {
            self.openActionSheet()
        }
        else
        if strWhoIam == "2" {
            self.openActionSheet()
        }
        else
        if strWhoIam == "3" {
            self.openActionSheet()
        }
        else
        if strWhoIam == "4" {
            self.openActionSheet()
        }
        else
        if strWhoIam == "5" {
            self.openActionSheet()
        }
        else
        if strWhoIam == "6" {
            self.openActionSheet()
        }
        
    }
    
    @objc func openActionSheet() {
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
            
            let cell = tbleView.cellForRow(at: NSIndexPath(row: 0, section: 0) as IndexPath) as! VeterinarianBiographyTableCell
            
            
            
            /*
            strUploadYourProfilePicture
            strUploadYourBusinessPicture
            strUploadEstimatedPriceList
            strUploadTranscript
            strUploadLicense
            strUploadSupportDocumentation
            */
            
            //print(strUploadYourProfilePicture as Any)
            //print(strUploadYourBusinessPicture as Any)
            //print(strUploadEstimatedPriceList as Any)
            //print(strUploadTranscript as Any)
            //print(strUploadLicense as Any)
            //print(strUploadSupportDocumentation as Any)
            
            /*
            ownPicture:
            BImage:
            estimatePrice:
            uploadTranscript:
            uploadLicense:
            uploadDocument:
            */
            
            if  strUploadYourProfilePicture == "1" {
                let image_data = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
                
                cell.imgUploadProfilePicture.image = image_data // show image on image view
                let imageData:Data = image_data!.pngData()!
                imageStr = imageData.base64EncodedString()
                self.dismiss(animated: true, completion: nil)
                imgData = image_data!.jpegData(compressionQuality: 0.2)!
                
                // webservice done
                self.uploadImage(strImageName: "ownPicture")
                
            }
            else
            if  strUploadYourBusinessPicture == "2" {
                let image_data = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
                
                cell.imgUploadYourBusinessProfile.image = image_data // show image on image view
                let imageData:Data = image_data!.pngData()!
                imageStr = imageData.base64EncodedString()
                self.dismiss(animated: true, completion: nil)
                imgData = image_data!.jpegData(compressionQuality: 0.2)!
                
                // webservice done
                self.uploadImage(strImageName: "BImage")
            }
            else
            if  strUploadEstimatedPriceList == "3" {
                let image_data = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
                
                cell.imgUploadEstimatedPriceList.image = image_data // show image on image view
                let imageData:Data = image_data!.pngData()!
                imageStr = imageData.base64EncodedString()
                self.dismiss(animated: true, completion: nil)
                imgData = image_data!.jpegData(compressionQuality: 0.2)!
                
                // webservice done
                self.uploadImage(strImageName: "estimatePrice")
            }
            else
            if  strUploadTranscript == "4" {
                let image_data = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
                
                cell.imgUploadUploadTranscript.image = image_data // show image on image view
                let imageData:Data = image_data!.pngData()!
                imageStr = imageData.base64EncodedString()
                self.dismiss(animated: true, completion: nil)
                imgData = image_data!.jpegData(compressionQuality: 0.2)!
                
                // webservice done
                self.uploadImage(strImageName: "uploadTranscript")
            }
            else
            if  strUploadLicense == "5" {
                let image_data = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
                
               cell.imgUploadLicense.image = image_data // show image on image view
                let imageData:Data = image_data!.pngData()!
                imageStr = imageData.base64EncodedString()
                self.dismiss(animated: true, completion: nil)
                imgData = image_data!.jpegData(compressionQuality: 0.2)!
                
                // webservice done
                self.uploadImage(strImageName: "uploadLicense")
            }
            else
            if  strUploadSupportDocumentation == "6" {
                let image_data = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
                
                cell.imgUploadSupportDocumentation.image = image_data // show image on image view
                let imageData:Data = image_data!.pngData()!
                imageStr = imageData.base64EncodedString()
                self.dismiss(animated: true, completion: nil)
                imgData = image_data!.jpegData(compressionQuality: 0.2)!
                
                // webservice done
                self.uploadImage(strImageName: "uploadDocument")
            }
            
            
            
            
                //print(type(of: imgData))
                //print(imgData as Any)
            
    }
    
    @objc func allZeroImageString() {
        strUploadYourProfilePicture = "0"
        strUploadYourBusinessPicture = "0"
        strUploadEstimatedPriceList = "0"
        strUploadTranscript = "0"
        strUploadLicense = "0"
        strUploadSupportDocumentation = "0"
    }
    
    @objc func uploadImage(strImageName:String!) {
            
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
              
            var urlRequest = URLRequest(url: URL(string: BASE_URL_KREASE)!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0 * 1000)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
            
            // let indexPath = IndexPath.init(row: 0, section: 0)
            // let cell = self.tablView.cellForRow(at: indexPath) as! AddTableTableViewCell
            
            //Set Your Parameter
            let parameterDict = [
                "action"          :   "petparentregistration",
                "userId"          :   String(myString),
                "UTYPE"           :   "2",
                "biography"        :  "",
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
                            
                            var dict: Dictionary<AnyHashable, Any>
                            dict = dictionary["data"] as! Dictionary<AnyHashable, Any>
                                
                            let defaults = UserDefaults.standard
                            defaults.setValue(dict, forKey: "saveVeterinarianRegistration")
                                
                            self.dismiss(animated: true, completion: nil)
                                
                            self.allZeroImageString()
                            
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
                "action"          :   "petparentregistration",
                "userId"          :   String(myString),
                "UTYPE"           :   "2",
                "biography"        :  "",
            ] //Optional for extra parameter
                
            print(parameters as Any)
                
            Alamofire.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(self.imgData, withName: strImageName,fileName: "riteVetImage.jpg", mimeType: "image/jpg")
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                } //Optional for extra parameters
            },
            to:BASE_URL_KREASE)
            { (result) in
                switch result {
                case .success(let upload, _, _):

                    upload.uploadProgress(closure: { (progress) in
                            //print("Upload Progress: \(progress.fractionCompleted)")
                            

                        /*let alertController = UIAlertController(title: nil, message: "Please wait......", preferredStyle: .alert)
                        let progressDownload : UIProgressView = UIProgressView(progressViewStyle: .default)

                        progressDownload.setProgress(Float((progress.fractionCompleted)/1.0), animated: true)
                        progressDownload.frame = CGRect(x: 10, y: 70, width: 250, height: 0)

                        alertController.view.addSubview(progressDownload)
                        self.present(alertController, animated: true, completion: nil)*/
                            
                    })

                    upload.responseJSON { response in
                            //print(response.result.value as Any)
                        if let data = response.value {
                            let JSON = data as! NSDictionary
                                
                            var dict: Dictionary<AnyHashable, Any>
                            dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                                
                            let defaults = UserDefaults.standard
                            defaults.setValue(dict, forKey: "saveVeterinarianRegistration")
                                
                            self.dismiss(animated: true, completion: nil)
                                
                            self.allZeroImageString()
                            }
                            else {
                                self.dismiss(animated: true, completion: nil)
                                CRNotifications.showNotification(type: CRNotifications.success, title: "Error!", message:"Server Not Responding. Please try again Later.", dismissDelay: 1.5, completion:{})

                            }
                            
                    }

                case .failure(let encodingError):
                    print(encodingError)
                    self.dismiss(animated: true, completion: nil)
                }
            }*/
        }
    }
    
    @objc func nextClick(_ sender:UIButton) {
        
        let cell = tbleView.cellForRow(at: NSIndexPath(row: 0, section: 0) as IndexPath) as! VeterinarianBiographyTableCell
        
        if cell.txtView.text == "Message" {
            CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Biography should not be Empty.", dismissDelay: 1.5, completion:{})

        }
        else if cell.txtView.text == "" {
            CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Biography should not be Empty.", dismissDelay: 1.5, completion:{})
        }
        else
        {
            if strChekcTerm == "0" {
                CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Please accept our Terms and Conditions.", dismissDelay: 1.5, completion:{})
            }
            else
            {
                self.biographyWebservice(strBiographyText: cell.txtView.text)
            }
        }
    }
    
    @objc func welcome4() {
        // indicator.startAnimating()
        Utils.RiteVetIndicatorShow()
           
        let urlString = BASE_URL_KREASE
               
        var parameters:Dictionary<AnyHashable, Any>!
           
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            // print(person as Any)
            
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            parameters = [
                "action"    : "returnprofile",
                "userId"    : String(myString),
                "UTYPE"     : "2"
            ]
        }
                
        print("parameters-------\(String(describing: parameters))")
                   
        AF.request(urlString, method: .post, parameters: parameters as? Parameters).responseJSON { [self]
            response in
               
            switch(response.result) {
            case .success(_):
                if let data = response.value {

                    let JSON = data as! NSDictionary
                    print(JSON)
                    
                    var strSuccess : String!
                    strSuccess = JSON["status"]as Any as? String
                              
                    if strSuccess == "success" {
                        Utils.RiteVetIndicatorHide()
                        
                         var dict: Dictionary<AnyHashable, Any>
                         dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                        
                        let cell = tbleView.cellForRow(at: NSIndexPath(row: 0, section: 0) as IndexPath) as! VeterinarianBiographyTableCell
                        
                        cell.txtView.text = (dict["biography"] as! String)
                        
                        cell.imgUploadProfilePicture.sd_imageIndicator = SDWebImageActivityIndicator.gray
                        cell.imgUploadProfilePicture.sd_setImage(with: URL(string: (dict["ownPicture"] as! String)), placeholderImage: UIImage(named: "plainBack")) // my profile image
                        
                        cell.imgUploadYourBusinessProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
                        cell.imgUploadYourBusinessProfile.sd_setImage(with: URL(string: (dict["BImage"] as! String)), placeholderImage: UIImage(named: "plainBack")) // business profile image
                        
                        cell.imgUploadEstimatedPriceList.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                        cell.imgUploadEstimatedPriceList.sd_setImage(with: URL(string: (dict["estimatePrice"] as! String)), placeholderImage: UIImage(named: "plainBack")) // estimated price list
                        
                        cell.imgUploadUploadTranscript.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                        cell.imgUploadUploadTranscript.sd_setImage(with: URL(string: (dict["uploadTranscript"] as! String)), placeholderImage: UIImage(named: "plainBack")) // transcript
                        
                        cell.imgUploadLicense.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                        cell.imgUploadLicense.sd_setImage(with: URL(string: (dict["uploadLicense"] as! String)), placeholderImage: UIImage(named: "plainBack")) // license
                        
                        cell.imgUploadSupportDocumentation.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                        cell.imgUploadSupportDocumentation.sd_setImage(with: URL(string: (dict["uploadDocument"] as! String)), placeholderImage: UIImage(named: "plainBack")) // support documantation
                           
                    }
                    else {
                        Utils.RiteVetIndicatorHide()
                        //  self.indicator.stopAnimating()
                        //  self.enableService()
                    }
                }

            case .failure(_):
                print("Error message:\(String(describing: response.error))")
                Utils.RiteVetIndicatorHide()
                
//                               self.indicator.stopAnimating()
//                               self.enableService()
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
    
    @objc func biographyWebservice(strBiographyText:String!) {
        
        Utils.RiteVetIndicatorShow()
           
        let urlString = BASE_URL_KREASE
               
        var parameters:Dictionary<AnyHashable, Any>!
           
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]
        {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
                   parameters = [
                       "action"          :   "petparentregistration",
                       "userId"          :   String(myString),
                       "UTYPE"           :   "2",
                       "biography"    :   String(strBiographyText)
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
                               //print(JSON)
                               
                               var strSuccess : String!
                               strSuccess = JSON["status"]as Any as? String
                               
                               if strSuccess == "success" {
                                   var dict: Dictionary<AnyHashable, Any>
                                   dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                                   
                                let defaults = UserDefaults.standard
                                defaults.setValue(dict, forKey: "saveVeterinarianRegistration")
                                
                                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SetYourAvailabilityId")
                                self.navigationController?.pushViewController(push, animated: true)
                                
                                // AddVeterinarianBankInfo
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
    
    @objc func btnCheckUncheckClickMethod() {
        if btnCheckUncheckCode.tag == 0 {
        //strExcoticBirds = "excoticBirdsGreen"
            strChekcTerm = "1"
             btnCheckUncheckCode.setImage(UIImage(named: "tickGreen"), for: .normal)
             btnCheckUncheckCode.tag = 1
         }
         else if btnCheckUncheckCode.tag == 1 {
        //strExcoticBirds = "excoticBirdsWhite"
            strChekcTerm = "0"
             btnCheckUncheckCode.setImage(UIImage(named: "tickWhite"), for: .normal)
             btnCheckUncheckCode.tag = 0
         }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 1000
    }
}

extension VeterinarianBiography: UITableViewDelegate {
    
}

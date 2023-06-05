//
//  SubmitPost.swift
//  RiteVet
//
//  Created by Apple  on 02/12/19.
//  Copyright © 2019 Apple . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CRNotifications
import BottomPopup
import AVKit

class SubmitPost: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate,UIPickerViewDelegate, UIPickerViewDataSource {

    let cellReuseIdentifier = "submitPostTableCell"
    
    // multiple picker UI
    let regularFont = UIFont.systemFont(ofSize: 16)
    let boldFont = UIFont.boldSystemFont(ofSize: 16)
    
    var imageStr:String!
    var imgData:Data!
    
    // 2
    var imageStr2:String!
    var imgData2:Data!
    
    // 3
    var imageStr3:String!
    var imgData3:Data!
    
    // 4
    var imageStr4:String!
    var imgData4:Data!
    
    // 5
    var imageStr5:String!
    var imgData5:Data!
    
    //let pickerView = UIPickerView()
    //let colors = ["Red","Yellow","Green","Blue"]
    
    var myCatIdIs:String!
    
    // bottom view popup
    var height: CGFloat = 600 // height
    var topCornerRadius: CGFloat = 35 // corner
    var presentDuration: Double = 0.8 // present view time
    var dismissDuration: Double = 0.5 // dismiss view time
    let kHeightMaxValue: CGFloat = 600 // maximum height
    let kTopCornerRadiusMaxValue: CGFloat = 35 //
    let kPresentDurationMaxValue = 3.0
    let kDismissDurationMaxValue = 3.0
    
    var arrListCategory  = ["Fish","Cat","Bird","Dog","Animal","Reptiles","Large Animal"]
    var pickerView:UIPickerView?
    
    var strCheckWhichImage:String!
    
    var strCheckImageOne:String!
    var strCheckImageTwo:String!
    var strCheckImageThree:String!
    var strCheckImageFour:String!
    var strCheckImageFive:String!
    
    var arrListOfCategory:Array<Any>!
    
    // video
    let imagePickerController = UIImagePickerController()
    var videoURL: NSURL?
    var strYesIamVideo:String!
    var saveSelectedVideoURLforServer:URL!
    
    var dictGetPostForEdit:NSDictionary!
    
    @IBOutlet weak var viewNavigation:UIView! {
        didSet {
            viewNavigation.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }
    @IBOutlet weak var btnBack:UIButton!
    
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "SUBMIT POST"
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
    
    var hereForEdit:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /****** VIEW BG IMAGE *********/
        self.view.backgroundColor = UIColor.init(patternImage: UIImage(named: "plainBack")!)
     
     //self.view.backgroundColor = .white
     
        let defaults = UserDefaults.standard
        if let name = defaults.string(forKey: "keySideBarMenuSubmitPost") {
            print(name)
            if name == "SubmitPostMenuBar" {
             // menu
                btnBack.setImage(UIImage(named: "menuWhite"), for: .normal)
                self.sideBarMenu()
            }
            else
            {
                btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
            }
        }
        else
        {
            btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        }
        
        
        strCheckImageOne = "0"
        strCheckImageTwo = "0"
        strCheckImageThree = "0"
        strCheckImageFour = "0"
        strCheckImageFive = "0"
        
        // this string is for video
        strYesIamVideo = "0"
        
        self.pickerView = UIPickerView()
        self.pickerView?.delegate = self
        self.pickerView?.dataSource = self
        
        let cell = tbleView.cellForRow(at: NSIndexPath(row: 0, section: 0) as IndexPath) as! SubmitPostTableCell
        cell.txtSelectCategory.inputView = self.pickerView
        
        self.pickerView?.backgroundColor = BUTTON_BACKGROUND_COLOR_BLUE
        
        self.category()
    }
    @objc func sideBarMenu() {
        
        let defaults = UserDefaults.standard
        defaults.set("", forKey: "keySideBarMenuSubmitPost")
        defaults.set(nil, forKey: "keySideBarMenuSubmitPost")
        
            if revealViewController() != nil {
            btnBack.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            
                revealViewController().rearViewRevealWidth = 300
                view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
              }
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

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let cell = tbleView.cellForRow(at: NSIndexPath(row: 0, section: 0) as IndexPath) as! SubmitPostTableCell
        
        if cell.txtSelectCategory.isFirstResponder {
            return arrListCategory.count
        }
        
        return 0
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let cell = tbleView.cellForRow(at: NSIndexPath(row: 0, section: 0) as IndexPath) as! SubmitPostTableCell
        
        if cell.txtSelectCategory.isFirstResponder {
            return arrListCategory[row]
        }
        return nil
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let cell = tbleView.cellForRow(at: NSIndexPath(row: 0, section: 0) as IndexPath) as! SubmitPostTableCell
        
        if cell.txtSelectCategory.isFirstResponder {
            let itemSelected = arrListCategory[row]
            cell.txtSelectCategory.text = itemSelected
        }
        
        
        
        
        
        
    }
    
    // open video section
    // MARK:- OPEN VIDEO FROM GALLERY
    @objc func openVideoFromGallery() {
        let cell = tbleView.cellForRow(at: NSIndexPath(row: 0, section: 0) as IndexPath) as! SubmitPostTableCell
        
        if cell.imgOne.image == nil {
            let alertController = UIAlertController(title: nil, message: "Please Upload atleast One Product Image before uploading Video.", preferredStyle: .actionSheet)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    //NSLog("OK Pressed")
                }
            
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
        else {
        strYesIamVideo = "1"
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = [/*"public.image", */"public.movie"]

        present(imagePickerController, animated: true, completion: nil)
        }
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        videoURL = info["UIImagePickerControllerReferenceURL"] as? NSURL
        print(videoURL as Any)
        imagePickerController.dismiss(animated: true, completion: nil)
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
      
        let cell = tbleView.cellForRow(at: NSIndexPath(row: 0, section: 0) as IndexPath) as! SubmitPostTableCell
        
        cell.txtUploadImage.placeholder = ""
        // mediaURL
    
        if strYesIamVideo == "1" {
            // videoURL = info["UIImagePickerControllerReferenceURL"] as? NSURL
            videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? NSURL
            print(videoURL as Any)
            print("videoURL:\(String(describing: videoURL))")
            cell.btnVideoPlay.isHidden = false
            cell.btnVideoPlay.addTarget(self, action: #selector(playVideoBeforUploadToServer), for: .touchUpInside)
            saveSelectedVideoURLforServer = videoURL as URL?
            imagePickerController.dismiss(animated: true, completion: nil)
            strYesIamVideo = "2"
        }
        else
        {
        if  strCheckImageOne == "0" {
            let image_data = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            cell.imgOne.image = image_data // show image on image view
            let imageData:Data = image_data!.pngData()!
            imageStr = imageData.base64EncodedString()
            self.dismiss(animated: true, completion: nil)
            imgData = image_data!.jpegData(compressionQuality: 0.2)!
            strCheckImageOne = "1"
        }
        else if  strCheckImageTwo == "0" {
            let image_data = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            cell.imgTwo.image = image_data // show image on image view
            let imageData:Data = image_data!.pngData()!
            imageStr2 = imageData.base64EncodedString()
            self.dismiss(animated: true, completion: nil)
            imgData2 = image_data!.jpegData(compressionQuality: 0.2)!
            
            strCheckImageTwo = "1"
        }
        else if  strCheckImageThree == "0" {
            let image_data = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            cell.imgThree.image = image_data // show image on image view
            let imageData:Data = image_data!.pngData()!
            imageStr3 = imageData.base64EncodedString()
            self.dismiss(animated: true, completion: nil)
            imgData3 = image_data!.jpegData(compressionQuality: 0.2)!
            
            strCheckImageThree = "1"
        }
        else if  strCheckImageFour == "0" {
            let image_data = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            cell.imgFour.image = image_data // show image on image view
            let imageData:Data = image_data!.pngData()!
            imageStr4 = imageData.base64EncodedString()
            self.dismiss(animated: true, completion: nil)
            imgData4 = image_data!.jpegData(compressionQuality: 0.2)!
            
            strCheckImageFour = "1"
        }
        else if  strCheckImageFive == "0" {
            let image_data = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            cell.imgFive.image = image_data // show image on image view
            let imageData:Data = image_data!.pngData()!
            imageStr5 = imageData.base64EncodedString()
            self.dismiss(animated: true, completion: nil)
            imgData5 = image_data!.jpegData(compressionQuality: 0.2)!
            
            strCheckImageFive = "1"
        }
        
        else
        {
            print("for video")
            
        }
        }
            // webservice done
            //self.uploadImage(strImageName: "ownPicture")
            
        
        
    }
    
    @objc func playVideoBeforUploadToServer() {
        if videoURL != nil{
            let player = AVPlayer(url: saveSelectedVideoURLforServer)

          let playerViewController = AVPlayerViewController()
          playerViewController.player = player

            present(playerViewController, animated: true) {
            playerViewController.player!.play()
          }
        }
    }
    
    @objc func category() {
        
                   //self.pushFromLoginPage()
                   
                   //indicator.startAnimating()
        //           self.disableService()
                   
        Utils.RiteVetIndicatorShow()
                   
        let urlString = BASE_URL_KREASE
                       
        var parameters:Dictionary<AnyHashable, Any>!
                   
        parameters = [
            "action"        :   "category"
        ]
                      
                        
        print("parameters-------\(String(describing: parameters))")
                           
        AF.request(urlString, method: .post, parameters: parameters as? Parameters).responseJSON {
            response in
                       
            switch(response.result) {
            case .success(_):
                if let data = response.value {

                    let JSON = data as! NSDictionary
                                       //print(JSON)
                                       
                    var strSuccess : String!
                    strSuccess = JSON["status"]as Any as? String
                                       
                                       //var strSuccessAlert : String!
                                       //strSuccessAlert = JSON["msg"]as Any as? String
                                       
                    if strSuccess == "success" {
                        Utils.RiteVetIndicatorHide()
        //                                   self.pushFromLoginPage()
                                        
                        let ar : NSArray!
                        ar = (JSON["response"] as! Array<Any>) as NSArray
                                        //print(ar as Any)
                                            
                        self.arrListOfCategory = (ar as! Array<Any>)
                                        
                                        
                      
                        
                        
                        if self.hereForEdit == "editPost" {
                            print("edit")
                            
                            print(self.dictGetPostForEdit as Any)
                            
                            let cell = self.tbleView.cellForRow(at: NSIndexPath(row: 0, section: 0) as IndexPath) as! SubmitPostTableCell
                            
                            cell.txtPostTitle.text = (self.dictGetPostForEdit["postTitle"] as! String)
                            cell.txtSelectCategory.text = (self.dictGetPostForEdit["categoryName"] as! String)
                            cell.txtDescription.text = (self.dictGetPostForEdit["description"] as! String)
                            // cell.txtPostTitle.text = (self.dictGetPostForEdit[""] as! String)
                            // cell.txtPostTitle.text = (self.dictGetPostForEdit[""] as! String)
                            // cell.txtUploadVideoLink.text = (self.dictGetPostForEdit[""] as! String)
                            
                            // cell.imgOne
                            
                            cell.imgOne.sd_setImage(with: URL(string: (self.dictGetPostForEdit["image_1"] as! String)), placeholderImage: UIImage(named: "logo"))
                            
                            cell.imgTwo.sd_setImage(with: URL(string: (self.dictGetPostForEdit["image_2"] as! String)), placeholderImage: UIImage(named: "logo"))
                            
                            cell.imgThree.sd_setImage(with: URL(string: (self.dictGetPostForEdit["image_3"] as! String)), placeholderImage: UIImage(named: "logo"))
                            
                            cell.imgFour.sd_setImage(with: URL(string: (self.dictGetPostForEdit["image_4"] as! String)), placeholderImage: UIImage(named: "logo"))
                            
                            cell.imgFive.sd_setImage(with: URL(string: (self.dictGetPostForEdit["image_5"] as! String)), placeholderImage: UIImage(named: "logo"))
                            
                            let x : Int = (self.dictGetPostForEdit["categoryId"] as! Int)
                            let myString = String(x)
                            self.myCatIdIs = String(myString)
                            
                            // let testImage = NSData(contentsOf: (self.dictGetPostForEdit["image_1"]) as! URL)
                            // self.imgData = testImage as Data?
                            
                            
                            let url = URL(string: (self.dictGetPostForEdit["image_1"] as! String))
                            let data = try? Data(contentsOf: url!)

                             if let imageData = data {
                                print(imageData as Any)
                                self.imgData = imageData
                                
                                // let image = UIImage(data: imageData)
                             }
                             
                            
                        } else {
                            print("add")
                        }
                        
                                        //self.arrListCategory = self
                                        
                                        
                                        //self.tbleView.reloadData()
                    }
                    else {
                        Utils.RiteVetIndicatorHide()
        //                                   self.indicator.stopAnimating()
        //                                   self.enableService()
                    }
                                       
                }

                case .failure(_):
                    print("Error message:\(String(describing: response.error))")
        //                               self.indicator.stopAnimating()
        //                               self.enableService()
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
    
    // MARK:- IMAGE 1 -
    @objc func uploadImageWB() {
            
        /*
         action: addstaff
         userId:
         categoryId:
         postTitle:
         description:
         image_1:
         image_2:
         image_3:
         image_4:
         image_5:
         video:
         */
        
        let cell = tbleView.cellForRow(at: NSIndexPath(row: 0, section: 0) as IndexPath) as! SubmitPostTableCell
        
        if cell.txtPostTitle.text == "" {
            CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Field should not be Empty.", dismissDelay: 1.5, completion:{})
        }
        else
        if cell.txtSelectCategory.text == "" {
                CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Field should not be Empty.", dismissDelay: 1.5, completion:{})
        }
        else
        if cell.txtDescription.text == "" {
                CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Field should not be Empty.", dismissDelay: 1.5, completion:{})
        }
        else
        if cell.imgOne.image == nil {
            let alertController = UIAlertController(title: nil, message: "Please Upload At Least One Product Image.", preferredStyle: .actionSheet)
            
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
                  
                let strEditOrAdd:String!
                
                if self.hereForEdit == "editPost" {
                    strEditOrAdd = "editstaff"
                } else {
                    strEditOrAdd = "addstaff"
                }
                
                var urlRequest = URLRequest(url: URL(string: BASE_URL_KREASE)!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0 * 1000)
                urlRequest.httpMethod = "POST"
                urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
                
                // let indexPath = IndexPath.init(row: 0, section: 0)
                // let cell = self.tablView.cellForRow(at: indexPath) as! AddTableTableViewCell
                
                //Set Your Parameter
                let parameterDict = [
                    "action"          : String(strEditOrAdd),
                    "userId"          : String(myString),
                    "categoryId"       : String(myCatIdIs),
                    "postTitle"        : String(cell.txtPostTitle.text!),
                    "description"      : String(cell.txtDescription.text!),
                    // "videolink"         : String(cell.txtUploadVideoLink.text!),
                ]
                
 
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
                                
                                let JSON = dictionary
                                print(JSON)
                                
                                //var dict: Dictionary<AnyHashable, Any>
                                //dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                                
                                
                                //print(dict)
                                
                                let ar : NSArray!
                                ar = (JSON["data"] as! Array<Any>) as NSArray
                                let item = ar[0] as? [String:Any]
                                let x : Int = item!["staffId"] as! Int
                                let myString = String(x)
                                
                                /*
                                        var strCheckImageOne:String!
                                        var strCheckImageTwo:String!
                                        var strCheckImageThree:String!
                                        var strCheckImageFour:String!
                                        var strCheckImageFive:String!
                                    */
                             
                                if self.strYesIamVideo == "2" {
                                    // upload video then check image two
                                    self.uploadVideoToServer(staffId:myString)
                                }
                                else {
                                    if self.strCheckImageTwo == "1" {
                                        self.uploadImageSecondImage(staffId: myString)
                                    }
                                    else {
                                        print("only one image")
                                        Utils.RiteVetIndicatorHide()
                                        self.dismiss(animated: true, completion: nil)
                                        
                                        self.pushToFreeStuff()
                                    }
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
                
                /*let strEditOrAdd:String!
                
                if self.hereForEdit == "editPost" {
                    strEditOrAdd = "editstaff"
                } else {
                    strEditOrAdd = "addstaff"
                }
                
                let parameters = [
                    "action"          : String(strEditOrAdd),
                    "userId"          : String(myString),
                    "categoryId"       : String(myCatIdIs),
                    "postTitle"        : String(cell.txtPostTitle.text!),
                    "description"      : String(cell.txtDescription.text!),
                    // "videolink"         : String(cell.txtUploadVideoLink.text!),
                ] //Optional for extra parameter
                
                print(parameters as Any)
                
                    
                Alamofire.upload(multipartFormData: { multipartFormData in
                    multipartFormData.append(self.imgData, withName: "image_1",fileName: "riteVetImage.jpg", mimeType: "image/jpg")
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
                            
                            let alertController = UIAlertController(title: nil, message: "Please wait......", preferredStyle: .alert)
                            let progressDownload : UIProgressView = UIProgressView(progressViewStyle: .default)

                            progressDownload.setProgress(Float((progress.fractionCompleted)/1.0), animated: true)
                            progressDownload.frame = CGRect(x: 10, y: 70, width: 250, height: 0)

                            alertController.view.addSubview(progressDownload)
                            self.present(alertController, animated: true, completion: nil)
                            
                        })

                        upload.responseJSON { response in
                            //print(response.result.value as Any)
                            if let data = response.value {
                                let JSON = data as! NSDictionary
                                print(JSON)
                                
                                //var dict: Dictionary<AnyHashable, Any>
                                //dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                                
                                
                                //print(dict)
                                
                                let ar : NSArray!
                                ar = (JSON["data"] as! Array<Any>) as NSArray
                                let item = ar[0] as? [String:Any]
                                let x : Int = item!["staffId"] as! Int
                                let myString = String(x)
                                
                                /*
                                        var strCheckImageOne:String!
                                        var strCheckImageTwo:String!
                                        var strCheckImageThree:String!
                                        var strCheckImageFour:String!
                                        var strCheckImageFive:String!
                                    */
                             
                                if self.strYesIamVideo == "2" {
                                    // upload video then check image two
                                    self.uploadVideoToServer(staffId:myString)
                                }
                                else {
                                    if self.strCheckImageTwo == "1" {
                                        self.uploadImageSecondImage(staffId: myString)
                                    }
                                    else {
                                        print("only one image")
                                        Utils.RiteVetIndicatorHide()
                                        self.dismiss(animated: true, completion: nil)
                                        
                                        self.pushToFreeStuff()
                                    }
                                }
                                  
                            }
                            else {
                                
                                CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Server Not Responding. Please try again Later.", dismissDelay: 1.5, completion:{})
                            }
                            
                        }

                    case .failure(let encodingError):
                        print(encodingError)
                        self.dismiss(animated: true, completion: nil)
                    }
                }*/
            }
        }
    }
    
    // upload second image
    // MARK:- IMAGE 2
    @objc func uploadImageSecondImage(staffId:String) {

        if strCheckImageTwo == "0" {
            self.dismiss(animated: true, completion: nil)
            self.pushToFreeStuff()
        }
        else
        {
        
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
               "action"     : "editstaff",
               "staffId"    : String(staffId),
               "userId"     : String(myString)
               
               
           ]
            

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
                            
//                            let JSON = dictionary as! NSDictionary
//                            print(JSON)
//                            let JSON = data as! NSDictionary
//                            print(JSON)
                            
                            if self.strCheckImageThree == "1" {
                                self.uploadImageThirdImage(staffId: staffId)
                            }
                            else
                            {
                                print("only one image")
                                Utils.RiteVetIndicatorHide()
                                self.dismiss(animated: true, completion: nil)
                                self.pushToFreeStuff()
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
            
            
                 /*let parameters = [
                    "action"          : "editstaff",
                    "staffId"       : String(staffId),
                    "userId"         : String(myString)
                    
                    
                ] //Optional for extra parameter
                
                    print(parameters as Any)
                
                Alamofire.upload(multipartFormData: { multipartFormData in
                    multipartFormData.append(self.imgData2, withName: "image_2",fileName: "riteVetImage.jpg", mimeType: "image/jpg")
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
                            
                        })

                        upload.responseJSON { response in
                            //print(response.result.value as Any)
                            if let data = response.result.value
                            {
                                let JSON = data as! NSDictionary
                                print(JSON)
                                
                                if self.strCheckImageThree == "1" {
                                    self.uploadImageThirdImage(staffId: staffId)
                                }
                                else
                                {
                                    print("only one image")
                                    Utils.RiteVetIndicatorHide()
                                    self.dismiss(animated: true, completion: nil)
                                    self.pushToFreeStuff()
                                }
                            }
                            else
                            {
                                CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Server Not Responding. Please try again Later.", dismissDelay: 1.5, completion:{})

                            }
                        }
                    case .failure(let encodingError):
                        print(encodingError)
                        self.dismiss(animated: true, completion: nil)
                    }}*/
            
            
            
        }
        }
        
    }
    
    
    // third image
    // MARK:- IMAGE 3
    @objc func uploadImageThirdImage(staffId:String) {

        if strCheckImageThree == "0" {
            self.dismiss(animated: true, completion: nil)
            self.pushToFreeStuff()
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
           "action"          : "editstaff",
           "staffId"       : String(staffId),
           "userId"         : String(myString)
           
           
       ]
        

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
                        
                        if self.strCheckImageThree == "1" {
                            self.uploadImageFourthImage(staffId: staffId)
                        }
                        else
                        {
                            print("only one image")
                            Utils.RiteVetIndicatorHide()
                            self.dismiss(animated: true, completion: nil)
                            self.pushToFreeStuff()
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
             /*let parameters = [
                "action"          : "editstaff",
                "staffId"       : String(staffId),
                "userId"         : String(myString)
                
                
            ] //Optional for extra parameter
            
                print(parameters as Any)
            
            Alamofire.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(self.imgData3, withName: "image_3",fileName: "riteVetImage.jpg", mimeType: "image/jpg")
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
                        
                    })
                    
                    upload.responseJSON { response in
                        //print(response.result.value as Any)
                        if let data = response.result.value
                        {
                            let JSON = data as! NSDictionary
                            print(JSON)
                            
                            if self.strCheckImageThree == "1" {
                                self.uploadImageFourthImage(staffId: staffId)
                            }
                            else
                            {
                                print("only one image")
                                Utils.RiteVetIndicatorHide()
                                self.dismiss(animated: true, completion: nil)
                                self.pushToFreeStuff()
                            }
                        }
                        else
                        {
                            CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Server Not Responding. Please try again Later.", dismissDelay: 1.5, completion:{})
                            
                        }
                    }
                case .failure(let encodingError):
                    print(encodingError)
                    self.dismiss(animated: true, completion: nil)
                    
                }
                
            }*/
        
    }
            
            
            
            
        }}
    
    // fourth image
    // MARK:- IMAGE 4
    @objc func uploadImageFourthImage(staffId:String) {

        if strCheckImageFour == "0" {
            self.dismiss(animated: true, completion: nil)
            self.pushToFreeStuff()
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
           "action"          : "editstaff",
           "staffId"       : String(staffId),
           "userId"         : String(myString)
           
           
       ]
        

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
                        
                        if self.strCheckImageFour == "1" {
                            self.uploadImageFifthImage(staffId: staffId)
                        }
                        else
                        {
                            print("only one image")
                            Utils.RiteVetIndicatorHide()
                            self.dismiss(animated: true, completion: nil)
                            self.pushToFreeStuff()
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
        
             /*let parameters = [
                "action"          : "editstaff",
                "staffId"       : String(staffId),
                "userId"         : String(myString)
                
                
            ] //Optional for extra parameter
            
                print(parameters as Any)
            
            Alamofire.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(self.imgData4, withName: "image_4",fileName: "riteVetImage.jpg", mimeType: "image/jpg")
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
                        
                    })

                    upload.responseJSON { response in
                        //print(response.result.value as Any)
                        if let data = response.result.value
                        {
                            let JSON = data as! NSDictionary
                            print(JSON)
                            
                            if self.strCheckImageFour == "1" {
                                self.uploadImageFifthImage(staffId: staffId)
                            }
                            else
                            {
                                print("only one image")
                                Utils.RiteVetIndicatorHide()
                                self.dismiss(animated: true, completion: nil)
                                self.pushToFreeStuff()
                            }
                        }
                        else
                        {
                            CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Server Not Responding. Please try again Later.", dismissDelay: 1.5, completion:{})

                        }
                    }
                case .failure(let encodingError):
                    print(encodingError)
                    self.dismiss(animated: true, completion: nil)
                }
                
            }*/
        
    }
            
            
        }}
    
    // five image
    // MARK:- IMAGE 5
    @objc func uploadImageFifthImage(staffId:String) {

        if strCheckImageFive == "0" {
            self.dismiss(animated: true, completion: nil)
            self.pushToFreeStuff()
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
           "action"          : "editstaff",
           "staffId"       : String(staffId),
           "userId"         : String(myString)
           
           
       ]
        

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
                            self.dismiss(animated: true, completion: nil)
                        self.pushToFreeStuff()
                         
                        
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
        
        
        
             /*let parameters = [
                "action"          : "editstaff",
                "staffId"       : String(staffId),
                "userId"         : String(myString)
                
                
            ] //Optional for extra parameter
            
                print(parameters as Any)
            
            Alamofire.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(self.imgData5, withName: "image_5",fileName: "riteVetImage.jpg", mimeType: "image/jpg")
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
                        
                    })

                    upload.responseJSON { response in
                        //print(response.result.value as Any)
                        if let data = response.result.value
                        {
                            let JSON = data as! NSDictionary
                            print(JSON)
                            
                            
                                
                            
                               Utils.RiteVetIndicatorHide()
                                self.dismiss(animated: true, completion: nil)
                            self.pushToFreeStuff()
                                
                        }
                        else
                        {
                            CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Server Not Responding. Please try again Later.", dismissDelay: 1.5, completion:{})

                        }
                    }
                case .failure(let encodingError):
                    print(encodingError)
                    self.dismiss(animated: true, completion: nil)
                }
                
            }*/
        
    }
            
            
        }}
    
    
    @objc func checkVideoIsUplodedOrNot(staffId:String) {
        if self.strYesIamVideo == "1" {
            self.uploadVideoToServer(staffId: staffId)
        }
        else
        {
         // no video uploded
        }
    }
    // MARK:- UPLOAD VIDEO TO SERVER
    @objc func uploadVideoToServer(staffId:String) {
        
                
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
               "action"          : "editstaff",
               "staffId"       : String(staffId),
               "userId"         : String(myString)
               
               
           ]
            

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
                            
                            if self.strCheckImageTwo == "1" {
                                self.uploadImageSecondImage(staffId: staffId)
                            }
                            else
                            {
                                print("only one image")
                                Utils.RiteVetIndicatorHide()
                                self.dismiss(animated: true, completion: nil)
                                self.pushToFreeStuff()
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
                 /*let parameters = [
                    "action"          : "editstaff",
                    "staffId"       : String(staffId),
                    "userId"         : String(myString)
                    
                    
                ] //Optional for extra parameter
                
                    print(parameters as Any)
                
                Alamofire.upload(multipartFormData: { multipartFormData in
                    multipartFormData.append(self.saveSelectedVideoURLforServer, withName: "video",fileName: "riteVetImage.mp4", mimeType: "video/mp4")
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
                            
                        })

                        upload.responseJSON { response in
                            //print(response.result.value as Any)
                            if let data = response.result.value
                            {
                                let JSON = data as! NSDictionary
                                print(JSON)
                                
                                if self.strCheckImageTwo == "1" {
                                    self.uploadImageSecondImage(staffId: staffId)
                                }
                                else
                                {
                                    print("only one image")
                                    Utils.RiteVetIndicatorHide()
                                    self.dismiss(animated: true, completion: nil)
                                    self.pushToFreeStuff()
                                }
                                
                            }
                            else
                            {
                                CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Server Not Responding. Please try again Later.", dismissDelay: 1.5, completion:{})

                            }
                        }
                    case .failure(let encodingError):
                        print(encodingError)
                        self.dismiss(animated: true, completion: nil)
                    }
                    
                }*/
            
        }
        
        /*
        Alamofire.upload(multipartFormData: { (multipartFormData) in
                    // code
        // here you can upload only mp4 video
                        multipartFormData.append(self.selectedVideoURL!, withName: "File1", fileName: "video.mp4", mimeType: "video/mp4")
        // here you can upload any type of video
                        //multipartFormData.append(self.selectedVideoURL!, withName: "File1")
                         multipartFormData.append(("VIDEO".data(using: String.Encoding.utf8, allowLossyConversion: false))!, withName: "Type")

                }, to: /* Set Url Here */ , encodingCompletion: { (result) in
                    // code
                    switch result {
                    case .success(request: let upload, streamingFromDisk: _, streamFileURL: _):
                        upload.validate().responseJSON {
                            response in
                            HideLoaderOnView()
                            if response.result.isFailure {
                                debugPrint(response)
                            } else {
                                let result = response.value as! NSDictionary
                                print(result)
                            }
                        }
                    case .failure(let encodingError):
                        HideLoaderOnView()
                        NSLog((encodingError as NSError).localizedDescription)
                    }
                })
 */
    }
    
    
    @objc func pushToFreeStuff() {
         let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FreeStuffId") as? FreeStuff
         self.navigationController?.pushViewController(push!, animated: true)
    }
    
}



extension SubmitPost: UITableViewDataSource
    {
        func numberOfSections(in tableView: UITableView) -> Int
        {
            return 1
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
        {
            return 1
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
        {
            let cell:SubmitPostTableCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! SubmitPostTableCell
            
            cell.backgroundColor = .clear
        
            Utils.textFieldDR(text: cell.txtPostTitle, placeHolder: "Post Title", cornerRadius: 20, color: .white)
            Utils.textFieldDR(text: cell.txtSelectCategory, placeHolder: "Select category", cornerRadius: 20, color: .white)
            Utils.textFieldDR(text: cell.txtDescription, placeHolder: "Description", cornerRadius: 20, color: .white)
            Utils.textFieldDR(text: cell.txtUploadImage, placeHolder: "Upload Image", cornerRadius: 20, color: .white)
            Utils.textFieldDR(text: cell.txtUploadVideo, placeHolder: "Upload Video", cornerRadius: 20, color: .white)
            Utils.textFieldDR(text: cell.txtUploadVideoLink, placeHolder: "Upload Video Link", cornerRadius: 20, color: .white)
            
            //
            Utils.buttonDR(button: cell.btnSubmit, text: "SUBMIT NOW", backgroundColor: BUTTON_BACKGROUND_COLOR_BLUE, textColor: BUTTON_TEXT_COLOR, cornerRadius: 20)
            
            cell.btnUploadNow.addTarget(self, action: #selector(openActionSheet), for: .touchUpInside)
            cell.btnCategory.addTarget(self, action: #selector(op), for: .touchUpInside)
            cell.btnSubmit.addTarget(self, action: #selector(uploadImageWB), for: .touchUpInside)
            
            // video button
            cell.btnUploadVideo.addTarget(self, action: #selector(openVideoFromGallery), for: .touchUpInside)
            
            return cell
        }
        
    @objc func op() {
        guard let popupVC = self.storyboard?.instantiateViewController(withIdentifier: "secondVC") as? ExamplePopupViewController else { return }
        popupVC.height = self.height
        popupVC.topCornerRadius = self.topCornerRadius
        popupVC.presentDuration = self.presentDuration
        popupVC.dismissDuration = self.dismissDuration
        //popupVC.shouldDismissInteractivelty = dismissInteractivelySwitch.isOn
        popupVC.popupDelegate = self
        popupVC.strGetDetails = "categorySection"
        popupVC.getArrListOfCategory = self.arrListOfCategory
                                    
        self.present(popupVC, animated: true, completion: nil)
    }
    
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView .deselectRow(at: indexPath, animated: true)
            
//            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FreeStuffPageId") as? FreeStuffPage
            //self.navigationController?.pushViewController(push!, animated: true)
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 850
        }
    }

extension SubmitPost: UITableViewDelegate
    {
        
    }

extension SubmitPost: BottomPopupDelegate {
    
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
        
        let cell = tbleView.cellForRow(at: NSIndexPath(row: 0, section: 0) as IndexPath) as! SubmitPostTableCell
        
        let defaults = UserDefaults.standard
        
        if let myString = defaults.string(forKey: "getCategoryNameForFreeStuff")
        {
            cell.txtSelectCategory.text = String(myString)
        }
        if let myString = defaults.string(forKey: "getCategoryIdForFreeStuff")
        {
            myCatIdIs = String(myString)
               self.tbleView.reloadData()
        }
         
        
    }
    
    func bottomPopupDismissInteractionPercentChanged(from oldValue: CGFloat, to newValue: CGFloat) {
        print("bottomPopupDismissInteractionPercentChanged fromValue: \(oldValue) to: \(newValue)")
    }
}


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
import SDWebImage

class SubmitPost: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate,UIPickerViewDelegate, UIPickerViewDataSource {

    var str_staff_id:String!
    
    var arr_add_image:NSMutableArray! = []
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
        /*let cell = tbleView.cellForRow(at: NSIndexPath(row: 0, section: 0) as IndexPath) as! SubmitPostTableCell
        
        if cell.imgOne.image == nil {
            let alertController = UIAlertController(title: nil, message: "Please Upload atleast One Product Image before uploading Video.", preferredStyle: .actionSheet)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                UIAlertAction in
                //NSLog("OK Pressed")
            }
            
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
        else {*/
            strYesIamVideo = "1"
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.delegate = self
            imagePickerController.mediaTypes = [/*"public.image", */"public.movie"]
            
            present(imagePickerController, animated: true, completion: nil)
        // }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        videoURL = info["UIImagePickerControllerReferenceURL"] as? NSURL
        print(videoURL as Any)
        imagePickerController.dismiss(animated: true, completion: nil)
    }
    
    @objc func openActionSheet() {
        
        if (self.arr_add_image.count == 5) {
            let alert = UIAlertController(title: "Alert", message: "You can not upload more than 5 images.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        } else {
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
            cell.btn_delete_video.isHidden = false
            cell.btn_delete_video.addTarget(self, action: #selector(delete_video), for: .touchUpInside)
            cell.btnVideoPlay.addTarget(self, action: #selector(playVideoBeforUploadToServer), for: .touchUpInside)
            saveSelectedVideoURLforServer = videoURL as URL?
            imagePickerController.dismiss(animated: true, completion: nil)
            strYesIamVideo = "10"
        }
        else
        {
            
            
            if self.hereForEdit == "editPost" {
                
                var str_detect_number:String! = ""
                
                print("user select image from gallery")
                print(self.arr_add_image.count as Any)
                
                str_detect_number = "\(self.arr_add_image.count)"
                let image_data = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
                cell.imgOne.image = image_data
                cell.imgOne.isHidden = true
                let imageData:Data = image_data!.pngData()!
                imageStr = imageData.base64EncodedString()
                
                imgData = image_data!.jpegData(compressionQuality: 0.2)!
                print(imgData as Any)
                
                let custom = [
                    
                        "image_data":imgData
                    ]
                
                self.arr_add_image.add(custom)

                print(self.arr_add_image as Any)
                print(self.arr_add_image.count as Any)
                
                self.dismiss(animated: true, completion: nil)
                
                print(str_detect_number as Any)
                
                if (str_detect_number == "1") {
                    Utils.RiteVetIndicatorShow()
                     
                    
                    if (self.dictGetPostForEdit["image_1"] as! String) == "" {
                        // self.imgData = imgData
                        self.uploadImageEditOneImage(staffId: "\(self.dictGetPostForEdit["staffId"]!)")
                    } else if (self.dictGetPostForEdit["image_2"] as! String) == "" {
                        self.imgData2 = imgData
                        self.uploadImageSecondImage(staffId: "\(self.dictGetPostForEdit["staffId"]!)")
                    } else if (self.dictGetPostForEdit["image_3"] as! String) == "" {
                        self.imgData3 = imgData
                        self.uploadImageThirdImage(staffId: "\(self.dictGetPostForEdit["staffId"]!)")
                    } else if (self.dictGetPostForEdit["image_4"] as! String) == "" {
                        self.imgData4 = imgData
                        self.uploadImageFourthImage(staffId: "\(self.dictGetPostForEdit["staffId"]!)")
                    } else {
                        self.imgData5 = imgData
                        self.uploadImageFifthImage(staffId: "\(self.dictGetPostForEdit["staffId"]!)")
                    }
                    
                    
                } else if (str_detect_number == "2") {
                    Utils.RiteVetIndicatorShow()
                    if (self.dictGetPostForEdit["image_1"] as! String) == "" {
                        // self.imgData = imgData
                        self.uploadImageEditOneImage(staffId: "\(self.dictGetPostForEdit["staffId"]!)")
                    } else if (self.dictGetPostForEdit["image_2"] as! String) == "" {
                        self.imgData2 = imgData
                        self.uploadImageSecondImage(staffId: "\(self.dictGetPostForEdit["staffId"]!)")
                    } else if (self.dictGetPostForEdit["image_3"] as! String) == "" {
                        self.imgData3 = imgData
                        self.uploadImageThirdImage(staffId: "\(self.dictGetPostForEdit["staffId"]!)")
                    } else if (self.dictGetPostForEdit["image_4"] as! String) == "" {
                        self.imgData4 = imgData
                        self.uploadImageFourthImage(staffId: "\(self.dictGetPostForEdit["staffId"]!)")
                    } else {
                        self.imgData5 = imgData
                        self.uploadImageFifthImage(staffId: "\(self.dictGetPostForEdit["staffId"]!)")
                    }
                    
                } else if (str_detect_number == "3") {
                    Utils.RiteVetIndicatorShow()
                    if (self.dictGetPostForEdit["image_1"] as! String) == "" {
                        // self.imgData = imgData
                        self.uploadImageEditOneImage(staffId: "\(self.dictGetPostForEdit["staffId"]!)")
                    } else if (self.dictGetPostForEdit["image_2"] as! String) == "" {
                        self.imgData2 = imgData
                        self.uploadImageSecondImage(staffId: "\(self.dictGetPostForEdit["staffId"]!)")
                    } else if (self.dictGetPostForEdit["image_3"] as! String) == "" {
                        self.imgData3 = imgData
                        self.uploadImageThirdImage(staffId: "\(self.dictGetPostForEdit["staffId"]!)")
                    } else if (self.dictGetPostForEdit["image_4"] as! String) == "" {
                        self.imgData4 = imgData
                        self.uploadImageFourthImage(staffId: "\(self.dictGetPostForEdit["staffId"]!)")
                    } else {
                        self.imgData5 = imgData
                        self.uploadImageFifthImage(staffId: "\(self.dictGetPostForEdit["staffId"]!)")
                    }
                    
                } else if (str_detect_number == "4") {
                    Utils.RiteVetIndicatorShow()
                    if (self.dictGetPostForEdit["image_1"] as! String) == "" {
                        // self.imgData = imgData
                        self.uploadImageEditOneImage(staffId: "\(self.dictGetPostForEdit["staffId"]!)")
                    } else if (self.dictGetPostForEdit["image_2"] as! String) == "" {
                        self.imgData2 = imgData
                        self.uploadImageSecondImage(staffId: "\(self.dictGetPostForEdit["staffId"]!)")
                    } else if (self.dictGetPostForEdit["image_3"] as! String) == "" {
                        self.imgData3 = imgData
                        self.uploadImageThirdImage(staffId: "\(self.dictGetPostForEdit["staffId"]!)")
                    } else if (self.dictGetPostForEdit["image_4"] as! String) == "" {
                        self.imgData4 = imgData
                        self.uploadImageFourthImage(staffId: "\(self.dictGetPostForEdit["staffId"]!)")
                    } else {
                        self.imgData5 = imgData
                        self.uploadImageFifthImage(staffId: "\(self.dictGetPostForEdit["staffId"]!)")
                    }
                    
                } else {
                    Utils.RiteVetIndicatorShow()
                    if (self.dictGetPostForEdit["image_1"] as! String) == "" {
                        // self.imgData = imgData
                        self.uploadImageEditOneImage(staffId: "\(self.dictGetPostForEdit["staffId"]!)")
                    } else if (self.dictGetPostForEdit["image_2"] as! String) == "" {
                        self.imgData2 = imgData
                        self.uploadImageSecondImage(staffId: "\(self.dictGetPostForEdit["staffId"]!)")
                    } else if (self.dictGetPostForEdit["image_3"] as! String) == "" {
                        self.imgData3 = imgData
                        self.uploadImageThirdImage(staffId: "\(self.dictGetPostForEdit["staffId"]!)")
                    } else if (self.dictGetPostForEdit["image_4"] as! String) == "" {
                        self.imgData4 = imgData
                        self.uploadImageFourthImage(staffId: "\(self.dictGetPostForEdit["staffId"]!)")
                    } else {
                        self.imgData5 = imgData
                        self.uploadImageFifthImage(staffId: "\(self.dictGetPostForEdit["staffId"]!)")
                    }
                    
                }
                /**/
                
            } else {
                print("user select image from gallery")
                print(self.arr_add_image.count as Any)
                let image_data = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
                cell.imgOne.image = image_data
                cell.imgOne.isHidden = true
                let imageData:Data = image_data!.pngData()!
                imageStr = imageData.base64EncodedString()
                
                imgData = image_data!.jpegData(compressionQuality: 0.2)!
                print(imgData as Any)
                
                let custom = [
                    
                        "image_data":imgData
                    ]
                
                self.arr_add_image.add(custom)

                print(self.arr_add_image as Any)
                print(self.arr_add_image.count as Any)
                
                self.dismiss(animated: true, completion: nil)
                
                
                
                cell.clView.delegate = self
                cell.clView.dataSource = self
                cell.clView.reloadData()
            }
            
            
            // arr_add_image
        /*if  strCheckImageOne == "0" {
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
            
        }*/
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
                                       
                    if strSuccess == "success" {
                        Utils.RiteVetIndicatorHide()
                                        
                        let ar : NSArray!
                        ar = (JSON["response"] as! Array<Any>) as NSArray
                                            
                        self.arrListOfCategory = (ar as! Array<Any>)
                          
                        if self.hereForEdit == "editPost" {
                            print("edit")
                            
                            print(self.dictGetPostForEdit as Any)
                            
                            let cell = self.tbleView.cellForRow(at: NSIndexPath(row: 0, section: 0) as IndexPath) as! SubmitPostTableCell
                            
                            cell.txtPostTitle.text = (self.dictGetPostForEdit["postTitle"] as! String)
                            cell.txtSelectCategory.text = (self.dictGetPostForEdit["categoryName"] as! String)
                            cell.txtDescription.text = (self.dictGetPostForEdit["description"] as! String)
                           
                            let x : Int = (self.dictGetPostForEdit["categoryId"] as! Int)
                            let myString = String(x)
                            self.myCatIdIs = String(myString)
                            
                            let url = URL(string: (self.dictGetPostForEdit["image_1"] as! String))
                            let data = try? Data(contentsOf: url!)

                             if let imageData = data {
                                print(imageData as Any)
                                self.imgData = imageData
                                
                                 
                             }
                             
                            
                        } else {
                            print("add")
                        }
                      
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
    
    @objc func delete_photo_fromWB_click_method(img_key:String) {
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]
        {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            Utils.RiteVetIndicatorShow()
            
            let urlString = BASE_URL_KREASE
            
            var parameters:Dictionary<AnyHashable, Any>!
            
            /*
             action: deletestuffimage
             freestaffId:
             userId:
             image_key:
             */
            
            parameters = [
                "action"        :   "deletestuffimage",
                "freestaffId"   :   "\(self.dictGetPostForEdit["staffId"]!)",
                "userId"        :   String(myString),
                "image_key"     :   String(img_key)
            ]
            
            //
            print("parameters-------\(String(describing: parameters))")
            
            AF.request(urlString, method: .post, parameters: parameters as? Parameters).responseJSON {
                response in
                
                switch(response.result) {
                case .success(_):
                    if let data = response.value {
                        
                        let JSON = data as! NSDictionary
                        print(JSON)
                        
                        var strSuccess : String!
                        strSuccess = JSON["status"]as Any as? String
                        
                        //var strSuccessAlert : String!
                        //strSuccessAlert = JSON["msg"]as Any as? String
                        
                        if strSuccess == "success" {
                            self.freeStuffDetailsWB()
                        }
                        else {
                            
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
    }
    
    @objc func validate_before_upload_image_click_method() {
        print("submit.")
        
        print(self.arr_add_image.count as Any)
        
        /*if (self.arr_add_image.count == 0) {
            let alertController = UIAlertController(title: "Alert", message: "Please upload atleast one product image.", preferredStyle: .actionSheet)
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            
            return
        } else {*/
           
            self.upload_image_for_index_one()
            
//            for indexx in 0..<self.arr_add_image.count {
//                print(indexx as Any)
//                if (indexx == 0) {
//                    self.upload_image_for_index_one()
//                } else if (indexx == 1) {
//                    print("index 1")
//                    self.uploadImageSecondImage(staffId: String(self.str_staff_id))
//                } else if (indexx == 2) {
//                    print("index 2")
//                } else if (indexx == 3) {
//                    print("index 3")
//                } else if (indexx == 4) {
//                    print("index 4")
//                } else {
//                    print("index 5")
//                }
//            }
            
        // }
     
    }
    
    
    @objc func upload_image_for_index_one() {
        let cell = tbleView.cellForRow(at: NSIndexPath(row: 0, section: 0) as IndexPath) as! SubmitPostTableCell
        
        Utils.RiteVetIndicatorShow()
        
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
            
            let parameterDict = NSMutableDictionary()
            
            parameterDict.setValue(String(strEditOrAdd), forKey: "action")
            
            parameterDict.setValue(String(myString), forKey: "userId")
            parameterDict.setValue(String(myCatIdIs), forKey: "categoryId")
            parameterDict.setValue(String(cell.txtPostTitle.text!), forKey: "postTitle")
            parameterDict.setValue(String(cell.txtDescription.text!), forKey: "description")
            
            parameterDict.setValue(Date.get24TimeWithDateForTimeZone(), forKey: "added_time")
            parameterDict.setValue("\(TimeZone.current.abbreviation()!)", forKey: "current_time_zone")
            
            print(parameterDict)
            
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
                multiPart.append(self.imgData, withName: "image_1", fileName: "submit_post_image_1.jpg", mimeType: "image/png")
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
                        
                        self.str_staff_id = String(myString)
                        
                        print(self.imgData2 as Any)
                        print(self.imgData3 as Any)
                        print(self.imgData4 as Any)
                        print(self.imgData5 as Any)
                        
                        if (self.imgData2 == nil) {
                            print("only one image")
                            Utils.RiteVetIndicatorHide()
                            self.dismiss(animated: true, completion: nil)
                            
                            self.pushToFreeStuff()
                        } else {
                            self.uploadImageSecondImage(staffId: myString)
                        }
                        /*if self.strYesIamVideo == "2" {
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
                        }*/
                        
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
            
            // remove space from title
            let resStr = removeWhitespacesFromString(mStr: String(cell.txtPostTitle.text!))
            
            
            // remove space from description
            let resStr2 = removeWhitespacesFromString(mStr: String(cell.txtDescription.text!))
            
            let letters = CharacterSet.alphanumerics
            let string = resStr
            print(string as Any)
            if (string.trimmingCharacters(in: letters) != "") {
                print("Invalid characters in string.")
                
                let alertController = UIAlertController(title: "Error", message: "Invalid title. Please enter valid title.", preferredStyle: .actionSheet)
                
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                        UIAlertAction in
                        //NSLog("OK Pressed")
                    }
                
                alertController.addAction(okAction)
                
                self.present(alertController, animated: true, completion: nil)
                
            }
            else {
                print("Only letters and numbers.")
                
                
                
                let letters2 = CharacterSet.alphanumerics
                let string2 = resStr2
                print(string2 as Any)
                if (string2.trimmingCharacters(in: letters2) != "") {
                    print("Invalid characters in string.")
                    
                    let alertController = UIAlertController(title: "Error", message: "Invalid description. Please enter valid description", preferredStyle: .actionSheet)
                    
                    let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                            UIAlertAction in
                            //NSLog("OK Pressed")
                        }
                    
                    alertController.addAction(okAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                }
                else {
                    self.validate_before_upload_image_click_method()
                }
                
            }
            
        }
    }

    func removeWhitespacesFromString(mStr: String) -> String {

       let chr = mStr.components(separatedBy: .whitespaces)
       let resString = chr.joined()
       return resString
    }
    
    // upload second image
    @objc func uploadImageEditOneImage(staffId:String) {

        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
         let x : Int = (person["userId"] as! Int)
         let myString = String(x)
          
            var urlRequest = URLRequest(url: URL(string: BASE_URL_KREASE)!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0 * 1000)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
            
            // let indexPath = IndexPath.init(row: 0, section: 0)
            // let cell = self.tablView.cellForRow(at: indexPath) as! AddTableTableViewCell
            
            //Set Your Parameter
//            let parameterDict = [
//               "action"     : "editstaff",
//               "staffId"    : String(staffId),
//               "userId"     : String(myString)
//
//
//           ]
            
            let parameterDict = NSMutableDictionary()
            
            parameterDict.setValue(String("editstaff"), forKey: "action")
            
            parameterDict.setValue(String(myString), forKey: "userId")
            parameterDict.setValue(String(staffId), forKey: "staffId")
            // parameterDict.setValue(Date.get24TimeForTimeZone(), forKey: "added_time")
            // parameterDict.setValue("\(TimeZone.current.abbreviation()!)", forKey: "current_time_zone")
            print(parameterDict)
            

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
                multiPart.append(self.imgData, withName: "image_1", fileName: "submit_post_image_1.png", mimeType: "image/png")
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
                            
                            if (self.imgData3 == nil) {
                                print("only 2 image")
                                
                                self.dismiss(animated: true, completion: nil)
                                
                                if self.hereForEdit == "editPost" {
                                    let cell = self.tbleView.cellForRow(at: NSIndexPath(row: 0, section: 0) as IndexPath) as! SubmitPostTableCell
                                    let alert = UIAlertController(title: "Success", message: "Successfully Uploaded", preferredStyle: UIAlertController.Style.alert)
                                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
                                        
                                        self.freeStuffDetailsWB()
                                        
                                    }))
                                    
                                    self.present(alert, animated: true, completion: nil)
                                } else {
                                    Utils.RiteVetIndicatorHide()
                                    self.pushToFreeStuff()
                                }
                                
                            } else {
                                self.uploadImageThirdImage(staffId: staffId)
                            }
                            
                            /*if self.strCheckImageThree == "1" {
                                self.uploadImageThirdImage(staffId: staffId)
                            }
                            else
                            {
                                print("only one image")
                                Utils.RiteVetIndicatorHide()
                                self.dismiss(animated: true, completion: nil)
                                self.pushToFreeStuff()
                            }*/
                            
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
    // MARK:- IMAGE 2
    @objc func uploadImageSecondImage(staffId:String) {

        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
         let x : Int = (person["userId"] as! Int)
         let myString = String(x)
          
            var urlRequest = URLRequest(url: URL(string: BASE_URL_KREASE)!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0 * 1000)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
            
            // let indexPath = IndexPath.init(row: 0, section: 0)
            // let cell = self.tablView.cellForRow(at: indexPath) as! AddTableTableViewCell
            
            //Set Your Parameter
//            let parameterDict = [
//               "action"     : "editstaff",
//               "staffId"    : String(staffId),
//               "userId"     : String(myString)
//
//
//           ]
            
            let parameterDict = NSMutableDictionary()
            
            parameterDict.setValue(String("editstaff"), forKey: "action")
            
            parameterDict.setValue(String(myString), forKey: "userId")
            parameterDict.setValue(String(staffId), forKey: "staffId")
            // parameterDict.setValue(Date.get24TimeForTimeZone(), forKey: "added_time")
            // parameterDict.setValue("\(TimeZone.current.abbreviation()!)", forKey: "current_time_zone")
            print(parameterDict)
            

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
                multiPart.append(self.imgData2, withName: "image_2", fileName: "submit_post_image_2.png", mimeType: "image/png")
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
                            
                            if (self.imgData3 == nil) {
                                print("only 2 image")
                                
                                self.dismiss(animated: true, completion: nil)
                                
                                if self.hereForEdit == "editPost" {
                                    let cell = self.tbleView.cellForRow(at: NSIndexPath(row: 0, section: 0) as IndexPath) as! SubmitPostTableCell
                                    let alert = UIAlertController(title: "Success", message: "Successfully Uploaded", preferredStyle: UIAlertController.Style.alert)
                                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
                                        
                                        self.freeStuffDetailsWB()
                                        
                                    }))
                                    
                                    self.present(alert, animated: true, completion: nil)
                                } else {
                                    Utils.RiteVetIndicatorHide()
                                    self.pushToFreeStuff()
                                }
                                
                            } else {
                                self.uploadImageThirdImage(staffId: staffId)
                            }
                            
                            /*if self.strCheckImageThree == "1" {
                                self.uploadImageThirdImage(staffId: staffId)
                            }
                            else
                            {
                                print("only one image")
                                Utils.RiteVetIndicatorHide()
                                self.dismiss(animated: true, completion: nil)
                                self.pushToFreeStuff()
                            }*/
                            
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
    
    
    // third image
    // MARK:- IMAGE 3
    @objc func uploadImageThirdImage(staffId:String) {
    
            
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
//        let parameterDict = [
//           "action"          : "editstaff",
//           "staffId"       : String(staffId),
//           "userId"         : String(myString)
//
//
//       ]
        
        
        let parameterDict = NSMutableDictionary()
        
        parameterDict.setValue(String("editstaff"), forKey: "action")
        
        parameterDict.setValue(String(myString), forKey: "userId")
        parameterDict.setValue(String(staffId), forKey: "staffId")
        // parameterDict.setValue(Date.get24TimeForTimeZone(), forKey: "added_time")
        // parameterDict.setValue("\(TimeZone.current.abbreviation()!)", forKey: "current_time_zone")
        print(parameterDict)
        

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
            multiPart.append(self.imgData3, withName: "image_3", fileName: "submit_post_image_3.png", mimeType: "image/png")
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
                        
                        if (self.imgData4 == nil) {
                            print("only 4 image")
                            
                            self.dismiss(animated: true, completion: nil)
                            if self.hereForEdit == "editPost" {
                                let cell = self.tbleView.cellForRow(at: NSIndexPath(row: 0, section: 0) as IndexPath) as! SubmitPostTableCell
                                let alert = UIAlertController(title: "Success", message: "Successfully Uploaded", preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
                                    self.freeStuffDetailsWB()
                                }))
                                
                                self.present(alert, animated: true, completion: nil)
                            } else {
                                Utils.RiteVetIndicatorHide()
                                self.pushToFreeStuff()
                            }
                        } else {
                            self.uploadImageFourthImage(staffId: staffId)
                        }
                        
                        /*if self.strCheckImageThree == "1" {
                            self.uploadImageFourthImage(staffId: staffId)
                        }
                        else
                        {
                            print("only one image")
                            Utils.RiteVetIndicatorHide()
                            self.dismiss(animated: true, completion: nil)
                            self.pushToFreeStuff()
                        }*/
                         
                        
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
            
            
            
            
        }
    
    // fourth image
    // MARK:- IMAGE 4
    @objc func uploadImageFourthImage(staffId:String) {
        
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
            let parameterDict = NSMutableDictionary()
            
            parameterDict.setValue(String("editstaff"), forKey: "action")
            
            parameterDict.setValue(String(myString), forKey: "userId")
            parameterDict.setValue(String(staffId), forKey: "staffId")
            // parameterDict.setValue(Date.get24TimeForTimeZone(), forKey: "added_time")
            // parameterDict.setValue("\(TimeZone.current.abbreviation()!)", forKey: "current_time_zone")
            print(parameterDict)
            
            
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
                multiPart.append(self.imgData4, withName: "image_4", fileName: "submit_post_image_4.png", mimeType: "image/png")
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
                        
                        if (self.imgData5 == nil) {
                            print("only 4 image")
                            
                            self.dismiss(animated: true, completion: nil)
                            
                            if self.hereForEdit == "editPost" {
                                let cell = self.tbleView.cellForRow(at: NSIndexPath(row: 0, section: 0) as IndexPath) as! SubmitPostTableCell
                                let alert = UIAlertController(title: "Success", message: "Successfully Uploaded", preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
                                    self.freeStuffDetailsWB()
                                }))
                                
                                self.present(alert, animated: true, completion: nil)
                            } else {
                                Utils.RiteVetIndicatorHide()
                                self.pushToFreeStuff()
                            }
                        } else {
                            self.uploadImageFifthImage(staffId: staffId)
                        }
                        
                        /*if self.strCheckImageFour == "1" {
                         self.uploadImageFifthImage(staffId: staffId)
                         }
                         else
                         {
                         print("only one image")
                         Utils.RiteVetIndicatorHide()
                         self.dismiss(animated: true, completion: nil)
                         self.pushToFreeStuff()
                         }*/
                        
                        
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
        
        
    }
    
    // five image
    // MARK:- IMAGE 5
    @objc func uploadImageFifthImage(staffId:String) {
        
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
            let parameterDict = NSMutableDictionary()
            
            parameterDict.setValue(String("editstaff"), forKey: "action")
            
            parameterDict.setValue(String(myString), forKey: "userId")
            parameterDict.setValue(String(staffId), forKey: "staffId")
            // parameterDict.setValue(Date.get24TimeForTimeZone(), forKey: "added_time")
            // parameterDict.setValue("\(TimeZone.current.abbreviation()!)", forKey: "current_time_zone")
            print(parameterDict)
            
            
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
                multiPart.append(self.imgData5, withName: "image_5", fileName: "submit_post_image_5.png", mimeType: "image/png")
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
                        
                        
                        
                        
                        self.dismiss(animated: true, completion: nil)
                        
                        if self.hereForEdit == "editPost" {
                            let cell = self.tbleView.cellForRow(at: NSIndexPath(row: 0, section: 0) as IndexPath) as! SubmitPostTableCell
                            let alert = UIAlertController(title: "Success", message: "Successfully Uploaded", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
                                self.freeStuffDetailsWB()
                            }))
                            
                            self.present(alert, animated: true, completion: nil)
                        } else {
                            Utils.RiteVetIndicatorHide()
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
        
        
    }
    
    
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
            let parameterDict = NSMutableDictionary()
            
            parameterDict.setValue(String("editstaff"), forKey: "action")
            
            parameterDict.setValue(String(myString), forKey: "userId")
            parameterDict.setValue(String(staffId), forKey: "staffId")
            // parameterDict.setValue(Date.get24TimeForTimeZone(), forKey: "added_time")
            // parameterDict.setValue("\(TimeZone.current.abbreviation()!)", forKey: "current_time_zone")
            print(parameterDict)
            

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
                multiPart.append(self.saveSelectedVideoURLforServer, withName: "video", fileName: "submit_post_video.png", mimeType: "image/png")
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
    
    @objc func upload_video_on_server() {
        Utils.RiteVetIndicatorShow()
        
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
            let parameterDict = NSMutableDictionary()
            
            parameterDict.setValue(String("editstaff"), forKey: "action")
            
            parameterDict.setValue(String(myString), forKey: "userId")
            
            // parameterDict.setValue(Date.get24TimeForTimeZone(), forKey: "added_time")
            // parameterDict.setValue("\(TimeZone.current.abbreviation()!)", forKey: "current_time_zone")
            if (self.dictGetPostForEdit == nil ) {
                parameterDict.setValue(String(self.str_staff_id), forKey: "staffId")
            } else {
                parameterDict.setValue("\(self.dictGetPostForEdit["staffId"]!)", forKey: "staffId")
            }
            print(parameterDict)
            

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
                multiPart.append(self.saveSelectedVideoURLforServer, withName: "video", fileName: "submit_post_video.mp4", mimeType: "image/png")
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
                            Utils.RiteVetIndicatorHide()
                            
                            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DashboardId") as? Dashboard
                            self.navigationController?.pushViewController(push!, animated: true)
                             
                            
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
    
    @objc func pushToFreeStuff() {
        
        
        print(self.strYesIamVideo as Any)
        
        if (self.strYesIamVideo == "10") {
            self.upload_video_on_server()
        } else {
            Utils.RiteVetIndicatorHide()
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DashboardId") as? Dashboard
            self.navigationController?.pushViewController(push!, animated: true)
        }
        
    }
    
    
    func freeStuffDetailsWB() {
        
        let urlString = BASE_URL_KREASE
        
        var parameters:Dictionary<AnyHashable, Any>!
        
        parameters = [
            "action"     : "stuffdetail",
            "staffId"    : "\(self.dictGetPostForEdit!["staffId"]!)"
        ]
        
        
        print("parameters-------\(String(describing: parameters))")
        
        AF.request(urlString, method: .post, parameters: parameters as? Parameters).responseJSON {
            response in
            
            switch(response.result) {
            case .success(_):
                if let data = response.value {
                    
                    let JSON = data as! NSDictionary
                    print(JSON)
                    
                    var strSuccess : String!
                    strSuccess = JSON["status"]as Any as? String
                    
                    if strSuccess == "success" {
                        self.dictGetPostForEdit = (JSON["data"] as! NSDictionary)
                        
                        Utils.RiteVetIndicatorHide()
                        
                        self.tbleView.reloadData()
                    }
                    else {
                        
                        Utils.RiteVetIndicatorHide()
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
    
    @objc func update_only_details() {
        Utils.RiteVetIndicatorShow()
        let urlString = BASE_URL_KREASE
        
        var parameters:Dictionary<AnyHashable, Any>!
        
        let cell = tbleView.cellForRow(at: NSIndexPath(row: 0, section: 0) as IndexPath) as! SubmitPostTableCell
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]
        {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            // parameterDict.setValue(String(staffId), forKey: "staffId")
            
            parameters = [
                "action"        : "editstaff",
                "userId"        : String(myString),
                "categoryId"    : String(myCatIdIs),
                "postTitle"     : String(cell.txtPostTitle.text!),
                "description"   : String(cell.txtDescription.text!),
                "staffId"       : "\(self.dictGetPostForEdit["staffId"]!)",
                
                "added_time"       : Date.get24TimeWithDateForTimeZone(),
                "current_time_zone" : "\(TimeZone.current.abbreviation()!)",
                 
            ]
            
            
            print("parameters-------\(String(describing: parameters))")
            
            AF.request(urlString, method: .post, parameters: parameters as? Parameters).responseJSON {
                response in
                
                switch(response.result) {
                case .success(_):
                    if let data = response.value {
                        
                        let JSON = data as! NSDictionary
                        print(JSON)
                        
                        var strSuccess : String!
                        strSuccess = JSON["status"]as Any as? String
                        
                        if strSuccess == "success" {
                            self.pushToFreeStuff()
                        }
                        else {
                            
                            Utils.RiteVetIndicatorHide()
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
    }
    
    
    
    
    @objc func delete_video() {
        let cell = tbleView.cellForRow(at: NSIndexPath(row: 0, section: 0) as IndexPath) as! SubmitPostTableCell
        
        
        if self.hereForEdit == "editPost" {
            
        } else {
            print("no edit")
            
            cell.btnVideoPlay.isHidden = true
            cell.btn_delete_video.isHidden = true
            self.strYesIamVideo = "0"
            return
        }
        
        
        
        cell.btnVideoPlay.isHidden = true
        cell.btn_delete_video.isHidden = true
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]
        {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            Utils.RiteVetIndicatorShow()
            
            let urlString = BASE_URL_KREASE
            
            var parameters:Dictionary<AnyHashable, Any>!
            
            parameters = [
                "action"        :   "deletestuffimage",
                "freestaffId"   :   "\(self.dictGetPostForEdit["staffId"]!)",
                "userId"        :   String(myString),
                "image_key"     :   String("video")
            ]
            
            
            print("parameters-------\(String(describing: parameters))")
            
            AF.request(urlString, method: .post, parameters: parameters as? Parameters).responseJSON {
                response in
                
                switch(response.result) {
                case .success(_):
                    if let data = response.value {
                        
                        let JSON = data as! NSDictionary
                        print(JSON)
                        
                        var strSuccess : String!
                        strSuccess = JSON["status"]as Any as? String
                        
                        //var strSuccessAlert : String!
                        //strSuccessAlert = JSON["msg"]as Any as? String
                        
                        if strSuccess == "success" {
                            Utils.RiteVetIndicatorHide()
                            // self.pushToFreeStuff()
                        }
                        else {
                            
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
        
        
        
        if self.hereForEdit == "editPost" {
            cell.btnSubmit.addTarget(self, action: #selector(update_only_details), for: .touchUpInside)
        } else {
            cell.btnSubmit.addTarget(self, action: #selector(uploadImageWB), for: .touchUpInside)
        }
        
        
        // video button
        cell.btnUploadVideo.addTarget(self, action: #selector(openVideoFromGallery), for: .touchUpInside)
        
        /*
         "image_1" = "https://ritevet.com/img/uploads/freestaff/1703850294submit_post_image_1.jpg";
         "image_2" = "https://ritevet.com/img/uploads/freestaff/1703850314submit_post_image_2.png";
         "image_3" = "https://ritevet.com/img/uploads/freestaff/1703850315submit_post_image_3.png";
         "image_4" = "https://ritevet.com/img/uploads/freestaff/1703850315submit_post_image_4.png";
         "image_5" = "";
         */
        if self.hereForEdit == "editPost" {
            
            print(self.dictGetPostForEdit as Any)
            self.arr_add_image.removeAllObjects()
            
            // 1
            if (self.dictGetPostForEdit["image_1"] as! String == "") {
                self.imgData = nil
            } else {
                
                let custom = [
                    "image_name":"image_1",
                    "image":(self.dictGetPostForEdit["image_1"] as! String),
                ]
                self.arr_add_image.add(custom)
            }
            
            // 2
            if (self.dictGetPostForEdit["image_2"] as! String == "") {
                self.imgData2 = nil
            } else {
                let custom = [
                    "image_name":"image_2",
                    "image":(self.dictGetPostForEdit["image_2"] as! String),
                ]
                self.arr_add_image.add(custom)
            }
            
            // 3
            if (self.dictGetPostForEdit["image_3"] as! String == "") {
                self.imgData3 = nil
            } else {
                let custom = [
                    "image_name":"image_3",
                    "image":(self.dictGetPostForEdit["image_3"] as! String),
                ]
                self.arr_add_image.add(custom)
            }
            
            // 4
            if (self.dictGetPostForEdit["image_4"] as! String == "") {
                self.imgData4 = nil
            } else {
                let custom = [
                    "image_name":"image_4",
                    "image":(self.dictGetPostForEdit["image_4"] as! String),
                ]
                self.arr_add_image.add(custom)
            }
            
            // 5
            if (self.dictGetPostForEdit["image_5"] as! String == "") {
                self.imgData5 = nil
            } else {
                let custom = [
                    "image_name":"image_5",
                    "image":(self.dictGetPostForEdit["image_5"] as! String),
                ]
                self.arr_add_image.add(custom)
            }
            
            print(self.arr_add_image as Any)
            print(self.arr_add_image.count as Any)
            
            
            
            
            
            // print(self.dictGetPostForEdit as Any)
            /*
             videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? NSURL
             print(videoURL as Any)
             print("videoURL:\(String(describing: videoURL))")
             cell.btnVideoPlay.isHidden = false
             cell.btnVideoPlay.addTarget(self, action: #selector(playVideoBeforUploadToServer), for: .touchUpInside)
             saveSelectedVideoURLforServer = videoURL as URL?
             imagePickerController.dismiss(animated: true, completion: nil)
             strYesIamVideo = "10"
             */
            if (self.dictGetPostForEdit["video"] as! String != "") {
                // btn_delete_video
                let fileUrl = URL(string: (self.dictGetPostForEdit["video"] as! String))
                self.saveSelectedVideoURLforServer = fileUrl
                
                // self.saveSelectedVideoURLforServer = videoURL as URL?
                cell.btn_delete_video.isHidden = false
                cell.btnVideoPlay.isHidden = false
                cell.btnVideoPlay.addTarget(self, action: #selector(playVideoBeforUploadToServer2), for: .touchUpInside)
                
                cell.btn_delete_video.addTarget(self, action: #selector(delete_video), for: .touchUpInside)
            }
            
            
            
            cell.clView.delegate = self
            cell.clView.dataSource = self
            cell.clView.reloadData()
            
        } else {
            
        }
        
        return cell
    }
    
    @objc func playVideoBeforUploadToServer2() {
        // if videoURL != nil{
        print(self.saveSelectedVideoURLforServer as Any)
        let player = AVPlayer(url: saveSelectedVideoURLforServer)
        
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        
        present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
        // }
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

extension SubmitPost: UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    //Write Delegate Code Here
    
    //UICollectionViewDatasource methods
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arr_add_image.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubmitPostcollectionCell", for: indexPath as IndexPath) as! SubmitPostcollectionCell
        cell.backgroundColor = UIColor.clear
        cell.layer.borderWidth = 0.5
        cell.backgroundColor = UIColor.clear
        cell.layer.borderColor = UIColor.clear.cgColor
        cell.layer.borderWidth = 0.70
    
        cell.imgTitle.backgroundColor = .clear
        
        if self.hereForEdit == "editPost" {
            
            let item = self.arr_add_image[indexPath.row] as? [String:Any]
            cell.imgTitle.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
            cell.imgTitle.sd_setImage(with: URL(string: (item!["image"] as! String)), placeholderImage: UIImage(named: "logo"))
            
            cell.btn_delete.tag = indexPath.row
            cell.btn_delete.addTarget(self, action: #selector(delete_photo_click_method), for: .touchUpInside)
            
        } else {
            let item = self.arr_add_image[indexPath.row] as? [String:Any]
            
            let image : UIImage = UIImage(data: item!["image_data"] as! Data)!
            print(image)
            cell.imgTitle.image = image
            
            if (indexPath.row == 0) {
                self.imgData = ((item!["image_data"]) as! Data)
            } else if (indexPath.row == 1) {
                self.imgData2 =  ((item!["image_data"]) as! Data)
            } else if (indexPath.row == 2) {
                self.imgData3 =   ((item!["image_data"]) as! Data)
            } else if (indexPath.row == 3) {
                self.imgData4 =   ((item!["image_data"]) as! Data)
            } else if (indexPath.row == 4) {
                self.imgData5 =   ((item!["image_data"]) as! Data)
            }
            
            cell.btn_delete.tag = indexPath.row
            cell.btn_delete.addTarget(self, action: #selector(delete_photo_click_method), for: .touchUpInside)
        }
        
        return cell
        
    }
    
    @objc func delete_photo_click_method(_ sender:UIButton) {
        // let item = self.arr_add_image[sender.tag] as? [String:Any]
        
        if self.hereForEdit == "editPost" {
            
            if (self.arr_add_image.count == 1) {
                let cell = self.tbleView.cellForRow(at: NSIndexPath(row: 0, section: 0) as IndexPath) as! SubmitPostTableCell
                let alert = UIAlertController(title: "Alert", message: "You can not delete last image.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
                    
                     
                    
                }))
                
                self.present(alert, animated: true, completion: nil)
            } else {
                let item = self.arr_add_image[sender.tag] as? [String:Any]
                self.arr_add_image.removeObject(at: sender.tag)
                
                let cell = tbleView.cellForRow(at: NSIndexPath(row: 0, section: 0) as IndexPath) as! SubmitPostTableCell
                cell.clView.reloadData()
                
                self.delete_photo_fromWB_click_method(img_key: (item!["image_name"] as! String))
            }
            
            
        } else {
            print(sender.tag as Any)
            self.arr_add_image.removeObject(at: sender.tag)
             
            let cell = tbleView.cellForRow(at: NSIndexPath(row: 0, section: 0) as IndexPath) as! SubmitPostTableCell
            cell.clView.reloadData()
        }
        
        // print()
    }
 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        var sizes: CGSize
        
        sizes = CGSize(width: 100.0, height: 100.0)
        
        return sizes
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
}
class SubmitPostcollectionCell: UICollectionViewCell {
    @IBOutlet weak var imgTitle: UIImageView! {
        didSet {
            imgTitle.layer.cornerRadius = 8
            imgTitle.clipsToBounds = true
        }
    }
    @IBOutlet weak var btn_delete:UIButton!
}

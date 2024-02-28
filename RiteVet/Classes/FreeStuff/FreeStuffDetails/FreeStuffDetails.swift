//
//  FreeStuffDetails.swift
//  RiteVet
//
//  Created by Apple  on 02/12/19.
//  Copyright © 2019 Apple . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
//import ShimmerSwift
import AVKit

class FreeStuffDetails: UIViewController,UITextFieldDelegate {
    var str_get:String! = ""
    let cellReuseIdentifier = "freeStuffDetailsTableCell"
    
    var arrListOfFreeItemDetails:Array<Any>!
    
    var getFreeStuffDict:NSDictionary!
    
    var arrListOfFreeStuffComments:Array<Any>!
    
    var arrListOfImages:Array<Any>!
    
    var collectionView: UICollectionView?
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
    // collection view rows count
    var intCountImage:Int!
    
    // video in collection cell placeholder
    var strVideoCheck:String!
    
    var str_edit_this_comment:String!
    var str_comment_id:String!
    
    @IBOutlet weak var viewNavigation:UIView! {
        didSet {
            viewNavigation.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }
    @IBOutlet weak var btnBack:UIButton!
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "POST DETAILS"
            lblNavigationTitle.textColor = .white
        }
    }
    
    @IBOutlet weak var clView: UICollectionView! {
        didSet {
            //collection
            clView.delegate = self
            clView.dataSource = self
            screenSize = UIScreen.main.bounds
            screenWidth = screenSize.width
            screenHeight = screenSize.height
            
            // Do any additional setup after loading the view, typically from a nib
            let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
            
            
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
            clView!.backgroundColor = .clear
            clView.isPagingEnabled = true
        }
    }
    
    @IBOutlet weak var lblTitleName:UILabel!
    @IBOutlet weak var btnLike:UIButton!
    @IBOutlet weak var btnDislike:UIButton!
    @IBOutlet weak var btnShare:UIButton!
    @IBOutlet weak var lblSubTitle:UILabel!
    @IBOutlet weak var lblTotalViews:UILabel!
    @IBOutlet weak var txtViewDescription:UITextView!
    @IBOutlet weak var imgSend:UIImageView!
    @IBOutlet weak var lblDaysAgo:UILabel! {
        didSet {
            lblDaysAgo.text = "2 weeks ago"
        }
    }
    @IBOutlet weak var lblLoginUserImage:UIImageView! {
        didSet {
            lblLoginUserImage.layer.cornerRadius = 20
            lblLoginUserImage.clipsToBounds = true
        }
    }
    @IBOutlet weak var txtComment:UITextField! {
        didSet {
            txtComment.backgroundColor = UIColor.init(red: 228.0/255.0, green: 234.0/255.0, blue: 10.0/255.0, alpha: 1)
            txtComment.placeholder = "Enter your comment"
            txtComment.layer.cornerRadius = 4
            txtComment.clipsToBounds = true
            txtComment.layer.borderWidth = 1.0
            txtComment.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    @IBOutlet weak var tbleView: UITableView! {
        didSet {
            //tbleView.delegate = self
            //tbleView.dataSource = self
            tbleView.isHidden = true
            tbleView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
            tbleView.backgroundColor = .white
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /****** VIEW BG IMAGE *********/
        //self.view.backgroundColor = UIColor.init(patternImage: UIImage(named: "plainBack")!)
        
        txtComment.delegate = self
        
        self.view.backgroundColor = .white
        
        btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        
        // server values
        self.lblTitleName.text = "please wait..."
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(FreeStuffDetails.cellTappedMethod(_:)))
        
        imgSend.isUserInteractionEnabled = true
        imgSend.addGestureRecognizer(tapGestureRecognizer)
        
        btnLike.addTarget(self, action: #selector(likeWB), for: .touchUpInside)
        btnDislike.addTarget(self, action: #selector(dislike), for: .touchUpInside)
        
        // keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        freeStuffDetailsWB()
    }
    
    @objc func cellTappedMethod(_ sender:AnyObject){
        self.addComment()
    }
    
    //    @objc func keyboardWillShow(notification: NSNotification) {
    //        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
    //            if self.view.frame.origin.y == 0 {
    //                self.view.frame.origin.y -= keyboardSize.height
    //            }
    //        }
    //    }
    //
    //    @objc func keyboardWillHide(notification: NSNotification) {
    //        if self.view.frame.origin.y != 0 {
    //            self.view.frame.origin.y = 0
    //        }
    //    }
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        //print(getFreeStuffDict as Any)
        
        var strImageOne:String!
        var strImageTwo:String!
        var strImageThree:String!
        var strImageFour:String!
        var strImageFive:String!
        
        
        strImageOne   = (getFreeStuffDict!["image_1"] as! String)
        strImageTwo   = (getFreeStuffDict!["image_2"] as! String)
        strImageThree = (getFreeStuffDict!["image_3"] as! String)
        strImageFour  = (getFreeStuffDict!["image_4"] as! String)
        strImageFive  = (getFreeStuffDict!["image_5"] as! String)
        strVideoCheck  = (getFreeStuffDict!["video"] as! String)
        
        // 1
        if strImageOne == "" {
        }
        else {
            intCountImage = 1
        }
        
        // 2
        if strImageTwo == "" {
        }
        else {
            
            intCountImage = 2
        }
        
        // 3
        if strImageThree == "" {
        }
        else {
            intCountImage = 3
        }
        
        // 4
        if strImageFour == "" {
        }
        else {
            intCountImage = 4
        }
        
        // 5
        if strImageFive == "" {
        }
        else {
            intCountImage = 5
        }
        
        
        //            var addMe:String!
        //            var addAllStrings:String!
        //
        //            addMe = strImageOne+", "+strImageTwo+", "+strImageThree+", "+strImageFour+", "+strImageFive
        //
        //            print(addMe as Any)
        //
        //            addAllStrings = addMe.replacingOccurrences(of: ", ", with: "+", options: [.regularExpression, .caseInsensitive])
        //
        //            print("=====>"+addAllStrings as Any)
        
        
        
        
        
        //            // 6
        //            if strVideoCheck == "" {
        //            }
        //            else {
        //                intCountImage = 6
        //            }
        
        
        
        
        /*
         categoryId = 18;
         categoryName = Bird;
         created = "2019-12-23 13:51:00";
         description = "In this unique world all type of birds are moving in a different direction and other related things have been found to make the trend of their future in very different and uniquely different environments ";
         "image_1" = "http://demo2.evirtualservices.com/ritevet/site/img/uploads/freestaff/1577082058images104.jpeg";
         "image_2" = "http://demo2.evirtualservices.com/ritevet/site/img/uploads/freestaff/1577082058140384-center-12.jpeg";
         "image_3" = "http://demo2.evirtualservices.com/ritevet/site/img/uploads/freestaff/1577082058images93.jpeg";
         "image_4" = "";
         "image_5" = "";
         postTitle = "How birds are moving in this world";
         staffId = 84;
         totalComment = 0;
         userImage = "http://demo2.evirtualservices.com/ritevet/site/img/uploads/users/1574315662_images (10).jpeg";
         userName = purnima;
         video = "";
         */
        
        //var freeStuffId:NSNumber!
        //freeStuffId = ((getFreeStuffDict!["categoryId"]) as! NSNumber)
        //self.freeStuffDetailsWB(strStuffIdInNumber: freeStuffId)
        
        self.lblTitleName.text = (getFreeStuffDict!["postTitle"] as! String)
        self.lblSubTitle.text = (getFreeStuffDict!["categoryName"] as! String)
        self.txtViewDescription.text = (getFreeStuffDict!["description"] as! String)
        self.lblTotalViews.text = ""
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func freeStuffDetailsWB() {
        
        Utils.RiteVetIndicatorShow()
        
        let urlString = BASE_URL_KREASE
        
        var parameters:Dictionary<AnyHashable, Any>!
        
        parameters = [
            "action"     : "stuffdetail",
            "staffId"    : (getFreeStuffDict!["staffId"] as! NSNumber)
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
                    //strSuccessAlert = JSON["data"]as Any as? String
                    
                    var dictServerValue:NSDictionary!
                    
                    if strSuccess == "success" {
                        dictServerValue = (JSON["data"] as! NSDictionary)
                        
                        // print(dictServerValue as Any)
                        /*
                         data =     {
                         TotalDislike = 0;
                         TotalLike = 1;
                         categoryId = 15;
                         categoryName = Cat;
                         created = "2019-11-20 10:42:00";
                         description = "<p>Test free stuff for all type of animal food</p>
                         \n";
                         "image_1" = "http://demo2.evirtualservices.com/ritevet/site/img/uploads/freestaff/1574226718";
                         "image_2" = "http://demo2.evirtualservices.com/ritevet/site/img/uploads/freestaff/1574256045";
                         "image_3" = "";
                         "image_4" = "";
                         "image_5" = "";
                         likeStatus = 0;
                         postTitle = "Food free stuff";
                         staffId = 23;
                         totalComment = 1;
                         totalView = 1;
                         userImage = "http://demo2.evirtualservices.com/ritevet/site/img/uploads/users/15688797792.jpg";
                         userName = "Rite Vet App";
                         video = "";
                         };
                         */
                        
                        //print(dictServerValue!["TotalLike"] as! String)
                        
                        // lblDaysAgo
                        
                        
                        
                        // created
                        // let array = (dictServerValue!["created"] as! String).components(separatedBy: " ")
                        // print(array as Any)
                        
                        // print(array[1] as Any)
                        
                        self.lblDaysAgo.text = (dictServerValue!["created"] as! String)
                        
                        self.lblTitleName.text = (dictServerValue!["postTitle"] as! String)
                        self.txtViewDescription.text = (dictServerValue!["description"] as! String)
                        
                        let livingArea = dictServerValue?["totalView"] as? Int ?? 0
                        
                        if livingArea == 0 {
                            let stringValue = String(livingArea)
                            self.lblTotalViews.text = (stringValue)+" View"
                        } else if livingArea == 1 {
                            let stringValue = String(livingArea)
                            self.lblTotalViews.text = (stringValue)+" View"
                        } else {
                            let stringValue = String(livingArea)
                            self.lblTotalViews.text = (stringValue)+" Views"
                        }
                        
                        let likeCheck = dictServerValue?["TotalLike"] as? Int ?? 0
                        if likeCheck == 0 {
                            let stringValue = String(likeCheck)
                            self.btnLike.isHidden = false
                            self.btnLike.imageEdgeInsets = UIEdgeInsets(top: 6,left: 20,bottom: 6,right: 14)
                            self.btnLike.titleEdgeInsets = UIEdgeInsets(top: 0,left: -10,bottom: 0,right: 34)
                            self.btnLike.setTitle(stringValue, for: .normal)
                        }
                        else {
                            let stringValue = String(likeCheck)
                            self.btnLike.isHidden = false
                            self.btnLike.imageEdgeInsets = UIEdgeInsets(top: 6,left: 20,bottom: 6,right: 14)
                            self.btnLike.titleEdgeInsets = UIEdgeInsets(top: 0,left: -10,bottom: 0,right: 34)
                            self.btnLike.setTitle(stringValue, for: .normal)
                        }
                        
                        
                        // dislike
                        let disLikeCheck = dictServerValue?["TotalDislike"] as? Int ?? 0
                        if disLikeCheck == 0 {
                            let stringValue = String(disLikeCheck)
                            self.btnDislike.isHidden = false
                            self.btnDislike.imageEdgeInsets = UIEdgeInsets(top: 6,left: 20,bottom: 6,right: 14)
                            self.btnDislike.titleEdgeInsets = UIEdgeInsets(top: 0,left: -10,bottom: 0,right: 34)
                            self.btnDislike.setTitle(stringValue, for: .normal)
                        }
                        else
                        {
                            let stringValue = String(disLikeCheck)
                            self.btnDislike.isHidden = false
                            self.btnDislike.imageEdgeInsets = UIEdgeInsets(top: 6,left: 20,bottom: 6,right: 14)
                            self.btnDislike.titleEdgeInsets = UIEdgeInsets(top: 0,left: -5,bottom: 0,right: 34)
                            self.btnDislike.setTitle(stringValue, for: .normal)
                        }
                        
                        
                        Utils.RiteVetIndicatorHide()
                        self.commentListWB()
                        
                    }
                    else
                    {
                        //                                   self.indicator.stopAnimating()
                        //                                   self.enableService()
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
    
    
    private func timestampToStringAgo(timestamp: Int64) -> String{
        let actualTime = Int64(Date().timeIntervalSince1970*1000)
        var lastSeenTime = actualTime - timestamp
        lastSeenTime /= 1000 //seconds
        var lastTimeString = ""
        if lastSeenTime < 60 {
            if lastSeenTime == 1 {
                lastTimeString = String(lastSeenTime) + " second ago"
            } else {
                lastTimeString = String(lastSeenTime) + " seconds ago"
            }
        } else {
            lastSeenTime /= 60
            if lastSeenTime < 60 {
                if lastSeenTime == 1 {
                    lastTimeString =  String(lastSeenTime) + " minute ago"
                } else {
                    lastTimeString =  String(lastSeenTime) + " minutes ago"
                }
                
            } else {
                lastSeenTime /= 60
                if lastSeenTime < 24 {
                    if lastSeenTime == 1 {
                        lastTimeString = String(lastSeenTime) + " hour ago"
                    } else {
                        lastTimeString = String(lastSeenTime) + " hours ago"
                    }
                } else {
                    lastSeenTime /= 24
                    if lastSeenTime == 1 {
                        lastTimeString = String(lastSeenTime) + " day ago"
                    } else {
                        lastTimeString = String(lastSeenTime) + " days ago"
                    }
                }
            }
        }
        return lastTimeString
    }
    
    func commentListWB() {
        //self.pushFromLoginPage()
        
        //indicator.startAnimating()
        //           self.disableService()
        
        
        let urlString = BASE_URL_KREASE
        
        var parameters:Dictionary<AnyHashable, Any>!
        
        parameters = [
            "action"        :   "commentlist",
            "pageNo"        :   "0",
            "freestaffId"    :(getFreeStuffDict!["staffId"] as! NSNumber)
        ]
        
        
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
                    
                    if strSuccess == "success" //true
                    {
                        Utils.RiteVetIndicatorHide()
                        self.tbleView.isHidden = false
                        
                        self.tbleView!.dataSource = self
                        self.tbleView!.delegate = self
                        
                        var ar : NSArray!
                        ar = (JSON["data"] as! Array<Any>) as NSArray
                        
                        self.arrListOfFreeStuffComments = (ar as! Array<Any>)
                        self.tbleView.reloadData()
                        
                    }
                    else {
                        Utils.RiteVetIndicatorHide()
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
    
    func addComment() {
        self.view.endEditing(true)
        //self.pushFromLoginPage()
        
        //indicator.startAnimating()
        //           self.disableService()
        
        Utils.RiteVetIndicatorShow()
        
        let urlString = BASE_URL_KREASE
        
        var parameters:Dictionary<AnyHashable, Any>!
        if (self.str_edit_this_comment == "1") {
            
            
            if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]
            {
                let x : Int = (person["userId"] as! Int)
                let myString = String(x)
                
                parameters = [
                    "action"        : "addcomment",
                    "userId"        : myString,
                    "commentId"     : String(self.str_comment_id),
                    "freestaffId"   : (getFreeStuffDict!["staffId"] as! NSNumber),
                    "comment"       : String(txtComment.text!),
                    "added_time"    : Date.get24TimeForTimeZone(),
                    "current_time_zone":"\(TimeZone.current.abbreviation()!)",
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
                        
                        if strSuccess == "success" //true
                        {
                            self.str_edit_this_comment = "0"
                            self.txtComment.text = ""
                            self.commentListWB()
                            
                        }
                        else
                        {
                            //                                   self.indicator.stopAnimating()
                            //                                   self.enableService()
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
            
            
            
        } else {
            if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]
            {
                let x : Int = (person["userId"] as! Int)
                let myString = String(x)
                
                parameters = [
                    "action"        : "addcomment",
                    "userId"        : myString,
                    "freestaffId"   : (getFreeStuffDict!["staffId"] as! NSNumber),
                    "comment"       : String(txtComment.text!),
                    "added_time"    : Date.get24TimeWithDateForTimeZone(),
                    "current_time_zone":"\(TimeZone.current.abbreviation()!)",
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
                        
                        if strSuccess == "success" //true
                        {
                            self.txtComment.text = ""
                            self.commentListWB()
                            
                        }
                        else
                        {
                            //                                   self.indicator.stopAnimating()
                            //                                   self.enableService()
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
    
    @objc func likeWB() {
        //self.pushFromLoginPage()
        
        //indicator.startAnimating()
        //           self.disableService()
        
        
        let urlString = BASE_URL_KREASE
        
        var parameters:Dictionary<AnyHashable, Any>!
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]
        {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            parameters = [
                "action"        :   "stufflikes",
                "userId"        :   myString,
                "freestaffId"    :(getFreeStuffDict!["staffId"] as! NSNumber),
                "status"    :"1"
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
                    
                    if strSuccess == "Success" //true
                    {
                        self.freeStuffDetailsWB()
                    }
                    else
                    {
                        //                                   self.indicator.stopAnimating()
                        //                                   self.enableService()
                    }
                    
                }
                
            case .failure(_):
                print("Error message:\(String(describing: response.error))")
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
    
    @objc func dislike() {
        //self.pushFromLoginPage()
        
        //indicator.startAnimating()
        //           self.disableService()
        
        
        let urlString = BASE_URL_KREASE
        
        var parameters:Dictionary<AnyHashable, Any>!
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]
        {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            parameters = [
                "action"        :   "stufflikes",
                "userId"        :   myString,
                "freestaffId"    :(getFreeStuffDict!["staffId"] as! NSNumber),
                "status"    :"2"
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
                    
                    if strSuccess == "Success" //true
                    {
                        self.freeStuffDetailsWB()
                    }
                    else
                    {
                        //                                   self.indicator.stopAnimating()
                        //                                   self.enableService()
                    }
                    
                }
                
            case .failure(_):
                print("Error message:\(String(describing: response.error))")
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view .endEditing(true)
        return true
    }
    
    @objc func delete_this_comment(_ sender:UIButton) {
        Utils.RiteVetIndicatorShow()
        
        print(sender.tag)
        
        let item = arrListOfFreeStuffComments[sender.tag] as? [String:Any]
        print(item as Any)
        
        /*
         action: commentdelete
         userId:
         freestaffId:
         commentId:
         */
        
        print(self.getFreeStuffDict as Any)
        
        let urlString = BASE_URL_KREASE
        
        var parameters:Dictionary<AnyHashable, Any>!
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            parameters = [
                "action"        :   "commentdelete",
                "userId"        :   myString,
                "freestaffId"   :   "\(self.getFreeStuffDict!["staffId"]!)",
                "commentId"     :   "\(item!["freestaffcommentId"]!)"
            ]
            
        }
        
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
                        self.commentListWB()
                    }
                    else {
                        //                                   self.indicator.stopAnimating()
                        //                                   self.enableService()
                    }
                    
                }
                
            case .failure(_):
                print("Error message:\(String(describing: response.error))")
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
    
    @objc func editMyComment(_ sender:UIButton) {
        // Utils.RiteVetIndicatorShow()
        
        print(sender.tag)
        
        let item = arrListOfFreeStuffComments[sender.tag] as? [String:Any]
        print(item as Any)
        
        self.txtComment.text = (item!["comment"] as! String)
       
        self.str_comment_id = "\(item!["freestaffcommentId"]!)"
        
        self.str_edit_this_comment = "1"
    }
     
}

extension FreeStuffDetails: UITableViewDataSource {
    
        func numberOfSections(in tableView: UITableView) -> Int
        {
            var numOfSection: NSInteger = 0
            
            if arrListOfFreeStuffComments.count > 0 {
                
                self.tbleView.backgroundView = nil
                numOfSection = 1
                
                
            } else {
                
                //let noDataLabel: UILabel = UILabel(frame: CGRectMake(0, 0, self.tbleView.bounds.size.width, self.tbleView.bounds.size.height))
                
                let noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.tbleView.bounds.size.width, height: self.tbleView.bounds.size.height))
                
                
                
                noDataLabel.text = "No Comments Available"
                noDataLabel.textColor = UIColor(red: 22.0/255.0, green: 106.0/255.0, blue: 176.0/255.0, alpha: 1.0)
                noDataLabel.textAlignment = NSTextAlignment.center
                self.tbleView.backgroundView = noDataLabel
                
            }
            return numOfSection
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
        {
            return arrListOfFreeStuffComments.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
        {
            let cell:FreeStuffDetailsTableCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! FreeStuffDetailsTableCell
            
            cell.backgroundColor = .clear
            
            let item = arrListOfFreeStuffComments[indexPath.row] as? [String:Any]
            
            print(item as Any)
            /*
             Optional(["UserfullName": Dishant Rajput, "created": 2019-12-23 17:46:00, "userId": 105, "Userprofile_picture": , "Useremail": abcd@gmail.com, "freestaffcommentId": 57, "comment": I am comment oki ])
             */
            
            if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
                print(person as Any)
                
                let x : Int = (person["userId"] as! Int)
                let myString = String(x)
                
                if "\(item!["userId"]!)" == "\(myString)" {
                    cell.btn_delete.isHidden = false
                    cell.btn_edit.isHidden =  false
                } else {
                    cell.btn_delete.isHidden = true
                    cell.btn_edit.isHidden =  true
                }
            }
            
            print(TimeZone.current.abbreviation()!)
            
            if (item!["added_time"] as! String) != "" {
                // divide time
                let fullName    = (item!["added_time"] as! String)
                let fullNameArr = fullName.components(separatedBy: " ")

                let normal_date    = fullNameArr[0]
                let surname = fullNameArr[1]
                
                // print(normal_date as Any)
                // print(surname as Any)
                
                // divide sub time
                let divide_time = surname.components(separatedBy: ":")
                let time_hour    = divide_time[0]
                let time_minute = divide_time[1]
                
                // print(time_hour as Any)
                // print(time_minute as Any)
                
                let joiin_and_create_new_time = time_hour+":"+time_minute
                // print(joiin_and_create_new_time as Any)
                
                let dateAsString = String(joiin_and_create_new_time)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm"

                let date = dateFormatter.date(from: dateAsString)
                dateFormatter.dateFormat = "h:mm a"
                let Date12 = dateFormatter.string(from: date!)
                // print(Date12)
                
                // print(date24 as Any)
                let commenter_time_zone = (item!["current_time_zone"] as! String)
                let commenter_watcher_time_zone = "\(TimeZone.current.abbreviation()!)"
                // print(commenter_time_zone)
                // print(commenter_watcher_time_zone)
                
                let timeFormatterGet = DateFormatter()
                timeFormatterGet.dateFormat = "yyyy-MM-dd h:mm a"
                // timeFormatterGet.timeZone = TimeZone(abbreviation: TimeZone.current.abbreviation()!)
                timeFormatterGet.timeZone = TimeZone(abbreviation: "\(commenter_time_zone)")
                
                let timeFormatterPrint = DateFormatter()
                timeFormatterPrint.dateFormat = "yyyy-MM-dd h:mm a"
                timeFormatterPrint.timeZone = TimeZone(abbreviation: "\(commenter_watcher_time_zone)")
                
                // timeFormatterPrint.timeZone = TimeZone(abbreviation: "\(TimeZone.current.abbreviation()!)\(TimeZone.current.currentTimezoneOffset())") // if you want to specify timezone for output, otherwise leave this line blank and it will default to devices timezone

                let join_date_and_time_together = String(normal_date)+" "+String(Date12)
                // print(join_date_and_time_together)
                
                
                if let date = timeFormatterGet.date(from: "\(join_date_and_time_together)") {
                    print(timeFormatterPrint.string(from: date))
                    self.str_get = timeFormatterPrint.string(from: date)
                } else {
                   print("There was an error decoding the string")
                }
                
                cell.lblTitle.text = (item!["UserfullName"] as! String)+" - "+String(self.str_get)
            } else {
                cell.lblTitle.text = (item!["UserfullName"] as! String)
            }
            
            
            cell.lblMessage.text = (item!["comment"] as! String)
            // cell.imgProfile.image = UIImage(named:"dog")
            cell.imgProfile.sd_setImage(with: URL(string: (item!["Userprofile_picture"] as! String)), placeholderImage: UIImage(named: "logo-500"))
            
            cell.btn_delete.tag = indexPath.row
            cell.btn_delete.addTarget(self, action: #selector(delete_this_comment), for: .touchUpInside)
            
            cell.btn_edit.tag = indexPath.row
            cell.btn_edit.addTarget(self, action: #selector(editMyComment), for: .touchUpInside)
            
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView .deselectRow(at: indexPath, animated: true)
            
            // let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SubmitPostId") as? SubmitPost
            // self.navigationController?.pushViewController(push!, animated: true)
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 90
        }
    }

extension FreeStuffDetails: UITableViewDelegate {
        
    }

//MARK:- COLLECTION VIEW
extension FreeStuffDetails: UICollectionViewDelegate {
    //Write Delegate Code Here
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "freeStuffDetailsCollectionCell", for: indexPath as IndexPath) as! FreeStuffDetailsCollectionCell
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor.clear.cgColor
        cell.layer.borderWidth = 0.70
    
        cell.backgroundColor = .white
        
        //print(getFreeStuffDict!["image_1"] as! String)
        //print(getFreeStuffDict!["image_2"] as! String)
        //print(getFreeStuffDict!["image_3"] as! String)
        //print(getFreeStuffDict!["image_4"] as! String)
        //print(getFreeStuffDict!["image_5"] as! String)
        
        //if indexPath.item == intCountImage! {
        
        //print(intCountImage as Any)
        
        
        
        if indexPath.row == 0 {
            cell.img.sd_setImage(with: URL(string: (getFreeStuffDict!["image_1"] as! String)), placeholderImage: UIImage(named: "play_icon"))
        }
        else
        {
            // one
            print("one")
        }
//        else
        if indexPath.row == 1 {
            cell.img.sd_setImage(with: URL(string: (getFreeStuffDict!["image_2"] as! String)), placeholderImage: UIImage(named: "play_icon"))
        }
        else
        {
            // two
            print("two")
        }
        
        //else
        if indexPath.row == 2 {
            cell.img.sd_setImage(with: URL(string: (getFreeStuffDict!["image_3"] as! String)), placeholderImage: UIImage(named: "play_icon"))
        }
        else
        {
            // three
            print("three")
        }
        
        
        //else
        if indexPath.row == 3 {
            cell.img.sd_setImage(with: URL(string: (getFreeStuffDict!["image_4"] as! String)), placeholderImage: UIImage(named: "play_icon"))
        }
        else
        {
            // four
            print("four")
        }
        
        //else
        if indexPath.row == 4 {
            cell.img.sd_setImage(with: URL(string: (getFreeStuffDict!["image_5"] as! String)), placeholderImage: UIImage(named: "play_icon"))
        }
        else
        {
            // five
            print("five")
        }
        //}
        
        if cell.img.image == UIImage(named:"plainBack") {
            print("six")
        }
        
        
        
        
        
        
        
        //cell.img.sd_setImage(with: URL(string: arrListOfImages![indexPath.row] as! String), placeholderImage: UIImage(named: "plainBack"))
        
        return cell
        
    }
    
    //UICollectionViewDatasource methods
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if strVideoCheck == "" {
            return intCountImage
        }
        else
        {
            return intCountImage+1
        }
    }
}

extension FreeStuffDetails: UICollectionViewDataSource {
    //Write DataSource Code Here
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if indexPath.row >= intCountImage {
            print("yes")
            if strVideoCheck == "" {
                
            }
            else
            {
                let videoURL = URL(string: strVideoCheck)
                let player = AVPlayer(url: videoURL!)
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                self.present(playerViewController, animated: true) {
                    playerViewController.player!.play()
                }
            }
        }
        else
        {
            print("no")
        }
        
        
        
    }
}

extension FreeStuffDetails: UICollectionViewDelegateFlowLayout
{
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        /*
         var sizes: CGSize
         
         let result = UIScreen.main.bounds.size
         //                    NSLog("%f",result.height);
         if result.height == 480
         {
         //Load 3.5 inch xib
         sizes = CGSize(width: 170.0, height: 190.0)
         }
         else if result.height == 568
         {
         //Load 4 inch xib
         sizes = CGSize(width: 130.0, height: 150.0)
         }
         else if result.height == 667.000000
         {
         //Load 4.7 inch xib
         sizes = CGSize(width: 170.0, height: 190.0)
         }
         else if result.height == 736.000000
         {
         // iphone 6s Plus and 7 Plus
         sizes = CGSize(width: 190.0, height: 210.0)
         }
         else if result.height == 812.000000
         {
         // iphone X
         sizes = CGSize(width: 170.0, height: 190.0)
         }
         else if result.height == 896.000000
         {
         // iphone Xr
         sizes = CGSize(width: 190.0, height: 210.0)
         }
         else
         {
         sizes = CGSize(width: 170.0, height: 190.0)
         }
         
         return sizes
         */
        CGSize(width: view.frame.width, height: 190.0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
                        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
}

extension Date {
    func timeAgoDisplay() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}

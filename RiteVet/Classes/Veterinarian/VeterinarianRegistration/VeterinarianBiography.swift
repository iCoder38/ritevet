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
    
    var dict_new:NSDictionary!
    
    var str_upload_picture:String! = "0"
    var str_upload_business:String! = "0"
    var str_upload_est_price:String! = "0"
    var str_upload_upload_transcript:String! = "0"
    var str_upload_license:String! = "0"
    
    @IBOutlet weak var viewNavigation:UIView! {
        didSet {
            viewNavigation.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }
    @IBOutlet weak var btnBack:UIButton!
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "VETERINARIAN BIOGRAPHY"
            lblNavigationTitle.textColor = .white
        }
    }
    
    
    @IBOutlet weak var tbleView: UITableView! {
        didSet {
            
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
        
        
         
        
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        self.welcome4()
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
        
        Utils.textFieldDR(text: cell.txtUpload, placeHolder: "Upload your Picture*", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: cell.txtUploadYourBusinessPicture, placeHolder: "Upload Business Picture*", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: cell.txtEstimatedPriceList, placeHolder: "Estimated Price List*", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: cell.txtUploadTranscript, placeHolder: "Upload Transcript*", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: cell.txtLicense, placeHolder: "License*", cornerRadius: 20, color: .white)
        Utils.textFieldDR(text: cell.txtSupportDocumentation, placeHolder: "Supporting Document", cornerRadius: 20, color: .white)
        
        // if (cell.txtView.text == "") {
            cell.txtView.text = (self.dict_new["biography"] as! String)
        // }
        
        
        Utils.buttonDR(button: cell.btnNext, text: "NEXT", backgroundColor: BUTTON_BACKGROUND_COLOR_BLUE, textColor: BUTTON_TEXT_COLOR, cornerRadius: 20)
        
        //cell.btnCheckUncheck.addTarget(self, action: #selector(btnCheckUncheckClickMethod), for: .touchUpInside)
        //cell.btnCheckUncheck.tag = 0
        
        cell.btnCheckUncheck.isHidden = true
        
        btnCheckUncheckCode = UIButton(frame: CGRect(x: 15, y: 528, width: 34, height: 34))
        btnCheckUncheckCode.tag = 0
        btnCheckUncheckCode.setImage(UIImage(named: "regUncheck"), for: .normal)
        btnCheckUncheckCode.addTarget(self, action: #selector(btnCheckUncheckClickMethod), for: .touchUpInside)
        cell.addSubview(btnCheckUncheckCode)
        
        /*
         var :String! = ""
         var :String! = ""
         var :String! = ""
         var :String! = ""
         var :String! = ""
         */
        // if (self.dict_new["multi_image"] != nil) {
        var dict_own: Dictionary<AnyHashable, Any>
        dict_own = self.dict_new["multi_image"] as! Dictionary<AnyHashable, Any>
        print(dict_own as Any)
        
        // var ar_multi_image : NSArray!
        if (dict_own["Own"] == nil) {
            self.str_upload_picture = "0"
        } else {
            self.str_upload_picture = "1"
            let ar_own_ar_multi_image = (dict_own["Own"] as! Array<Any>) as NSArray
            print(ar_own_ar_multi_image as Any)
            cell.txtUpload.text = "Uploaded : \(ar_own_ar_multi_image.count)/10"
        }
        
        
        // business picture
        /*var dict_business: Dictionary<AnyHashable, Any>
         dict_business = self.dict_new["multi_image"] as! Dictionary<AnyHashable, Any>
         print(dict_business as Any)*/
        
        // var ar_multi_image : NSArray!
        if (dict_own["Business"] == nil) {
            self.str_upload_business = "0"
        } else {
            self.str_upload_business = "1"
            let arr_business = (dict_own["Business"] as! Array<Any>) as NSArray
            print(arr_business as Any)
            cell.txtUploadYourBusinessPicture.text = "Uploaded : \(arr_business.count)/10"
        }
        
        
        
        // license
        /*var dict_license: Dictionary<AnyHashable, Any>
        dict_license = self.dict_new["multi_image"] as! Dictionary<AnyHashable, Any>
        print(dict_license as Any)*/
        
        if (dict_own["License"] == nil) {
            self.str_upload_license = "0"
        } else {
            self.str_upload_license = "1"
            let arr_license = (dict_own["License"] as! Array<Any>) as NSArray
            print(arr_license as Any)
            cell.txtLicense.text = "Uploaded : \(arr_license.count)/10"
        }
        
        
        
        // est price
        /*var dict_est_price: Dictionary<AnyHashable, Any>
        dict_est_price = self.dict_new["multi_image"] as! Dictionary<AnyHashable, Any>
        print(dict_est_price as Any)*/
        
        if (dict_own["Eprice"] == nil) {
            self.str_upload_est_price = "0"
        } else {
            self.str_upload_est_price = "1"
            let arr_est_price = (dict_own["Eprice"] as! Array<Any>) as NSArray
            print(arr_est_price as Any)
            cell.txtEstimatedPriceList.text = "Uploaded : \(arr_est_price.count)/10"
        }
        
        
        
        // transcript
        /*var dict_transcript: Dictionary<AnyHashable, Any>
        dict_transcript = self.dict_new["multi_image"] as! Dictionary<AnyHashable, Any>
        print(dict_transcript as Any)*/
        
        if (dict_own["Transcript"] == nil) {
            self.str_upload_upload_transcript = "0"
        } else {
            self.str_upload_upload_transcript = "1"
            let arr_transcript = (dict_own["Transcript"] as! Array<Any>) as NSArray
            print(arr_transcript as Any)
            cell.txtUploadTranscript.text = "Uploaded : \(arr_transcript.count)/10"
        }
        
        
        
        // document
        var dict_document: Dictionary<AnyHashable, Any>
        dict_document = self.dict_new["multi_image"] as! Dictionary<AnyHashable, Any>
        print(dict_document as Any)
        
        if (dict_own["Document"] == nil) {
            // cell.txtUpload.text = "Please upload an Business *"
        } else {
            let arr_document = (dict_own["Document"] as! Array<Any>) as NSArray
            print(arr_document as Any)
            cell.txtSupportDocumentation.text = "Uploaded : \(arr_document.count)/10"
        }
        
        
        // }
        
        cell.btnUploadYourPicture.addTarget(self, action: #selector(uploadProfilePictureClickMethod), for: .touchUpInside)
        cell.btnUploadYourBusinessProfile.addTarget(self, action: #selector(uploadYourBusinessProfilePictureClickMethod), for: .touchUpInside)
        cell.btnEstimatedPriceList.addTarget(self, action: #selector(estimatedPriceListClickMethod), for: .touchUpInside)
        cell.btnUploadTranscript.addTarget(self, action: #selector(transcriptClickMethod), for: .touchUpInside)
        cell.btnLicense.addTarget(self, action: #selector(licenseClickMethod), for: .touchUpInside)
        cell.btnUploadSupportDocumantation.addTarget(self, action: #selector(SupportDocumentationClickMethod), for: .touchUpInside)
        
        cell.btnNext.addTarget(self, action: #selector(nextClick(_:)), for: .touchUpInside)
        
        
        cell.btn_upload_own_profile_picture.addTarget(self, action: #selector(upload_profile_picture_click_method), for: .touchUpInside)
        
        cell.btn_upload_business_picture.addTarget(self, action: #selector(upload_profile_business_picture_click_method), for: .touchUpInside)
        
        cell.btn_upload_e_price_picture.addTarget(self, action: #selector(upload_profile_e_price_click_method), for: .touchUpInside)
        
        cell.btn_upload_transcript_picture.addTarget(self, action: #selector(upload_profile_transcript_click_method), for: .touchUpInside)
        
        cell.btn_upload_license_picture.addTarget(self, action: #selector(upload_profile_license_click_method), for: .touchUpInside)
        
        cell.btn_upload_document_picture.addTarget(self, action: #selector(upload_profile_document_click_method), for: .touchUpInside)
        
        return cell
    }
    
    @objc func upload_profile_business_picture_click_method() {
        let cell = tbleView.cellForRow(at: NSIndexPath(row: 0, section: 0) as IndexPath) as! VeterinarianBiographyTableCell
        
        UserDefaults.standard.set(cell.txtView.text, forKey: "key_biography")
        var dict_multi_image: Dictionary<AnyHashable, Any>
        dict_multi_image = self.dict_new["multi_image"] as! Dictionary<AnyHashable, Any>
        print(dict_multi_image as Any)
        
        var ar_multi_image : NSArray!
        if (dict_multi_image["Business"] == nil) {
            
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "add_images_in_vet_id") as? add_images_in_vet
            
            push!.str_title_name = "Upload Business Picture"
            push!.arr_image = []
            
            push!.str_image_type = String("Business")
            push!.str_user_info_id = "\(self.dict_new["userInfoId"]!)"
            
            self.navigationController?.pushViewController(push!, animated: true)
            
        } else {
            ar_multi_image = (dict_multi_image["Business"] as! Array<Any>) as NSArray
            print(ar_multi_image as Any)
            
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "add_images_in_vet_id") as? add_images_in_vet
            
            push!.str_title_name = "Upload Business Picture"
            push!.arr_image = ar_multi_image
            
            push!.str_image_type = String("Business")
            push!.str_user_info_id = "\(self.dict_new["userInfoId"]!)"
            self.navigationController?.pushViewController(push!, animated: true)
        }
        
    }
    @objc func upload_profile_e_price_click_method() {
        let cell = tbleView.cellForRow(at: NSIndexPath(row: 0, section: 0) as IndexPath) as! VeterinarianBiographyTableCell
        
        UserDefaults.standard.set(cell.txtView.text, forKey: "key_biography")
        var dict_multi_image: Dictionary<AnyHashable, Any>
        dict_multi_image = self.dict_new["multi_image"] as! Dictionary<AnyHashable, Any>
        print(dict_multi_image as Any)
        
        var ar_multi_image : NSArray!
        
        if (dict_multi_image["Eprice"] == nil) {
             
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "add_images_in_vet_id") as? add_images_in_vet
            
            push!.str_title_name = "Upload Estimate Price Picture"
            push!.arr_image = []
            
            push!.str_image_type = String("Eprice")
            push!.str_user_info_id = "\(self.dict_new["userInfoId"]!)"
            self.navigationController?.pushViewController(push!, animated: true)
            
        } else {
            
            ar_multi_image = (dict_multi_image["Eprice"] as! Array<Any>) as NSArray
            print(ar_multi_image as Any)
            
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "add_images_in_vet_id") as? add_images_in_vet
            
            push!.str_title_name = "Upload Estimate Price Picture"
            push!.arr_image = ar_multi_image
            
            push!.str_image_type = String("Eprice")
            push!.str_user_info_id = "\(self.dict_new["userInfoId"]!)"
            self.navigationController?.pushViewController(push!, animated: true)
            
        }
        
    }
    
    @objc func upload_profile_transcript_click_method() {
        let cell = tbleView.cellForRow(at: NSIndexPath(row: 0, section: 0) as IndexPath) as! VeterinarianBiographyTableCell
        
        UserDefaults.standard.set(cell.txtView.text, forKey: "key_biography")
        var dict_multi_image: Dictionary<AnyHashable, Any>
        dict_multi_image = self.dict_new["multi_image"] as! Dictionary<AnyHashable, Any>
        print(dict_multi_image as Any)
        
        var ar_multi_image : NSArray!
        
        if (dict_multi_image["Transcript"] == nil) {
             
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "add_images_in_vet_id") as? add_images_in_vet
            
            push!.str_title_name = "Upload Transcript Picture"
            push!.arr_image = []
            
            push!.str_image_type = String("Transcript")
            push!.str_user_info_id = "\(self.dict_new["userInfoId"]!)"
            self.navigationController?.pushViewController(push!, animated: true)
            
        } else {
            
            ar_multi_image = (dict_multi_image["Transcript"] as! Array<Any>) as NSArray
            print(ar_multi_image as Any)
            
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "add_images_in_vet_id") as? add_images_in_vet
            
            push!.str_title_name = "Upload Transcript Picture"
            push!.arr_image = ar_multi_image
            
            push!.str_image_type = String("Transcript")
            push!.str_user_info_id = "\(self.dict_new["userInfoId"]!)"
            self.navigationController?.pushViewController(push!, animated: true)
            
        }
        
    }
    
    @objc func upload_profile_license_click_method() {
        let cell = tbleView.cellForRow(at: NSIndexPath(row: 0, section: 0) as IndexPath) as! VeterinarianBiographyTableCell
        
        UserDefaults.standard.set(cell.txtView.text, forKey: "key_biography")
        var dict_multi_image: Dictionary<AnyHashable, Any>
        dict_multi_image = self.dict_new["multi_image"] as! Dictionary<AnyHashable, Any>
        print(dict_multi_image as Any)
        
        var ar_multi_image : NSArray!
        
        if (dict_multi_image["License"] == nil) {
             
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "add_images_in_vet_id") as? add_images_in_vet
            
            push!.str_title_name = "Upload License Picture"
            push!.arr_image = []
            
            push!.str_image_type = String("License")
            push!.str_user_info_id = "\(self.dict_new["userInfoId"]!)"
            self.navigationController?.pushViewController(push!, animated: true)
        } else {
            ar_multi_image = (dict_multi_image["License"] as! Array<Any>) as NSArray
            print(ar_multi_image as Any)
            
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "add_images_in_vet_id") as? add_images_in_vet
            
            push!.str_title_name = "Upload License Picture"
            push!.arr_image = ar_multi_image
            
            push!.str_image_type = String("License")
            push!.str_user_info_id = "\(self.dict_new["userInfoId"]!)"
            self.navigationController?.pushViewController(push!, animated: true)
        }
        
    }
    
    @objc func upload_profile_document_click_method() {
        let cell = tbleView.cellForRow(at: NSIndexPath(row: 0, section: 0) as IndexPath) as! VeterinarianBiographyTableCell
        
        UserDefaults.standard.set(cell.txtView.text, forKey: "key_biography")
        var dict_multi_image: Dictionary<AnyHashable, Any>
        dict_multi_image = self.dict_new["multi_image"] as! Dictionary<AnyHashable, Any>
        print(dict_multi_image as Any)
        
        var ar_multi_image : NSArray!
        
        if (dict_multi_image["Document"] == nil) {
            
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "add_images_in_vet_id") as? add_images_in_vet
            
            push!.str_title_name = "Upload Documents"
            push!.arr_image = ar_multi_image
            
            push!.str_image_type = String("Document")
            push!.str_user_info_id = "\(self.dict_new["userInfoId"]!)"
            self.navigationController?.pushViewController(push!, animated: true)
        } else {
            ar_multi_image = (dict_multi_image["Document"] as! Array<Any>) as NSArray
            print(ar_multi_image as Any)
            
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "add_images_in_vet_id") as? add_images_in_vet
            
            push!.str_title_name = "Upload Documents"
            push!.arr_image = ar_multi_image
            
            push!.str_image_type = String("Document")
            push!.str_user_info_id = "\(self.dict_new["userInfoId"]!)"
            self.navigationController?.pushViewController(push!, animated: true)
        }
        
    }
    
    @objc func upload_profile_picture_click_method() {
        let cell = tbleView.cellForRow(at: NSIndexPath(row: 0, section: 0) as IndexPath) as! VeterinarianBiographyTableCell
        
        UserDefaults.standard.set(cell.txtView.text, forKey: "key_biography")

        
        
        
        
        
        
        var dict_multi_image: Dictionary<AnyHashable, Any>
        dict_multi_image = self.dict_new["multi_image"] as! Dictionary<AnyHashable, Any>
        print(dict_multi_image as Any)
        
        var ar_multi_image : NSArray!
        
        if (dict_multi_image["Own"] == nil) {
             
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "add_images_in_vet_id") as? add_images_in_vet
            
            push!.str_title_name = "Upload Profile Picture"
            push!.arr_image = ar_multi_image
            
            push!.str_image_type = String("Own")
            push!.str_user_info_id = "\(self.dict_new["userInfoId"]!)"
            self.navigationController?.pushViewController(push!, animated: true)
        } else {
            ar_multi_image = (dict_multi_image["Own"] as! Array<Any>) as NSArray
            print(ar_multi_image as Any)
            
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "add_images_in_vet_id") as? add_images_in_vet
            
            push!.str_title_name = "Upload Profile Picture"
            push!.arr_image = ar_multi_image
            
            push!.str_image_type = String("Own")
            push!.str_user_info_id = "\(self.dict_new["userInfoId"]!)"
            self.navigationController?.pushViewController(push!, animated: true)
        }
        
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
            
         
    }
    
    @objc func nextClick(_ sender:UIButton) {
        
        let cell = tbleView.cellForRow(at: NSIndexPath(row: 0, section: 0) as IndexPath) as! VeterinarianBiographyTableCell
        
         
        if cell.txtView.text == "Message" {
            CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Biography should not be Empty.", dismissDelay: 1.5, completion:{})

        }
        else if cell.txtView.text == "" {
            CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Biography should not be Empty.", dismissDelay: 1.5, completion:{})
        } else if (self.str_upload_picture == "0") {
            CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Please Upload your picture.", dismissDelay: 1.5, completion:{})
        } else if (self.str_upload_business == "0") {
            CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Please Upload your Business picture.", dismissDelay: 1.5, completion:{})
        } else if (self.str_upload_est_price == "0") {
            CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Please Upload your Est price.", dismissDelay: 1.5, completion:{})
        } else if (self.str_upload_upload_transcript == "0") {
            CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Please Upload your Transcript.", dismissDelay: 1.5, completion:{})
        } else if (self.str_upload_license == "0") {
            CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message:"Please Upload your License.", dismissDelay: 1.5, completion:{})
        } else {
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
                        
                        self.dict_new = dict as NSDictionary
                        
                        self.tbleView.delegate = self
                        self.tbleView.dataSource = self
                        self.tbleView.reloadData()
                        
                        let cell = tbleView.cellForRow(at: NSIndexPath(row: 0, section: 0) as IndexPath) as! VeterinarianBiographyTableCell
                        // if (cell.txtView.text)
                        
                        if let loadedString = UserDefaults.standard.string(forKey: "key_biography") {
                            print(loadedString)
                            
                            cell.txtView.text = String(loadedString)
                        }
                        
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
    func removeWhitespacesFromString(mStr: String) -> String {

       let chr = mStr.components(separatedBy: .whitespaces)
       let resString = chr.joined()
       return resString
    }
    
    @objc func biographyWebservice(strBiographyText:String!) {
        let cell = tbleView.cellForRow(at: NSIndexPath(row: 0, section: 0) as IndexPath) as! VeterinarianBiographyTableCell
        let resStr = removeWhitespacesFromString(mStr: String(cell.txtView.text!))
        
        let letters = CharacterSet.alphanumerics
        let string = resStr
        print(string as Any)
        if (string.trimmingCharacters(in: letters) != "") {
            print("Invalid characters in string.")
            
            let alertController = UIAlertController(title: "Error", message: "Invalid biography. Please enter biography", preferredStyle: .actionSheet)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            
            return
        }
        
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
                        
                       // UserDefaults.standard.set("", forKey: "key_biography")
                        
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
             btnCheckUncheckCode.setImage(UIImage(named: "regCheck"), for: .normal)
             btnCheckUncheckCode.tag = 1
         }
         else if btnCheckUncheckCode.tag == 1 {
        //strExcoticBirds = "excoticBirdsWhite"
            strChekcTerm = "0"
             btnCheckUncheckCode.setImage(UIImage(named: "regUncheck"), for: .normal)
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

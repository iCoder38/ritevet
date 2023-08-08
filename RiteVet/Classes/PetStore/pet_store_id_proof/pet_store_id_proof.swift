//
//  pet_store_id_proof.swift
//  RiteVet
//
//  Created by Dishant Rajput on 03/08/23.
//  Copyright © 2023 Apple . All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class pet_store_id_proof: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var str_from_edit:String!
    
    @IBOutlet weak var viewNavigation:UIView! {
        didSet {
            viewNavigation.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }
    @IBOutlet weak var btnBack:UIButton!
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "PET STORE"
            lblNavigationTitle.textColor = .white
        }
    }
    
    @IBOutlet weak var img_id_proof:UIImageView! {
        didSet {
            img_id_proof.layer.cornerRadius = 20
            img_id_proof.clipsToBounds = true
        }
    }
    @IBOutlet weak var btn_submit:UIButton! {
        didSet {
            btn_submit.setTitleColor(.white, for: .normal)
            btn_submit.layer.cornerRadius = 20
            btn_submit.clipsToBounds = true
            btn_submit.backgroundColor = BUTTON_BACKGROUND_COLOR_BLUE
            btn_submit.setTitle("Submit", for: .normal)
        }
    }
    
    // image
    var imageStr:String!
    var imgData:Data!
    
    var str_image_validation:String! = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /****** VIEW BG IMAGE *********/
        self.view.backgroundColor = UIColor.init(patternImage: UIImage(named: "plainBack")!)
        
        self.btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        self.img_id_proof.isUserInteractionEnabled = true
        self.img_id_proof.addGestureRecognizer(tapGestureRecognizer)
        
        if (self.str_from_edit == "from_edit") {
            
            if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
                
                self.img_id_proof.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                self.img_id_proof.sd_setImage(with: URL(string: (person["profile_ID_image"] as! String)), placeholderImage: UIImage(named: "logo"))
                
            }
            
        }
        
        self.btn_submit.addTarget(self, action: #selector(validation_before_submit), for: .touchUpInside)
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
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        self.uploadImageOpenActionSheet()
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
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
            let image_data = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        self.img_id_proof.image = image_data // show image on image view
        let imageData:Data = image_data!.pngData()!
        imageStr = imageData.base64EncodedString()
        self.dismiss(animated: true, completion: nil)
            
        imgData = image_data!.jpegData(compressionQuality: 0.2)!
        
        self.str_image_validation = "1"

    }
    

    @objc func validation_before_submit() {
        
        if (self.str_image_validation == "1") {
            self.upload_id_proof_to_server_wb()
        }
    }
    
    
    @objc func upload_id_proof_to_server_wb() {
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        // yes image upload
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]
        {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            var urlRequest = URLRequest(url: URL(string: BASE_URL_KREASE)!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0 * 1000)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
             
            //Set Your Parameter
            let parameterDict = NSMutableDictionary()
            parameterDict.setValue("editprofile", forKey: "action")
            parameterDict.setValue(String(myString), forKey: "userId")
             
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
                multiPart.append(self.imgData, withName: "profile_ID_image", fileName: "add_id_proof.png", mimeType: "image/png")
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
                        
                        let JSON = dictionary
                        print(JSON)
                        
                        var dict: Dictionary<AnyHashable, Any>
                        dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                        
                        let defaults = UserDefaults.standard
                        defaults.setValue(dict, forKey: "keyLoginFullData")
                        
                        self.navigationController?.popViewController(animated: true)
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

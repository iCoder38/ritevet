//
//  BooCheckChat.swift
//  BooCheck
//
//  Created by apple on 01/04/21.
//

import UIKit
import GrowingTextView
import Firebase
import FirebaseStorage
import SDWebImage
import Alamofire

import FirebaseDatabase

// sam //

class BooCheckChat: UIViewController, MessagingDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    // ***************************************************************** // nav
    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            navigationBar.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }
    @IBOutlet weak var btnBack:UIButton! {
        didSet {
            btnBack.tintColor = .white
        }
    }
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "CHAT"
            // lblNavigationTitle.textColor = NAVIGATION_TITLE_COLOR
        }
    }
    // ***************************************************************** // nav
    
    // let dict : [String : Any] = UserDefaults.standard.dictionary(forKey: "kAPI_LOGIN_DATA") ?? [:] //
    
    let cellReuseIdentifier = "cuckooChatCTableCell"
    
    var fromDialog:String!
    var receiverIdFromDialog:String!
    var receiverNameFromDialog:String!
    var receiverImageFromDialog:String!
    
    // MARK:- mutable array set up -
    var chatMessages:NSMutableArray = []
    
    var strLoginUserId:String!
    var strLoginUserName:String!
    var strLoginUserImage:String!
    
    var strReceiptId:String!
    var strReceiptImage:String!
    
    var imageStr1:String!
    var imgData1:Data!
    
    var uploadImageForChatURL:String!
    var chatChannelName:String!
    var receiverData:NSDictionary!
    //    var receiverData : [String :Any] = [:]
    
    
    
    var strSenderDevice:String! = "0"
    var strSenderDeviceToken:String! = "0"
    
    var strReceiverDevice:String! = "0"
    var strReceiverDeviceToken:String! = "0"
    
    
    
    
    var strSaveLastMessage:String!
    
    @IBOutlet weak var uploadingImageView:UIView! {
        didSet {
            //  uploadingImageView.backgroundColor = APP_BASIC_COLOR
            uploadingImageView.isHidden = true
        }
    }
    
    @IBOutlet weak var indicators:UIActivityIndicatorView! {
        didSet {
            indicators.color = .white
        }
    }
    
    @IBOutlet weak var lblProcessingImage:UILabel! {
        didSet {
            lblProcessingImage.textColor = .white
            lblProcessingImage.text = "processing..."
        }
    }
    
    @IBOutlet weak var inputToolbar: UIView! {
        didSet {
            inputToolbar.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }
    
    @IBOutlet weak var textView: GrowingTextView!
    @IBOutlet weak var textViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var imgReceiverProfilePicture:UIImageView! {
        didSet {
            imgReceiverProfilePicture.layer.cornerRadius = 20
            imgReceiverProfilePicture.clipsToBounds = true
            imgReceiverProfilePicture.layer.borderWidth = 0.5
            imgReceiverProfilePicture.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
    }
    
    // MARK:- TABLE VIEW -
    @IBOutlet weak var tbleView: UITableView! {
        didSet {
            self.tbleView.delegate = self
            self.tbleView.dataSource = self
            self.tbleView.backgroundColor = .clear // UIColor.init(red: 244.0/255.0, green: 246.0/255.0, blue: 248.0/255.0, alpha: 1)
            self.tbleView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
        }
    }
    
    @IBOutlet weak var btnSendMessage:UIButton! {
        didSet {
            btnSendMessage.tintColor = .white
        }
    }
    
    @IBOutlet weak var btnAttachment:UIButton! {
        didSet {
            btnAttachment.tintColor = .white
        }
    }
    
    
    
    
    @IBOutlet weak var btnPhone:UIButton! {
        didSet {
            btnPhone.isHidden = true
        }
    }
    @IBOutlet weak var btnVideoCall:UIButton! {
        didSet {
            btnVideoCall.isHidden = true
        }
    }
    
    var friendDeviceToken:String!
    
    
    
    
    var receiverNameIs:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // print(receiverData as Any)
        
        self.imageStr1 = "0"
        self.uploadImageForChatURL = ""
        
        
        
        self.btnSendMessage.addTarget(self, action: #selector(sendMessageWithoutAttachment), for: .touchUpInside)
        self.btnAttachment.addTarget(self, action: #selector(cellTappedMethod1), for: .touchUpInside)
        
        
        
        
        
        
        
        self.btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        
        // *** Customize GrowingTextView ***
        textView.layer.cornerRadius = 4.0
        
        // *** Listen to keyboard show / hide ***
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        // *** Hide keyboard when tapping outside ***
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler))
        view.addGestureRecognizer(tapGesture)
        
        /*
         var strSenderDevice:String! = "0"
         var strSenderDeviceToken:String! = "0"
         
         var strReceiverDevice:String! = "0"
         var strReceiverDeviceToken:String! = "0"
         */
        
        print(self.receiverData as Any)
        
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            // let str:String = person["role"] as! String
             print(person as Any)
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            self.strLoginUserId = String(myString)
            
            self.strLoginUserName = (person["fullName"] as! String)
            self.strLoginUserImage = (person["image"] as! String)
            
            self.strSenderDevice = (person["device"] as! String)
            self.strSenderDeviceToken = (person["deviceToken"] as! String)
        }
        
        if self.fromDialog == "yes" {
            self.yesFromDialog()
        } else {
            self.notFromDialog()
        }
        
    }
    
    @objc func yesFromDialog() {
        
        
        self.strReceiptId = String(self.receiverIdFromDialog)
        
        self.receiverNameIs = String(self.receiverNameFromDialog)
        
        self.strReceiptImage = String(self.receiverImageFromDialog)
        
        self.imgReceiverProfilePicture.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
        self.imgReceiverProfilePicture.sd_setImage(with: URL(string: receiverImageFromDialog), placeholderImage: UIImage(named: "logo"))
        
        self.observeMessage()
    }
    
    @objc func notFromDialog() {
    
        let xR : Int = receiverData["userId"] as! Int
        let myStringR = String(xR)
        
        self.strReceiptId = String(myStringR)
        self.strReceiptImage = (receiverData["ownPicture"] as! String)
        
        self.receiverNameIs = (receiverData["VFirstName"] as! String)
        
        self.lblNavigationTitle.text = self.receiverNameIs
        self.imgReceiverProfilePicture.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
        self.imgReceiverProfilePicture.sd_setImage(with: URL(string: (receiverData["ownPicture"] as! String)), placeholderImage: UIImage(named: "logo"))
        
        self.strReceiverDevice = (receiverData["device"] as! String)
        self.strReceiverDeviceToken = (receiverData["deviceToken"] as! String)
        
        /*let x30 : Int = (receiverData["chatStatus"] as! Int)
         let myString30 = String(x30)
         if myString30 == "1" {
         self.readUnreadStatus()
         } else {
         self.observeMessage()
         }*/
        
        
        
        
        
        self.observeMessage()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func keyboardWillChangeFrame(_ notification: Notification) {
        if let endFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            var keyboardHeight = UIScreen.main.bounds.height - endFrame.origin.y
            if #available(iOS 11, *) {
                if keyboardHeight > 0 {
                    keyboardHeight = keyboardHeight - view.safeAreaInsets.bottom
                }
            }
            textViewBottomConstraint.constant = keyboardHeight + 8
            view.layoutIfNeeded()
        }
    }
    
    @objc func tapGestureHandler() {
        view.endEditing(true)
    }
    
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    func observeMessage() {
        // print(self.strReceiptId+"+"+self.strLoginUserId)
        let ref = Database.database().reference()
        ref.child("one_to_one").child(self.strReceiptId+"+"+self.strLoginUserId).observe(.value, with: { (snapshot) in
            if snapshot.exists() {
                print("true rooms exist")
                
                self.chatChannelName = self.strReceiptId+"+"+self.strLoginUserId
                
                self.chatMessages.removeAllObjects()
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    let placeDict = snap.value as! [String: Any]
                    // print(placeDict as Any)
                    // self.chatMessages.add(placeDict)
                    DispatchQueue.main.async {
                        /*guard let dict = snapshot.value as? [String: AnyObject] else {
                         return
                         }*/
                        self.chatMessages.add(placeDict)
                        // print(self.chatMessages as Any)
                        self.tbleView.isHidden = false
                        if self.chatMessages.count == 0 {
                            self.tbleView.isHidden = true
                        }
                        if self.chatMessages.count > 2 {
                            self.scrollToBottom()
                        }
                        self.tbleView.delegate = self
                        self.tbleView.dataSource = self
                        self.tbleView.reloadData()
                    }
                }
            } else {
                // print("false rooms exist 1")
                ref.child("one_to_one").child(self.strLoginUserId+"+"+self.strReceiptId).observe(.value, with: { (snapshot) in
                    if snapshot.exists() {
                        print("true rooms exist")
                        self.chatChannelName = self.strLoginUserId+"+"+self.strReceiptId
                        self.chatMessages.removeAllObjects()
                        for child in snapshot.children {
                            let snap = child as! DataSnapshot
                            let placeDict = snap.value as! [String: Any]
                            print(placeDict as Any)
                            DispatchQueue.main.async {
                                /*guard let dict = snapshot.value as? [String: AnyObject] else {
                                 return
                                 }*/
                                
                                self.chatMessages.add(placeDict)
                                // print(self.chatMessages as Any)
                                self.tbleView.isHidden = false
                                if self.chatMessages.count == 0 {
                                    self.tbleView.isHidden = true
                                }
                                if self.chatMessages.count > 2 {
                                    self.scrollToBottom()
                                }
                                self.tbleView.delegate = self
                                self.tbleView.dataSource = self
                                self.tbleView.reloadData()
                            }
                        }
                    } else {
                        print("false rooms exist 2")
                        // here create a new room for chat
                        self.chatChannelName = self.strLoginUserId+"+"+self.strReceiptId
                    }
                })
            }
        })
    }
    
    func scrollToBottom() {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.chatMessages.count-1, section: 0)
            self.tbleView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    @objc func convertSelectedImageFromGallery(img1 :UIImage) {
    }
    @objc func cellTappedMethod1(){
        // print("you tap image number: \(sender.view.tag)")
        let alert = UIAlertController(title: "Upload Profile Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default , handler:{ (UIAlertAction)in
            print("User click Approve button")
            self.openCamera1()
        }))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default , handler:{ (UIAlertAction)in
            print("User click Edit button")
            self.openGallery1()
        }))
        alert.addAction(UIAlertAction(title: "In-Appropriate terms", style: .default , handler:{ (UIAlertAction)in
            print("User click Delete button")
        }))
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    @objc func openCamera1() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera;
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func openGallery1() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary;
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true, completion: nil)
        self.uploadingImageView.isHidden = false
        self.indicators.startAnimating()
        var strURL = ""
        // Points to the root reference
        let store = Storage.storage()
        let storeRef = store.reference()
        // ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        // default
        let image_data = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        let imageData:Data = image_data!.pngData()!
        imageStr1 = imageData.base64EncodedString()
        imgData1 = image_data!.jpegData(compressionQuality: 0.2)!
        // #2
        
        let storeImage = storeRef.child("singleChatImage")
            .child(self.strLoginUserId+".png")
        // if let uploadImageData = UIImagePNGRepresentation((img.image)!){
        storeImage.putData(imgData1, metadata: nil, completion: { (metaData, error) in
            storeImage.downloadURL(completion: { (url, error) in
                if let urlText = url?.absoluteString {
                    strURL = urlText
                    print("///////////tttttttt//////// \(strURL)   ////////")
                    self.uploadImageForChatURL = ("\(strURL)")
                    self.sendMessageWithAttachment()
                }
            })
        })
        self.imageStr1 = "1"
    }
    
    
    // MARK:- SEND IMAGE WITH ATTACHMENT -
    @objc func sendMessageWithAttachment() {
        
        /*let date = Date()
         let calender = Calendar.self
         let components = Calendar.dateComponents([.year,.month,.day,.weekday,.hour,.minute,.second], from: date)
         
         let year = components.year
         let month = components.month
         let day = components.day
         let weekday = components.weekday
         
         let hourr = components.hour
         let minutee = components.minute
         
         let today_string = String(day!) + "/" + String(month!) + "/" + String(year!)
         
         let time_string = String(hourr!)+":"+String(minutee!)
         */
        
        let ref = Database.database().reference()
            .child("one_to_one")
            .child(self.chatChannelName)
            .childByAutoId()
        
        let message = ["attachment_path": (self.uploadImageForChatURL!),
                       "chatSenderId": String(self.strLoginUserId),
                       "chat_date": "today_string",
                       "chat_message": String(self.textView.text!),
                       "chat_receiver": String(self.receiverNameIs),//String(self.strReceiptId),
                       "chat_receiver_img": String(self.strReceiptImage),
                       "chat_sender": String(self.strLoginUserName),
                       "chat_sender_img": String(self.strLoginUserImage),
                       "chat_time": "time_string",
                       "type": String("image")] as [String : Any]
        
        ref.setValue(message)
        self.uploadingImageView.isHidden = true
        
        
        self.dialog_listing()
        
         
    }
    
    @objc func dialog_listing() {
        
        let someDate = Date()
        let myTimeStamp = someDate.timeIntervalSince1970
        
        let ref2 = Database.database().reference()
        ref2.child("DialogsListing")
            .child(self.chatChannelName)
            .updateChildValues(
            
                ["SenderId"             : (self.strLoginUserId!),
                 "SenderName"            : (self.strLoginUserName!),
                 "SenderImage"           : (self.strLoginUserImage!),
                 "ReceiverId"            : (self.strReceiptId!),
                 "ReceiverName"          : (self.receiverNameIs!),
                 "ReceiverImage"         : (self.strReceiptImage!),
                 "lastMessage"           : (self.textView.text!),
            
            "lastMessageType"       : "Image",
            
            "TimeStamp"             : myTimeStamp,
            
                 "SenderDeviceToken"     : (self.strSenderDeviceToken!),
                 "SenderDevice"          : (self.strSenderDevice!),
            
                 "ReceiverDeviceToken"   : (self.strReceiverDeviceToken!),
                 "ReceiverDevice"        : (self.strReceiverDevice!)
            
            ])
        
        self.textView.text = ""
        
    }
    
    
    
    
    
    
    
    
    
    
    
    // MARK:- SEND IMAGE WITHOUT ATTACHMENT -
    @objc func sendMessageWithoutAttachment() {
        
        /*let date = Date()
         let calender = Calendar.current
         let components = calender.dateComponents([.year,.month,.day,.weekday,.hour,.minute,.second], from: date)
         
         let year = components.year
         let month = components.month
         let day = components.day
         let weekday = components.weekday
         
         let hourr = components.hour
         let minutee = components.minute
         
         let today_string = String(day!) + "/" + String(month!) + "/" + String(year!)
         
         let time_string = String(hourr!)+":"+String(minutee!)
         */
        
        let newRegistrationUniqueId = String.createChatUniqueId()
        
        if self.textView.text == "" {
            
        } else {
            // self.textView.text = self.strSaveLastMessage
            // self.view.endEditing(true)
            let ref = Database.database().reference()
                .child("one_to_one")
                .child(self.chatChannelName)
                .childByAutoId()
            
            let message = ["attachment_path": String(""),
                           "chatSenderId": String(self.strLoginUserId!),
                           "uid":newRegistrationUniqueId,
                           "chat_date": "today_string",
                           "chat_message": String(self.textView.text!),
                           "chat_receiver": String(self.receiverNameIs),//String(self.strReceiptId),
                           "chat_receiver_img": String(self.strReceiptImage),
                           "chat_sender": String(self.strLoginUserName!),
                           "chat_sender_img": String(self.strLoginUserImage!),
                           "chat_time": String("time_string"),
                           "type": "Text"] as [String : Any]
            
            ref.setValue(message)
            
            
            let someDate = Date()
            let myTimeStamp = someDate.timeIntervalSince1970
            
            let ref2 = Database.database().reference()
            ref2.child("DialogsListing")
                // .child(newRegistrationUniqueId)
                .child(self.chatChannelName)
                .updateChildValues(
                
                ["SenderId"              : (self.strLoginUserId!),
                 "SenderName"            : (self.strLoginUserName!),
                 "SenderImage"           : (self.strLoginUserImage!),
                 "ReceiverId"            : (self.strReceiptId!),
                 "ReceiverName"          : (self.receiverNameIs!),
                 "ReceiverImage"         : (self.strReceiptImage!),
                 "lastMessage"           : (self.textView.text!),
                 "uid"                   : newRegistrationUniqueId,
                 "lastMessageType"       : "Text",
                 
                 "TimeStamp"             : myTimeStamp,
                 
                 "SenderDeviceToken"     : (self.strSenderDeviceToken!),
                 "SenderDevice"          : (self.strSenderDevice!),
                 
                 "ReceiverDeviceToken"   : (self.strReceiverDeviceToken!),
                 "ReceiverDevice"        : (self.strReceiverDevice!)
                 
                 // "SenderNotificationCount":0,
                 // "ReceiverNotificationCount":"",
                 
                 /*"Notification":[
                    "SenderId":"",
                    "":"",
                    String(self.strLoginUserId!) : 0,
                    String(self.strReceiptId) : 1
                 ]*/
                 
                ])
            self.textView.text = ""
            
            
            
        }
    }
    
    
}
extension BooCheckChat: GrowingTextViewDelegate {
    // *** Call layoutIfNeeded on superview for animation when changing height ***
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [.curveLinear], animations: { () -> Void in
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

extension BooCheckChat: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chatMessages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = self.chatMessages[indexPath.row] as? [String:Any]
        if item!["chatSenderId"] as! String == String(strLoginUserId) {
            
            print(item as Any)
            
            if item!["type"] as! String == "Text" {
                
                // text
                let cell1 = tableView.dequeueReusableCell(withIdentifier: "cellOne") as! BooCheckTableCell
                cell1.senderName.text = (item!["chat_sender"] as! String)
                cell1.senderText.text = (item!["chat_message"] as! String)
                cell1.backgroundColor = .clear
                cell1.imgSender.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                cell1.imgSender.sd_setImage(with: URL(string:strLoginUserImage), placeholderImage: UIImage(named: "logo_300"))
                return cell1
                
            } else  {
                
                // image
                let cell3 = tableView.dequeueReusableCell(withIdentifier: "cellThree") as! BooCheckTableCell
                cell3.imgSenderAttachment.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                cell3.imgSenderAttachment.sd_setImage(with: URL(string: (item!["attachment_path"] as! String)), placeholderImage: UIImage(named: "logo_300"))
                cell3.backgroundColor = .clear
                cell3.imgSenderAttachment2.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                cell3.imgSenderAttachment2.sd_setImage(with: URL(string: strLoginUserImage), placeholderImage: UIImage(named: "logo_300"))
                return cell3
                
            }
            
        } else { // receiver txt
            
            if item!["type"] as! String == "Text" {
                
                let cell2 = tableView.dequeueReusableCell(withIdentifier: "cellTwo") as! BooCheckTableCell
                cell2.receiverName.text = (item!["chat_sender"] as! String)// (item!["chat_receiver"] as! String)
                cell2.receiverText.text = (item!["chat_message"] as! String)
                cell2.backgroundColor = .clear
                cell2.imgReceiver.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                cell2.imgReceiver.sd_setImage(with: URL(string: strReceiptImage), placeholderImage: UIImage(named: "logo_300"))
                return cell2
                
            } else { // receiver image
                
                let cell4 = tableView.dequeueReusableCell(withIdentifier: "cellFour") as! BooCheckTableCell
                cell4.imgReceiverAttachment.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                cell4.imgReceiverAttachment.sd_setImage(with: URL(string: (item!["attachment_path"] as! String)), placeholderImage: UIImage(named: "logo_300"))
                cell4.backgroundColor = .clear
                cell4.imgReceiverAttachment2.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                cell4.imgReceiverAttachment2.sd_setImage(with: URL(string: strReceiptImage), placeholderImage: UIImage(named: "logo_300"))
                return cell4
                
            }
            
        }
        
        
        
        
    }
    


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = self.chatMessages[indexPath.row] as? [String:Any]
        if item!["type"] as! String == "Text" {
            return UITableView.automaticDimension
        } else {
            return 240
        }
    }
}

extension BooCheckChat: UITableViewDelegate {
}

struct SendLastMessageToServerWB: Encodable {
    let action: String
    let senderId: String
    let receiverId: String
    let message: String
}

struct ReadUnreadStatus: Encodable {
    let action: String
    let senderId: String
    let receiverId: String
}


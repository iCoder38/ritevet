//
//  Dialogs.swift
//  RiteVet
//
//  Created by apple on 11/08/21.
//  Copyright © 2021 Apple . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Firebase
import FirebaseDatabase

class Dialogs: UIViewController {

    var arrListOfAllSingleFriendList : NSMutableArray! = []
    
    @IBOutlet weak var viewNavigation:UIView! {
        didSet {
            viewNavigation.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }
    @IBOutlet weak var btnBack:UIButton!
    
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "CHATS"
            lblNavigationTitle.textColor = .white
        }
    }
    // 255 200 68
    @IBOutlet weak var tbleView: UITableView! {
        didSet {
            // tbleView.delegate = self
            // tbleView.dataSource = self
            tbleView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
            tbleView.backgroundColor = .clear
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnBack.setImage(UIImage(named: "menuWhite"), for: .normal)
        self.sideBarMenu()
        
        self.tbleView.separatorColor = .clear
        self.getSingleFriendsChatsFromFirebaseXMPPserver()
    }
    
    @objc func sideBarMenu() {
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
    @objc func backClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    @objc func getSingleFriendsChatsFromFirebaseXMPPserver() {
        // Utils.RiteVetIndicatorShow()
        
        
        let ref = Database.database().reference()
        ref.child("DialogsListing")
            .queryOrdered(byChild: "TimeStamp")
            
            .observe(.value, with: { (snapshot) in
                if snapshot.exists() {
                    print("true rooms exist")
                    
                    self.arrListOfAllSingleFriendList.removeAllObjects()
                    
                    for child in snapshot.children {
                        let snap = child as! DataSnapshot
                        let placeDict = snap.value as! [String: Any]
                        print(placeDict as Any)
                        
                        // self.chatMessages.add(placeDict)
                        
                        DispatchQueue.main.async {
                            
                            self.arrListOfAllSingleFriendList.add(placeDict)
                            // print(self.arrListOfAllGroupList as Any)
                            
                            self.tbleView.isHidden = false
                            
                            if self.arrListOfAllSingleFriendList.count == 0 {
                                self.tbleView.isHidden = true
                            }
                            
                            self.tbleView.delegate = self
                            self.tbleView.dataSource = self
                            self.tbleView.reloadData()
                            
                            
                        }
                        
                        Utils.RiteVetIndicatorHide()
                        // print(self.chatMessages.reversed() as Any)
                    }
                    
                } else {
                    print("room not exist")
                    Utils.RiteVetIndicatorHide()
                    // self.categoryListingWB()
                }
            })
        // print(self.chatMessages.reversed() as Any)
        
    }
}


extension Dialogs: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrListOfAllSingleFriendList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:DialogsTableCell = tableView.dequeueReusableCell(withIdentifier: "dialogsTableCell") as! DialogsTableCell
        
        cell.backgroundColor = .clear
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            let item = self.arrListOfAllSingleFriendList.reversed()[indexPath.row] as? [String:Any]
            
            print(item as Any)
            
            if (item!["SenderId"] as! String) == String(myString) {
                
                cell.lblGroupName.text = (item!["ReceiverName"] as! String)
                cell.imgProfile.sd_setImage(with: URL(string: (item!["ReceiverImage"] as! String)), placeholderImage: UIImage(named: "logo-500"))
                
                cell.lblNotificationCounter.isHidden = true
                
                /*let likeRef = Database.database().reference()
                           
                           // if let uid = Auth.auth().currentUser?.uid {
                           likeRef.child("DialogsListing")
                             // .child((item!["uid"] as! String))
                           // .child("Notification")
                            
                            .queryOrdered(byChild: "uid")
                                .queryEqual(toValue: (item!["uid"] as! String))
                            
                            
                               // .child(String(myString))
                               // .queryOrderedByKey()
                               
                               //.queryOrdered(byChild: "PostLikers")
                               // .queryEqual(toValue: "yes")
                               
                               .observeSingleEvent(of:.value, with: { snap in
                                   if snap.exists() {
                                       
                                    print("yes")
                                    
                                    /*print(snap)
                                    print(snap.value as Any)
                                    print(snap.key as Any)
                                    let item = snap.value as! NSDictionary?
                                    print(item as Any)
                                    
                                    let placeDict = snap.value as! [String: Any]
                                    print(placeDict as Any)
                                    
                                    var dict: Dictionary<AnyHashable, Any>
                                    dict = item!["Notification"] as! Dictionary<AnyHashable, Any>
                                    print(dict as Any)
                                    */
                                    
                                    // for child in snapshot.children {
                                    
                                    for child in snap.children {
                                        
                                        let snap = child as! DataSnapshot
                                        let placeDict = snap.value as! [String: Any]
                                        print(placeDict as Any)
                                        
                                        var dict: Dictionary<AnyHashable, Any>
                                        dict = placeDict["Notification"] as! Dictionary<AnyHashable, Any>
                                        print(dict as Any)
                                        
                                        print("\(dict[myString] as! Int)")
                                        
                                        // if
                                        
                                        // var points = dict
                                        // var arr = points.components(separatedBy: ",")
                                        
                                        // let arr = [dict]
                                        // print(arr as Any)
                                        
                                        // print(type(of: dict))
                                        // print(type(of: arr))
                                        
                                        //print(arr[0])
                                        //print(arr[1])
                                        
                                    }
                                    /*print(snap.children as Any)
                                    let snap = snap.children as! DataSnapshot
                                    let placeDict = snap.value as! [String: Any]
                                    print(placeDict as Any)*/
                                    
                                    
                                    
                                       // print("yes exist")
                                       // cell.btnLike.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                                       // cell.btnLike.tintColor = APP_MAIN_COLOR
                                       
                                   } else {
                                    
                                    print("no")
                                    
                                       // print("not exist")
                                       // cell.btnLike.setImage(UIImage(systemName: "heart"), for: .normal)
                                       // cell.btnLike.tintColor = .black
                                       
                                   }
                               })
                           likeRef.removeAllObservers()*/
                
            } else if (item!["SenderId"] as! String) != String(myString) {
                
                cell.lblGroupName.text = (item!["SenderName"] as! String)
                cell.imgProfile.sd_setImage(with: URL(string: (item!["SenderImage"] as! String)), placeholderImage: UIImage(named: "logo-500"))
                
                cell.lblNotificationCounter.isHidden = true
                
            } else {
                // i am not here
                cell.lblNotificationCounter.isHidden = true
            }
            
            // last message
            if (item!["lastMessageType"] as! String) == "Text" || (item!["lastMessageType"] as! String) == "text" {
                
                cell.imgLastMessage.image = UIImage(systemName: "pencil")
                cell.lblLastText.text = (item!["lastMessage"] as! String)
                
            } else {
                
                cell.imgLastMessage.image = UIImage(systemName: "person.crop.square")
                cell.lblLastText.text = "photo"
                
            }
            
            
            // notification
            // myString
            
            // print(item![myString] as! String)
            
            
            
            
            /*
             let likeRef = Database.database().reference()
                        
                        // if let uid = Auth.auth().currentUser?.uid {
                        likeRef.child("DialogsListing")
                         .child(self.chatChannelName)
                         .child("Notification")
                            .child(String(myString))
                            .queryOrderedByKey()
                            
                            //.queryOrdered(byChild: "PostLikers")
                            // .queryEqual(toValue: "yes")
                            
                            .observeSingleEvent(of:.value, with: { snap in
                                if snap.exists() {
                                    
                                 print("yes")
                                    // print("yes exist")
                                    // cell.btnLike.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                                    // cell.btnLike.tintColor = APP_MAIN_COLOR
                                    
                                } else {
                                 
                                 print("no")
                                 
                                    // print("not exist")
                                    // cell.btnLike.setImage(UIImage(systemName: "heart"), for: .normal)
                                    // cell.btnLike.tintColor = .black
                                    
                                }
                            })
                        likeRef.removeAllObservers()
             */
            
            
            
            
            
        }
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
            
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            let item = self.arrListOfAllSingleFriendList.reversed()[indexPath.row] as? [String:Any]
            
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BooCheckChatId") as? BooCheckChat
            push!.fromDialog = "yes"
            
            
            
            if (item!["SenderId"] as! String) == String(myString) {
                
                push!.receiverIdFromDialog = (item!["ReceiverId"] as! String)
                push!.receiverNameFromDialog = (item!["ReceiverName"] as! String)
                push!.receiverImageFromDialog = (item!["ReceiverImage"] as! String)
                
            } else {
                
                push!.receiverIdFromDialog = (item!["SenderId"] as! String)
                push!.receiverNameFromDialog = (item!["SenderName"] as! String)
                push!.receiverImageFromDialog = (item!["SenderImage"] as! String)
            }
            
            self.navigationController?.pushViewController(push!, animated: true)
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            let item = self.arrListOfAllSingleFriendList.reversed()[indexPath.row] as? [String:Any]
            // print(item as Any)
            
            if (item!["SenderId"] as? String) == String(myString) {
                return 80
            } else  if (item!["ReceiverId"] as? String) == String(myString) {
                return 80
            } else {
                return 0
            }
            
        } else {
            return 0
        }
    }
}

extension Dialogs: UITableViewDelegate {
    
}

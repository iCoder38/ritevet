//
//  MyPost.swift
//  RiteVet
//
//  Created by evs_SSD on 1/9/20.
//  Copyright © 2020 Apple . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MyPost: UIViewController {

    let cellReuseIdentifier = "myPostTableCell"
    
    var arrListOfMyPost:Array<Any>!
    
    @IBOutlet weak var viewNavigation:UIView! {
        didSet {
            viewNavigation.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }
    @IBOutlet weak var btnBack:UIButton!
    
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "MY POST"
            lblNavigationTitle.textColor = .white
        }
    }
    // 255 200 68
    @IBOutlet weak var tbleView: UITableView! {
        didSet {
            //tbleView.delegate = self
            //tbleView.dataSource = self
            tbleView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
            tbleView.backgroundColor = .clear
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // btnBack.addTarget(self, action: #selector(backClick), for: .touchUpInside)
        btnBack.setImage(UIImage(named: "menuWhite"), for: .normal)
        self.sideBarMenu()
        
        
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
        myPost()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    @objc func backClick() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func myPost() {
    
         Utils.RiteVetIndicatorShow()
        
         let urlString = BASE_URL_KREASE
     
     var parameters:Dictionary<AnyHashable, Any>!
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]
               {
                   let x : Int = (person["userId"] as! Int)
                   let myString = String(x)
               
                 
                parameters = [
                    "action"       :   "stufflist",
                    "userId"       :   myString,// login id
                    "pageNo"       :   "",
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
                             Utils.RiteVetIndicatorHide()
                                
                            var ar : NSArray!
                            ar = (JSON["data"] as! Array<Any>) as NSArray
                            self.arrListOfMyPost = (ar as! Array<Any>)
                                
                             self.tbleView.delegate = self
                             self.tbleView.dataSource = self
                             self.tbleView.reloadData()
                             
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
}

extension MyPost: UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrListOfMyPost.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:MyPostTableCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! MyPostTableCell
        
        cell.backgroundColor = .clear
        
        /*
         categoryId = 18;
         categoryName = Bird;
         created = "2020-01-02 18:21:00";
         description = does;
         "image_1" = "http://demo2.evirtualservices.com/ritevet/site/img/uploads/freestaff/1577969474riteVetImage.jpg";
         "image_2" = "";
         "image_3" = "";
         "image_4" = "";
         "image_5" = "";
         postTitle = title;
         staffId = 92;
         totalComment = 0;
         userImage = "http://demo2.evirtualservices.com/ritevet/site/img/uploads/users/1578568990riteVetImage.jpg";
         userName = "Dishant Rajput";
         video = "";
         */
        
         let item = arrListOfMyPost[indexPath.row] as? [String:Any]
        
         // image
        cell.imgProfile.sd_setImage(with: URL(string: (item!["userImage"] as! String)), placeholderImage: UIImage(named: "plainBack"))
        
         // title
        cell.lblTitle.text = (item!["postTitle"] as! String)
        
        // date
        cell.lblDate.text = (item!["created"] as! String)
        cell.lblDate.textColor = NAVIGATION_BACKGROUND_COLOR
        
        // message
        cell.lblMessage.text = (item!["description"] as! String)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        // getFreeStuffDict
        let item = arrListOfMyPost[indexPath.row] as? [String:Any]
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MyPostDetailsId") as? MyPostDetails
        push!.getFreeStuffDict = item as NSDictionary?
        self.navigationController?.pushViewController(push!, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 120
    }
}

extension MyPost: UITableViewDelegate
{
    
}

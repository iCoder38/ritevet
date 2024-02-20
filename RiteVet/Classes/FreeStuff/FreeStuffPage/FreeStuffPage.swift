//
//  FreeStuffPage.swift
//  RiteVet
//
//  Created by Apple  on 02/12/19.
//  Copyright © 2019 Apple . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class FreeStuffPage: UIViewController {

    let cellReuseIdentifier = "freeStuffPageTableCell"
    
    var arrListOfFreeItem:Array<Any>!
    
    // share
    var shareText:String!
    var shareURLString:String!
    
    @IBOutlet weak var viewNavigation:UIView! {
        didSet {
            viewNavigation.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }
    
    @IBOutlet weak var btnBack:UIButton!
    
    @IBOutlet weak var btnAdd:UIButton!
    
    @IBOutlet weak var btnShare:UIButton!
    
      @IBOutlet weak var lblNavigationTitle:UILabel! {
          didSet {
              lblNavigationTitle.text = "FREE STUFF"
              lblNavigationTitle.textColor = .white
          }
      }
    
    
    
      @IBOutlet weak var tbleView: UITableView! {
          didSet {
              //tbleView.delegate = self
              //tbleView.dataSource = self
            
              tbleView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
              tbleView.backgroundColor = .white
          }
      }
    
    @IBOutlet weak var imgVieww: UIImageView!
    @IBOutlet weak var lblFirst: UILabel!
    @IBOutlet weak var lblSecond: UILabel!
      
    
    
     override func viewDidLoad() {
           super.viewDidLoad()
           
           /****** VIEW BG IMAGE *********/
           //self.view.backgroundColor = UIColor.init(patternImage: UIImage(named: "plainBack")!)
           
        self.view.backgroundColor = .white
        
        tbleView.isHidden = true
        
        btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        btnAdd.addTarget(self, action: #selector(addClickMethod), for: .touchUpInside)
        
        // share click
        btnShare.addTarget(self, action: #selector(shareClickMethod), for: .touchUpInside)
        
        
        // gradient
        let gradient:CAGradientLayer = CAGradientLayer()
        gradient.frame.size = imgVieww.frame.size
        gradient.colors = [UIColor.black.withAlphaComponent(0).cgColor,UIColor.black.cgColor] //Or any colors
        imgVieww.layer.addSublayer(gradient)
        
        
       }
    
       override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        self.listOfFreeStuff()
       }
       override var preferredStatusBarStyle: UIStatusBarStyle {
           return .lightContent
       }
       @objc func backClickMethod() {
           self.navigationController?.popViewController(animated: true)
       }
    @objc func addClickMethod() {
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SubmitPostId") as? SubmitPost
        self.navigationController?.pushViewController(push!, animated: true)
    }

    @objc func shareClickMethod(_ sender: UIButton) {
        guard let url = URL(string: shareURLString) else {
            return
        }
        
        let items: [Any] = [shareText as Any, url, #imageLiteral(resourceName: "dog")]
        let vc = VisualActivityViewController(activityItems: items, applicationActivities: nil)
        vc.previewNumberOfLines = 10
        
        present(vc, animated: true, completion: nil)
        //present(vc, from: sender)
    }
    
    func listOfFreeStuff() {
               //self.pushFromLoginPage()
               
               //indicator.startAnimating()
    //           self.disableService()
               
        Utils.RiteVetIndicatorShow()
               
                   let urlString = BASE_URL_KREASE
                   
                   var parameters:Dictionary<AnyHashable, Any>!
               
                       parameters = [
                           "action"        :   "stufflist",
                           "pageNo"        :   "0",
                           "userId"        :   ""
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
                                   
                                   //var strSuccessAlert : String!
                                   //strSuccessAlert = JSON["msg"]as Any as? String
                                   
                                   if strSuccess == "success" //true
                                   {
                                    Utils.RiteVetIndicatorHide()
    //                                   self.pushFromLoginPage()
                                    self.tbleView.isHidden = false
                                    self.tbleView.delegate = self
                                    self.tbleView.dataSource = self
                                    
                                    var ar : NSArray!
                                    ar = (JSON["data"] as! Array<Any>) as NSArray
                                    //print(ar as Any)
                                    
                                    
                                    // index 0
                                    var ar0 : NSArray!
                                    ar0 = (JSON["data"] as! Array<Any>) as NSArray
                                    
                                    var arrListOfFreeItem0:Array<Any>!
                                    arrListOfFreeItem0 = (ar0 as! Array<Any>)
                                    
                                    //print(arrListOfFreeItem0[0] as Any)
                                    
                                    
                                    let item = arrListOfFreeItem0[0] as? [String:Any]
                                    
                                    //cell.lblTitle.text = (item!["postTitle"] as! String)
                                    /*
                                     @IBOutlet weak var imgVieww: UIImageView!
                                     @IBOutlet weak var lblFirst: UILabel!
                                     @IBOutlet weak var lblSecond: UILabel!
                                     */
                                    
                                    
                                    self.imgVieww.sd_setImage(with: URL(string: (item!["image_1"] as! String)), placeholderImage: UIImage(named: "dog"))
                                    
                                    self.lblFirst.text = (item!["description"] as! String)
                                    self.lblSecond.text = (item!["postTitle"] as! String)
                                  
        // share data
            self.shareText = (item!["description"] as! String)
            self.shareURLString = (item!["image_1"] as! String)
                                    
                                    
                                    
                                    self.arrListOfFreeItem = (ar as! Array<Any>)
                                    
                                    self.tbleView.reloadData()
                                   }
                                   else
                                   {
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

}

extension FreeStuffPage: UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrListOfFreeItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:FreeStuffPageTableCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! FreeStuffPageTableCell
        
        cell.backgroundColor = .clear
    
        let item = arrListOfFreeItem[indexPath.row] as? [String:Any]
        
        /*
         categoryId = 18;
         categoryName = Bird;
         created = "2019-12-23 11:50:00";
         description = "In this unique world all type of birds are moving in a different  direction and other related things have been found to make the trend of their future in very different and uniquely different environments ";
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
        
        cell.lblTitle.text = (item!["postTitle"] as! String)
        
        cell.lblDate.text = (item!["created"] as! String)
        cell.lblMessage.text = (item!["description"] as! String)
        
        //cell.imgProfile.image = UIImage(named: item!["userImage"] as! String)
        
        cell.imgProfile.sd_setImage(with: URL(string: (item!["image_1"] as! String)), placeholderImage: UIImage(named: "plainBack"))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        
        let item = arrListOfFreeItem[indexPath.row] as? [String:Any]
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FreeStuffDetailsId") as? FreeStuffDetails
        push!.getFreeStuffDict = item as NSDictionary?
        self.navigationController?.pushViewController(push!, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}

extension FreeStuffPage: UITableViewDelegate
{
    
}

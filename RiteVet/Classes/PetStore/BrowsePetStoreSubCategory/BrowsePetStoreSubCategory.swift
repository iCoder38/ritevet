//
//  BrowsePetStoreSubCategory.swift
//  RiteVet
//
//  Created by evs_SSD on 12/24/19.
//  Copyright © 2019 Apple . All rights reserved.
//

import UIKit

class BrowsePetStoreSubCategory: UIViewController {

    let cellReuseIdentifier = "browsePetStoreSubCategoryTableCell"
    
    var arrSubscription = [
    "1","2"
    ]
    
    var ar : NSArray!
    
    var mainIdOfCategory:Int!
    var stringValue:String!
    var stringValueSubCat:String!
    
    var arrBrowseGetPetDetails:Array<Any>!
    
    var dictGetPetDetails:NSDictionary!
    
    var getCategoryIdInBrowsePet:String!
    
    @IBOutlet weak var viewNavigation:UIView! {
        didSet {
            viewNavigation.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }
    @IBOutlet weak var btnBack:UIButton!
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "BROWSE PET STORE"
            lblNavigationTitle.textColor = .white
        }
    }
    // 255 200 68
    @IBOutlet weak var tbleView: UITableView! {
        didSet {
            
            tbleView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
            tbleView.backgroundColor = .clear
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnBack.addTarget(self, action: #selector(backClick), for: .touchUpInside)
        
        print(dictGetPetDetails as Any)
        //print(dictGetPetDetails["SubCat"] as Any)
        
        ar = (dictGetPetDetails["SubCat"] as! Array<Any>) as NSArray
        tbleView.delegate = self
        tbleView.dataSource = self
        tbleView.reloadData()
        //print(ar as Any)
        
       

        
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    @objc func backClick() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension BrowsePetStoreSubCategory: UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return ar.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:BrowsePetStoreSubCategoryTableCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! BrowsePetStoreSubCategoryTableCell
        
        cell.backgroundColor = .clear
        
        
        let item = ar[indexPath.row] as? [String:Any]
        
        cell.lblTitle.text = (item!["name"] as! String)
        
        let livingArea = item?["totalProduct"] as? Int ?? 0
        if livingArea == 0 {
            let stringValue = String(livingArea)
            cell.lblCount.text = "("+stringValue+")"
        }
        else
        {
            let stringValue = String(livingArea)
            cell.lblCount.text = "("+stringValue+")"
        }
        
        cell.lblCount.textColor = UIColor.init(red: 255.0/255.0, green: 173.0/255.0, blue: 68.0/255.0, alpha: 1)
        
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        
        mainIdOfCategory = dictGetPetDetails?["id"] as? Int ?? 0
               if mainIdOfCategory == 0 {
                   stringValue = String(mainIdOfCategory)
               }
               else
               {
                   stringValue = String(mainIdOfCategory)
               }
        
         let item = ar[indexPath.row] as? [String:Any]
        
        // id of sub category
        let livingArea = item?["id"] as? Int ?? 0
        if livingArea == 0 {
            stringValueSubCat = String(livingArea)
        }
        else
        {
            stringValueSubCat = String(livingArea)
        }
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DogFoodId") as? DogFood
        
        push!.getCategoryIdInDogFood = stringValue
        push!.getSubCategoryIdInDogFood = stringValueSubCat
        
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50
    }
}

extension BrowsePetStoreSubCategory: UITableViewDelegate
{
    
}


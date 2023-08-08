//
//  BuyNow.swift
//  RiteVet
//
//  Created by evs_SSD on 2/27/20.
//  Copyright © 2020 Apple . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class BuyNow: UIViewController {

    let cellReuseIdentifier = "buyNowTableCell"
    
    var buyNowItemFullQuery:NSDictionary!
    var quantityCount:Double!
    
    var str_total_price:String!
    
    @IBOutlet weak var viewNavigation:UIView! {
        didSet {
            viewNavigation.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }
    @IBOutlet weak var btnBack:UIButton!
    
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "BUY NOW"
            lblNavigationTitle.textColor = .white
        }
    }
    // 255 200 68
    @IBOutlet weak var tbleView: UITableView! {
        didSet {
            self.tbleView.delegate = self
            self.tbleView.dataSource = self
            self.tbleView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
            self.tbleView.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var btnCheckOut:UIButton! {
        didSet {
            btnCheckOut.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            btnCheckOut.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            btnCheckOut.layer.shadowOpacity = 1.0
            btnCheckOut.layer.shadowRadius = 15.0
            btnCheckOut.layer.masksToBounds = false
            btnCheckOut.layer.cornerRadius = 14
            btnCheckOut.backgroundColor = .systemGreen
            btnCheckOut.setTitleColor(.white, for: .normal)
        }
    }
    
    @IBOutlet weak var lblSubTotal:UILabel!
    @IBOutlet weak var lblShipingCharge:UILabel!
    @IBOutlet weak var lblTotalPrice:UILabel!
        override func viewDidLoad() {
        super.viewDidLoad()
        
        self.btnBack.addTarget(self, action: #selector(backClick), for: .touchUpInside)
        
        self.btnCheckOut.addTarget(self, action: #selector(checkOutClickMethod), for: .touchUpInside)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func backClick() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc func checkOutClickMethod() {
        
        self.push_to_payment_page()
    }
    
    @objc func push_to_payment_page() {
        print(self.buyNowItemFullQuery as Any)
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CSelectPaymetScreenId") as? CSelectPaymetScreen
        
        push!.finalPrice = self.str_total_price
        push!.dict_get_selected_product_Details = buyNowItemFullQuery
        
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
    
}

extension BuyNow: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1//arrListOfMyCartItems2.count
        //arrListOfMyCartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:BuyNowTableCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! BuyNowTableCell
        
        cell.backgroundColor = .clear
        
        // let item = arrListOfMyCartItems2[indexPath.row] as? [String:Any]
         print(buyNowItemFullQuery as Any)
        
        // image
        cell.imgDogProduct.sd_setImage(with: URL(string: (buyNowItemFullQuery!["image"] as! String)), placeholderImage: UIImage(named: "plainBack"))
        
        // title
        cell.lblDetails.text = (buyNowItemFullQuery!["productName"] as! String)
        
        print(quantityCount as Any)
        
        // stepper
        cell.stepper.tag = indexPath.row
        cell.stepper.minimumValue = 0 // item?["quantity"] as! Double
        cell.stepper.maximumValue = Double(buyNowItemFullQuery!["quantity"] as! String)!
        // buyNowItemFullQuery?["quantity"] as! Double
        cell.stepper.value = quantityCount // buyNowItemFullQuery?["quantity"] as! Double//0
        cell.stepper.addTarget(self, action: #selector(stepperValueChanged(_:)), for: .valueChanged)
        
        // cell.lblPrice.textAlignment = .right
        
        // stepper label
        cell.lblStepperText.tag = indexPath.row
        cell.lblStepperText.textColor = .black
        
         let c:String = String(format:"%.0f", quantityCount)
         cell.lblStepperText.text = "\(c)"
        
        /*// price
        let livingArea = (buyNowItemFullQuery!["specialPrice"] as! Int)*Int(quantityCount)
        
        if livingArea == 0 {
            let stringValue = String(livingArea)
            // cell.lblPrice.text = "$"+stringValue
            lblSubTotal.text = "$ "+stringValue
        }
        else {
            let stringValue = String(livingArea)
            // cell.lblPrice.text = "$"+stringValue
            lblSubTotal.text = "$ "+stringValue
        }*/
        
        self.lblSubTotal.text = (buyNowItemFullQuery!["specialPrice"] as! String)
        
        self.lblShipingCharge.text = (buyNowItemFullQuery!["shippingAmount"] as! String)
        
        let calculateNewTotalPrice = quantityCount*Double(buyNowItemFullQuery!["specialPrice"] as! String)!+Double(buyNowItemFullQuery!["shippingAmount"] as! String)!
        lblTotalPrice.text = "$ "+String(calculateNewTotalPrice)
        
        self.str_total_price = String(calculateNewTotalPrice)
        
        return cell
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tbleView)
        let indexPath = self.tbleView.indexPathForRow(at:buttonPosition)
        let cell = self.tbleView.cellForRow(at: indexPath!) as! BuyNowTableCell

        cell.lblStepperText.text = Int(sender.value).description
        
        let myInt = Double(cell.lblStepperText.text!)!
        
        let getStepperValue = myInt*Double(buyNowItemFullQuery!["specialPrice"] as! String)!
        print(getStepperValue as Any)
        
        self.lblSubTotal.text = "$"+String(getStepperValue)
        
        self.lblShipingCharge.text = "$"+(buyNowItemFullQuery!["shippingAmount"] as! String)
        
        let calculateNewTotalPrice = Double(getStepperValue)+Double(buyNowItemFullQuery!["shippingAmount"] as! String)!
        lblTotalPrice.text = String(calculateNewTotalPrice)
        
        self.str_total_price = String(calculateNewTotalPrice)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 120
    }
}

extension BuyNow: UITableViewDelegate {
    
}





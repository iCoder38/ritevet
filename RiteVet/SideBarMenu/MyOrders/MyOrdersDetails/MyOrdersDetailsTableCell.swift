//
//  MyOrdersDetailsTableCell.swift
//  RiteVet
//
//  Created by evs_SSD on 1/10/20.
//  Copyright © 2020 Apple . All rights reserved.
//

import UIKit

class MyOrdersDetailsTableCell: UITableViewCell {

    @IBOutlet weak var lblOrderId:UILabel!
    @IBOutlet weak var lblInTansit:UILabel!
    
    @IBOutlet weak var lbl_seller_info:UILabel!
    
    @IBOutlet weak var imgProductImage:UIImageView!
    
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblQuantity:UILabel!
    @IBOutlet weak var lblPrice:UILabel! {
        didSet {
            lblPrice.textColor = .blue
        }
    }
    @IBOutlet weak var lblDate:UILabel!
    
    @IBOutlet weak var lblShippingDetails:UILabel!
    @IBOutlet weak var lblUsername:UILabel!
    @IBOutlet weak var lblAddress:UILabel!
    @IBOutlet weak var lblPhoneNumber:UILabel!
    @IBOutlet weak var lblZipcode:UILabel!
    
    @IBOutlet weak var lblPaymentDetails:UILabel!
    @IBOutlet weak var lblInvoiceDate:UILabel!
    @IBOutlet weak var lblRefId:UILabel!
    
    @IBOutlet weak var lblDeliveryStatus:UILabel!
    @IBOutlet weak var lblInvoilblCurrentStatusceDate:UILabel!
    @IBOutlet weak var lblExpectedDelivery:UILabel!
    
    @IBOutlet weak var view_seller_info:UIView! {
        didSet {
            view_seller_info.layer.cornerRadius = 8
            view_seller_info.clipsToBounds = true
            view_seller_info.backgroundColor = .white
        }
    }
    
    @IBOutlet weak var viewBGOne:UIView! {
        didSet {
            viewBGOne.layer.cornerRadius = 8
            viewBGOne.clipsToBounds = true
            viewBGOne.backgroundColor = .white
        }
    }
    @IBOutlet weak var viewBGTwo:UIView! {
        didSet {
            viewBGTwo.layer.cornerRadius = 8
            viewBGTwo.clipsToBounds = true
            viewBGTwo.backgroundColor = .white
        }
    }
    @IBOutlet weak var viewBGThree:UIView! {
        didSet {
            viewBGThree.layer.cornerRadius = 8
            viewBGThree.clipsToBounds = true
            viewBGThree.backgroundColor = .systemYellow
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

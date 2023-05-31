//
//  VeterinarianBiographyTableCell.swift
//  RiteVet
//
//  Created by Apple  on 28/11/19.
//  Copyright © 2019 Apple . All rights reserved.
//

import UIKit

class VeterinarianBiographyTableCell: UITableViewCell {

    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var txtView:UITextView!
    @IBOutlet weak var txtUpload:UITextField!
    @IBOutlet weak var txtUploadYourBusinessPicture:UITextField!
    @IBOutlet weak var txtEstimatedPriceList:UITextField!
    @IBOutlet weak var txtUploadTranscript:UITextField!
    @IBOutlet weak var txtLicense:UITextField!
    @IBOutlet weak var txtSupportDocumentation:UITextField!
    
    @IBOutlet weak var btnCheckUncheck:UIButton!
    @IBOutlet weak var lblTermsAndCondition:UILabel!
    
    @IBOutlet weak var btnUploadYourPicture:UIButton!
    @IBOutlet weak var btnUploadYourBusinessProfile:UIButton!
    @IBOutlet weak var btnEstimatedPriceList:UIButton!
    @IBOutlet weak var btnUploadTranscript:UIButton!
    @IBOutlet weak var btnLicense:UIButton!
    @IBOutlet weak var btnUploadSupportDocumantation:UIButton!
    
    @IBOutlet weak var imgBtnUploadYourProfilePicture:UIButton! {
        didSet {
            imgBtnUploadYourProfilePicture.isHidden = true
        }
    }
    
    @IBOutlet weak var imgBtnUploadYourBusinessProfile:UIButton!{
        didSet {
            imgBtnUploadYourBusinessProfile.isHidden = true
        }
    }
    
    @IBOutlet weak var imgBtnEstimatedPriceList:UIButton!{
        didSet {
            imgBtnEstimatedPriceList.isHidden = true
        }
    }
    
    @IBOutlet weak var imgBtnUploadTranscript:UIButton!{
        didSet {
            imgBtnUploadTranscript.isHidden = true
        }
    }
    
    @IBOutlet weak var imgBtnLicense:UIButton!{
        didSet {
            imgBtnLicense.isHidden = true
        }
    }
    
    @IBOutlet weak var imgBtnUploadSupportDocumentation:UIButton!{
        didSet {
            imgBtnUploadSupportDocumentation.isHidden = true
        }
    }
    
    @IBOutlet weak var imgUploadProfilePicture:UIImageView! {
        didSet {
            imgUploadProfilePicture.layer.cornerRadius = 20
            imgUploadProfilePicture.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var imgUploadYourBusinessProfile:UIImageView! {
        didSet {
            imgUploadYourBusinessProfile.layer.cornerRadius = 20
            imgUploadYourBusinessProfile.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var imgUploadEstimatedPriceList:UIImageView! {
        didSet {
            imgUploadEstimatedPriceList.layer.cornerRadius = 20
            imgUploadEstimatedPriceList.clipsToBounds = true
        }
    }
    @IBOutlet weak var imgUploadUploadTranscript:UIImageView! {
        didSet {
            imgUploadUploadTranscript.layer.cornerRadius = 20
            imgUploadUploadTranscript.clipsToBounds = true
        }
    }
    @IBOutlet weak var imgUploadLicense:UIImageView! {
        didSet {
            imgUploadLicense.layer.cornerRadius = 20
            imgUploadLicense.clipsToBounds = true
        }
    }
    @IBOutlet weak var imgUploadSupportDocumentation:UIImageView! {
        didSet {
            imgUploadSupportDocumentation.layer.cornerRadius = 20
            imgUploadSupportDocumentation.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var btnNext:UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

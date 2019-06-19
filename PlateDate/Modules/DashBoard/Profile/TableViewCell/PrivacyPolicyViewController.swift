//
//  PrivacyPolicyViewController.swift
//  PlateDate
//
//  Created by WebCrafters on 26/05/19.
//  Copyright © 2019 WebCrafters. All rights reserved.
//

import UIKit

class PrivacyPolicyViewController: UIViewController {

    @IBOutlet weak var informationCollectionLabel: UILabel!
    let informationCollectionArray = [
    "Your contact information, such as your first and last name, email address, and phone number;",
    "Your Platedate account information, including your user name",
    "Information you voluntarily provide about yourself, such as allergies, dietary restrictions, food preferences, and groceries that you want to purchase;",
    "Your user content (including images) you provide to use certain features, including recipes you submit.",
    "Your mobile device model and ID number, user settings."
    ]

    @IBOutlet weak var LegealBasicLabel: UILabel!
    let LegealBasicArray = [
    "To satisfy our contractual obligation to you. For example: allowing you to register for an Account; providing the Services to you.",
    "With your consent. For example: processing health information, such as information about your allergies, so that we can customize our recommendations for you; sending you customized marketing communications related to our products and services electronically (including email, notifications from third party services, and notifications from mobile applications); and sharing your Personal Data for customized marketing communication with our selected trusted partners with your consent.",
    "When we have a legitimate business interest to do so. For example: managing the requests for information you send us, including handling complaints; preventing fraud; enforcing our rights before the courts; improving the performance and security of our products and our Services, including the App and the Site; sending you customer care communications concerning products or services you have used or which you showed interest in, and in order to carry out customer satisfaction surveys; unless you opt-out, contacting you for marketing purposes by phone (non-automated).",
    "We may also use your Personal Data to the extent necessary to comply with our legal obligations.",
    ]

     @IBOutlet weak var dataRetensionLabel: UILabel!
    let dataRetensionArray = [
    "To satisfy our contractual obligation to you. For example: allowing you to register for an Account; providing the Services to you.",
    "With your consent. For example: processing health information, such as information about your allergies, so that we can customize our recommendations for you; sending you customized marketing communications related to our products and services electronically (including email, notifications from third party services, and notifications from mobile applications); and sharing your Personal Data for customized marketing communication with our selected trusted partners with your consent.",
    "When we have a legitimate business interest to do so. For example: managing the requests for information you send us, including handling complaints; preventing fraud; enforcing our rights before the courts; improving the performance and security of our products and our Services, including the App and the Site; sending you customer care communications concerning products or services you have used or which you showed interest in, and in order to carry out customer satisfaction surveys; unless you opt-out, contacting you for marketing purposes by phone (non-automated).",
    "We may also use your Personal Data to the extent necessary to comply with our legal obligations.",
    ]

    @IBOutlet weak var  managingLabel : UILabel!
    let managingArray = [
    "be informed on the purposes and methods of the processing of your Personal Data; ",
    "access your Personal Data (commonly known as making a data subject access request). This enables you to receive a copy of the Personal Data we hold about you;",
    "ask for updating or rectification of the Personal Data we hold about you. This enables you to have any incomplete or inaccurate data we hold about you corrected, though we may need to verify the accuracy of the new data you provide to us;",
    "request erasure of your Personal Data. This enables you to ask us to delete or remove your Personal Data where there is no good reason for us continuing to process it. You can also ask us to delete or remove your Personal Data where you have successfully objected to processing or where we are required to erase your Personal Data to comply with local law.",
    "object to the processing, wholly or partly, of your Personal Data where we are relying on legitimate interest (or those of a third party) and there is something about your particular situation which makes you want to object to processing on this ground as you feel it impacts on your fundamental rights and freedoms. In some cases, we may demonstrate that we have compelling legitimate grounds to process your information which override your rights and freedoms;",
    "where we are relying on consent to process your Personal Data, you can revoke the consent to the processing of your Personal Data freely and at any time, also by clicking on the unsubscribe option at the bottom of our marketing communications; or"
    ]


    override func viewDidLoad() {
        super.viewDidLoad()

        informationCollectionLabel.attributedText = add(stringList: informationCollectionArray, font: informationCollectionLabel.font, bullet: "•")

         LegealBasicLabel.attributedText = add(stringList: LegealBasicArray, font: LegealBasicLabel.font, bullet: "•")

         dataRetensionLabel.attributedText = add(stringList: dataRetensionArray, font: dataRetensionLabel.font, bullet: "•")

         managingLabel.attributedText = add(stringList: managingArray, font: managingLabel.font, bullet: "•")



        // Do any additional setup after loading the view.
    }


    @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)

    }

}

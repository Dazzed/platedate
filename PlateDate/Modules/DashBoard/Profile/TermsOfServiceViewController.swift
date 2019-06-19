//
//  TermsOfServiceViewController.swift
//  PlateDate
//
//  Created by WebCrafters on 26/05/19.
//  Copyright © 2019 WebCrafters. All rights reserved.
//

import UIKit

class TermsOfServiceViewController: UIViewController {


    @IBOutlet weak var additionalPoliciesLabel: UILabel!
    let additionalPoliciesArray = [
    "Our Privacy Policy, which explains what personal information we collect, why we collect it, how we use it, the controls you have over your personal information and the procedures that we have in place to protect your privacy. It applies to personal information we collect through the Site and the App. Please make sure that you read our Privacy Policy carefully before using the Site or the App",
    "Our Community Guidelines, which set out the permitted uses and prohibited uses of our Site or App. These Community Guidelines form part of these Terms of Service, so references to Terms of Service includes them.."
    ]


    @IBOutlet weak var regardingRecipesLabel: UILabel!
    let regardingRecipesArray = [
    "you should verify any unusual or novel ingredients or methods in a recipe by referring to other sources",
    "you should comply at all times with any food safety notices or bulletins issued by your local government authority, and you should not expect the Platedate Service to note or explain risks contained in food preparation, method or techniques of cooking or consumption of certain food; and",
    "if you are not an experienced cook, we advise that you take instruction from an experienced cook, or other appropriate authority, when using recipes from the Platedate Service, particularly in respect of health and safety."
    ]

    @IBOutlet weak var userRegisterationLabel: UILabel!
    let userRegisterationArray = [
    "you do not exist;",
    "you do not have an email address that could receive emails;",
    "you breach these Terms of Service;",
    "you have or appear to have intentionally provided false information to us;",
    "you are a minor and have not submitted the account information with the approval of a parent or guardian;",
    "to respond to actual or potential threats to our business (such as cyber-security threats), or unwelcome or dangerous practices or behaviours in our community; or",
    "for any of the reasons set out in Section 18 below."
    ]

    @IBOutlet weak var responsiblePromiseLabel: UILabel!
    let responsiblePromiseArray = [
    "any Content you post or publish comply with these Terms of Service;",
    "you have the right to use, upload, post or publish Contents to our App or Site andgrant the licences to us as set out in Section 10; and",
    "the use by Platedate of the Contents you uploaded, posted or published will not infringe the rights of any third parties.",

    ]

    @IBOutlet weak var responsibleAcknowledgeLabel: UILabel!
    let responsibleAcknowledgeArray = [
    "we will not be responsible, or liable to any third party, for the Content or accuracy of any Content posted by you or any other user of our Site or App;",
    "we have the right to remove any Content you make available on our Site or App at our sole discretion, including; if, in our opinion, your Content does not comply with these Terms of Service, or if we believe that it is necessary to protect ourselves, other users or any third party; and",
    "you are solely responsible for securing and backing up your Content."
    ]

    @IBOutlet weak var changesOfTermsLabel: UILabel!
    let changesOfTermsArray = [
    "there are changes in applicable laws and regulations;",
    "there are changes in the specification or operation of the Platedate Service;",
    "it is necessary to respond to actual or potential threats to our business (such as cyber-security threats), or unwelcome or dangerous practices or behaviours in our community;",
    "it is necessary to clarify or make a correction of any part of these Terms of Service; or",
    "of other, unanticipated, situations that may reasonably require us to revise these Terms of Service;"
    ]

    @IBOutlet weak var restrctionLabel: UILabel!
    let restrctionArray = [
    "you have breached these Terms of Service;",
    "you have given us false information;",
    "you are using P    latedate Service illegally or in breach of any third party’s rights;",
    "it is necessary to protect ourselves, other users or any third party;",
    "it is likely that claims or proceedings may be brought against us by third parties due to circumstances that are connected to your use of Platedate Service",
    "it is not possible to establish contact with you through telephone, fax and/or email",
    "it is an emergency; and/or",
    "it is necessary for operating Platedate Service."
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        additionalPoliciesLabel.attributedText = add(stringList: additionalPoliciesArray, font: additionalPoliciesLabel.font, bullet: "•")

        regardingRecipesLabel.attributedText = add(stringList: regardingRecipesArray, font: regardingRecipesLabel.font, bullet: "•")

         userRegisterationLabel.attributedText = add(stringList: userRegisterationArray, font: userRegisterationLabel.font, bullet: "•")

         responsiblePromiseLabel.attributedText = add(stringList: responsiblePromiseArray, font: responsiblePromiseLabel.font, bullet: "•")

         responsibleAcknowledgeLabel.attributedText = add(stringList: responsibleAcknowledgeArray, font: responsibleAcknowledgeLabel.font, bullet: "•")

         changesOfTermsLabel.attributedText = add(stringList: changesOfTermsArray, font: changesOfTermsLabel.font, bullet: "•")

          restrctionLabel.attributedText = add(stringList: restrctionArray, font: restrctionLabel.font, bullet: "•")
        // Do any additional setup after loading the view.
    }

    // Mark: - Back Button Action
    @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }


}


extension UIViewController {
     func add(stringList: [String],
         font: UIFont,
         bullet: String = "\u{2022}",
         indentation: CGFloat = 20,
         lineSpacing: CGFloat = 2,
         paragraphSpacing: CGFloat = 12,
         textColor: UIColor = .gray,
         bulletColor: UIColor = ._lightGray3) -> NSAttributedString {

    let textAttributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: font, NSAttributedStringKey.foregroundColor: textColor]
    let bulletAttributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: font, NSAttributedStringKey.foregroundColor: bulletColor]

    let paragraphStyle = NSMutableParagraphStyle()
    let nonOptions = [NSTextTab.OptionKey: Any]()
    paragraphStyle.tabStops = [
        NSTextTab(textAlignment: .left, location: indentation, options: nonOptions)]
    paragraphStyle.defaultTabInterval = indentation
    //paragraphStyle.firstLineHeadIndent = 0
    //paragraphStyle.headIndent = 20
    //paragraphStyle.tailIndent = 1
    paragraphStyle.lineSpacing = lineSpacing
    paragraphStyle.paragraphSpacing = paragraphSpacing
    paragraphStyle.headIndent = indentation

    let bulletList = NSMutableAttributedString()
    for string in stringList {
        let formattedString = "\(bullet)\t\(string)\n"
        let attributedString = NSMutableAttributedString(string: formattedString)

        attributedString.addAttributes(
            [NSAttributedStringKey.paragraphStyle : paragraphStyle],
            range: NSMakeRange(0, attributedString.length))

        attributedString.addAttributes(
            textAttributes,
            range: NSMakeRange(0, attributedString.length))

        let string:NSString = NSString(string: formattedString)
        let rangeForBullet:NSRange = string.range(of: bullet)
        attributedString.addAttributes(bulletAttributes, range: rangeForBullet)
        bulletList.append(attributedString)
    }

    return bulletList
}

}




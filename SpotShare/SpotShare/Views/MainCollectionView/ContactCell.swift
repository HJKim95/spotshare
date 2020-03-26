//
//  ContactCell.swift
//  SpotShare
//
//  Created by 김희중 on 21/07/2019.
//  Copyright © 2019 김희중. All rights reserved.
//

import UIKit

class ContactCell: UICollectionViewCell {
    
    let helloLabel: UILabel = {
        let lb = UILabel()
//        lb.text = "SAY HELLO"
        // letter spacing 1
        let attributedString = NSMutableAttributedString(string: "SAY HELLO")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(1.0), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.textAlignment = .left
        lb.backgroundColor = .clear
        lb.textColor = .gray
        lb.font = UIFont(name: "DMSans-Medium", size: 12)
        return lb
    }()
    
    let helloLabel2: UILabel = {
        let lb = UILabel()
        lb.text = "We'd love to hear from you"
        lb.textAlignment = .left
        lb.backgroundColor = .clear
        lb.textColor = .darkGray
        lb.font = UIFont(name: "DMSans-Regular", size: 14)
        return lb
    }()
    
    let contactButton: UILabel = {
        let lb = UILabel()
        lb.backgroundColor = UIColor.clear
        lb.text = "CONTACT US"
        lb.textAlignment = .center
        lb.font = UIFont(name: "DMSans-Bold", size: 12)
        lb.textColor = UIColor.mainColor
        lb.layer.masksToBounds = true
        lb.layer.cornerRadius = 18
        lb.layer.borderWidth = 2
        lb.layer.borderColor = UIColor.mainColor.cgColor
        return lb
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var helloLabelConstraint: NSLayoutConstraint?
    var helloLabel2Constraint: NSLayoutConstraint?
    var contactButtonConstraint: NSLayoutConstraint?
    
    //total cell size 122
    //36+36+50
    fileprivate func setupViews() {
        self.backgroundColor = UIColor.rgb(red: 252, green: 252, blue: 252)
        
        addSubview(helloLabel)
        addSubview(helloLabel2)
        addSubview(contactButton)
        
        helloLabelConstraint = helloLabel.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, topConstant: 32, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 71, heightConstant: 18).first
        helloLabel2Constraint = helloLabel2.anchor(helloLabel.bottomAnchor, left: self.leftAnchor, bottom: nil, right: nil, topConstant: 2, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 177, heightConstant: 24).first
        contactButtonConstraint = contactButton.anchor(self.topAnchor, left: nil, bottom: nil, right: self.rightAnchor, topConstant: 36, leftConstant: 0, bottomConstant: 0, rightConstant: 19, widthConstant: 122, heightConstant: 36).first
    }
}

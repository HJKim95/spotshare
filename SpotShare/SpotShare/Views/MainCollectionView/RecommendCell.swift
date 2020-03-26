//
//  RecommendCell.swift
//  SpotShare
//
//  Created by 김희중 on 21/07/2019.
//  Copyright © 2019 김희중. All rights reserved.
//

import UIKit

class RecommendCell: UICollectionViewCell {
    
    let recommendLabel: UILabel = {
        let lb = UILabel()
        lb.backgroundColor = .white
//        lb.text = "RECOMMENDED"
        // letter spacing 1
        let attributedString = NSMutableAttributedString(string: "RECOMMENDED")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(1.0), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.font = UIFont(name: "DMSans-Medium", size: 12)
        lb.textColor = .lightGray
        lb.textAlignment = .left
        return lb
    }()
    
    let textLabel: UILabel = {
        let lb = UILabel()
        lb.backgroundColor = .white
//        lb.text = "How about a beer today?"
        // letter spacing -0.3
        let attributedString = NSMutableAttributedString(string: "How about a beer today?")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(-0.3), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.font = UIFont(name: "DMSans-Medium", size: 20)
        lb.textColor = .black
        lb.textAlignment = .left
        lb.numberOfLines = 0
        return lb
    }()
    
    let checkoutLabel: UILabel = {
        let lb = UILabel()
        lb.backgroundColor = .white
//        lb.text = "CHECK OUT THE LIST"
        // letter spacing 1
        let attributedString = NSMutableAttributedString(string: "CHECK OUT THE LIST")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(1.0), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.font = UIFont(name: "DMSans-Medium", size: 10)
        lb.textColor = .lightGray
        lb.textAlignment = .left
        return lb
    }()
    
    let recommendMaskView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "mask")
        return iv
    }()
    
    let recommendImageView: UIImageView = {
        let iv = UIImageView()
//        iv.backgroundColor = UIColor.wheat
        iv.image = UIImage(named: "beer_image")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let recommendBackImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .clear
        iv.image = UIImage(named: "fill1")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var recommendLabelConstraint: NSLayoutConstraint?
    var textLabelConstraint: NSLayoutConstraint?
    var checkoutLabelConstraint: NSLayoutConstraint?
    var recommendImageViewConstraint: NSLayoutConstraint?
    var recommendBackImageViewConstraint: NSLayoutConstraint?
    
    //total cell size 226
    //33+18+11+164
    fileprivate func setupViews() {
        backgroundColor = .white
        
        recommendImageView.mask = recommendMaskView
        
        addSubview(recommendLabel)
        addSubview(textLabel)
        addSubview(checkoutLabel)
        addSubview(recommendBackImageView)
        addSubview(recommendImageView)
        
        recommendLabelConstraint = recommendLabel.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 33, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 18).first
        textLabelConstraint = textLabel.anchor(recommendLabel.bottomAnchor, left: self.leftAnchor, bottom: nil, right: nil, topConstant: 37, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 134, heightConstant: 56).first
        checkoutLabelConstraint = checkoutLabel.anchor(textLabel.bottomAnchor, left: self.leftAnchor, bottom: nil, right: nil, topConstant: 8, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 117, heightConstant: 18).first
        recommendImageViewConstraint = recommendImageView.anchor(recommendLabel.bottomAnchor, left: nil, bottom: nil, right: self.rightAnchor, topConstant: 11, leftConstant: 0, bottomConstant: 0, rightConstant: 25, widthConstant: 165.5, heightConstant: 164).first
        recommendBackImageViewConstraint = recommendBackImageView.anchor(recommendLabel.bottomAnchor, left: nil, bottom: nil, right: self.rightAnchor, topConstant: 18, leftConstant: 0, bottomConstant: 0, rightConstant: 9.5, widthConstant: 168, heightConstant: 160).first
        
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        recommendMaskView.frame = recommendImageView.bounds
    }
    
    
}

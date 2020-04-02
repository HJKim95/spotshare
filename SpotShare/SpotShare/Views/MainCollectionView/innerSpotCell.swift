//
//  innerSpotCell.swift
//  SpotShare
//
//  Created by 김희중 on 06/08/2019.
//  Copyright © 2019 김희중. All rights reserved.
//

import UIKit

class innerSpotCell: UICollectionViewCell {
    
    let resImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .lightGray
        iv.layer.cornerRadius = 12
        iv.layer.masksToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let resLabel: UILabel = {
        let lb = UILabel()
        lb.backgroundColor = .white
        lb.textColor = UIColor.mainText
        lb.font = UIFont(name: "DMSans-Medium", size: 14)
        return lb
    }()
    
    let pointLabel: UILabel = {
        let lb = UILabel()
        lb.backgroundColor = UIColor.wheat
        lb.textAlignment = .center
        lb.font = UIFont(name: "DMSans-Regular", size: 12)
        lb.textColor = .darkGray
        lb.layer.masksToBounds = true
        lb.layer.cornerRadius = 11
        return lb
    }()
    
    let distanceImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .clear
        iv.image = UIImage(named: "location")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let distanceLabel: UILabel = {
        let lb = UILabel()
        lb.backgroundColor = .white
        lb.font = UIFont(name: "DMSans-Regular", size: 12)
        lb.textColor = .gray
        lb.textAlignment = .left
        lb.adjustsFontSizeToFitWidth = true
        return lb
    }()
    
    let toiletImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .white
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let toiletLabel: UILabel = {
        let lb = UILabel()
        lb.backgroundColor = .clear
        lb.font = UIFont(name: "DMSans-Regular", size: 11)
        lb.textColor = .gray
        lb.textAlignment = .center
        lb.adjustsFontSizeToFitWidth = true
        return lb
    }()
    
    var toilet: String? {
        didSet {
            checkToilet()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var resImageViewConstraint: NSLayoutConstraint?
    var resLabelConstraint: NSLayoutConstraint?
    var pointLabelConstraint: NSLayoutConstraint?
    var distanceImageViewConstraint: NSLayoutConstraint?
    var distanceLabelConstraint: NSLayoutConstraint?
    var toiletImageViewConstraint: NSLayoutConstraint?
    var toiletLabelConstraint: NSLayoutConstraint?
    
    
    fileprivate func setupViews() {
        self.backgroundColor = .white
        addSubview(resImageView)
        addSubview(resLabel)
        addSubview(pointLabel)
        addSubview(distanceImageView)
        addSubview(distanceLabel)
        addSubview(toiletImageView)
        addSubview(toiletLabel)
        
        
        distanceImageViewConstraint = distanceImageView.anchor(nil, left: self.leftAnchor, bottom: self.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 6, rightConstant: 0, widthConstant: 10, heightConstant: 10).first
        distanceLabelConstraint = distanceLabel.anchor(nil, left: distanceImageView.rightAnchor, bottom: self.bottomAnchor, right: nil, topConstant: 0, leftConstant: 3, bottomConstant: 4, rightConstant: 0, widthConstant: 35, heightConstant: 16).first
        toiletLabelConstraint = toiletLabel.anchor(nil, left: nil, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 4, rightConstant: 0, widthConstant: 30, heightConstant: 16).first
        toiletImageViewConstraint = toiletImageView.anchor(nil, left: nil, bottom: self.bottomAnchor, right: toiletLabel.leftAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 6, rightConstant: 3, widthConstant: 12, heightConstant: 12).first
        
        resLabelConstraint = resLabel.anchor(nil, left: self.leftAnchor, bottom: distanceLabel.topAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 1, rightConstant: 0, widthConstant: 108, heightConstant: 18).first
        pointLabelConstraint = pointLabel.anchor(nil, left: resLabel.rightAnchor, bottom: distanceLabel.topAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 0, rightConstant: 0, widthConstant: 32, heightConstant: 21).first
        resImageViewConstraint = resImageView.anchor(self.topAnchor, left: self.leftAnchor, bottom: resLabel.topAnchor, right: self.rightAnchor, topConstant: 16, leftConstant: 0, bottomConstant: 9, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
        
        
        
    }
    
//    let gradientLayer = CAGradientLayer()
//
//    fileprivate func setupGradientLayer() {
//        gradientLayer.colors = [UIColor.black.withAlphaComponent(0.4).cgColor, UIColor.clear.cgColor]
//        gradientLayer.cornerRadius = 12
//        gradientLayer.locations = [0,0.5]
//        layer.addSublayer(gradientLayer)
////        gradientLayer.frame = CGRect(x: 0, y: 16, width: 50, height: 50)
////        resImageView.layer.insertSublayer(gradientLayer, at: 0)
//    }
//    override func layoutSubviews() {
//        gradientLayer.frame = resImageView.frame
//    }
    
    fileprivate func checkToilet() {
        // toilet image width가 서로 달라서 각각 padding을 넣어주어 맞추어줌.
        if toilet == "남녀구분" {
            toiletImageView.image = UIImage(named: "Seperate Toilet_gray")
        }
        else {
            toiletImageView.image = UIImage(named: "Unisex Toilet_gray")

        }
    }
}

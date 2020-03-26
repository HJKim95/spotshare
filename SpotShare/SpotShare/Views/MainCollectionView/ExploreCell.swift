//
//  ExploreCell.swift
//  SpotShare
//
//  Created by 김희중 on 21/07/2019.
//  Copyright © 2019 김희중. All rights reserved.
//
import UIKit

class ExploreCell: UICollectionViewCell, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var mainCollection: MainCollectionCell?
    
    fileprivate let cellid = "cellid"
    
    fileprivate let BackColors = [UIColor.pink, UIColor.wheat, UIColor.lightGreen, UIColor.apricot, UIColor.pink, UIColor.wheat, UIColor.lightGreen, UIColor.apricot]
    fileprivate let exploreBackNames = ["mask1","mask2","mask3","mask4","mask1","mask2","mask3","mask4"]
    fileprivate let exploreNames = ["맛집","카페","피자,버거","치킨","분식","술집","베이커리","기타"]
    
    fileprivate let exploreLabel: UILabel = {
        let lb = UILabel()
        lb.backgroundColor = .white
//        lb.text = "EXPLORE NOW"
        // letter spacing 1
        let attributedString = NSMutableAttributedString(string: "EXPLORE NOW")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(1.0), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.font = UIFont(name: "DMSans-Medium", size: 12)
        lb.textColor = .lightGray
        lb.textAlignment = .left
        return lb
    }()
    
    lazy var innerExploreCollectionview: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.alwaysBounceHorizontal = true
        collectionview.showsHorizontalScrollIndicator = false
        return collectionview
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var exploreLabelConstraint: NSLayoutConstraint?
    var innerCollectionViewConstraint: NSLayoutConstraint?
    
    //total cell size 142
    //24+18+16+99+1
    fileprivate func setupViews() {
        
        innerExploreCollectionview.backgroundColor = .white
        
        innerExploreCollectionview.register(innerExploreCell.self, forCellWithReuseIdentifier: cellid)
        
        addSubview(exploreLabel)
        addSubview(innerExploreCollectionview)
        exploreLabelConstraint = exploreLabel.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 24, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 18).first
        innerCollectionViewConstraint = innerExploreCollectionview.anchor(exploreLabel.bottomAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 16, leftConstant: 24, bottomConstant: 1, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return exploreNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath) as! innerExploreCell
        cell.exploreBackView.backgroundColor = BackColors[indexPath.item]
        cell.exploreBackView.image = UIImage(named: exploreBackNames[indexPath.item])
        cell.exploreImageView.image = UIImage(named: exploreNames[indexPath.item].convertName())
        cell.exploreLabel.text = exploreNames[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 90, height: 99)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var category = exploreNames[indexPath.item]
        if category == "맛집" {
            category = "한식"
        }
        else if category == "술집" {
            category = "소주,맥주"
        }
        goCategory(category: category)
    }
    
    func goCategory(category: String) {
        mainCollection?.goCategory(category: category)
    }
}

class innerExploreCell: UICollectionViewCell {
    
    let exploreBackView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .white
        iv.layer.cornerRadius = 15
        iv.layer.masksToBounds = true
        return iv
    }()
    
    let exploreImageView: UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .clear
        return iv
    }()
    
    let exploreLabel: UILabel = {
        let lb = UILabel()
        lb.textAlignment = .left
        lb.textColor = .black
        lb.backgroundColor = .clear
        lb.font = UIFont(name: "DMSans-Regular", size: 12)
        return lb
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var exploreBackViewConstraint: NSLayoutConstraint?
    var exploreImageViewConstraint: NSLayoutConstraint?
    var exploreLabelConstraint: NSLayoutConstraint?
    
    fileprivate func setupViews() {
        addSubview(exploreBackView)
        addSubview(exploreImageView)
        addSubview(exploreLabel)
        
        exploreBackViewConstraint = exploreBackView.anchor(self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
        exploreImageViewConstraint = exploreImageView.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, topConstant: 15, leftConstant: 13, bottomConstant: 0, rightConstant: 0, widthConstant: 35, heightConstant: 35).first
        exploreLabelConstraint = exploreLabel.anchor(exploreImageView.bottomAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 18, leftConstant: 16, bottomConstant: 15, rightConstant: 13, widthConstant: 0, heightConstant: 16).first
    }
}



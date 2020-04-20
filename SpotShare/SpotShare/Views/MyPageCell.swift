//
//  MyPageCell.swift
//  SpotShare
//
//  Created by 김희중 on 29/04/2019.
//  Copyright © 2019 김희중. All rights reserved.
//

import UIKit

// https://www.youtube.com/watch?v=ePCliV2CsuU

class MyPageCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var maincontroll: MainController?
    
    let headerid = "headerid"
    let cellid = "cellid"

    lazy var ProfileBigcollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    lazy var myPageBar: MyPageBar = {
        let pb = MyPageBar()
        pb.users = self
        pb.translatesAutoresizingMaskIntoConstraints = false
        return pb
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var ProfileBigcollectionViewConstraint: NSLayoutConstraint?
    var myPageBarConstraint: NSLayoutConstraint?
    var ssConstraint: NSLayoutConstraint?
    fileprivate func setupViews() {
        self.backgroundColor = .white
        
        addSubview(ProfileBigcollectionView)

        ProfileBigcollectionViewConstraint = ProfileBigcollectionView.anchor(self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first

        ProfileBigcollectionView.register(ProfileHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerid)
        ProfileBigcollectionView.register(ProfileScrollCell.self, forCellWithReuseIdentifier: cellid)
        
        let pageBarWidth: CGFloat = 210
        addSubview(myPageBar)
        myPageBarConstraint = myPageBar.anchor(nil, left: self.leftAnchor, bottom: self.bottomAnchor, right: nil, topConstant: 0, leftConstant: (frame.width / 2) - (pageBarWidth / 2), bottomConstant: 20, rightConstant: 0, widthConstant: pageBarWidth, heightConstant: 36).first
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerid, for: indexPath) as! ProfileHeaderCell
        header.delegate = self
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath) as! ProfileScrollCell
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 54)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height - 90)
    }
    
    func scrollToMenuIndex(menuIndex: Int) {
        let indexPath = IndexPath(item: 0, section: 0)
        let cell = ProfileBigcollectionView.cellForItem(at: indexPath) as! ProfileScrollCell
        cell.scrollToMenuIndex(menuIndex: menuIndex)
    }
    
    
    
    // tabbar icon 눌르면 위로 올라가게
    func goTopCollectionView() {
        let indexPath = IndexPath(item: 0, section: 0)
//        let cell = ScrollcollectionView.cellForItem(at: indexPath) as? MyFavoriteCell
        // myPage에 있는 다른 cell들도 올라가게 하기.
//        cell?.goTopCollectionView()
    }
    
    @objc fileprivate func goEditProfile() {
        maincontroll?.goEditProfile()
    }
    @objc fileprivate func goSettings() {
        maincontroll?.goSettings()
    }
    
}

class ProfileHeaderCell: UICollectionViewCell {
    
    weak var delegate: MyPageCell?
    
    let myView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var editButton: UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor.rgb(red: 76, green: 76, blue: 76)
        lb.text = "EDIT PROFILE"
        lb.font = UIFont(name: "DMSans-Bold", size: 12)
        lb.textAlignment = .center
        lb.layer.borderWidth = 2
        lb.layer.borderColor = UIColor.rgb(red: 76, green: 76, blue: 76).cgColor
        lb.layer.masksToBounds = true
        lb.layer.cornerRadius = 18
        lb.isUserInteractionEnabled = true
        lb.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goEditProfile)))
        return lb
    }()
    
    lazy var settingButton: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .clear
        iv.image = UIImage(named: "settings")
        iv.contentMode = .scaleAspectFit
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goSettings)))
        return iv
    }()
    
    let nameLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor.rgb(red: 34, green: 34, blue: 34)
        lb.text = "Jane Doe"
        lb.numberOfLines = 0
        lb.font = UIFont(name: "DMSans-Medium", size: 28)
        lb.textAlignment = .left
        return lb
    }()
    
    let reviewLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .gray
        lb.text = "24 REVIEWS"
        lb.font = UIFont(name: "DMSans-Medium", size: 12)
        lb.textAlignment = .left
        return lb
    }()
    
    let favoriteLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .gray
        lb.text = "102 FAVORITES"
        lb.font = UIFont(name: "DMSans-Medium", size: 12)
        lb.textAlignment = .left
        return lb
    }()
    
    let userImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .gray
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "imsi_user")
        iv.layer.cornerRadius = 10
        iv.layer.masksToBounds = true
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var myViewConstraint: NSLayoutConstraint?
    var editButtonConstraint: NSLayoutConstraint?
    var settingButtonConstraint: NSLayoutConstraint?
    var nameLabelConstraint: NSLayoutConstraint?
    var reviewLabelConstraint: NSLayoutConstraint?
    var favoriteLabelConstraint: NSLayoutConstraint?
    var userImageViewConstraint: NSLayoutConstraint?
    
    
    fileprivate func setupLayouts() {
        backgroundColor = .white
        addSubview(myView)
        myView.addSubview(editButton)
        myView.addSubview(settingButton)
        myView.addSubview(nameLabel)
//        myView.addSubview(reviewLabel)
//        myView.addSubview(favoriteLabel)
//        myView.addSubview(userImageView)
        
        myViewConstraint = myView.anchor(self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
        settingButtonConstraint = settingButton.anchor(myView.topAnchor, left: nil, bottom: nil, right: myView.rightAnchor, topConstant: 22, leftConstant: 0, bottomConstant: 0, rightConstant: 24, widthConstant: 24, heightConstant: 24).first
        editButtonConstraint = editButton.anchor(myView.topAnchor, left: nil, bottom: nil, right: settingButton.leftAnchor, topConstant: 16, leftConstant: 0, bottomConstant: 0, rightConstant: 26, widthConstant: 130, heightConstant: 36).first
//        userImageViewConstraint = userImageView.anchor(myView.topAnchor, left: nil, bottom: nil, right: myView.rightAnchor, topConstant: 76, leftConstant: 0, bottomConstant: 0, rightConstant: -10, widthConstant: 190, heightConstant: 120).first
        nameLabelConstraint = nameLabel.anchor(myView.topAnchor, left: myView.leftAnchor, bottom: nil, right: editButton.leftAnchor, topConstant: 16, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 38).first
//        reviewLabelConstraint = reviewLabel.anchor(nameLabel.bottomAnchor, left: myView.leftAnchor, bottom: nil, right: userImageView.leftAnchor, topConstant: 10, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 18).first
//        favoriteLabelConstraint = favoriteLabel.anchor(reviewLabel.bottomAnchor, left: myView.leftAnchor, bottom: nil, right: userImageView.leftAnchor, topConstant: 4, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 18).first
//
    }
    
    
    
    @objc fileprivate func goEditProfile() {
           delegate?.goEditProfile()
       }
       @objc fileprivate func goSettings() {
           delegate?.goSettings()
       }
}

class ProfileScrollCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    weak var delegate: MyPageCell?
    
    let MyFavoriteid = "favoriteid"
    let MyReviewid = "reviewid"
    let MyViewid = "viewid"

    
    lazy var ScrollcollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var myPageBarConstraint: NSLayoutConstraint?
    var viewwwwConstraint: NSLayoutConstraint?
    var ScrollCollectionViewConstraint: NSLayoutConstraint?
    
    fileprivate func setupLayouts() {
        backgroundColor = .white
    
        ScrollcollectionView.register(MyFavoriteCell.self, forCellWithReuseIdentifier: MyFavoriteid)
        ScrollcollectionView.register(MyReviewCell.self, forCellWithReuseIdentifier: MyReviewid)
        ScrollcollectionView.register(MyLastViewCell.self, forCellWithReuseIdentifier: MyViewid)
        
        
        addSubview(ScrollcollectionView)
        ScrollCollectionViewConstraint = ScrollcollectionView.anchor(self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyFavoriteid, for: indexPath) as! MyFavoriteCell
//            cell.mypagecell = self
            return cell
        }

        if indexPath.item == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyReviewid, for: indexPath) as! MyReviewCell
//            cell.mypagecell = self
            return cell
        }

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyViewid, for: indexPath) as! MyLastViewCell
//        cell.mypagecell = self
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height - 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    

    func scrollToMenuIndex(menuIndex: Int) {
        let indexPath = NSIndexPath(item: menuIndex, section: 0)
        ScrollcollectionView.scrollToItem(at: indexPath as IndexPath, at: [], animated: false)
    }

}

//
//  SettingController.swift
//  SpotShare
//
//  Created by 김희중 on 30/12/2019.
//  Copyright © 2019 김희중. All rights reserved.
//

import UIKit

class SettingController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    deinit {
        print("no retain cycle in SettingController")
    }
    
    
    let cellid = "cellid"
    let cellid2 = "cellid2"
    
    lazy var backImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "back")
        iv.contentMode = .scaleAspectFit
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goBack)))
        return iv
    }()
    
    let settingTitle: UILabel = {
        let lb = UILabel()
        // letter spacing -0.3
        let attributedString = NSMutableAttributedString(string: "Settings")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(-0.3), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.font = UIFont(name: "DMSans-Medium", size: 28)
        lb.textAlignment = .left
        lb.numberOfLines = 0
        lb.textColor = .black
        return lb
    }()
    
    let settingName: UILabel = {
        let lb = UILabel()
        // letter spacing -0.1
        let attributedString = NSMutableAttributedString(string: "Jane Doe")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(-0.1), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.font = UIFont(name: "DMSans-Regular", size: 16)
        lb.textAlignment = .left
        lb.numberOfLines = 0
        lb.textColor = .lightGray
        return lb
    }()
    
    lazy var innerSettingCollectionview: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 32
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.alwaysBounceVertical = false
        collectionview.showsVerticalScrollIndicator = false
        collectionview.backgroundColor = .white
        return collectionview
    }()
    
    var backImageViewConstraint: NSLayoutConstraint?
    var settingTitleConstraint: NSLayoutConstraint?
    var settingNameConstraint: NSLayoutConstraint?
    var innerSettingCollectionviewConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        // swipe로 back 구현하려면 두개 다 써줘야함.
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        view.addSubview(backImageView)
        view.addSubview(settingTitle)
        view.addSubview(settingName)
        view.addSubview(innerSettingCollectionview)
        
        if #available(iOS 11.0, *) {
            backImageViewConstraint = backImageView.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 16, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 24, heightConstant: 24).first
            settingTitleConstraint = settingTitle.anchor(backImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 38).first
            settingNameConstraint = settingName.anchor(settingTitle.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 4, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 26).first
            innerSettingCollectionviewConstraint = innerSettingCollectionview.anchor(settingName.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, topConstant: 24, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
            
        }
        else {
            backImageViewConstraint = backImageView.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 16, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 24, heightConstant: 24).first
            settingTitleConstraint = settingTitle.anchor(backImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 38).first
            settingNameConstraint = settingName.anchor(settingTitle.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 4, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 26).first
            innerSettingCollectionviewConstraint = innerSettingCollectionview.anchor(settingName.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 24, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
        }
        
        innerSettingCollectionview.register(innerSettingGeneralCell.self, forCellWithReuseIdentifier: cellid)
        innerSettingCollectionview.register(innerSettingPermissionCell.self, forCellWithReuseIdentifier: cellid2)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath) as! innerSettingGeneralCell
            return cell
        }
            
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid2, for: indexPath) as! innerSettingPermissionCell
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 {
            // 28 + 24 + 26 + 16 + 26
            return CGSize(width: collectionView.frame.width, height: 120)
        }
        else {
            // 28 + 24 + 26 + 16 + 26 + 16 +26 + 32 + 26 = 220
            return CGSize(width: collectionView.frame.width, height: 220)
        }
        
    }
    
    @objc fileprivate func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

class innerSettingGeneralCell: UICollectionViewCell {
    
    let cellid = "cellid"
    
    let generalTitleLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "DMSans-Medium", size: 20)
        // letter spacing -0.3
        let attributedString = NSMutableAttributedString(string: "General")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(-0.3), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.textAlignment = .left
        lb.numberOfLines = 0
        lb.textColor = .black
        return lb
    }()
    
    let inviteLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "DMSans-Regular", size: 16)
        // letter spacing -0.1
        let attributedString = NSMutableAttributedString(string: "Invite SNS Friends")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(-0.1), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.textAlignment = .left
        lb.numberOfLines = 0
        lb.textColor = .darkGray
        return lb
    }()
    
    let rightArrowImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "goRight")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let referanceLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "DMSans-Regular", size: 16)
        // letter spacing -0.1
        let attributedString = NSMutableAttributedString(string: "Referance")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(-0.1), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.textAlignment = .left
        lb.numberOfLines = 0
        lb.textColor = .darkGray
        return lb
    }()
    
    let rightArrowImageView2: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "goRight")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var generalTitleLabelConstraint: NSLayoutConstraint?
    var inviteLabelConstratint: NSLayoutConstraint?
    var rightArrowImageViewConstraint: NSLayoutConstraint?
    var referanceLabelConstratint: NSLayoutConstraint?
    var rightArrowImageView2Constraint: NSLayoutConstraint?
    
    fileprivate func setupLayout() {
        backgroundColor = .white
        addSubview(generalTitleLabel)
        addSubview(inviteLabel)
        addSubview(rightArrowImageView)
        addSubview(referanceLabel)
        addSubview(rightArrowImageView2)
        
        generalTitleLabelConstraint = generalTitleLabel.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 28).first
        rightArrowImageViewConstraint = rightArrowImageView.anchor(generalTitleLabel.bottomAnchor, left: nil, bottom: nil, right: self.rightAnchor, topConstant: 29, leftConstant: 0, bottomConstant: 0, rightConstant: 24, widthConstant: 16, heightConstant: 16).first
        inviteLabelConstratint = inviteLabel.anchor(generalTitleLabel.bottomAnchor, left: self.leftAnchor, bottom: nil, right: rightArrowImageView.leftAnchor, topConstant: 24, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 26).first
        rightArrowImageView2Constraint = rightArrowImageView2.anchor(inviteLabel.bottomAnchor, left: nil, bottom: nil, right: self.rightAnchor, topConstant: 21, leftConstant: 0, bottomConstant: 0, rightConstant: 24, widthConstant: 16, heightConstant: 16).first
        referanceLabelConstratint = referanceLabel.anchor(inviteLabel.bottomAnchor, left: self.leftAnchor, bottom: nil, right: rightArrowImageView2.leftAnchor, topConstant: 16, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 26).first
        
    }
    
}


class innerSettingPermissionCell: UICollectionViewCell {
    
    let cellid = "cellid"
    
    let permissionTitleLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "DMSans-Medium", size: 20)
        // letter spacing -0.3
        let attributedString = NSMutableAttributedString(string: "Data and Permissions")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(-0.3), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.textAlignment = .left
        lb.numberOfLines = 0
        lb.textColor = .black
        return lb
    }()
    
    let noticeLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "DMSans-Regular", size: 16)
        // letter spacing -0.1
        let attributedString = NSMutableAttributedString(string: "Notice")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(-0.1), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.textAlignment = .left
        lb.numberOfLines = 0
        lb.textColor = .darkGray
        return lb
    }()
    
    let rightArrowImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "goRight")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let contactLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "DMSans-Regular", size: 16)
        // letter spacing -0.1
        let attributedString = NSMutableAttributedString(string: "Contact Us")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(-0.1), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.textAlignment = .left
        lb.numberOfLines = 0
        lb.textColor = .darkGray
        return lb
    }()
    
    let rightArrowImageView2: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "goRight")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let versionLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "DMSans-Regular", size: 16)
        // letter spacing -0.1
        let attributedString = NSMutableAttributedString(string: "Version")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(-0.1), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.textAlignment = .left
        lb.numberOfLines = 0
        lb.textColor = .darkGray
        return lb
    }()
    
    let versionPointLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "DMSans-Regular", size: 16)
        // letter spacing -0.1
        let attributedString = NSMutableAttributedString(string: "2.2")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(-0.1), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.textAlignment = .center
        lb.numberOfLines = 0
        lb.textColor = .gray
        return lb
    }()
    
    let logoutLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "DMSans-Bold", size: 16)
        // letter spacing -0.1
        let attributedString = NSMutableAttributedString(string: "Log out")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(-0.1), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.textAlignment = .left
        lb.numberOfLines = 0
        lb.textColor = UIColor.mainColor
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var permissionTitleLabelConstraint: NSLayoutConstraint?
    var noticeLabelConstraint: NSLayoutConstraint?
    var rightArrowImageViewConstraint: NSLayoutConstraint?
    var contactLabelConstratint: NSLayoutConstraint?
    var rightArrowImageView2Constraint: NSLayoutConstraint?
    var versionLabelConstratint: NSLayoutConstraint?
    var versionPointLabelConstraint: NSLayoutConstraint?
    var logoutLabelConstratint: NSLayoutConstraint?
    
    fileprivate func setupLayout() {
        backgroundColor = .white
        addSubview(permissionTitleLabel)
        addSubview(noticeLabel)
        addSubview(rightArrowImageView)
        addSubview(contactLabel)
        addSubview(rightArrowImageView2)
        addSubview(versionLabel)
        addSubview(versionPointLabel)
        addSubview(logoutLabel)
        
        permissionTitleLabelConstraint = permissionTitleLabel.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 28).first
        rightArrowImageViewConstraint = rightArrowImageView.anchor(permissionTitleLabel.bottomAnchor, left: nil, bottom: nil, right: self.rightAnchor, topConstant: 29, leftConstant: 0, bottomConstant: 0, rightConstant: 24, widthConstant: 16, heightConstant: 16).first
        noticeLabelConstraint = noticeLabel.anchor(permissionTitleLabel.bottomAnchor, left: self.leftAnchor, bottom: nil, right: rightArrowImageView.leftAnchor, topConstant: 24, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 26).first
        rightArrowImageView2Constraint = rightArrowImageView2.anchor(noticeLabel.bottomAnchor, left: nil, bottom: nil, right: self.rightAnchor, topConstant: 21, leftConstant: 0, bottomConstant: 0, rightConstant: 24, widthConstant: 16, heightConstant: 16).first
        contactLabelConstratint = contactLabel.anchor(noticeLabel.bottomAnchor, left: self.leftAnchor, bottom: nil, right: rightArrowImageView2.leftAnchor, topConstant: 16, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 26).first
        versionPointLabelConstraint = versionPointLabel.anchor(contactLabel.bottomAnchor, left: nil, bottom: nil, right: self.rightAnchor, topConstant: 18, leftConstant: 0, bottomConstant: 0, rightConstant: 24, widthConstant: 22, heightConstant: 26).first
        versionLabelConstratint = versionLabel.anchor(contactLabel.bottomAnchor, left: self.leftAnchor, bottom: nil, right: versionPointLabel.leftAnchor, topConstant: 16, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 26).first
        logoutLabelConstratint = logoutLabel.anchor(versionLabel.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 32, leftConstant: 0, bottomConstant: 0, rightConstant: 100, widthConstant: 0, heightConstant: 26).first
        
    }
    
}




//
//  ImproveListingViewController.swift
//  SpotShare
//
//  Created by 김희중 on 15/01/2020.
//  Copyright © 2020 김희중. All rights reserved.
//

import UIKit

class ImproveListingViewController: BottomPopupViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    deinit {
        print("no retain cycle in ImproveListingViewController")
    }
    
    
    fileprivate let cellid = "cellid"
    fileprivate let cellid2 = "cellid2"
    fileprivate let cellid3 = "cellid3"
    
    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?
    
    // Bottom popup attribute methods
    // You can override the desired method to change appearance
    
    override func getPopupHeight() -> CGFloat {
        return height ?? CGFloat(300)
    }
    
    override func getPopupTopCornerRadius() -> CGFloat {
        return topCornerRadius ?? CGFloat(10)
    }
    
    override func getPopupPresentDuration() -> Double {
        return presentDuration ?? 1.0
    }
    
    override func getPopupDismissDuration() -> Double {
        return dismissDuration ?? 1.0
    }
    
    override func shouldPopupDismissInteractivelty() -> Bool {
        return shouldDismissInteractivelty ?? true
    }
    
    let thumbView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 204, green: 204, blue: 204)
        view.layer.cornerRadius = 2.5
        view.layer.masksToBounds = true
        return view
    }()
    
    let improveTitleLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor.gray
        lb.font = UIFont(name: "DMSans-Medium", size: 14)
        // letter spacing 1.17
        let attributedString = NSMutableAttributedString(string: "IMPROVE THIS LISTING")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(1.17), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.textAlignment = .center
        return lb
    }()
    
    let dividerLine: UIView = {
        let viewview = UIView()
        viewview.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        return viewview
    }()
    
    lazy var innerImproveCollectionview: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 24
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.alwaysBounceVertical = false
        collectionview.showsVerticalScrollIndicator = false
        collectionview.backgroundColor = .white
        return collectionview
    }()
    
    let improveListArr = ["Place is permanently closed", "Menu changed", "Wrong information", "Too much advertising"]
    
    
    var thumbViewConstraint: NSLayoutConstraint?
    var improveTitleLabelConstraint: NSLayoutConstraint?
    var dividerLineConstraint: NSLayoutConstraint?
    var innerImproveCollectionviewConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(thumbView)
        view.addSubview(improveTitleLabel)
        view.addSubview(dividerLine)
        view.addSubview(innerImproveCollectionview)

        thumbViewConstraint = thumbView.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 12, leftConstant: (view.frame.width / 2) - 30, bottomConstant: 0, rightConstant: 0, widthConstant: 60, heightConstant: 5).first
        improveTitleLabelConstraint = improveTitleLabel.anchor(thumbView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 18).first
        dividerLineConstraint = dividerLine.anchor(improveTitleLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 15.5, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0.5).first
        innerImproveCollectionviewConstraint = innerImproveCollectionview.anchor(dividerLine.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 23.5, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 0, heightConstant: 513.5).first
        // 447.5 + 56 + 10 = 513.5
        
        innerImproveCollectionview.register(ImproveListCell.self, forCellWithReuseIdentifier: cellid)
        innerImproveCollectionview.register(ImproveTextCell.self, forCellWithReuseIdentifier: cellid2)
        innerImproveCollectionview.register(ImproveReportCell.self, forCellWithReuseIdentifier: cellid3)
        
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item < 4 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath) as! ImproveListCell
            // letter spacing -0.1
            let attributedString = NSMutableAttributedString(string: improveListArr[indexPath.item])
            attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(-0.1), range: NSRange(location: 0, length: attributedString.length))
            cell.improveLabel.attributedText = attributedString
            return cell
        }
        
        else if indexPath.item == 4 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid2, for: indexPath) as! ImproveTextCell
            return cell
        }
        
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid3, for: indexPath) as! ImproveReportCell
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item < 4 {
            return CGSize(width: collectionView.frame.width, height: 26)
        }
        else if indexPath.item == 4 {
            return CGSize(width: collectionView.frame.width, height: 166)
        }
        else {
            return CGSize(width: collectionView.frame.width, height: 66)
        }
    }
    
}

class ImproveListCell: UICollectionViewCell {
    
    let improveLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor.darkGray
        lb.font = UIFont(name: "DMSans-Regular", size: 16)
        lb.textAlignment = .left
        lb.numberOfLines = 0
        return lb
    }()
    
    let checkImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "checkbox")
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .white
        return iv
    }()
    
    override var isHighlighted: Bool {
        didSet {
            checkImageView.image  = isHighlighted ? UIImage(named: "checked") : UIImage(named: "checkbox")
        }
    }
    
    override var isSelected: Bool {
        didSet {
            checkImageView.image  = isSelected ? UIImage(named: "checked") : UIImage(named: "checkbox")
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var improveLabelConstraint: NSLayoutConstraint?
    var checkImageViewConstraint: NSLayoutConstraint?
    
    fileprivate func setupLayouts() {
        backgroundColor = .white
        
        addSubview(improveLabel)
        addSubview(checkImageView)
        
        checkImageViewConstraint = checkImageView.anchor(self.topAnchor, left: nil, bottom: nil, right: self.rightAnchor, topConstant: 1, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 24, heightConstant: 24).first
        improveLabelConstraint = improveLabel.anchor(self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: checkImageView.leftAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 30, widthConstant: 0, heightConstant: 0).first
    }
}

class ImproveTextCell: UICollectionViewCell {
    
    let improvePlaceholder: UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor.gray
        lb.font = UIFont(name: "DMSans-Regular", size: 14)
        // letter spacing -0.1
        let attributedString = NSMutableAttributedString(string: "Need changes? Write here…")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(-0.1), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.textAlignment = .left
        lb.numberOfLines = 0
        return lb
    }()
    
    let textBox: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.layer.borderColor = UIColor.rgb(red: 228, green: 228, blue: 228).cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var improvePlaceholderConstraint: NSLayoutConstraint?
    var textBoxConstraint: NSLayoutConstraint?
    
    fileprivate func setupLayouts() {
        backgroundColor = .white
        
        addSubview(improvePlaceholder)
        addSubview(textBox)
        
        textBoxConstraint = textBox.anchor(self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 8, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
        improvePlaceholderConstraint = improvePlaceholder.anchor(textBox.topAnchor, left: textBox.leftAnchor, bottom: nil, right: textBox.rightAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 22).first
        
    }
}

class ImproveReportCell: UICollectionViewCell {
    
    let improveReportLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor.white
        lb.font = UIFont(name: "DMSans-Bold", size: 14)
        // letter spacing 1.0
        let attributedString = NSMutableAttributedString(string: "REPORT")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(1.0), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.textAlignment = .center
        lb.numberOfLines = 0
        lb.backgroundColor = .mainColor
        lb.layer.cornerRadius = 10
        lb.layer.masksToBounds = true
        return lb
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var improveReportLabelConstraint: NSLayoutConstraint?
    
    fileprivate func setupLayouts() {
        backgroundColor = .white
        
        addSubview(improveReportLabel)

        improveReportLabelConstraint = improveReportLabel.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 56).first
        
    }
}

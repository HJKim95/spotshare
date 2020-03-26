//
//  WriteReviewController.swift
//  SpotShare
//
//  Created by 김희중 on 20/01/2020.
//  Copyright © 2020 김희중. All rights reserved.
//

import UIKit
import Cosmos
// https://github.com/ergunemr/BottomPopup
// https://github.com/evgenyneu/Cosmos

class WriteReviewController: BottomPopupViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    deinit {
        print("no retain cycle in WriteReivewController")
    }
    
    fileprivate let cellid = "cellid"
    fileprivate let cellid2 = "cellid2"
    fileprivate let cellid3 = "cellid3"
    fileprivate let cellid4 = "cellid4"
    fileprivate let cellid5 = "celli5"
    
    
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
    
    let shareLabel: UILabel = {
        let lb = UILabel()
        // letter spacing 1.17
        let attributedString = NSMutableAttributedString(string: "SHARE YOUR REVIEW")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(1.17), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.font = UIFont(name: "DMSans-Medium", size: 14)
        lb.textColor = .lightGray
        lb.textAlignment = .center
        lb.numberOfLines = 0
        return lb
    }()
    
    let dividerLine: UIView = {
        let viewview = UIView()
        viewview.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        return viewview
    }()
    
    
    
    let centerLine: UIView = {
        let viewview = UIView()
        viewview.backgroundColor = UIColor.rgb(red: 232, green: 232, blue: 232)
        return viewview
    }()
    
    let firstCircle: UIView = {
        let viewview = UIView()
        viewview.backgroundColor = UIColor.mainColor
        viewview.layer.cornerRadius = 24
        viewview.layer.masksToBounds = true
        return viewview
    }()
    
    let firstImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "where")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let secondCircle: UIView = {
        let viewview = UIView()
        viewview.backgroundColor = UIColor.rgb(red: 232, green: 232, blue: 232)
        viewview.layer.cornerRadius = 24
        viewview.layer.masksToBounds = true
        return viewview
    }()
    
    let secondImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "rate")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let thirdCircle: UIView = {
        let viewview = UIView()
        viewview.backgroundColor = UIColor.rgb(red: 232, green: 232, blue: 232)
        viewview.layer.cornerRadius = 24
        viewview.layer.masksToBounds = true
        return viewview
    }()
    
    let thirdImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "photo")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let fourthCircle: UIView = {
        let viewview = UIView()
        viewview.backgroundColor = UIColor.rgb(red: 232, green: 232, blue: 232)
        viewview.layer.cornerRadius = 24
        viewview.layer.masksToBounds = true
        return viewview
    }()
    
    let fourthImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "write")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    lazy var reviewCollectionview: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.alwaysBounceHorizontal = true
        collectionview.showsVerticalScrollIndicator = false
        collectionview.backgroundColor = .white
        collectionview.isPagingEnabled = true
        collectionview.isScrollEnabled = false
        return collectionview
    }()
    
    
    var thumbViewConstraint: NSLayoutConstraint?
    var shareLabelConstraint: NSLayoutConstraint?
    var dividerLineConstraint: NSLayoutConstraint?
    
    var centerLineConstraint: NSLayoutConstraint?
    var firstCircleConstraint: NSLayoutConstraint?
    var secondCircleConstraint: NSLayoutConstraint?
    var thirdCircleConstraint: NSLayoutConstraint?
    var fourthCircleConstraint: NSLayoutConstraint?
    var firstImageViewConstraint: NSLayoutConstraint?
    var secondImageViewConstraint: NSLayoutConstraint?
    var thirdImageViewConstraint: NSLayoutConstraint?
    var fourthImageViewConstraint: NSLayoutConstraint?
    
    var reviewCollectionviewConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(thumbView)
        view.addSubview(shareLabel)
        view.addSubview(dividerLine)
        
        view.addSubview(centerLine)
        view.addSubview(firstCircle)
        view.addSubview(secondCircle)
        view.addSubview(thirdCircle)
        view.addSubview(fourthCircle)
        view.addSubview(firstImageView)
        view.addSubview(secondImageView)
        view.addSubview(thirdImageView)
        view.addSubview(fourthImageView)
        
        view.addSubview(reviewCollectionview)
        
        thumbViewConstraint = thumbView.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 12, leftConstant: (view.frame.width / 2) - 40, bottomConstant: 0, rightConstant: 0, widthConstant: 80, heightConstant: 5).first
        shareLabelConstraint = shareLabel.anchor(thumbView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 18).first
        dividerLineConstraint = dividerLine.anchor(shareLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 15.5, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0.5).first
        
        centerLineConstraint = centerLine.anchor(dividerLine.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 47.5, leftConstant: (view.frame.width / 2) - 96, bottomConstant: 0, rightConstant: 0, widthConstant: 192, heightConstant: 2).first
        firstCircleConstraint = firstCircle.anchor(dividerLine.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 23.5, leftConstant: (view.frame.width / 2) - 120, bottomConstant: 0, rightConstant: 0, widthConstant: 48, heightConstant: 48).first
        firstImageViewConstraint = firstImageView.anchor(firstCircle.topAnchor, left: firstCircle.leftAnchor, bottom: nil, right: nil, topConstant: 12.5, leftConstant: 12.5, bottomConstant: 0, rightConstant: 0, widthConstant: 23, heightConstant: 23).first
        secondCircleConstraint = secondCircle.anchor(firstCircle.topAnchor, left: firstCircle.rightAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 16, bottomConstant: 0, rightConstant: 0, widthConstant: 48, heightConstant: 48).first
        secondImageViewConstraint = secondImageView.anchor(secondCircle.topAnchor, left: secondCircle.leftAnchor, bottom: nil, right: nil, topConstant: 12, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: 24, heightConstant: 24).first
        thirdCircleConstraint = thirdCircle.anchor(firstCircle.topAnchor, left: secondCircle.rightAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 16, bottomConstant: 0, rightConstant: 0, widthConstant: 48, heightConstant: 48).first
        thirdImageViewConstraint = thirdImageView.anchor(thirdCircle.topAnchor, left: thirdCircle.leftAnchor, bottom: nil, right: nil, topConstant: 12, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: 24, heightConstant: 24).first
        fourthCircleConstraint = fourthCircle.anchor(firstCircle.topAnchor, left: thirdCircle.rightAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 16, bottomConstant: 0, rightConstant: 0, widthConstant: 48, heightConstant: 48).first
        fourthImageViewConstraint = fourthImageView.anchor(fourthCircle.topAnchor, left: fourthCircle.leftAnchor, bottom: nil, right: nil, topConstant: 12, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: 24, heightConstant: 24).first

        reviewCollectionviewConstraint = reviewCollectionview.anchor(fourthCircle.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 32, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
        
        reviewCollectionview.register(firstWriteReviewCell.self, forCellWithReuseIdentifier: cellid)
        reviewCollectionview.register(secondWriteReviewCell.self, forCellWithReuseIdentifier: cellid2)
        reviewCollectionview.register(thirdWriteReviewCell.self, forCellWithReuseIdentifier: cellid3)
        reviewCollectionview.register(fourthWriteReviewCell.self, forCellWithReuseIdentifier: cellid4)
        reviewCollectionview.register(LastWriteReviewCell.self, forCellWithReuseIdentifier: cellid5)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath) as! firstWriteReviewCell
            cell.delegate = self
            return cell
        }
        else if indexPath.item == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid2, for: indexPath) as! secondWriteReviewCell
            cell.delegate = self
            return cell
        }
        else if indexPath.item == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid3, for: indexPath) as! thirdWriteReviewCell
            cell.delegate = self
            return cell
        }
        else if indexPath.item == 3 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid4, for: indexPath) as! fourthWriteReviewCell
            cell.delegate = self
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid5, for: indexPath) as! LastWriteReviewCell
            cell.delegate = self
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func goNextCell(index: Int) {
        let indexPath = IndexPath(item: index + 1, section: 0)
        reviewCollectionview.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        changeCircleBackground(index: index)
    }
    
    fileprivate func changeCircleBackground(index: Int) {
        if index == 0 {
            self.secondCircle.backgroundColor = .wheat
        }
        else if index == 1 {
            self.thirdCircle.backgroundColor = .lightGreen
        }
        
        else if index == 2 {
            self.fourthCircle.backgroundColor = .apricot
        }
    }
    
    func goFinish() {
        centerLine.alpha = 0
        firstCircle.alpha = 0
        firstImageView.alpha = 0
        secondCircle.alpha = 0
        secondImageView.alpha = 0
        thirdCircle.alpha = 0
        thirdImageView.alpha = 0
        fourthCircle.alpha = 0
        fourthImageView.alpha = 0
    }
    
    func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

class firstWriteReviewCell: UICollectionViewCell, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var index: Int = 0
    weak var delegate: WriteReviewController?
    
    fileprivate let cellid = "cellid"
    
    let titleLabel: UILabel = {
        let lb = UILabel()
        // letter spacing -0.3
        let attributedString = NSMutableAttributedString(string: "Where to review?")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(-0.3), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.font = UIFont(name: "DMSans-Medium", size: 20)
        lb.textColor = .black
        lb.textAlignment = .center
        lb.numberOfLines = 0
        return lb
    }()
    
    let subtitleLabel: UILabel = {
        let lb = UILabel()
        // letter spacing -0.1
        let attributedString = NSMutableAttributedString(string: "Lorem ipsum dolor sit amet, consectetur adipiscing elit duis eu.")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(-0.1), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.font = UIFont(name: "DMSans-Regular", size: 16)
        lb.textColor = .lightGray
        lb.textAlignment = .center
        lb.numberOfLines = 0
        return lb
    }()
    
    lazy var searchView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.rgb(red: 232, green: 232, blue: 232)
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickSearch)))
        return view
    }()
    
    let searchImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "searchLine")
        iv.image = iv.image?.withRenderingMode(.alwaysTemplate)
        iv.contentMode = .scaleAspectFit
        iv.tintColor =  UIColor.rgb(red: 153, green: 153, blue: 153)
        return iv
    }()
    
    let searchLabel: UILabel = {
        let lb = UILabel()
        // letter spacing -0.1
        let attributedString = NSMutableAttributedString(string: "Search a place to review...")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(-0.1), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.font = UIFont(name: "DMSans-Regular", size: 14)
        lb.textColor = UIColor.rgb(red: 153, green: 153, blue: 153)
        lb.textAlignment = .left
        lb.numberOfLines = 0
        return lb
    }()
    
    lazy var nextLabel: UILabel = {
        let lb = UILabel()
        // letter spacing 1.0
        let attributedString = NSMutableAttributedString(string: "NEXT")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(1.0), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.font = UIFont(name: "DMSans-Bold", size: 14)
        lb.textColor = .white
        lb.backgroundColor = .mainColor
        lb.textAlignment = .center
        lb.numberOfLines = 0
        lb.layer.cornerRadius = 12
        lb.layer.masksToBounds = true
        lb.alpha = 0.5
        lb.isUserInteractionEnabled = true
        lb.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goNextCell)))
        return lb
    }()
    
    let backWhiteView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.alpha = 0
        return view
    }()
    
    let searchView2: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.rgb(red: 232, green: 232, blue: 232)
        view.alpha = 0
        return view
    }()
    
    lazy var backImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "back")
        iv.contentMode = .scaleAspectFit
        iv.alpha = 0
        iv.isUserInteractionEnabled = true
        // 우선 임시로 이렇게하지만 추후에 다르게 해주어야함.
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(restClicked)))
        return iv
    }()
    
    let searchLabel2: UILabel = {
        let lb = UILabel()
        // letter spacing -0.1
        let attributedString = NSMutableAttributedString(string: "Cool Restaurant")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(-0.1), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.font = UIFont(name: "DMSans-Regular", size: 14)
        lb.textColor = .black
        lb.textAlignment = .left
        lb.numberOfLines = 0
        lb.alpha = 0
        return lb
    }()
    
    lazy var innerWriteCollectionview: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.alwaysBounceVertical = true
        collectionview.showsVerticalScrollIndicator = true
        collectionview.backgroundColor = .white
        collectionview.alpha = 0
        return collectionview
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var titleLabelConstraint: NSLayoutConstraint?
    var subtitleLabelConstraint: NSLayoutConstraint?
    var searchViewConstraint: NSLayoutConstraint?
    var searchImageViewConstraint: NSLayoutConstraint?
    var searchLabelConstraint: NSLayoutConstraint?
    var nextLabelConstraint: NSLayoutConstraint?
    
    var backWhiteViewConstraint: NSLayoutConstraint?
    var searchView2Constraint: NSLayoutConstraint?
    var backImageViewConstraint: NSLayoutConstraint?
    var searchLabel2Constraint: NSLayoutConstraint?
    var innerWriteCollectionviewConstraint: NSLayoutConstraint?
    
    fileprivate func setupLayouts() {
        backgroundColor = .white
        
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(searchView)
        addSubview(searchImageView)
        addSubview(searchLabel)
        addSubview(nextLabel)
        
        addSubview(backWhiteView)
        addSubview(searchView2)
        addSubview(backImageView)
        addSubview(searchLabel2)
        addSubview(innerWriteCollectionview)
        
        titleLabelConstraint = titleLabel.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 28).first
        subtitleLabelConstraint = subtitleLabel.anchor(titleLabel.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 8, leftConstant: 48, bottomConstant: 0, rightConstant: 48, widthConstant: 0, heightConstant: 56).first
        searchViewConstraint = searchView.anchor(subtitleLabel.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 24, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 0, heightConstant: 48).first
        searchImageViewConstraint = searchImageView.anchor(searchView.topAnchor, left: searchView.leftAnchor, bottom: nil, right: nil, topConstant: 12, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: 24, heightConstant: 24).first
        searchLabelConstraint = searchLabel.anchor(searchView.topAnchor, left: searchImageView.rightAnchor, bottom: nil, right: searchView.rightAnchor, topConstant: 14, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 20).first
        nextLabelConstraint = nextLabel.anchor(searchView.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 36, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 0, heightConstant: 56).first
        
        backWhiteViewConstraint = backWhiteView.anchor(self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
        searchView2Constraint = searchView2.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 0, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 0, heightConstant: 48).first
        backImageViewConstraint = backImageView.anchor(searchView2.topAnchor, left: searchView2.leftAnchor, bottom: nil, right: nil, topConstant: 12, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: 24, heightConstant: 24).first
        searchLabel2Constraint = searchLabel2.anchor(searchView2.topAnchor, left: backImageView.rightAnchor, bottom: nil, right: nil, topConstant: 14, leftConstant: 9, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 20).first
        innerWriteCollectionviewConstraint = innerWriteCollectionview.anchor(searchView2.bottomAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 24, leftConstant: 24, bottomConstant: 100, rightConstant: 24, widthConstant: 0, heightConstant: 0).first
        
        innerWriteCollectionview.register(innerFirstWriteCell.self, forCellWithReuseIdentifier: cellid)
    }
    
    @objc fileprivate func goNextCell() {
        delegate?.goNextCell(index: index)
    }
    
    @objc fileprivate func clickSearch() {
        backWhiteView.alpha = 1
        searchView2.alpha = 1
        backImageView.alpha = 1
        searchLabel2.alpha = 1
        innerWriteCollectionview.alpha = 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath) as! innerFirstWriteCell
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 48)
    }
    
    @objc func restClicked() {
        backWhiteView.alpha = 0
        searchView2.alpha = 0
        backImageView.alpha = 0
        searchLabel2.alpha = 0
        innerWriteCollectionview.alpha = 0
        
        let attributedString = NSMutableAttributedString(string: "Cool Restaurant")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(-0.1), range: NSRange(location: 0, length: attributedString.length))
        searchLabel.attributedText = attributedString
        searchLabel.textColor = .black
        
        searchImageView.image = UIImage(named: "imsi_restaurant")
        searchImageView.contentMode = .scaleAspectFill
        searchImageView.layer.cornerRadius = 12
        searchImageView.layer.masksToBounds = true
        
        nextLabel.alpha = 1
        // 추후 자세하게 parameter까지 해서
        // next 그제서야 누르면 넘어가게
    }
    
}

class innerFirstWriteCell: UICollectionViewCell {
    
    weak var delegate: firstWriteReviewCell?
    
    let restImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "imsi_restaurant")
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 8
        iv.layer.masksToBounds = true
        return iv
    }()
    
    let restLabel: UILabel = {
        let lb = UILabel()
        // letter spacing -0.1
        let attributedString = NSMutableAttributedString(string: "Cool Restaurant")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(-0.1), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.font = UIFont(name: "DMSans-Medium", size: 14)
        lb.textColor = .black
        lb.textAlignment = .left
        lb.numberOfLines = 0
        return lb
    }()
    
    let locationImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "location")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let locationLabel: UILabel = {
        let lb = UILabel()
        // letter spacing 0.0
        let attributedString = NSMutableAttributedString(string: "100m")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(0.0), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.font = UIFont(name: "DMSans-Regular", size: 12)
        lb.textColor = .gray
        lb.textAlignment = .left
        lb.numberOfLines = 0
        return lb
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var restImageViewConstraint: NSLayoutConstraint?
    var restLabelConstraint: NSLayoutConstraint?
    var locationImageViewConstraint: NSLayoutConstraint?
    var locationLabelConstraint: NSLayoutConstraint?
    
    fileprivate func setupLayouts() {
        backgroundColor = .white
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(restClicked)))
        
        addSubview(restImageView)
        addSubview(restLabel)
        addSubview(locationImageView)
        addSubview(locationLabel)
        
        restImageViewConstraint = restImageView.anchor(self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 48, heightConstant: 0).first
        restLabelConstraint = restLabel.anchor(self.topAnchor, left: restImageView.rightAnchor, bottom: nil, right: self.rightAnchor, topConstant: 5, leftConstant: 16, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 18).first
        locationImageViewConstraint = locationImageView.anchor(restLabel.bottomAnchor, left: restImageView.rightAnchor, bottom: nil, right: nil, topConstant: 7, leftConstant: 16, bottomConstant: 0, rightConstant: 0, widthConstant: 10, heightConstant: 10).first
        locationLabelConstraint = locationLabel.anchor(restLabel.bottomAnchor, left: locationImageView.rightAnchor, bottom: nil, right: self.rightAnchor, topConstant: 4, leftConstant: 3, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 16).first
    }
    
    @objc fileprivate func restClicked() {
        delegate?.restClicked()
    }
    
}

class secondWriteReviewCell: UICollectionViewCell {
    
    var index: Int = 1
    weak var delegate: WriteReviewController?
    
    let titleLabel: UILabel = {
       let lb = UILabel()
       // letter spacing -0.3
       let attributedString = NSMutableAttributedString(string: "Do you like it?")
       attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(-0.3), range: NSRange(location: 0, length: attributedString.length))
       lb.attributedText = attributedString
       lb.font = UIFont(name: "DMSans-Medium", size: 20)
       lb.textColor = .black
       lb.textAlignment = .center
       lb.numberOfLines = 0
       return lb
   }()
       
   let subtitleLabel: UILabel = {
       let lb = UILabel()
       // letter spacing -0.1
       let attributedString = NSMutableAttributedString(string: "Lorem ipsum dolor sit amet, consectetur adipiscing elit duis eu.")
       attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(-0.1), range: NSRange(location: 0, length: attributedString.length))
       lb.attributedText = attributedString
       lb.font = UIFont(name: "DMSans-Regular", size: 16)
       lb.textColor = .lightGray
       lb.textAlignment = .center
       lb.numberOfLines = 0
       return lb
   }()
    
    lazy var cosmosView: CosmosView = {
        var cv = CosmosView()
        cv.settings.updateOnTouch = true
        cv.settings.totalStars = 5
        cv.settings.starSize = 40
        cv.settings.starMargin = 4
        cv.settings.fillMode = .half
        cv.rating = 0
        cv.settings.filledImage = UIImage(named: "filledStar")
        cv.settings.emptyImage = UIImage(named: "emptyStar")
        return cv
    }()
    
    lazy var nextLabel: UILabel = {
        let lb = UILabel()
        // letter spacing 1.0
        let attributedString = NSMutableAttributedString(string: "NEXT")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(1.0), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.font = UIFont(name: "DMSans-Bold", size: 14)
        lb.textColor = .white
        lb.backgroundColor = .mainColor
        lb.textAlignment = .center
        lb.numberOfLines = 0
        lb.layer.cornerRadius = 12
        lb.layer.masksToBounds = true
        lb.alpha = 0.5
        lb.isUserInteractionEnabled = true
        lb.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goNextCell)))
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var titleLabelConstraint: NSLayoutConstraint?
    var subtitleLabelConstraint: NSLayoutConstraint?
    var cosmosViewConstraint: NSLayoutConstraint?
    var nextLabelConstraint: NSLayoutConstraint?
    
    fileprivate func setupLayouts() {
        backgroundColor = .white
        
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(cosmosView)
        addSubview(nextLabel)
        
        titleLabelConstraint = titleLabel.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 28).first
        subtitleLabelConstraint = subtitleLabel.anchor(titleLabel.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 8, leftConstant: 48, bottomConstant: 0, rightConstant: 48, widthConstant: 0, heightConstant: 56).first
        cosmosViewConstraint = cosmosView.anchor(subtitleLabel.bottomAnchor, left: self.leftAnchor, bottom: nil, right: nil, topConstant: 16, leftConstant: (self.frame.width / 2) - 108, bottomConstant: 0, rightConstant: 0, widthConstant: 216, heightConstant: 40).first
        nextLabelConstraint = nextLabel.anchor(cosmosView.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 32, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 0, heightConstant: 56).first
        
        cosmosView.didTouchCosmos = { rating in
            self.nextLabel.alpha = 1
        }
        // present한 viewcontroller에서 pangesture로 터치하기위해사는 아래처럼 해주어야함.(이름은 조금 잘못된듯..)
        cosmosView.settings.disablePanGestures = true
    }
    
    @objc fileprivate func goNextCell() {
        delegate?.goNextCell(index: index)
    }
}

class thirdWriteReviewCell: UICollectionViewCell {
    
    var index: Int = 2
    weak var delegate: WriteReviewController?
    
    let titleLabel: UILabel = {
        let lb = UILabel()
        // letter spacing -0.3
        let attributedString = NSMutableAttributedString(string: "How it looks?")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(-0.3), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.font = UIFont(name: "DMSans-Medium", size: 20)
        lb.textColor = .black
        lb.textAlignment = .center
        lb.numberOfLines = 0
        return lb
    }()
        
    let subtitleLabel: UILabel = {
        let lb = UILabel()
        // letter spacing -0.1
        let attributedString = NSMutableAttributedString(string: "Lorem ipsum dolor sit amet, consectetur adipiscing elit duis eu.")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(-0.1), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.font = UIFont(name: "DMSans-Regular", size: 16)
        lb.textColor = .lightGray
        lb.textAlignment = .center
        lb.numberOfLines = 0
        return lb
    }()
    
    let photoBackView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 232, green: 232, blue: 232)
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    
    let photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "photo")?.withRenderingMode(.alwaysTemplate)
        iv.contentMode = .scaleAspectFit
        iv.tintColor = UIColor.rgb(red: 153, green: 153, blue: 153)
        return iv
    }()
    
    let photoLabel: UILabel = {
        let lb = UILabel()
        // letter spacing -0.1
        let attributedString = NSMutableAttributedString(string: "Add Photo")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(-0.1), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.font = UIFont(name: "DMSans-Regular", size: 16)
        lb.textColor = UIColor.rgb(red: 153, green: 153, blue: 153)
        lb.textAlignment = .center
        lb.numberOfLines = 0
        return lb
    }()
    
    lazy var nextLabel: UILabel = {
        let lb = UILabel()
        // letter spacing 1.0
        let attributedString = NSMutableAttributedString(string: "SKIP")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(1.0), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.font = UIFont(name: "DMSans-Bold", size: 14)
        lb.textColor = .white
        lb.backgroundColor = .mainColor
        lb.textAlignment = .center
        lb.numberOfLines = 0
        lb.layer.cornerRadius = 12
        lb.layer.masksToBounds = true
        lb.isUserInteractionEnabled = true
        lb.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goNextCell)))
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var titleLabelConstraint: NSLayoutConstraint?
    var subtitleLabelConstraint: NSLayoutConstraint?
    var photoBackViewConstraint: NSLayoutConstraint?
    var photoImageViewConstraint: NSLayoutConstraint?
    var photoLabelConstraint: NSLayoutConstraint?
    var nextLabelConstraint: NSLayoutConstraint?
    
    fileprivate func setupLayouts() {
        backgroundColor = .white
        
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(photoBackView)
        addSubview(photoImageView)
        addSubview(photoLabel)
        addSubview(nextLabel)
        
        titleLabelConstraint = titleLabel.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 28).first
        subtitleLabelConstraint = subtitleLabel.anchor(titleLabel.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 8, leftConstant: 48, bottomConstant: 0, rightConstant: 48, widthConstant: 0, heightConstant: 56).first
        photoBackViewConstraint = photoBackView.anchor(subtitleLabel.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 16, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 0, heightConstant: 150).first
        photoImageViewConstraint = photoImageView.anchor(photoBackView.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, topConstant: 42, leftConstant: (self.frame.width / 2) - 16, bottomConstant: 0, rightConstant: 0, widthConstant: 32, heightConstant: 32).first
        photoLabelConstraint = photoLabel.anchor(photoImageView.bottomAnchor, left: photoBackView.leftAnchor, bottom: nil, right: photoBackView.rightAnchor, topConstant: 8, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 26).first
        nextLabelConstraint = nextLabel.anchor(photoBackView.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 24, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 0, heightConstant: 56).first
    }
    
    @objc fileprivate func goNextCell() {
        // 사진 선택했을때는 Skip을 Next로 바꿔주기.
        delegate?.goNextCell(index: index)
    }
}

class fourthWriteReviewCell: UICollectionViewCell {
    
    var index: Int = 3
    weak var delegate: WriteReviewController?
    
    let titleLabel: UILabel = {
        let lb = UILabel()
        // letter spacing -0.3
        let attributedString = NSMutableAttributedString(string: "What’s good or bad here?")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(-0.3), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.font = UIFont(name: "DMSans-Medium", size: 20)
        lb.textColor = .black
        lb.textAlignment = .center
        lb.numberOfLines = 0
        return lb
    }()
        
    let subtitleLabel: UILabel = {
        let lb = UILabel()
        // letter spacing -0.1
        let attributedString = NSMutableAttributedString(string: "Lorem ipsum dolor sit amet, consectetur adipiscing elit duis eu.")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(-0.1), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.font = UIFont(name: "DMSans-Regular", size: 16)
        lb.textColor = .lightGray
        lb.textAlignment = .center
        lb.numberOfLines = 0
        return lb
    }()
    
    let postBackView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 1
        view.layer.masksToBounds = true
        return view
    }()
    
    let postLabel: UILabel = {
        let lb = UILabel()
        // letter spacing -0.1
        let attributedString = NSMutableAttributedString(string: "Tell us about the restaurant!\n\nReviews unrelated to the restaurant may be deleted without notice.")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(-0.1), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.font = UIFont(name: "DMSans-Regular", size: 14)
        lb.textColor = .lightGray
        lb.textAlignment = .left
        lb.numberOfLines = 0
        return lb
    }()
    
    let countLabel: UILabel = {
        let lb = UILabel()
        // letter spacing 0.0
        let attributedString = NSMutableAttributedString(string: "0/300")
        // 추후에 글자크기에 맞춰서 background color 넓혀야함.
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(0.0), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.font = UIFont(name: "DMSans-Regular", size: 12)
        lb.textColor = .darkGray
        lb.textAlignment = .center
        lb.backgroundColor = .pink
        lb.layer.cornerRadius = 9
        lb.layer.masksToBounds = true
        lb.numberOfLines = 0
        return lb
    }()
    
    lazy var nextLabel: UILabel = {
        let lb = UILabel()
        // letter spacing 1.0
        let attributedString = NSMutableAttributedString(string: "PUBLISH")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(1.0), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.font = UIFont(name: "DMSans-Bold", size: 14)
        lb.textColor = .white
        lb.backgroundColor = .mainColor
        lb.textAlignment = .center
        lb.numberOfLines = 0
        lb.layer.cornerRadius = 12
        lb.layer.masksToBounds = true
        lb.isUserInteractionEnabled = true
        lb.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goNextCell)))
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var titleLabelConstraint: NSLayoutConstraint?
    var subtitleLabelConstraint: NSLayoutConstraint?
    var postBackViewConstraint: NSLayoutConstraint?
    var postLabelConstraint: NSLayoutConstraint?
    var countLabelConstraint: NSLayoutConstraint?
    var nextLabelConstraint: NSLayoutConstraint?
    
    fileprivate func setupLayouts() {
        backgroundColor = .white
        
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(postBackView)
        addSubview(postLabel)
        addSubview(countLabel)
        addSubview(nextLabel)
        
        titleLabelConstraint = titleLabel.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 28).first
        subtitleLabelConstraint = subtitleLabel.anchor(titleLabel.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 8, leftConstant: 48, bottomConstant: 0, rightConstant: 48, widthConstant: 0, heightConstant: 56).first
        postBackViewConstraint = postBackView.anchor(subtitleLabel.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 12, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 0, heightConstant: 166).first
        postLabelConstraint = postLabel.anchor(postBackView.topAnchor, left: postBackView.leftAnchor, bottom: nil, right: postBackView.rightAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 88).first
        countLabelConstraint = countLabel.anchor(nil, left: nil, bottom: postBackView.bottomAnchor, right: postBackView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 12, rightConstant: 12, widthConstant: 46, heightConstant: 18).first
        nextLabelConstraint = nextLabel.anchor(postBackView.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 24, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 0, heightConstant: 56).first
    }
    
    @objc fileprivate func goNextCell() {
        delegate?.goNextCell(index: index)
        delegate?.goFinish()
    }
    
}

class LastWriteReviewCell: UICollectionViewCell {
    
    var index: Int = 4
    weak var delegate: WriteReviewController?
    
    let finishImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "congrats")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let titleLabel: UILabel = {
        let lb = UILabel()
        // letter spacing -0.3
        let attributedString = NSMutableAttributedString(string: "Your review is published!")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(-0.3), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.font = UIFont(name: "DMSans-Medium", size: 20)
        lb.textColor = .black
        lb.textAlignment = .center
        lb.numberOfLines = 0
        return lb
    }()
        
    let subtitleLabel: UILabel = {
        let lb = UILabel()
        // letter spacing -0.1
        let attributedString = NSMutableAttributedString(string: "Lorem ipsum dolor sit amet, consectetur adipiscing elit duis eu.")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(-0.1), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.font = UIFont(name: "DMSans-Regular", size: 16)
        lb.textColor = .lightGray
        lb.textAlignment = .center
        lb.numberOfLines = 0
        return lb
    }()
    
    lazy var nextLabel: UILabel = {
        let lb = UILabel()
        // letter spacing 1.0
        let attributedString = NSMutableAttributedString(string: "GO TO REVIEW")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(1.0), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.font = UIFont(name: "DMSans-Bold", size: 14)
        lb.textColor = .white
        lb.backgroundColor = .mainColor
        lb.textAlignment = .center
        lb.numberOfLines = 0
        lb.layer.cornerRadius = 12
        lb.layer.masksToBounds = true
        lb.isUserInteractionEnabled = true
        lb.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissView)))
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var finishImageViewConstraint: NSLayoutConstraint?
    var titleLabelConstraint: NSLayoutConstraint?
    var subtitleLabelConstraint: NSLayoutConstraint?
    var nextLabelConstraint: NSLayoutConstraint?
    
    fileprivate func setupLayouts() {
        backgroundColor = .white
        
        addSubview(finishImageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(nextLabel)
        
        finishImageViewConstraint = finishImageView.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: (self.frame.width / 2) - 135, bottomConstant: 0, rightConstant: 0, widthConstant: 270, heightConstant: 200).first
        titleLabelConstraint = titleLabel.anchor(finishImageView.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 16, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 28).first
        subtitleLabelConstraint = subtitleLabel.anchor(titleLabel.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 8, leftConstant: 48, bottomConstant: 0, rightConstant: 48, widthConstant: 0, heightConstant: 56).first
        nextLabelConstraint = nextLabel.anchor(subtitleLabel.bottomAnchor, left: self.leftAnchor, bottom: nil, right: nil, topConstant: 16, leftConstant: (self.frame.width / 2) - 100, bottomConstant: 0, rightConstant: 0, widthConstant: 200, heightConstant: 56).first
    }
    
    @objc fileprivate func dismissView() {
        delegate?.dismissView()
    }
    
}



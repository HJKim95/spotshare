//
//  SearchResultController.swift
//  SpotShare
//
//  Created by 김희중 on 30/12/2019.
//  Copyright © 2019 김희중. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps

class SearchResultController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    deinit {
        print("no retain cycle in SearchResultController")
    }
    
    var searchText: String? {
        didSet {
            print(searchText)
            guard let text = searchText else {return}
            let ref = Database.database().reference().child("search_keywords")
            ref.observe(.childAdded) { (snapshot) in
                if text.contains(snapshot.key) {
                    print(snapshot.key)
                }
            }
        }
    }
    
    let restid = "restid"
    let trendingid = "trendingid"
    let recommendid = "recommendid"
    
    lazy var backImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "back")
        iv.contentMode = .scaleAspectFit
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goBack)))
        return iv
    }()

    
    lazy var innerBigCategoryCollectionview: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.alwaysBounceVertical = true
        collectionview.showsVerticalScrollIndicator = false
        collectionview.backgroundColor = .white
        return collectionview
    }()
    
    lazy var searchbar: searchBar = {
        let sb = searchBar()
        sb.backgroundColor = .white
        sb.layer.cornerRadius = 15
        sb.layer.borderColor = UIColor(white: 0.3, alpha: 0.3).cgColor
        sb.layer.borderWidth = 0.1
        sb.layer.masksToBounds = true
//        sb.maincontroller = self
        return sb
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: -0.05)
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 15
        view.layer.masksToBounds = false
        return view
    }()
    
    var backImageViewConstraint: NSLayoutConstraint?
    var restaurantLabelConstraint: NSLayoutConstraint?
    var innerCategoryCollectionviewConstraint: NSLayoutConstraint?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        
        // swipe로 back 구현하려면 두개 다 써줘야함.
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        view.addSubview(backImageView)
        view.addSubview(innerBigCategoryCollectionview)
        
        if #available(iOS 11.0, *) {
            backImageViewConstraint = backImageView.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 16, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 24, heightConstant: 24).first
            innerCategoryCollectionviewConstraint = innerBigCategoryCollectionview.anchor(backImageView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
            
        }
        else {
            backImageViewConstraint = backImageView.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 16, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 24, heightConstant: 24).first
            innerCategoryCollectionviewConstraint = innerBigCategoryCollectionview.anchor(backImageView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
        }
        
        innerBigCategoryCollectionview.register(HotSpotCell.self, forCellWithReuseIdentifier: restid)
        innerBigCategoryCollectionview.register(TrendingCell.self, forCellWithReuseIdentifier: trendingid)
        innerBigCategoryCollectionview.register(searchRecommendCell.self, forCellWithReuseIdentifier: recommendid)
        
        setupSearchBar()
        
    }
    
    var searchbarConstraint: NSLayoutConstraint?
    var searchContainerConstraint: NSLayoutConstraint?
    
    fileprivate func setupSearchBar() {

        view.addSubview(containerView)
        containerView.addSubview(searchbar)
        
        //밑에 cornerRadius 안보이게 하기위해
        let contentInset: CGFloat = 15

        if #available(iOS 11.0, *) {
            searchContainerConstraint = containerView.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 80 + contentInset).first
            searchbarConstraint = searchbar.anchor(containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
        }
        else {
            searchContainerConstraint = containerView.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 80 + contentInset).first
            searchbarConstraint = searchbar.anchor(containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: restid, for: indexPath) as! HotSpotCell
            // letter spacing 1
            let attributedString = NSMutableAttributedString(string: "RESTAURANTS")
            attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(1.0), range: NSRange(location: 0, length: attributedString.length))
            cell.categoryNameLabel.attributedText = attributedString
            return cell
        }
        
        else if indexPath.item == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: trendingid, for: indexPath) as! TrendingCell
            // letter spacing 1
            let attributedString = NSMutableAttributedString(string: "MAGAZINES")
            attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(1.0), range: NSRange(location: 0, length: attributedString.length))
            cell.trendingTitle.attributedText = attributedString
            cell.trendingTitle.font = UIFont(name: "DMSans-Medium", size: 12)
            cell.trendingTitle.textColor = .lightGray
            return cell
        }
        
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: recommendid, for: indexPath) as! searchRecommendCell
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 {
            // 97 + 9 + 18 + 1 + 16 + 4
            return CGSize(width: self.view.frame.width, height: 380)
        }
        
        else if indexPath.item == 1 {
            // 32 + 24 + 24 + 160 + 16 + 44
            return CGSize(width: collectionView.frame.width, height: 300)
        }
        
        else {
            // 50 + 156 = 206
            return CGSize(width: collectionView.frame.width, height: 206)
        }
        
    }
    
    fileprivate var lastContentOffset: CGFloat = 0
    //searchBar pop up
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if lastContentOffset > scrollView.contentOffset.y && lastContentOffset < scrollView.contentSize.height - scrollView.frame.height {
            //move up
            UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseInOut, animations: {
                self.searchbar.transform = .identity
            }, completion: nil)
        }
        else if lastContentOffset < scrollView.contentOffset.y && scrollView.contentOffset.y > 0 {
            //move down
            UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseInOut, animations: {
                self.searchbar.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
            }, completion: nil)}

        // update the new position acquired
        self.lastContentOffset = scrollView.contentOffset.y
    }
    
    @objc fileprivate func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

class categoryNameHeaderCell: UICollectionViewCell {
    
    let categoryNameLabel: UILabel = {
        let lb = UILabel()
        lb.backgroundColor = .white
        lb.font = UIFont(name: "DMSans-Medium", size: 12)
        lb.textColor = .lightGray
        lb.textAlignment = .left
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var categoryNameLabelConstraint: NSLayoutConstraint?
    
    fileprivate func setupLayout() {
        backgroundColor = .white
        
        addSubview(categoryNameLabel)
        
        categoryNameLabelConstraint = categoryNameLabel.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 16, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 18).first
    }
}

class searchRecommendCell: UICollectionViewCell, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let cellid = "cellid"
    
    let categoryNameLabel: UILabel = {
        let lb = UILabel()
        lb.backgroundColor = .white
        lb.font = UIFont(name: "DMSans-Medium", size: 12)
        lb.textColor = .lightGray
        lb.textAlignment = .left
        // letter spacing 1
        let attributedString = NSMutableAttributedString(string: "RECOMMENDATIONS")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(1.0), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        return lb
    }()
    
    lazy var innerRecommendCollectionview: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.alwaysBounceVertical = true
        collectionview.showsVerticalScrollIndicator = false
        collectionview.backgroundColor = .white
        return collectionview
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var categoryNameLabelConstraint: NSLayoutConstraint?
    var innerRecommendCollectionviewConstraint: NSLayoutConstraint?
    
    fileprivate func setupLayout() {
        backgroundColor = .white
        
        addSubview(categoryNameLabel)
        addSubview(innerRecommendCollectionview)
        
        categoryNameLabelConstraint = categoryNameLabel.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 32, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 18).first
        innerRecommendCollectionviewConstraint = innerRecommendCollectionview.anchor(categoryNameLabel.bottomAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 16, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
        
        innerRecommendCollectionview.register(innerRecommendCell.self, forCellWithReuseIdentifier: cellid)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath) as! innerRecommendCell
        // letter spacing -0.1
        let attributedString = NSMutableAttributedString(string: "Dinner ideas for the first date")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(-0.1), range: NSRange(location: 0, length: attributedString.length))
        cell.recommendTitleLabel.attributedText = attributedString
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize (width: self.frame.width - 24, height: 56)
    }
}

class innerRecommendCell: UICollectionViewCell {
    
    let recommendImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .lightGray
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = 8
        return iv
    }()
    
    let recommendTitleLabel: UILabel = {
        let lb = UILabel()
        lb.backgroundColor = .white
        lb.font = UIFont(name: "DMSans-Regular", size: 14)
        lb.textColor = .darkGray
        lb.textAlignment = .left
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var recommendImageViewConstraint: NSLayoutConstraint?
    var recommendTitleLabelConstraint: NSLayoutConstraint?
    
    fileprivate func setupLayout() {
        addSubview(recommendImageView)
        addSubview(recommendTitleLabel)
        
        recommendImageViewConstraint = recommendImageView.anchor(self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: nil, topConstant: 8, leftConstant: 0, bottomConstant: 8, rightConstant: 0, widthConstant: 40, heightConstant: 0).first
        recommendTitleLabelConstraint = recommendTitleLabel.anchor(self.topAnchor, left: recommendImageView.rightAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
    }
}






//
//  MagazineController.swift
//  SpotShare
//
//  Created by 김희중 on 21/11/2019.
//  Copyright © 2019 김희중. All rights reserved.
//

import UIKit

class MagazineController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    deinit {
        print("no retain cycle in MagazineController")
    }
    
    fileprivate let featureCellid = "featureCell"
    fileprivate let trendingCellid = "trendingCell"
    fileprivate let recommendCellid = "recommendCell"
    fileprivate let latestCellid = "latestCell"
    
    lazy var backImageView: UIImageView = {
       let iv = UIImageView()
       iv.image = UIImage(named: "back")
       iv.contentMode = .scaleAspectFit
       iv.isUserInteractionEnabled = true
       iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goBack)))
       return iv
   }()
    
    lazy var bigCategoryCollectionview: UICollectionView = {
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
        sb.magazinecontroller = self
        sb.searchText.text = "매거진/키워드 검색"
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        // swipe로 back 구현하려면 두개 다 써줘야함.
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        setupLayouts()
        setupSearchBar()
        
        bigCategoryCollectionview.register(FeatureCell.self, forCellWithReuseIdentifier: featureCellid)
        bigCategoryCollectionview.register(TrendingCell.self, forCellWithReuseIdentifier: trendingCellid)
        bigCategoryCollectionview.register(magazineRecommendCell.self, forCellWithReuseIdentifier: recommendCellid)
        bigCategoryCollectionview.register(LatestCell.self, forCellWithReuseIdentifier: latestCellid)
    }
    
    var backImageViewConstraint: NSLayoutConstraint?
    var bigCategoryCollectionviewConstraint: NSLayoutConstraint?
    var searchbarConstraint: NSLayoutConstraint?
    var searchContainerConstraint: NSLayoutConstraint?
    
    fileprivate func setupLayouts() {
        view.addSubview(backImageView)
        view.addSubview(bigCategoryCollectionview)
        
        if #available(iOS 11.0, *) {
            backImageViewConstraint = backImageView.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 16, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 24, heightConstant: 24).first
            bigCategoryCollectionviewConstraint = bigCategoryCollectionview.anchor(backImageView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 16, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
            
            
        }
        else {
            backImageViewConstraint = backImageView.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 16, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 24, heightConstant: 24).first
            bigCategoryCollectionviewConstraint = bigCategoryCollectionview.anchor(backImageView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 16, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
            
        }
        
    }
    
    @objc fileprivate func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    fileprivate func setupSearchBar() {

        view.addSubview(containerView)
        containerView.addSubview(searchbar)
        
        //밑에 cornerRadius 안보이게 하기위해
        let contentInset: CGFloat = 15

        if #available(iOS 11.0, *) {
            searchContainerConstraint = containerView.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: -contentInset, rightConstant: 0, widthConstant: 0, heightConstant: 100 + contentInset).first
            searchbarConstraint = searchbar.anchor(containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
        }
        else {
            searchContainerConstraint = containerView.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: contentInset, rightConstant: 0, widthConstant: 0, heightConstant: 100 + contentInset).first
            searchbarConstraint = searchbar.anchor(containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: featureCellid, for: indexPath) as! FeatureCell
            cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goInnerMagazine)))
            return cell
        }
        else if indexPath.item == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: trendingCellid, for: indexPath) as! TrendingCell
            // letter spacing 0.0
            let attributedString = NSMutableAttributedString(string: "Trending")
            attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(0.0), range: NSRange(location: 0, length: attributedString.length))
            cell.trendingTitle.attributedText = attributedString
            cell.trendingTitle.font = UIFont(name: "DMSans-Bold", size: 18)
            cell.trendingTitle.textColor = .darkGray
            // SearchResultController에도 class 따와야하기 때문에 여기서 label 설정하기.
            cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goInnerMagazine)))
            return cell
        }
        
        else if indexPath.item == 2 {
             let cell = collectionView.dequeueReusableCell(withReuseIdentifier: recommendCellid, for: indexPath) as! magazineRecommendCell
            cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goInnerMagazine)))
            return cell
        }
            
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: latestCellid, for: indexPath) as! LatestCell
            cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goInnerMagazine)))
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 {
            // 220
            return CGSize(width: collectionView.frame.width, height: 48 + 220)
        }
        else if indexPath.item == 1 {
            // 32 + 24 + 24 + 160 + 16 + 44
            return CGSize(width: collectionView.frame.width, height: 300)
        }
        
        else if indexPath.item == 2 {
            
            // 24 + 24 + 24 + 100 + 16 + 44 + 16 + 100 + 16 + 44
            return CGSize(width: collectionView.frame.width, height: 408)
        }
            
        else {
            // 478 + 32
            return CGSize(width: collectionView.frame.width, height: 510)
        }
    }
    
    fileprivate var lastContentOffset: CGFloat = 0
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // collectionview 위에만 bounce되고 밑에는 안되게
        scrollView.bounces = scrollView.contentOffset.y < 200
        
        if lastContentOffset > scrollView.contentOffset.y && lastContentOffset < scrollView.contentSize.height - scrollView.frame.height {
            //move up
            UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseInOut, animations: {
                self.searchbar.transform = .identity
            }, completion: nil)
        }
        else if lastContentOffset < scrollView.contentOffset.y && scrollView.contentOffset.y > 0 {
            //move down
            UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseInOut, animations: {
                self.searchbar.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
            }, completion: nil)}

        // update the new position acquired
        self.lastContentOffset = scrollView.contentOffset.y
    }
    
    @objc func goInnerMagazine() {
        let innerMagazine = innerMagazineViewController()
        self.navigationController?.pushViewController(innerMagazine, animated: true)
    }
     
}

class FeatureCell: UICollectionViewCell, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    fileprivate let featureid = "featureid"
    
    let featureTitle: UILabel = {
        let lb = UILabel()
        // letter spacing 0.0
        let attributedString = NSMutableAttributedString(string: "Featured")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(0.0), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.font = UIFont(name: "DMSans-Bold", size: 18)
        lb.textAlignment = .left
        lb.numberOfLines = 0
        lb.textColor = .darkGray
        return lb
    }()
    
    lazy var innerCollectionview: UICollectionView = {
        // https://github.com/ink-spot/UPCarouselFlowLayout
        // 문제가 있을시 RestaurantMonthController 참고.
        let flowLayout = UPCarouselFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.spacingMode = UPCarouselFlowLayoutSpacingMode.fixed(spacing: 24)
        flowLayout.sideItemScale = 0.97
        // 5:4 비율
        flowLayout.itemSize = CGSize(width: 275, height: 220)
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.alwaysBounceHorizontal = true
        collectionview.showsHorizontalScrollIndicator = false
        collectionview.backgroundColor = .white
        return collectionview
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var featureTitleConstraint: NSLayoutConstraint?
    var innerCollectionviewConstraint: NSLayoutConstraint?
    
    fileprivate func setupViews() {
        backgroundColor = .white
        
        innerCollectionview.register(innerFeatureCell.self, forCellWithReuseIdentifier: featureid)
        
        addSubview(featureTitle)
        addSubview(innerCollectionview)
        
        featureTitleConstraint = featureTitle.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil
            , right: self.rightAnchor, topConstant: 0, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 24).first
        innerCollectionviewConstraint = innerCollectionview.anchor(featureTitle.bottomAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 24, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: featureid, for: indexPath) as! innerFeatureCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
}


class innerFeatureCell:  UICollectionViewCell {
    
    let magazineImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = 12
        iv.backgroundColor = .gray
        return iv
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var magazineImageViewConstraint: NSLayoutConstraint?
    
    
    fileprivate func setupViews() {
        backgroundColor = .white
        
        addSubview(magazineImageView)
        
        magazineImageViewConstraint = magazineImageView.anchor(self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
    }
}




class TrendingCell: UICollectionViewCell, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    fileprivate let trendingid = "trendingid"
    
    let trendingTitle: UILabel = {
        let lb = UILabel()
        lb.textAlignment = .left
        lb.numberOfLines = 0
        return lb
    }()
    
    lazy var innerCollectionview: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 16
        flowLayout.itemSize = CGSize(width: 120, height: 220)
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.alwaysBounceHorizontal = true
        collectionview.showsHorizontalScrollIndicator = false
        collectionview.backgroundColor = .white
        return collectionview
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var innerCollectionviewConstraint: NSLayoutConstraint?
    var trendingTitleConstraint: NSLayoutConstraint?
    
    fileprivate func setupViews() {
        backgroundColor = .white
        
        innerCollectionview.register(innerTrendingCell.self, forCellWithReuseIdentifier: trendingid)
        
        addSubview(trendingTitle)
        addSubview(innerCollectionview)
        
        trendingTitleConstraint = trendingTitle.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil
            , right: self.rightAnchor, topConstant: 32, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 24).first
        innerCollectionviewConstraint = innerCollectionview.anchor(trendingTitle.bottomAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 24, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: trendingid, for: indexPath) as! innerTrendingCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
}

class innerTrendingCell:  UICollectionViewCell {
    
    let magazineImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = 6
        iv.backgroundColor = .gray
        return iv
    }()
    
    let magazineImageTitle: UILabel = {
        let lb = UILabel()
        // letter spacing -0.1
        let attributedString = NSMutableAttributedString(string: "Top 5 cafes to come with lovers")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(-0.1), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.font = UIFont(name: "DMSans-Regular", size: 14)
        lb.textAlignment = .left
        lb.numberOfLines = 0
        lb.textColor = .darkGray
        return lb
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var magazineImageViewConstraint: NSLayoutConstraint?
    var magazineImageTitleConstraint: NSLayoutConstraint?
    
    fileprivate func setupViews() {
        backgroundColor = .white
        
        addSubview(magazineImageView)
        addSubview(magazineImageTitle)
        
        magazineImageViewConstraint = magazineImageView.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 160).first
        magazineImageTitleConstraint = magazineImageTitle.anchor(magazineImageView.bottomAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 8, leftConstant: 2, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
    }
}






class magazineRecommendCell: UICollectionViewCell {
    
    let recommendationTitle: UILabel = {
        let lb = UILabel()
        // letter spacing 0.0
        let attributedString = NSMutableAttributedString(string: "Recommendations")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(0.0), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.font = UIFont(name: "DMSans-Bold", size: 18)
        lb.textAlignment = .left
        lb.numberOfLines = 0
        lb.textColor = .darkGray
        return lb
    }()
    
    let firstImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = 6
        iv.backgroundColor = .gray
        return iv
    }()
    
    let firstImageTitle: UILabel = {
        let lb = UILabel()
        // letter spacing -0.1
        let attributedString = NSMutableAttributedString(string: "How about a sushi today?")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(-0.1), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.font = UIFont(name: "DMSans-Regular", size: 14)
        lb.textAlignment = .left
        lb.numberOfLines = 0
        lb.textColor = .darkGray
        return lb
    }()
    
    let secondImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = 6
        iv.backgroundColor = .gray
        return iv
    }()
    
    let secondImageTitle: UILabel = {
        let lb = UILabel()
        // letter spacing -0.1
        let attributedString = NSMutableAttributedString(string: "How about a dessert today?")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(-0.1), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.font = UIFont(name: "DMSans-Regular", size: 14)
        lb.textAlignment = .left
        lb.numberOfLines = 0
        lb.textColor = .darkGray
        return lb
    }()
    
    let thirdBigImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = 6
        iv.backgroundColor = .gray
        return iv
    }()
    
    let thirdImageTitle: UILabel = {
        let lb = UILabel()
        // letter spacing -0.1
        let attributedString = NSMutableAttributedString(string: "How about a beer today?")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(-0.1), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.font = UIFont(name: "DMSans-Regular", size: 14)
        lb.textAlignment = .left
        lb.numberOfLines = 0
        lb.textColor = .darkGray
        return lb
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var recommendationTitleConstraint: NSLayoutConstraint?
    var firstImageViewConstraint: NSLayoutConstraint?
    var firstImageTitleConstraint: NSLayoutConstraint?
    var secondImageViewConstraint: NSLayoutConstraint?
    var secondImageTitleConstraint: NSLayoutConstraint?
    var thirdBigImageViewConstraint: NSLayoutConstraint?
    var thirdImageTitleConstraint: NSLayoutConstraint?
    
    fileprivate func setupViews() {
        backgroundColor = .white
        
        addSubview(recommendationTitle)
        addSubview(firstImageView)
        addSubview(firstImageTitle)
        addSubview(secondImageView)
        addSubview(secondImageTitle)
        addSubview(thirdBigImageView)
        addSubview(thirdImageTitle)
        
        recommendationTitleConstraint = recommendationTitle.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 24, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 24).first
        firstImageViewConstraint = firstImageView.anchor(recommendationTitle.bottomAnchor, left: self.leftAnchor, bottom: nil, right: nil, topConstant: 24, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 151, heightConstant: 100).first
        firstImageTitleConstraint = firstImageTitle.anchor(firstImageView.bottomAnchor, left: self.leftAnchor, bottom: nil, right: firstImageView.rightAnchor, topConstant: 8, leftConstant: 24 + 2, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 44).first
        secondImageViewConstraint = secondImageView.anchor(firstImageTitle.bottomAnchor, left: self.leftAnchor, bottom: nil, right: firstImageView.rightAnchor, topConstant: 16, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 100).first
        secondImageTitleConstraint = secondImageTitle.anchor(secondImageView.bottomAnchor, left: self.leftAnchor, bottom: nil, right: secondImageView.rightAnchor, topConstant: 8, leftConstant: 24 + 2, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 44).first
        thirdBigImageViewConstraint = thirdBigImageView.anchor(recommendationTitle.bottomAnchor, left: firstImageView.rightAnchor, bottom: nil, right: self.rightAnchor, topConstant: 24, leftConstant: 16, bottomConstant: 0, rightConstant: 24, widthConstant: 0, heightConstant: 277).first
        thirdImageTitleConstraint = thirdImageTitle.anchor(thirdBigImageView.bottomAnchor, left: thirdBigImageView.leftAnchor, bottom: nil, right: thirdBigImageView.rightAnchor, topConstant: 8, leftConstant: 2, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 44).first
    }
}

class LatestCell: UICollectionViewCell, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    fileprivate let latestid = "latestid"
    
    let backView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 68, green: 68, blue: 68)
        view.layer.cornerRadius = 44
        view.layer.masksToBounds = true
        return view
    }()
    
    let latestTitle: UILabel = {
        let lb = UILabel()
        // letter spacing 0.0
        let attributedString = NSMutableAttributedString(string: "Latest")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(0.0), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.font = UIFont(name: "DMSans-Bold", size: 18)
        lb.textAlignment = .left
        lb.numberOfLines = 0
        lb.textColor = .white
        return lb
    }()
    
    lazy var innerCollectionview: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 21
        flowLayout.itemSize = CGSize(width: self.frame.width - 24, height: 100)
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.alwaysBounceVertical = true
        collectionview.showsVerticalScrollIndicator = false
        collectionview.backgroundColor = .clear
        return collectionview
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var backViewConstraint: NSLayoutConstraint?
    var innerCollectionviewConstraint: NSLayoutConstraint?
    var latestTitleConstraint: NSLayoutConstraint?
    
    fileprivate func setupViews() {
        backgroundColor = .clear
        
        innerCollectionview.register(innerLatestCell.self, forCellWithReuseIdentifier: latestid)
        
        addSubview(backView)
        backView.addSubview(latestTitle)
        backView.addSubview(innerCollectionview)
        
        backViewConstraint = backView.anchor(self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 32, leftConstant: 0, bottomConstant: -44, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
        latestTitleConstraint = latestTitle.anchor(backView.topAnchor, left: self.leftAnchor, bottom: nil
            , right: self.rightAnchor, topConstant: 40, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 24).first
        innerCollectionviewConstraint = innerCollectionview.anchor(latestTitle.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 24, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 374).first
        // height = 100 * 3 + 21 * 2 + 32
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: latestid, for: indexPath) as! innerLatestCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
}

class innerLatestCell:  UICollectionViewCell {
    
    let magazineImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = 6
        iv.backgroundColor = UIColor(white: 1, alpha: 0.7)
        return iv
    }()
    
    let magazineImageTitle: UILabel = {
        let lb = UILabel()
        // letter spacing -0.2
        let attributedString = NSMutableAttributedString(string: "Top 5 cafes to come with lovers")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(-0.2), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.font = UIFont(name: "DMSans-Bold", size: 16)
        lb.textAlignment = .left
        lb.numberOfLines = 0
        lb.textColor = .white
        return lb
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var magazineImageViewConstraint: NSLayoutConstraint?
    var magazineImageTitleConstraint: NSLayoutConstraint?
    
    fileprivate func setupViews() {
        backgroundColor = .clear
        
        addSubview(magazineImageView)
        addSubview(magazineImageTitle)
        
        magazineImageViewConstraint = magazineImageView.anchor(self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 156, heightConstant: 0).first
        magazineImageTitleConstraint = magazineImageTitle.anchor(self.topAnchor, left: magazineImageView.rightAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 0, rightConstant: 48, widthConstant: 0, heightConstant: 0).first
    }
}

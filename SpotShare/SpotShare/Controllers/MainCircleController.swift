//
//  MainCircleController.swift
//  SpotShare
//
//  Created by 김희중 on 04/05/2019.
//  Copyright © 2019 김희중. All rights reserved.
//

import UIKit

// https://github.com/mischa-hildebrand/AlignedCollectionViewFlowLayout

class MainCircleController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    deinit {
        print("no retain cycle in MainCircleController")
    }
    
    fileprivate let searchid = "searchid"
    fileprivate let cellid = "cellid"
    
    fileprivate let CircleBackColors = [UIColor.pink, UIColor.wheat, UIColor.lightGreen, UIColor.apricot, UIColor.pink, UIColor.wheat, UIColor.lightGreen, UIColor.apricot]
    fileprivate let CircleNames = ["한식","카페","피자,버거","치킨","피자,버거","칵테일,와인","베이커리","기타"]
    
    let searchTitleLabel: UILabel = {
        let lb = UILabel()
        // letter spacing -0.3
        let attributedString = NSMutableAttributedString(string: "Real Time Search")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(-0.3), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.font = UIFont(name: "DMSans-Medium", size: 28)
        lb.textAlignment = .left
        lb.numberOfLines = 0
        lb.textColor = .black
        return lb
    }()
    
    lazy var closeImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "close")
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissView)))
        return iv
    }()
    
    lazy var innerSearchCollectionview: UICollectionView = {
        let layout = AlignedCollectionViewFlowLayout()
        // https://github.com/mischa-hildebrand/AlignedCollectionViewFlowLayout
        layout.horizontalAlignment = .left
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.alwaysBounceHorizontal = false
        collectionview.showsHorizontalScrollIndicator = false
        collectionview.backgroundColor = .clear
        return collectionview
    }()
    
    var searchWordArr: [String] = ["FLOG","Hongik","matjipmatjip","sushi","hongdae","helloooooooooo"]
    
    let CircularBackImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "oval_big")
        return iv
    }()
    
    lazy var CircularcollectionView: UICollectionView = {
        let layout = CircularCollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceHorizontal = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    let circleFadeViewRight: UIView = {
        let view = UIView()
        return view
    }()
    
    let backCircleImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "oval")
        iv.backgroundColor = .clear
        return iv
    }()
    
    lazy var BigCircleImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "bigCircle")
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    lazy var TodayMealImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "todaysMeal")
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goTodayMeal)))
        return iv
    }()
    
    lazy var TodayMealLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Today's Meal"
        lb.font = UIFont(name: "DMSans-Regular", size: 11)
        lb.textColor = .gray
        lb.textAlignment = .center
        lb.numberOfLines = 0
        lb.isUserInteractionEnabled = true
        lb.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goTodayMeal)))
        return lb
    }()
    
    lazy var RestaurantMonthImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "restaurantOfTheMonth")
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goRestMonth)))
        return iv
    }()
    
    lazy var RestuarantMonthLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Restaurant of The Month"
        lb.font = UIFont(name: "DMSans-Regular", size: 11)
        lb.textAlignment = .center
        lb.textColor = .gray
        lb.numberOfLines = 0
        lb.isUserInteractionEnabled = true
        lb.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goRestMonth)))
        return lb
    }()
    
    lazy var MagazineImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "magazine")
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goMagazine)))
        return iv
    }()
    
    lazy var MagazineLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Magazine"
        lb.font = UIFont(name: "DMSans-Regular", size: 11)
        lb.textAlignment = .center
        lb.numberOfLines = 0
        lb.textColor = .gray
        lb.isUserInteractionEnabled = true
        lb.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goMagazine)))
        return lb
    }()
    
    let VoiceSearchImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "voiceSearch")
        return iv
    }()
    
    let VoiceSearchLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Voice Search"
        lb.font = UIFont(name: "DMSans-Regular", size: 11)
        lb.textAlignment = .center
        lb.textColor = .gray
        lb.numberOfLines = 0
        return lb
    }()
    
    let MapViewImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "mapView")
        return iv
    }()
    
    let MapViewLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Map View"
        lb.font = UIFont(name: "DMSans-Regular", size: 11)
        lb.textAlignment = .center
        lb.textColor = .gray
        lb.numberOfLines = 0
        return lb
    }()
    
    lazy var ReviewImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "My Reviews")?.withRenderingMode(.alwaysTemplate)
        iv.tintColor = .mainColor
        iv.backgroundColor = .clear
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goReview)))
        return iv
    }()
    
    lazy var ReviewLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Reviews"
        lb.font = UIFont(name: "DMSans-Regular", size: 11)
        lb.textAlignment = .center
        lb.numberOfLines = 0
        lb.textColor = .gray
        lb.isUserInteractionEnabled = true
        lb.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goReview)))
        return lb
    }()
    
    var searchTitleLabelConstraint: NSLayoutConstraint?
    var closeImageViewConstraint: NSLayoutConstraint?
    var innerSearchCollectionviewConstraint: NSLayoutConstraint?
    var CircularBackImageViewConstraint: NSLayoutConstraint?
    var CircularcollectionViewConstraint: NSLayoutConstraint?
    var circleFadeViewRightConstraint: NSLayoutConstraint?
    var backCircleImageViewConstraint: NSLayoutConstraint?
    var BigCircleImageViewConstraint: NSLayoutConstraint?
    var TodayMealImageviewConstraint: NSLayoutConstraint?
    var TodayMealLabelConstraint: NSLayoutConstraint?
    var RestaurantMonthImageViewConstraint: NSLayoutConstraint?
    var RestaurantMonthLabelConstraint: NSLayoutConstraint?
    var MagzineImageViewConstraint: NSLayoutConstraint?
    var MagazineLabelConstraint: NSLayoutConstraint?
    var VoiceSearchImageViewConstraint: NSLayoutConstraint?
    var VoiceSearchLabelConstraint: NSLayoutConstraint?
    var MapViewImageViewConstraint: NSLayoutConstraint?
    var MapViewLabelConstraint: NSLayoutConstraint?
    var ReviewImageViewConstraint: NSLayoutConstraint?
    var ReviewLabelConstraint: NSLayoutConstraint?
    
    var gradientRight =  CAGradientLayer()
    var gradientLeft =  CAGradientLayer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.rgb(red: 246, green: 246, blue: 246)
        self.navigationController?.navigationBar.isHidden = true
        
        BigCircleImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissView)))
        
        setupLayouts()
        
    }
    
    fileprivate func setupLayouts() {
        
        innerSearchCollectionview.register(innerCircleSearchCell.self, forCellWithReuseIdentifier: searchid)
        CircularcollectionView.register(CircularCell.self, forCellWithReuseIdentifier: cellid)
        
        view.addSubview(searchTitleLabel)
        view.addSubview(closeImageView)
        view.addSubview(innerSearchCollectionview)
        view.addSubview(CircularBackImageView)
        view.addSubview(CircularcollectionView)
        view.addSubview(circleFadeViewRight)
        view.addSubview(backCircleImageView)
        view.addSubview(BigCircleImageView)
        view.addSubview(TodayMealImageView)
        view.addSubview(TodayMealLabel)
        view.addSubview(RestaurantMonthImageView)
        view.addSubview(RestuarantMonthLabel)
        view.addSubview(MagazineImageView)
        view.addSubview(MagazineLabel)
       
        view.addSubview(ReviewImageView)
        view.addSubview(ReviewLabel)
        view.addSubview(MapViewImageView)
        view.addSubview(MapViewLabel)
        view.addSubview(VoiceSearchImageView)
        view.addSubview(VoiceSearchLabel)
        
        closeImageViewConstraint = closeImageView.anchor(view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, topConstant: 32, leftConstant: 0, bottomConstant: 0, rightConstant: 24, widthConstant: 16, heightConstant: 16).first
        searchTitleLabelConstraint = searchTitleLabel.anchor(closeImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 24, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 38).first
        innerSearchCollectionviewConstraint = innerSearchCollectionview.anchor(searchTitleLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 30, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 0, heightConstant: 206).first
        CircularBackImageViewConstraint = CircularBackImageView.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 65, rightConstant: 0, widthConstant: 0, heightConstant: 316).first
        CircularcollectionViewConstraint = CircularcollectionView.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 120, rightConstant: 0, widthConstant: view.frame.width, heightConstant: 130 + 125).first
        backCircleImageViewConstraint = backCircleImageView.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: view.frame.width * 252 / 375).first
        BigCircleImageViewConstraint = BigCircleImageView.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: nil, topConstant: 0, leftConstant: (view.frame.width / 2) - 75, bottomConstant: 0, rightConstant: 0, widthConstant: 150, heightConstant: 150).first
        TodayMealImageviewConstraint = TodayMealImageView.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: nil, topConstant: 0, leftConstant: 33, bottomConstant: 72, rightConstant: 0, widthConstant: 24, heightConstant: 24).first
        TodayMealLabelConstraint = TodayMealLabel.anchor(TodayMealImageView.bottomAnchor, left: TodayMealImageView.leftAnchor, bottom: nil, right: nil, topConstant: 4, leftConstant: -(40 - 24) / 2, bottomConstant: 0, rightConstant: 0, widthConstant: 40, heightConstant: 29).first
        RestaurantMonthImageViewConstraint = RestaurantMonthImageView.anchor(nil, left: view.leftAnchor, bottom: TodayMealImageView.topAnchor, right: nil, topConstant: 0, leftConstant: 54, bottomConstant: 56, rightConstant: 0, widthConstant: 24, heightConstant: 24).first
        RestaurantMonthLabelConstraint = RestuarantMonthLabel.anchor(RestaurantMonthImageView.bottomAnchor, left: RestaurantMonthImageView.leftAnchor, bottom: nil, right: nil, topConstant: 4, leftConstant: -(69 - 24) / 2, bottomConstant: 0, rightConstant: 0, widthConstant: 69, heightConstant: 29).first
        MagzineImageViewConstraint = MagazineImageView.anchor(nil, left: RestaurantMonthImageView.rightAnchor, bottom: RestaurantMonthImageView.topAnchor, right: nil, topConstant: 0, leftConstant: 55, bottomConstant: 21, rightConstant: 0, widthConstant: 24, heightConstant: 24).first
        MagazineLabelConstraint = MagazineLabel.anchor(MagazineImageView.bottomAnchor, left: MagazineImageView.leftAnchor, bottom: nil, right: nil, topConstant: 4, leftConstant: -(48 - 24) / 2, bottomConstant: 0, rightConstant: 0, widthConstant: 48, heightConstant: 14).first

        ReviewImageViewConstraint = ReviewImageView.anchor(nil, left: nil, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 72, rightConstant: 33, widthConstant: 24, heightConstant: 24).first
        ReviewLabelConstraint = ReviewLabel.anchor(ReviewImageView.bottomAnchor, left: nil, bottom: nil, right: ReviewImageView.rightAnchor, topConstant: 4, leftConstant: 0, bottomConstant: 0, rightConstant: -(47 - 24) / 2, widthConstant: 47, heightConstant: 14).first
        MapViewImageViewConstraint = MapViewImageView.anchor(nil, left: nil, bottom: ReviewImageView.topAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 56, rightConstant: 54, widthConstant: 24, heightConstant: 24).first
        MapViewLabelConstraint = MapViewLabel.anchor(MapViewImageView.bottomAnchor, left: nil, bottom: nil, right: MapViewImageView.rightAnchor, topConstant: 4, leftConstant: 0, bottomConstant: 0, rightConstant: -(50 - 24) / 2, widthConstant: 50, heightConstant: 14).first
        circleFadeViewRightConstraint = circleFadeViewRight.anchor(CircularBackImageView.topAnchor, left: MapViewLabel.rightAnchor, bottom: MapViewImageView.topAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
        VoiceSearchImageViewConstraint = VoiceSearchImageView.anchor(nil, left: nil, bottom: MapViewImageView.topAnchor, right: MapViewImageView.leftAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 21, rightConstant: 55, widthConstant: 24, heightConstant: 24).first
        VoiceSearchLabelConstraint = VoiceSearchLabel.anchor(VoiceSearchImageView.bottomAnchor, left: nil, bottom: nil, right: VoiceSearchImageView.rightAnchor, topConstant: 4, leftConstant: 0, bottomConstant: 0, rightConstant: -(36 - 24) / 2, widthConstant: 36, heightConstant: 29).first
        
        circleFadeViewRight.setGradientBackgroundHorizontal(gradientLayer: gradientRight, colorOne:UIColor(white: 1, alpha: 0), colorTwo: UIColor(white: 1, alpha: 0.5))
        
    }
    
    // autolayout 사용시에는 gradient 설정하고 밑에 viewDidLayoutSubviews를 설정해주어야함.
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientRight.frame = circleFadeViewRight.bounds
    }
    
    @objc fileprivate func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == innerSearchCollectionview {
            return searchWordArr.count
        }
            
        else {
            return CircleNames.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == innerSearchCollectionview {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: searchid, for: indexPath) as! innerCircleSearchCell
            // letter spacing -0.3
            let attributedString = NSMutableAttributedString(string: "\(indexPath.item + 1)")
            attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(-0.3), range: NSRange(location: 0, length: attributedString.length))
            cell.numLabel.attributedText = attributedString
            
            // letter spacing 0.0
            let searchWords = searchWordArr[indexPath.item]
            let attributedString2 = NSMutableAttributedString(string: "\(searchWords)")
            attributedString2.addAttribute(NSAttributedString.Key.kern, value: CGFloat(0.0), range: NSRange(location: 0, length: attributedString2.length))
            cell.searchLabel.attributedText = attributedString2
            return cell
        }
            
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath) as! CircularCell
            let imageName = CircleNames[indexPath.item] + "_sm"
            cell.circleBackView.backgroundColor = CircleBackColors[indexPath.item]
            cell.circleImageView.image = UIImage(named: imageName)
            cell.circleLabel.text = CircleNames[indexPath.item]
            
            let tapgesture = UITapGestureRecognizer(target: self, action: #selector(goCategory(sender:)))
            
            cell.circleBackView.tag = indexPath.item
            cell.circleBackView.addGestureRecognizer(tapgesture)

            return cell
        }
    }
    
    var saveWidthArr = [CGFloat]()
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == innerSearchCollectionview {
            // https://www.youtube.com/watch?v=TEMUOaamcDA
            for i in 0..<searchWordArr.count {
                let item = searchWordArr[i]
                
                let size = CGSize(width: 1000, height: 44)
                let attributes = [NSAttributedString.Key.font : UIFont(name: "DMSans-Regular", size: 12)]
                
                let estimatedFrame = NSString(string: item).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes as [NSAttributedString.Key : Any], context: nil)
                saveWidthArr.append(estimatedFrame.width + 60)
            }
            
            if indexPath.item == 1 {
                return CGSize(width: collectionView.frame.width - saveWidthArr[0] - 10, height: 44)
            }
            else if indexPath.item == 2 {
                return CGSize(width: collectionView.frame.width - saveWidthArr[3] - 10, height: 44)
            }
            else if indexPath.item == 5 {
                return CGSize(width: collectionView.frame.width - saveWidthArr[4] - 10, height: 44)
            }
            else {
                return CGSize(width: saveWidthArr[indexPath.item], height: 44)
            }
        }
        return CGSize(width: 150, height: 44)
    }
    
    
    var delegate: circleDelegate?
    
    @objc fileprivate func goReview() {
        self.navigationController?.dismiss(animated: true, completion: {
            self.delegate?.goReview()
        })
    }
    
    @objc fileprivate func goRestMonth() {
        self.navigationController?.dismiss(animated: true, completion: {
            self.delegate?.goRestMonth()
        })
    }
    
    @objc fileprivate func goCategory(sender: UITapGestureRecognizer) {
        self.navigationController?.dismiss(animated: true, completion: {
            // 이렇게 tag를 이용해서 selector의 parameter를 가져오자..
            let indexPath = IndexPath(item: sender.view?.tag ?? 0, section: 0)
//            let cell = self.CircularcollectionView.cellForItem(at: indexPath) as? CircularCell
//            print(indexPath)
            let category = self.CircleNames[indexPath.item]
            self.delegate?.OpenCategoryCollectionView(category: category)
        })
    }
    
    @objc fileprivate func goMagazine() {
        self.navigationController?.dismiss(animated: true, completion: {
            self.delegate?.goMagazine()
        })
    }
    
    @objc fileprivate func goTodayMeal() {
        self.navigationController?.dismiss(animated: true, completion: {
            self.delegate?.goTodayMeal()
        })
    }
}


class innerCircleSearchCell: UICollectionViewCell {
    
    let numLabel: UILabel = {
        let lb = UILabel()
        lb.backgroundColor = .white
        lb.textColor = .mainColor
        lb.font = UIFont(name: "DMSans-Medium", size: 20)
        lb.numberOfLines = 0
        lb.textAlignment = .left
        return lb
    }()
    
    let searchLabel: UILabel = {
        let lb = UILabel()
        lb.backgroundColor = .white
        lb.textColor = UIColor.rgb(red: 102, green: 102, blue: 102)
        lb.font = UIFont(name: "DMSans-Regular", size: 12)
        lb.numberOfLines = 0
        lb.textAlignment = .left
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var numLabelConstraint: NSLayoutConstraint?
    var searchLabelConstraint: NSLayoutConstraint?
    
    fileprivate func setupLayouts() {
        backgroundColor = .white
        
        addSubview(numLabel)
        addSubview(searchLabel)
        
        numLabelConstraint = numLabel.anchor(self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: nil, topConstant: 8, leftConstant: 16, bottomConstant: 8, rightConstant: 0, widthConstant: 12, heightConstant: 0).first
        searchLabelConstraint = searchLabel.anchor(self.topAnchor, left: numLabel.rightAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 14, leftConstant: 10, bottomConstant: 14, rightConstant: 14, widthConstant: 0, heightConstant: 0).first
    }
}


class CircularCell: UICollectionViewCell {
    
    let containerView = UIView()
    
    lazy var circleBackView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.isUserInteractionEnabled = true
        return view
    }()
    
    let circleImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .clear
        return iv
    }()
    
    let circleLabel: UILabel = {
        let lb = UILabel()
        lb.textAlignment = .center
        lb.textColor = UIColor.rgb(red: 68, green: 68, blue: 68)
        lb.backgroundColor = .clear
        lb.font = UIFont(name: "DMSans-Regular", size: 12)
        lb.isUserInteractionEnabled = true
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        let circularlayoutAttributes = layoutAttributes as! CircularCollectionViewLayoutAttributes
        self.layer.anchorPoint = circularlayoutAttributes.anchorPoint
        containerView.transform = CGAffineTransform(rotationAngle: -circularlayoutAttributes.angle)
        self.center.y += (circularlayoutAttributes.anchorPoint.y - 0.5) * self.bounds.height
    }
    
    var containerViewConstraint: NSLayoutConstraint?
    var circleBackViewConstraint: NSLayoutConstraint?
    var circleImageViewConstraint: NSLayoutConstraint?
    var circleLabelConstraint: NSLayoutConstraint?
    
    
    fileprivate func setupViews() {
        backgroundColor = .clear
        
        addSubview(containerView)
        containerView.addSubview(circleBackView)
        containerView.addSubview(circleImageView)
        containerView.addSubview(circleLabel)
        
        containerViewConstraint = containerView.anchor(self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
        circleBackViewConstraint = circleBackView.anchor(containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: nil, topConstant: 20, leftConstant: (self.frame.width / 2) - 18, bottomConstant: 0, rightConstant: 0, widthConstant: 36, heightConstant: 36).first
        circleImageViewConstraint = circleImageView.anchor(circleBackView.topAnchor, left: circleBackView.leftAnchor, bottom: nil, right: nil, topConstant: (36 - 24) / 2, leftConstant: (36 - 24) / 2, bottomConstant: 0, rightConstant: 0, widthConstant: 24, heightConstant: 24).first
        circleLabelConstraint = circleLabel.anchor(circleImageView.bottomAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, topConstant: 9, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 28).first
    }
    
    
}

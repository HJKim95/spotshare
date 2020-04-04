//
//  innerMagazineViewController.swift
//  SpotShare
//
//  Created by 김희중 on 15/01/2020.
//  Copyright © 2020 김희중. All rights reserved.
//

import UIKit
import Cosmos
import Firebase
import GoogleMaps

// https://github.com/evgenyneu/Cosmos

class innerMagazineViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    deinit {
        print("no retain cycle in innerMagazineController")
    }
    
    var magTitle: String? {
        didSet {
            guard let magName = magTitle else {return}
            getInnerMagazine_firebase(magTitle: magName)
        }
    }
    
    fileprivate let cellid = "cellid"
    
    
    
    // 어두운부분 설정
    
    lazy var backImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "back")
        iv.isUserInteractionEnabled = true
        iv.tintColor = .white
        iv.image = iv.image?.withRenderingMode(.alwaysTemplate)
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goBack)))
        return iv
    }()
    
    lazy var shareImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "share")
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pressShare)))
        return iv
    }()
    
    lazy var infoMagazineCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.dataSource = self
        cv.delegate = self
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .white
        cv.alwaysBounceHorizontal = true
        cv.isPagingEnabled = true
        return cv
    }()
    
    var infoMagazineCollectionViewConstraint: NSLayoutConstraint?
    var backImageViewConstraint: NSLayoutConstraint?
    var shareImageViewConstraint: NSLayoutConstraint?
    

    
    override func viewDidLoad() {
        view.backgroundColor = .white
        
        // swipe로 back 구현하려면 두개 다 써줘야함.
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        infoMagazineCollectionView.register(innerMagazineInfoCell.self, forCellWithReuseIdentifier: cellid)
        
        view.addSubview(infoMagazineCollectionView)
        setupGradientLayer()
        view.addSubview(backImageView)
        view.addSubview(shareImageView)
        
        
        
        if #available(iOS 11.0, *) {

            backImageViewConstraint = backImageView.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 16, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 24, heightConstant: 24).first
            shareImageViewConstraint = shareImageView.anchor(view.safeAreaLayoutGuide.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 0, bottomConstant: 0, rightConstant: 24, widthConstant: 24, heightConstant: 24).first
            infoMagazineCollectionViewConstraint = infoMagazineCollectionView.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
            
        }
            
        else {
            backImageViewConstraint = backImageView.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 16, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 24, heightConstant: 24).first
            shareImageViewConstraint = shareImageView.anchor(view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 0, bottomConstant: 0, rightConstant: 24, widthConstant: 24, heightConstant: 24).first
            infoMagazineCollectionViewConstraint = infoMagazineCollectionView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
        }
        
        
        
    }
    
    var resInfos = [ResInfoModel]()
    
    fileprivate func getInnerMagazine_firebase(magTitle: String) {
        let ref = Database.database().reference().child("매거진").child(magTitle).child("res")
        ref.observe(.childAdded, with: { [weak self] (snapshot) in
            let snapid = snapshot.key
            let magazineReference = Database.database().reference().child("맛집").child(snapid)
            
            magazineReference.observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
                if let dictionary = snapshot.value as? [String:Any] {
                    let resInfo = ResInfoModel()
                    
                    // 주석한 부분은 그 다음 RestaurantViewController 넘어갈때 추가로 데이터 받아오기
                    // 그래야 각각 데이터 가져오는데 시간이 빠르고 효율적일듯.
                    resInfo.resName = dictionary["resName"] as? String
                    resInfo.starPoint = dictionary["resPoints"] as? Double
                    guard let lat = (dictionary["lat"] as? CLLocationDegrees) else {return}
                    guard let long = (dictionary["long"] as? CLLocationDegrees) else {return}
                    resInfo.resLocation = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    resInfo.locationText = dictionary["location"] as? String
                    resInfo.toilet = dictionary["toilet"] as? String
                    resInfo.teleText = dictionary["telephone"] as? String
                    resInfo.menuText = dictionary["resMenu"] as? String
                    resInfo.hourText = dictionary["resHour"] as? String
                    
                    // 해당 맛집에서 첫번째 이미지 따오기.
                    let firstImageReference = Database.database().reference().child("맛집").child(snapid).child("FirstResimage")
                    firstImageReference.observeSingleEvent(of: .childAdded, with: { [weak self] (snapshot) in
                        if let dictionary = snapshot.value as? [String:Any] {
                            resInfo.resImageUrl = dictionary["url"] as? String
                            self?.resInfos.append(resInfo)
                            
                        }
                        DispatchQueue.main.async {
                            self?.infoMagazineCollectionView.reloadData()
                        }
                    })
                }
                
            }, withCancel: { (err) in
                print("Failed to fetch resMonthData:", err)
            })
            
        }, withCancel: { (err) in
            print("Failed to fetch all resMonthDatas:", err)
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath) as! innerMagazineInfoCell
        let resinfo = resInfos[indexPath.item]
        cell.restaurantNameLabel.letterSpacing(text: resinfo.resName ?? "", spacing: -0.38)
        cell.locationLabel.letterSpacing(text: resinfo.locationText ?? "" , spacing: -0.1)
        let point = resinfo.starPoint ?? 3.5
        cell.pointLabel.letterSpacing(text: "\(String(describing: point))", spacing: -0.3)
        cell.cosmosView.rating = point
        cell.toiletLabel.text = resinfo.toilet
        cell.toilet = resinfo.toilet
        cell.menuLabel.letterSpacing(text: resinfo.menuText ?? "", spacing: -0.1)
        cell.callLabel.letterSpacing(text: resinfo.teleText ?? "", spacing: -0.1)
        cell.openTimeLabel.letterSpacing(text: resinfo.hourText ?? "", spacing: -0.1)
        let urlString = resinfo.resImageUrl ?? ""
        let url = URL(string: urlString)
        cell.restaurantImageView.sd_setImage(with: url, placeholderImage: nil, options: .scaleDownLargeImages, completed: nil)
        cell.pageIndicatorLabel.letterSpacing(text: "#\(indexPath.item + 1)", spacing: -0.45)
        cell.magazineTitleLabel.letterSpacing(text: magTitle ?? "", spacing: -0.32)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resInfos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let resinfo = resInfos[indexPath.item]
        let restaurant = RestaurantViewController()
        restaurant.resinfo = resinfo
        self.navigationController?.pushViewController(restaurant, animated: true)
    }
    
    
    @objc fileprivate func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc fileprivate func pressShare() {
        print("pressed share button")
    }
    
    let gradientLayer = CAGradientLayer()
    
    fileprivate func setupGradientLayer() {
        gradientLayer.colors = [UIColor.black.withAlphaComponent(0.4).cgColor, UIColor.clear.cgColor]
        gradientLayer.locations = [0,0.25]
        view.layer.addSublayer(gradientLayer)
    }
    
    override func viewDidLayoutSubviews() {
        gradientLayer.frame = infoMagazineCollectionView.frame
    }

}


class innerMagazineInfoCell: UICollectionViewCell {
    
    // 나중에 사진 여러개로 해서 swipe할꺼면 collectionview로 하자.
    let restaurantImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        return iv
    }()
    
    let magazineTitleLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "DMSans-Regular", size: 24)
        lb.textAlignment = .left
        lb.numberOfLines = 0
        lb.textColor = .white
        lb.backgroundColor = .clear
        return lb
    }()
    
    let infoView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 45
        view.layer.masksToBounds = true
        return view
    }()
    
    let restaurantNameLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "DMSans-Regular", size: 28)
        lb.textAlignment = .left
        lb.numberOfLines = 0
        lb.textColor = .black
        lb.backgroundColor = .white
        lb.adjustsFontSizeToFitWidth = true
        return lb
    }()
    
    let pageIndicatorLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "DMSans-Regular", size: 20)
        lb.textAlignment = .center
        lb.numberOfLines = 0
        lb.textColor = .white
        lb.layer.cornerRadius = 16
        lb.layer.masksToBounds = true
        lb.backgroundColor = .mainColor
        return lb
    }()
    
    lazy var cosmosView: CosmosView = {
        var cv = CosmosView()
        cv.settings.updateOnTouch = false
        cv.settings.totalStars = 5
        cv.settings.starSize = 16
        cv.settings.starMargin = 1
        cv.settings.fillMode = .half
        cv.settings.filledImage = UIImage(named: "filledStar")
        cv.settings.emptyImage = UIImage(named: "emptyStar")
        return cv
    }()
    
    let pointLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor.rgb(red: 102, green: 102, blue: 102)
        lb.font = UIFont(name: "DMSans-Regular", size: 14)
        lb.textAlignment = .left
        return lb
    }()
    
    let locationImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "pin")
        iv.image = iv.image?.withRenderingMode(.alwaysTemplate)
        iv.tintColor = UIColor.rgb(red: 204, green: 204, blue: 204)
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let locationLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor.rgb(red: 102, green: 102, blue: 102)
        lb.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
        lb.textAlignment = .left
        return lb
    }()
    
    let toiletImageView: UIImageView = {
        let iv = UIImageView()
        iv.tintColor = UIColor.rgb(red: 204, green: 204, blue: 204)
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let toiletLabel: UILabel = {
        let lb = UILabel()
        // letter spacing -0.1
        let attributedString = NSMutableAttributedString(string: "Public Toilet")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(-0.1), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.textColor = UIColor.rgb(red: 102, green: 102, blue: 102)
        lb.font = UIFont(name: "DMSans-Regular", size: 14)
        lb.textAlignment = .left
        return lb
    }()
    
    let openImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "time_gray")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let openTimeLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor.rgb(red: 102, green: 102, blue: 102)
        lb.font = UIFont(name: "DMSans-Regular", size: 14)
        lb.textAlignment = .left
        return lb
    }()
    
    let menuImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "magazine_menu")
        iv.backgroundColor = .white
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let menuLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor.rgb(red: 102, green: 102, blue: 102)
        lb.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
        lb.textAlignment = .left
        return lb
    }()
    
    let callImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "phone")
        iv.image = iv.image?.withRenderingMode(.alwaysTemplate)
        iv.tintColor = UIColor.rgb(red: 204, green: 204, blue: 204)
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let callLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor.rgb(red: 102, green: 102, blue: 102)
        lb.font = UIFont(name: "DMSans-Regular", size: 14)
        lb.textAlignment = .left
        return lb
    }()
    
    let detailLabel: UILabel = {
        let lb = UILabel()
        // letter spacing 1.0
        let attributedString = NSMutableAttributedString(string: "DETAILS")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(1.0), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.textColor = .white
        lb.font = UIFont(name: "DMSans-Bold", size: 14)
        lb.textAlignment = .center
        lb.layer.cornerRadius = 12
        lb.layer.masksToBounds = true
        lb.backgroundColor = .mainColor
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var restaurantImageViewConstraint: NSLayoutConstraint?
    var magazineTitleLabelConstraint: NSLayoutConstraint?
    var infoViewConstraint: NSLayoutConstraint?
    var restaurantNameLabelConstraint: NSLayoutConstraint?
    var pageIndicatorLabelConstraint: NSLayoutConstraint?
    var cosmosViewConstraint: NSLayoutConstraint?
    var pointLabelConstraint: NSLayoutConstraint?
    var locationImageViewConstraint: NSLayoutConstraint?
    var locationLabelConstraint: NSLayoutConstraint?
    var toiletImageViewConstraint: NSLayoutConstraint?
    var toiletLabelConstraint: NSLayoutConstraint?
    var openImageViewConstraint: NSLayoutConstraint?
    var openTimeLabelConstraint: NSLayoutConstraint?
    var menuImageViewConstraint: NSLayoutConstraint?
    var menuLabelConstraint: NSLayoutConstraint?
    var callImageViewConstraint: NSLayoutConstraint?
    var callLabelConstraint: NSLayoutConstraint?
    var detailLabelConstraint: NSLayoutConstraint?
    
    fileprivate func setupViews() {

        addSubview(restaurantImageView)
        addSubview(infoView)
        addSubview(magazineTitleLabel)
        addSubview(restaurantNameLabel)
        addSubview(pageIndicatorLabel)
        addSubview(cosmosView)
        addSubview(pointLabel)
        addSubview(locationImageView)
        addSubview(locationLabel)
        addSubview(toiletImageView)
        addSubview(toiletLabel)
        addSubview(openImageView)
        addSubview(openTimeLabel)
        addSubview(menuImageView)
        addSubview(menuLabel)
        addSubview(callImageView)
        addSubview(callLabel)
        addSubview(detailLabel)

        restaurantImageViewConstraint = restaurantImageView.anchor(self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 374 - 70, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
        infoViewConstraint = infoView.anchor(nil, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: -45 + 10, rightConstant: 0, widthConstant: 0, heightConstant: 374).first
        magazineTitleLabelConstraint = magazineTitleLabel.anchor(nil, left: self.leftAnchor, bottom: infoView.topAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 24, bottomConstant: 0, rightConstant: 47, widthConstant: 0, heightConstant: 64).first
        restaurantNameLabelConstraint = restaurantNameLabel.anchor(infoView.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 44, leftConstant: 50, bottomConstant: 0, rightConstant: 50, widthConstant: 0, heightConstant: 28).first
        pageIndicatorLabelConstraint = pageIndicatorLabel.anchor(restaurantNameLabel.topAnchor, left: nil, bottom: nil, right: self.rightAnchor, topConstant: -14, leftConstant: 0, bottomConstant: 0, rightConstant: 24, widthConstant: 56, heightConstant: 56).first
        cosmosViewConstraint = cosmosView.anchor(restaurantNameLabel.bottomAnchor, left: self.leftAnchor, bottom: nil, right: nil, topConstant: 10, leftConstant: 50, bottomConstant: 0, rightConstant: 0, widthConstant: 84, heightConstant: 16).first
        pointLabelConstraint = pointLabel.anchor(restaurantNameLabel.bottomAnchor, left: cosmosView.rightAnchor, bottom: nil, right: self.rightAnchor, topConstant: 8, leftConstant: 4, bottomConstant: 0, rightConstant: 50, widthConstant: 0, heightConstant: 20).first
        locationImageViewConstraint = locationImageView.anchor(cosmosView.bottomAnchor, left: self.leftAnchor, bottom: nil, right: nil, topConstant: 18, leftConstant: 50, bottomConstant: 0, rightConstant: 0, widthConstant: 16, heightConstant: 16).first
        locationLabelConstraint = locationLabel.anchor(cosmosView.bottomAnchor, left: locationImageView.rightAnchor, bottom: nil, right: self.rightAnchor, topConstant: 16, leftConstant: 8, bottomConstant: 0, rightConstant: 50, widthConstant: 0, heightConstant: 20).first
        toiletImageViewConstraint = toiletImageView.anchor(locationImageView.bottomAnchor, left: self.leftAnchor, bottom: nil, right: nil, topConstant: 12, leftConstant: 50, bottomConstant: 0, rightConstant: 0, widthConstant: 16, heightConstant: 16).first
        toiletLabelConstraint = toiletLabel.anchor(locationImageView.bottomAnchor, left: toiletImageView.rightAnchor, bottom: nil, right: self.rightAnchor, topConstant: 10, leftConstant: 8, bottomConstant: 0, rightConstant: 50, widthConstant: 0, heightConstant: 20).first
        openImageViewConstraint = openImageView.anchor(toiletImageView.bottomAnchor, left: self.leftAnchor, bottom: nil, right: nil, topConstant: 12, leftConstant: 50, bottomConstant: 0, rightConstant: 0, widthConstant: 16, heightConstant: 16).first
        openTimeLabelConstraint = openTimeLabel.anchor(toiletImageView.bottomAnchor, left: openImageView.rightAnchor, bottom: nil, right: self.rightAnchor, topConstant: 10, leftConstant: 8, bottomConstant: 0, rightConstant: 50, widthConstant: 0, heightConstant: 20).first
        menuImageViewConstraint = menuImageView.anchor(openImageView.bottomAnchor, left: self.leftAnchor, bottom: nil, right: nil, topConstant: 12, leftConstant: 50, bottomConstant: 0, rightConstant: 0, widthConstant: 16, heightConstant: 16).first
        menuLabelConstraint = menuLabel.anchor(openImageView.bottomAnchor, left: menuImageView.rightAnchor, bottom: nil, right: self.rightAnchor, topConstant: 10, leftConstant: 8, bottomConstant: 0, rightConstant: 50, widthConstant: 0, heightConstant: 20).first
        callImageViewConstraint = callImageView.anchor(menuImageView.bottomAnchor, left: self.leftAnchor, bottom: nil, right: nil, topConstant: 12, leftConstant: 50, bottomConstant: 0, rightConstant: 0, widthConstant: 16, heightConstant: 16).first
        callLabelConstraint = callLabel.anchor(menuImageView.bottomAnchor, left: callImageView.rightAnchor, bottom: nil, right: self.rightAnchor, topConstant: 10, leftConstant: 8, bottomConstant: 0, rightConstant: 50, widthConstant: 0, heightConstant: 20).first
        detailLabelConstraint = detailLabel.anchor(callLabel.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 29, leftConstant: 50, bottomConstant: 0, rightConstant: 50, widthConstant: 0, heightConstant: 56).first

    }
    
    fileprivate func checkToilet() {
        if toilet == "남녀구분" {
            toiletImageView.image = UIImage(named: "Seperate Toilet")?.withRenderingMode(.alwaysTemplate)
        }
        else {
            toiletImageView.image = UIImage(named: "Unisex Toilet")?.withRenderingMode(.alwaysTemplate)

        }
    }
}

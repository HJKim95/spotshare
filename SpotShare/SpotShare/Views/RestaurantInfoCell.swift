//
//  RestaurantInfoCell.swift
//  SpotShare
//
//  Created by 김희중 on 12/11/2019.
//  Copyright © 2019 김희중. All rights reserved.
//

import UIKit
import GoogleMaps
import Firebase

class RestaurantInfoCell: UICollectionViewCell, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    fileprivate let cellid = "cellid"
    
    weak var delegate: bigRestaurantCell?
    
    weak var resinfo: ResInfoModel? {
        didSet {
            guard let location = resinfo?.resLocation else {return}
            getMap(lat: location.latitude, long: location.longitude)
            if let resname = resinfo?.resName {
                getResData_firebase(resName: resname)
            }
        }
    }
    
    var mapBackView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    let phoneNumberLabel: UILabel = {
        let lb = UILabel()
        lb.backgroundColor = .clear
        lb.textColor = .mainGray
        // letter spacing 1.0
        lb.letterSpacing(text: "PHONE NUMBER", spacing: 1.0)
        lb.font = UIFont(name: "DMSans-Medium", size: 12)
        lb.numberOfLines = 0
        lb.textAlignment = .left
        return lb
    }()
    
    let numberLabel: UILabel = {
        let lb = UILabel()
        lb.backgroundColor = .clear
        lb.textColor = .darkGray
        lb.font = UIFont(name: "DMSans-Regular", size: 14)
        lb.numberOfLines = 0
        lb.textAlignment = .left
        return lb
    }()
    
    let dividerLine: UIView = {
        let viewview = UIView()
        viewview.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        return viewview
    }()
    
    let mainMenuLabel: UILabel = {
        let lb = UILabel()
        lb.backgroundColor = .clear
        lb.textColor = .mainGray
        // letter spacing 1.0
        lb.letterSpacing(text: "MAIN MENU", spacing: 1.0)
        lb.font = UIFont(name: "DMSans-Medium", size: 12)
        lb.numberOfLines = 0
        lb.textAlignment = .left
        return lb
    }()
    
    let menuLabel: UILabel = {
        let lb = UILabel()
        lb.backgroundColor = .clear
        lb.textColor = .darkGray
        lb.font = UIFont(name: "DMSans-Regular", size: 14)
        lb.numberOfLines = 0
        lb.textAlignment = .left
        return lb
    }()
    
    let dividerLine2: UIView = {
        let viewview = UIView()
        viewview.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        return viewview
    }()
    
    let priceRangeLabel: UILabel = {
        let lb = UILabel()
        lb.backgroundColor = .clear
        lb.textColor = .mainGray
        // letter spacing 1.0
        lb.letterSpacing(text: "PRICE RANGE", spacing: 1.0)
        lb.font = UIFont(name: "DMSans-Medium", size: 12)
        lb.numberOfLines = 0
        lb.textAlignment = .left
        return lb
    }()
    
    let priceLabel: UILabel = {
        let lb = UILabel()
        lb.backgroundColor = .clear
        lb.textColor = .darkGray
        lb.font = UIFont(name: "DMSans-Regular", size: 14)
        lb.numberOfLines = 0
        lb.textAlignment = .left
        return lb
    }()
    
    let dividerLine3: UIView = {
        let viewview = UIView()
        viewview.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        return viewview
    }()
    
    let dayOffLabel: UILabel = {
        let lb = UILabel()
        lb.backgroundColor = .clear
        lb.textColor = .mainGray
        // letter spacing 1.0
        lb.letterSpacing(text: "DAY OFF", spacing: 1.0)
        lb.font = UIFont(name: "DMSans-Medium", size: 12)
        lb.numberOfLines = 0
        lb.textAlignment = .left
        return lb
    }()
    
    let offLabel: UILabel = {
        let lb = UILabel()
        lb.backgroundColor = .clear
        lb.textColor = .darkGray
        lb.font = UIFont(name: "DMSans-Regular", size: 14)
        lb.numberOfLines = 0
        lb.textAlignment = .left
        return lb
    }()
    
    let dividerLine4: UIView = {
        let viewview = UIView()
        viewview.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        return viewview
    }()
    
    let reservationTitleLabel: UILabel = {
        let lb = UILabel()
        lb.backgroundColor = .clear
        lb.textColor = .mainGray
        // letter spacing 1.0
        lb.letterSpacing(text: "RESERVATION", spacing: 1.0)
        lb.font = UIFont(name: "DMSans-Medium", size: 12)
        lb.numberOfLines = 0
        lb.textAlignment = .left
        return lb
    }()
    
    let reservationLabel: UILabel = {
        let lb = UILabel()
        lb.backgroundColor = .clear
        lb.textColor = .darkGray
        lb.font = UIFont(name: "DMSans-Regular", size: 14)
        lb.numberOfLines = 0
        lb.textAlignment = .left
        return lb
    }()
    
    let dividerLine5: UIView = {
        let viewview = UIView()
        viewview.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        return viewview
    }()
    
    lazy var improveLabel: UILabel = {
        let lb = UILabel()
        lb.backgroundColor = .clear
        lb.textColor = .mainColor
        // letter spacing 0.86
        lb.letterSpacing(text: "IMPROVE THIS LISTING", spacing: 0.86)
        lb.font = UIFont(name: "DMSans-Bold", size: 12)
        lb.numberOfLines = 0
        lb.textAlignment = .center
        lb.isUserInteractionEnabled = true
        lb.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(improveListing)))
        return lb
    }()
    
    let dividerLine6: UIView = {
        let viewview = UIView()
        viewview.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        return viewview
    }()
    
    let recommendLabel: UILabel = {
        let lb = UILabel()
        lb.backgroundColor = .clear
        lb.textColor = .mainGray
        // letter spacing 1.0
        lb.letterSpacing(text: "YOU MAY ALSO LIKE", spacing: 1.0)
        lb.font = UIFont(name: "DMSans-Medium", size: 12)
        lb.numberOfLines = 0
        lb.textAlignment = .left
        return lb
    }()
    
    let questionImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "questionMark")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    lazy var recommendCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 15
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.dataSource = self
        cv.delegate = self
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .white
        cv.alwaysBounceHorizontal = true
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var mapBackViewConstraint: NSLayoutConstraint?
    var phoneNumberLabelConstraint: NSLayoutConstraint?
    var numberLabelConstraint: NSLayoutConstraint?
    var dividerLineConstraint: NSLayoutConstraint?
    var mainMenuLabelConstraint: NSLayoutConstraint?
    var menuLabelConstraint: NSLayoutConstraint?
    var dividerLine2Constraint: NSLayoutConstraint?
    var priceRangeLabelConstraint: NSLayoutConstraint?
    var priceLabelConstraint: NSLayoutConstraint?
    var dividerLine3Constraint: NSLayoutConstraint?
    var dayOffLabelConstraint: NSLayoutConstraint?
    var offLabelConstraint: NSLayoutConstraint?
    var dividerLine4Constraint: NSLayoutConstraint?
    var reservationTitleLabelConstraint: NSLayoutConstraint?
    var reservationLabelConstraint: NSLayoutConstraint?
    var dividerLine5Constraint: NSLayoutConstraint?
    var improveLabelConstraint: NSLayoutConstraint?
    var dividerLine6Constraint: NSLayoutConstraint?
    var recommendLabelConstraint: NSLayoutConstraint?
    var questionImageViewConstraint: NSLayoutConstraint?
    var recommendCollectionViewConstraint: NSLayoutConstraint?
    
    
    
    fileprivate func setupViews() {
        
        backgroundColor = .white
        recommendCollectionView.register(innerSpotCell.self, forCellWithReuseIdentifier: cellid)

        
        addSubview(phoneNumberLabel)
        addSubview(numberLabel)
        addSubview(dividerLine)
        addSubview(mainMenuLabel)
        addSubview(menuLabel)
        addSubview(dividerLine2)
        addSubview(priceRangeLabel)
        addSubview(priceLabel)
        addSubview(dividerLine3)
        addSubview(dayOffLabel)
        addSubview(offLabel)
        addSubview(dividerLine4)
        addSubview(reservationTitleLabel)
        addSubview(reservationLabel)
        addSubview(dividerLine5)
        addSubview(improveLabel)
        addSubview(dividerLine6)
        addSubview(recommendLabel)
        addSubview(questionImageView)
        addSubview(recommendCollectionView)
        
        
        phoneNumberLabelConstraint = phoneNumberLabel.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 140 + 16, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 18).first
        numberLabelConstraint = numberLabel.anchor(phoneNumberLabel.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 8, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 20).first
        dividerLineConstraint = dividerLine.anchor(numberLabel.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 16, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0.5).first
        mainMenuLabelConstraint = mainMenuLabel.anchor(dividerLine.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 16, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 18).first
        menuLabelConstraint = menuLabel.anchor(mainMenuLabel.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 8, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 20).first
        dividerLine2Constraint = dividerLine2.anchor(menuLabel.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 16, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0.5).first
        priceRangeLabelConstraint = priceRangeLabel.anchor(dividerLine2.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 16, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 18).first
        priceLabelConstraint = priceLabel.anchor(priceRangeLabel.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 8, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 20).first
        dividerLine3Constraint = dividerLine3.anchor(priceLabel.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 16, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0.5).first
        dayOffLabelConstraint = dayOffLabel.anchor(dividerLine3.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 16, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 18).first
        offLabelConstraint = offLabel.anchor(dayOffLabel.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 8, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 20).first
        dividerLine4Constraint = dividerLine4.anchor(offLabel.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 16, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0.5).first
        reservationTitleLabelConstraint = reservationTitleLabel.anchor(dividerLine4.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 16, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 18).first
        reservationLabelConstraint = reservationLabel.anchor(reservationTitleLabel.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 8, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 20).first
        dividerLine5Constraint = dividerLine5.anchor(reservationLabel.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 16, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0.5).first
        improveLabelConstraint = improveLabel.anchor(dividerLine5.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 16, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 16).first
        dividerLine6Constraint = dividerLine6.anchor(improveLabel.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 16, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0.5).first
        
        recommendLabelConstraint = recommendLabel.anchor(dividerLine6.bottomAnchor, left: self.leftAnchor, bottom: nil, right: nil, topConstant: 30, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 130, heightConstant: 18).first
        questionImageViewConstraint = questionImageView.anchor(dividerLine6.bottomAnchor, left: nil, bottom: nil, right: self.rightAnchor, topConstant: 29, leftConstant: 0, bottomConstant: 0, rightConstant: 24, widthConstant: 20, heightConstant: 20).first
        
        recommendCollectionViewConstraint = recommendCollectionView.anchor(questionImageView.bottomAnchor
            , left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 2, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 157).first
    }
    
    fileprivate func getMap(lat:CLLocationDegrees, long: CLLocationDegrees) {
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 16.0)
        let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        mapView.isUserInteractionEnabled = false
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
        marker.icon = UIImage(named: "marker_pin")
        marker.map = mapView
        
        mapBackView = mapView
        addSubview(mapBackView)
        mapBackViewConstraint = mapBackView.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 140).first
        
        let fadeView = UIView()
        fadeView.backgroundColor = .black
        fadeView.alpha = 0.05
        addSubview(fadeView)
        fadeView.frame = CGRect(x: 0, y: 0, width: frame.width, height: 140)
    }
    
    fileprivate func getResData_firebase(resName: String) {
        let reference = Database.database().reference().child("맛집").child(resName)
                    
        reference.observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
            if let dictionary = snapshot.value as? [String:Any] {
                
                guard let number = (dictionary["telephone"] as? String) else {return}
                guard let menu = dictionary["resMenu"] as? String else {return}
                guard let price = (dictionary["resPrice"] as? String) else {return}
                guard let hoilday = (dictionary["holidays"] as? String) else {return}
                guard let reservation = dictionary["reservation"] as? String else {return}
                
                // letter spacing -0.1
                self?.numberLabel.letterSpacing(text: number, spacing: -0.1)
                self?.menuLabel.letterSpacing(text: menu, spacing: -0.1)
                self?.priceLabel.letterSpacing(text: price, spacing: -0.1)
                self?.offLabel.letterSpacing(text: hoilday, spacing: -0.1)
                self?.reservationLabel.letterSpacing(text: reservation, spacing: -0.1)
                
            }
            
        }, withCancel: { (err) in
            print("Failed to fetch resMonthData:", err)
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath) as! innerSpotCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 156, height: collectionView.frame.height)
    }
    
    @objc func improveListing() {
        delegate?.goImproveListing()
    }
}




//
//  RestaurantHeaderView.swift
//  SpotShare
//
//  Created by 김희중 on 03/11/2019.
//  Copyright © 2019 김희중. All rights reserved.
//

import UIKit
import Cosmos
import Firebase
import GoogleMaps
import SDWebImage

// https://github.com/evgenyneu/Cosmos

class RestaurantHeaderCell: UICollectionViewCell, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    weak var resinfo: ResInfoModel? {
        didSet {
            guard let resname = resinfo?.resName else {return}
            getResImage_firebase(resName: resname)
            // letter spacing -0.3
            resName.letterSpacing(text: resname, spacing: -0.3)
            
            cosmosView.rating = resinfo?.starPoint ?? 4.5
            // letter spacing -0.3
            pointLabel.letterSpacing(text: String(resinfo?.starPoint ?? 4.5), spacing: -0.3)
            
            locationLabel.text = resinfo?.locationText
            
            toiletLabel.text = resinfo?.toilet ?? "공용"
            if toiletLabel.text == "공용"{
                toiletImageView.image = UIImage(named: "Unisex Toilet")?.withRenderingMode(.alwaysTemplate)
            }
            
            else {
                toiletImageView.image = UIImage(named: "Seperate Toilet")?.withRenderingMode(.alwaysTemplate)
            }
            
            hashtagArray.append(resinfo?.hash1 ?? "")
            hashtagArray.append(resinfo?.hash2 ?? "")
            hashtagArray.append(resinfo?.hash3 ?? "")
            hashtagArray.append(resinfo?.hash4 ?? "")
            hashtagArray.append(resinfo?.hash5 ?? "")
            
            guard var open: String = resinfo?.open else {return}
            // open 값만 현재 받아와서 보여줬음. 이제 이후로 close값 받아오고 지금 open인지 여부도 확인하고 open누르면 요일마다 시간나오게 하고 그러면 됨.
            let index = open.index(open.startIndex, offsetBy: 2)
            open.insert(":", at: index)
            openTimeLabel.text = "Opens \(open)"
        }
    }
    
    let cellid = "cellid"
    let resImageid = "resImageid"
    
    lazy var resImageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.dataSource = self
        cv.delegate = self
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .clear
        cv.alwaysBounceHorizontal = true
        cv.isPagingEnabled = true
        return cv
    }()
    
    let resName: UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor.mainText
        lb.font = UIFont(name: "DMSans-Medium", size: 28)
        lb.textAlignment = .left
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
        lb.textColor = UIColor.mainGray
        lb.font = UIFont(name: "DMSans-Regular", size: 14)
        lb.textAlignment = .left
        return lb
    }()
    
    let locationLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor.mainGray
        lb.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12)
        lb.textAlignment = .left
        return lb
    }()
    
    let distanceImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "distance")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let distanceLabel: UILabel = {
        let lb = UILabel()
        lb.text = "14 min walk"
        lb.textColor = UIColor.mainGray
        lb.font = UIFont(name: "DMSans-Regular", size: 12)
        lb.textAlignment = .left
        return lb
    }()
    
    let toiletImageView: UIImageView = {
        let iv = UIImageView()
        iv.tintColor = UIColor.mainGray
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let toiletLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor.mainGray
        lb.font = UIFont(name: "DMSans-Regular", size: 12)
        lb.textAlignment = .left
        return lb
    }()
    
    let OpenCloseLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Closed"
        lb.textColor = UIColor.mainGray
        lb.font = UIFont(name: "DMSans-Regular", size: 12)
        lb.textAlignment = .left
        return lb
    }()
    
    let seperatorImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "seperator")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let openTimeLabel: UILabel = {
        let lb = UILabel()
//        lb.text = "Opens 09:00"
        lb.textColor = UIColor.mainGray
        lb.font = UIFont(name: "DMSans-Regular", size: 12)
        lb.textAlignment = .left
        return lb
    }()
    
    lazy var hashCollecionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.dataSource = self
        cv.delegate = self
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .white
        return cv
    }()
    
    var hashtagArray = [String]()
    
    var resImageCollectionViewConstraint: NSLayoutConstraint?
    var resNameConstraint: NSLayoutConstraint?
    var cosmosViewConstraint: NSLayoutConstraint?
    var pointLabelConstraint: NSLayoutConstraint?
    var locationLabelConstraint: NSLayoutConstraint?
    var distanceImageViewConstraint: NSLayoutConstraint?
    var distanceLabelConstraint: NSLayoutConstraint?
    var toiletImageViewConstraint: NSLayoutConstraint?
    var toiletLabelConstraint: NSLayoutConstraint?
    var OpenCloseLabelConstraint: NSLayoutConstraint?
    var seperatorImageViewConstraint: NSLayoutConstraint?
    var openTimeConstraint: NSLayoutConstraint?
    var hashCollecionViewConstraint: NSLayoutConstraint?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupViews() {
        
        resImageCollectionView.register(resImageCell.self, forCellWithReuseIdentifier: resImageid)
        hashCollecionView.register(infoHashCell.self, forCellWithReuseIdentifier: cellid)
        
        
        addSubview(resImageCollectionView)
        addSubview(resName)
        addSubview(cosmosView)
        addSubview(pointLabel)
        addSubview(locationLabel)
        addSubview(distanceImageView)
        addSubview(distanceLabel)
        addSubview(toiletImageView)
        addSubview(toiletLabel)
        addSubview(OpenCloseLabel)
        addSubview(seperatorImageView)
        addSubview(openTimeLabel)
        addSubview(hashCollecionView)
        
//        let barheight = UIApplication.shared.statusBarFrame.height
        resImageCollectionViewConstraint = resImageCollectionView.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: frame.width - 50).first
        resNameConstraint = resName.anchor(resImageCollectionView.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 12, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 38).first
        //16*5 + 1*4
        cosmosViewConstraint = cosmosView.anchor(resName.bottomAnchor, left: self.leftAnchor, bottom: nil, right: nil, topConstant: 6, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 84, heightConstant: 16).first
        pointLabelConstraint = pointLabel.anchor(resName.bottomAnchor, left: cosmosView.rightAnchor, bottom: nil, right: nil, topConstant: 4, leftConstant: 4, bottomConstant: 0, rightConstant: 0, widthConstant: 20, heightConstant: 20).first
        locationLabelConstraint = locationLabel.anchor(cosmosView.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 12, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 16).first
        distanceImageViewConstraint = distanceImageView.anchor(locationLabel.bottomAnchor, left: self.leftAnchor, bottom: nil, right: nil, topConstant: 8, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 16, heightConstant: 16).first
        distanceLabelConstraint = distanceLabel.anchor(locationLabel.bottomAnchor, left: distanceImageView.rightAnchor, bottom: nil, right: nil, topConstant: 8, leftConstant: 4, bottomConstant: 0, rightConstant: 0, widthConstant: 62, heightConstant: 16).first
        toiletImageViewConstraint = toiletImageView.anchor(locationLabel.bottomAnchor, left: distanceLabel.rightAnchor, bottom: nil, right: nil, topConstant: 8, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 16, heightConstant: 16).first
        toiletLabelConstraint = toiletLabel.anchor(locationLabel.bottomAnchor, left: toiletImageView.rightAnchor, bottom: nil, right: self.rightAnchor, topConstant: 8, leftConstant: 4, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 16).first
        OpenCloseLabelConstraint = OpenCloseLabel.anchor(distanceImageView.bottomAnchor, left: self.leftAnchor, bottom: nil, right: nil, topConstant: 8, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 39, heightConstant: 16).first
        seperatorImageViewConstraint = seperatorImageView.anchor(distanceLabel.bottomAnchor, left: OpenCloseLabel.rightAnchor, bottom: nil, right: nil, topConstant: 12, leftConstant: 5, bottomConstant: 0, rightConstant: 0, widthConstant: 9, heightConstant: 9).first
        openTimeConstraint = openTimeLabel.anchor(distanceLabel.bottomAnchor, left: seperatorImageView.rightAnchor, bottom: nil, right: self.rightAnchor, topConstant: 8, leftConstant: 4, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 16).first
        hashCollecionViewConstraint = hashCollecionView.anchor(OpenCloseLabel.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 10, leftConstant: 24, bottomConstant: 0, rightConstant: 5, widthConstant: 0, heightConstant: 30).first
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == resImageCollectionView {
            return resImageInfos.count
        }
        return hashtagArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == resImageCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: resImageid, for: indexPath) as! resImageCell
            let url = URL(string: resImageInfos[indexPath.item])
            cell.resImageView.sd_setImage(with: url, completed: nil)
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath) as! infoHashCell
        // letter spacing -0.1
        cell.hashLabel.letterSpacing(text: "#" + hashtagArray[indexPath.item], spacing: -0.1)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == resImageCollectionView {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }
        // 밑에 frame의 width에 따라 width가 너무 작으면 오류가 나더라.. constraint관련해서
        let frame = CGRect(x: 0, y: 0, width:  1000, height: 24)
        let dummyCell = infoHashCell(frame: frame)
        // letter spacing -0.1
        dummyCell.hashLabel.letterSpacing(text: "#" + hashtagArray[indexPath.item], spacing: -0.1)
        dummyCell.layoutIfNeeded()

        let textWidth = dummyCell.hashLabel.sizeThatFits(dummyCell.hashLabel.frame.size).width + 10

        return CGSize(width: textWidth, height: 24)
    }
    
    var resImageInfos = [String]()
    
    fileprivate func getResImage_firebase(resName: String) {
        let reference = Database.database().reference().child("맛집").child(resName).child("FirstResimage")
                    
        reference.observe(.childAdded, with: { [weak self] (snapshot) in
            if let dictionary = snapshot.value as? [String:Any] {
                guard let url = dictionary["url"] as? String else {return}
                self?.resImageInfos.append(url)
            }
            
            DispatchQueue.main.async {
                self?.resImageCollectionView.reloadData()
            }
            
        }, withCancel: { (err) in
            print("Failed to fetch resMonthData:", err)
        })
    }
}

class resImageCell: UICollectionViewCell {
    
    let resImageView: UIImageView = {
        let iv = UIImageView()
//        iv.image = UIImage(named: "imsi_restaurant")
        iv.contentMode = .scaleAspectFill
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
    
    var resImageViewConstraint: NSLayoutConstraint?
    
    fileprivate func setupLayouts() {
        addSubview(resImageView)
        resImageViewConstraint = resImageView.anchor(self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
    }
}

class infoHashCell: UICollectionViewCell {
    
    let hashLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor.mainGray
        lb.font = UIFont(name: "DMSans-Regular", size: 14)
        lb.textAlignment = .center
        lb.layer.cornerRadius = 5
        lb.layer.masksToBounds = true
        lb.layer.borderColor = UIColor.lightGray.cgColor
        lb.layer.borderWidth = 1
        return lb
    }()
    
    var hashLabelConstraint: NSLayoutConstraint?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupViews() {
        addSubview(hashLabel)
        
        hashLabelConstraint = hashLabel.anchor(self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
    }
    
}

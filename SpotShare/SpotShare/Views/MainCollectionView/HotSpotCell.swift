//
//  HotSpotCell.swift
//  SpotShare
//
//  Created by 김희중 on 21/07/2019.
//  Copyright © 2019 김희중. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps
import SDWebImage

class HotSpotCell: UICollectionViewCell, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, CLLocationManagerDelegate {
    
    let cellid = "cellid"
    
    weak var delegate: MainCollectionCell?
    var locationManager = CLLocationManager()
    
    let categoryNameLabel: UILabel = {
        let lb = UILabel()
        lb.backgroundColor = .white
        lb.font = UIFont(name: "DMSans-Medium", size: 12)
        lb.textColor = .lightGray
        lb.textAlignment = .left
        return lb
    }()
    
    lazy var innerSpotCollectionview: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionview.backgroundColor = .white
        collectionview.delegate = self
        collectionview.dataSource = self
        return collectionview
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var categoryNameLabelConstraint: NSLayoutConstraint?
    var innerSpotCollectionviewConstraint: NSLayoutConstraint?
    
    //total cell size 380 - 376
    //42+18+16+(97+9+18+1+16)*2+20 + (2)
    fileprivate func setupViews() {
        backgroundColor = .white
        
        addSubview(categoryNameLabel)
        addSubview(innerSpotCollectionview)
        
        
        categoryNameLabelConstraint = categoryNameLabel.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 42, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 18).first
        innerSpotCollectionviewConstraint = innerSpotCollectionview.anchor(categoryNameLabel.bottomAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 24, bottomConstant: 2, rightConstant: 24, widthConstant: 0, heightConstant: 0).first

        innerSpotCollectionview.register(innerSpotCell.self, forCellWithReuseIdentifier: cellid)
        
//        locationManager.delegate = self
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.startUpdatingLocation()
        getHotSpot_firebase(location: myLocation)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while get location \(error)")
    }
    
    var myLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 37.537774, longitude: 127.072661)
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("위치 받아오는중... Hot Spot Cell")
        let location = locations.last
        
        guard let lat = location?.coordinate.latitude else {return}
        guard let long = location?.coordinate.longitude else {return}
        let convertLocation = CLLocationCoordinate2D(latitude: lat, longitude: long)
//        self.myLocation = convertLocation
        getHotSpot_firebase(location: myLocation)
        self.locationManager.stopUpdatingLocation()
    }
    

    var resInfos = [ResInfoModel]()
    
    fileprivate func getHotSpot_firebase(location: CLLocationCoordinate2D) {
        print("Hot Spot firebase...")
        let ref = Database.database().reference().child("추천")
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
                    resInfo.distance = location.distance(from: CLLocationCoordinate2D(latitude: lat, longitude: long))
                    resInfo.locationText = (dictionary["location"] as? String)
                    resInfo.toilet = dictionary["toilet"] as? String
                    
                    
                   // 내가 봤을땐 .value 구하는게 .childAdded보다 먼저 실행되서 .childAdded에 append를 해주어야 되는것같음.
                    // 해당 맛집에서 hashtag 따오기
                    let ref = Database.database().reference().child("맛집").child(snapid).child("hashTag")
                    ref.observeSingleEvent(of: .value) { (snapshot) in
                        if let dictionary = snapshot.value as? [String:Any] {
                            // 만약 hashTag가 DB에 없다면 결국 최종 append가 안된다고 생각.
                            resInfo.hash1 = dictionary["hash1"] as? String ?? ""
                            resInfo.hash2 = dictionary["hash2"] as? String ?? ""
                            resInfo.hash3 = dictionary["hash3"] as? String ?? ""
                            resInfo.hash4 = dictionary["hash4"] as? String ?? ""
                            resInfo.hash5 = dictionary["hash5"] as? String ?? ""
                        }
                    }
                    
                    // 해당 맛집에서 첫번째 이미지 따오기.
                    let firstImageReference = Database.database().reference().child("맛집").child(snapid).child("FirstResimage")
                    firstImageReference.observeSingleEvent(of: .childAdded, with: { [weak self] (snapshot) in
                        if let dictionary = snapshot.value as? [String:Any] {
                            resInfo.resImageUrl = dictionary["url"] as? String
                            self?.resInfos.append(resInfo)
                            if self?.resInfos.count ?? 0 > 4 {
                                return
                            }
                        }
                        DispatchQueue.main.async {
                            self?.innerSpotCollectionview.reloadData()
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
    

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resInfos.count
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath) as! innerSpotCell
        
        let resinfo = resInfos[indexPath.item]
        cell.resLabel.letterSpacing(text: resinfo.resName ?? "", spacing: -0.1)
        let point = resinfo.starPoint ?? 3.5
        cell.pointLabel.text = "\(String(describing: point))"
        if point < 3.0 {
            cell.pointLabel.backgroundColor = .pink
            }
        else if point < 4 {
            cell.pointLabel.backgroundColor = .wheat
            }
        else {
            cell.pointLabel.backgroundColor = .lightGreen
            }
        cell.toiletLabel.text = resinfo.toilet
        cell.toilet = resinfo.toilet
        var distanceString = ""
        if let distance = resinfo.distance {
            if distance < 1000.0 {
                distanceString = String(format: "%.0f", distance) + "m"
            }
            else {
                let kmDistance = distance / 1000.0
                distanceString = String(format: "%.0f", kmDistance) + "km"
            }
        }
        cell.distanceLabel.text = distanceString
        
        let url = URL(string: resinfo.resImageUrl ?? "")
        cell.resImageView.sd_setImage(with: url, completed: nil)
        
        //이런식으로 indexPath.item 넘겨주기.
        cell.tag = indexPath.item
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goRestaurant(sender:))))
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 16(위 여백) + 97 + 9 + 18 + 1 + 16
        let width = (self.frame.width - (24+15+24) ) / 2
        // 9 + 18 + 1 + 16
        return CGSize(width: width, height: width + 44)
    }
    
    @objc fileprivate func goRestaurant(sender: UITapGestureRecognizer) {
        let indexPath = IndexPath(item: sender.view?.tag ?? 0, section: 0)
        let resinfo = resInfos[indexPath.item]
        delegate?.goRestaurant(resinfo: resinfo)
    }
    
}




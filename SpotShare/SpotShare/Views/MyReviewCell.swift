//
//  MyReviewCell.swift
//  SpotShare
//
//  Created by 김희중 on 08/08/2019.
//  Copyright © 2019 김희중. All rights reserved.
//

import UIKit
import collection_view_layouts
import Cosmos
import GoogleMaps

// https://github.com/rubygarage/collection-view-layouts
// https://github.com/evgenyneu/Cosmos

class MyReviewCell: UICollectionViewCell, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource  {
    
    fileprivate let gridid = "gridid"
    fileprivate let mapid = "mapid"
    
    var mypagecell: ProfileScrollCell?
    
    
    
    let dividerLine: UIView = {
        let viewview = UIView()
        viewview.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        return viewview
    }()
    
    lazy var viewMapLabel: UILabel = {
        let lb = UILabel()
        // https://zeddios.tistory.com/406
        let attributedString = NSMutableAttributedString(string: "VIEW AS A MAP  ")
        // line spacing 0.86
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(0.86), range: NSRange(location: 0, length: attributedString.length))
        let mapImage = NSTextAttachment()
        mapImage.image = UIImage(named: "review_map")
        mapImage.bounds = CGRect(x: 0, y: -3.5, width: 16, height: 16)
        attributedString.append(NSAttributedString(attachment: mapImage))
        lb.attributedText = attributedString
        lb.font = UIFont(name: "DMSans-Bold", size: 12)
        lb.textColor = .black
        lb.textAlignment = .center
        lb.sizeToFit()
        lb.numberOfLines = 0
        lb.isUserInteractionEnabled = true
        lb.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickMap)))
        return lb
    }()
    
    let dividerLine2: UIView = {
        let viewview = UIView()
        viewview.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        return viewview
    }()
    
    lazy var innerReviewCollectionview: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.showsVerticalScrollIndicator = false
        collectionview.isPagingEnabled = true
        collectionview.isScrollEnabled = false
        collectionview.backgroundColor = .white
        return collectionview
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var dividerLineConstraint: NSLayoutConstraint?
    var viewMapLabelConstraint: NSLayoutConstraint?
    var innerReviewCollectionviewConstraint: NSLayoutConstraint?
    var dividerLine2Constraint: NSLayoutConstraint?
    
    fileprivate func setupView() {
        backgroundColor = .white
        
        
        addSubview(dividerLine)
        addSubview(viewMapLabel)
        addSubview(dividerLine2)
        addSubview(innerReviewCollectionview)
        
        
        dividerLineConstraint = dividerLine.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0.5).first
        dividerLine2Constraint = dividerLine2.anchor(dividerLine.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 48, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0.5).first
        viewMapLabelConstraint = viewMapLabel.anchor(dividerLine.bottomAnchor, left: self.leftAnchor, bottom: dividerLine2.bottomAnchor, right: self.rightAnchor, topConstant: 1, leftConstant: 0, bottomConstant: 1, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
        innerReviewCollectionviewConstraint = innerReviewCollectionview.anchor(dividerLine2.bottomAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
        
        innerReviewCollectionview.register(myReviewGridCell.self, forCellWithReuseIdentifier: gridid)
        innerReviewCollectionview.register(myReviewMapCell.self, forCellWithReuseIdentifier: mapid)
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: gridid, for: indexPath) as! myReviewGridCell
            return cell
        }
        
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: mapid, for: indexPath) as! myReviewMapCell
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    var clickedMap: Bool = false
    
    @objc fileprivate func clickMap() {
        if clickedMap == false {
            self.clickedMap = true
            print("clicked map")
            let indexPath = IndexPath(item: 1, section: 0)
            innerReviewCollectionview.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
            let attributedString = NSMutableAttributedString(string: "VIEW AS A GRID  ")
            // line spacing 0.86
            attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(0.86), range: NSRange(location: 0, length: attributedString.length))
            let mapImage = NSTextAttachment()
            mapImage.image = UIImage(named: "review_list")
            mapImage.bounds = CGRect(x: 0, y: -3.5, width: 16, height: 16)
            attributedString.append(NSAttributedString(attachment: mapImage))
            viewMapLabel.attributedText = attributedString
        }
        
        else {
            self.clickedMap = false
            print("clicked list")
            let indexPath = IndexPath(item: 0, section: 0)
            innerReviewCollectionview.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
            let attributedString = NSMutableAttributedString(string: "VIEW AS A MAP  ")
            // line spacing 0.86
            attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(0.86), range: NSRange(location: 0, length: attributedString.length))
            let mapImage = NSTextAttachment()
            mapImage.image = UIImage(named: "review_map")
            mapImage.bounds = CGRect(x: 0, y: -3.5, width: 16, height: 16)
            attributedString.append(NSAttributedString(attachment: mapImage))
            viewMapLabel.attributedText = attributedString
        }
        
        
    }
    
}

class myReviewGridCell: UICollectionViewCell, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, ContentDynamicLayoutDelegate {
    
    fileprivate let cellid = "cellid"
    
    var images2: [UIImage] = [UIImage(named: "2")!,UIImage(named: "3")!,UIImage(named: "4")!,UIImage(named: "5")!,UIImage(named: "6")!,UIImage(named: "7")!,UIImage(named: "8")!,UIImage(named: "9")!,UIImage(named: "10")!,UIImage(named: "1")!]
    var texts: [String] = ["Lorem ipsum dolor sit amet, consectetur adipiscing elit…Lorem ipsum dolor sit amet, consectetur adipiscing elit…Lorem ipsum dolor sit amet, consectetur adipiscing elit…","Lorem ipsum dolor sit amet, consectetur adipiscing elit…","Lorem ipsum dolor sit amet, consectetur adipiscing elit…","Lorem ipsum dolor sit amet, consectetur adipiscing elit…Lorem ipsum dolor sit amet, consectetur adipiscing elit…Lorem ipsum dolor sit amet, consectetur adipiscing elit…Lorem ipsum dolor sit amet, cons","Lorem ipsum dolor sit amet, consectetur adipiscing elit…","Lorem ipsum dolor sit amet, consectetur adipiscing elit…","Lorem ipsum dolor sit amet, consectetur adipiscing elit…","Lorem ipsum dolor sit amet, consectetur adipiscing elit…","Lorem ipsum dolor sit amet, consectetur adipiscing elit…","Lorem ipsum dolor sit amet, consectetur adipiscing elit…ing elit…ing elit…ing elit…ing elit…ing elit…ing elit…"]
    
    var imsiRating: [Double] = [4.5,2.5,3.0,1.5,1.0,5,4.4,3.3,2.8,4.5]
    
    lazy var reviewCollectionView: UICollectionView = {
        let layout = PinterestStyleFlowLayout()
        layout.columnsCount = 2
        layout.delegate = self
        layout.contentPadding = ItemsPadding(horizontal: 0, vertical: 0)
        layout.cellsPadding = ItemsPadding(horizontal: 10, vertical: 10)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.dataSource = self
        cv.delegate = self
        cv.showsVerticalScrollIndicator = false
        cv.backgroundColor = .white
        return cv
    }()
    
//    var reviews = [Review]()
//    var reviews2 = [Review2]()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var reviewCollectionViewConstraint: NSLayoutConstraint?
    
    
    fileprivate func setupLayouts() {
//        for text in texts {
//            let review = Review(text: text)
//            self.reviews.append(review)
//        }
//        for image in images2 {
//            let image = Review2(image: image)
//            self.reviews2.append(image)
//        }
        
        addSubview(reviewCollectionView)
        
        reviewCollectionViewConstraint = reviewCollectionView.anchor(self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 1, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 0, heightConstant: 0).first
        
        reviewCollectionView.register(ReviewCell.self, forCellWithReuseIdentifier: cellid)
    }
    
    fileprivate func calculateHeight(text: String, width: CGFloat) -> CGFloat {
            let constraintRect = CGSize(width: width, height: 1000)
            let boundingBox = NSString(string: text).boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : UIFont(name: "DMSans-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)], context: nil)
            
            return boundingBox.height
        }
            
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return texts.count
        }
        
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath) as! ReviewCell
//            cell.review = reviews[indexPath.item]
//            cell.review2 = reviews2[indexPath.item]
            
            let imsirating = imsiRating[indexPath.item]
            // letter spacing -0.1
            let attributedString = NSMutableAttributedString(string: "\(imsirating)")
            attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(-0.1), range: NSRange(location: 0, length: attributedString.length))
            cell.starPoint.attributedText = attributedString
            cell.cosmosView.rating = imsirating
            
    //        cell.foodImageView.heightAnchor.constraint(equalToConstant: image).isActive = true

            return cell
        }
            
            
        func cellSize(indexPath: IndexPath) -> CGSize {
            //        // 고정 height = 36 + 12 + 13 + 20 + 5 + 11.5 + 9 + 19 = 125.5
            //        // 변수 height(사진, text) = 150(해결) + 60(해결) = 214
            // 밑에 frame의 height에 따라 height가 너무 작으면 오류가 나더라.. constraint관련해서
            let frame = CGRect(x: 0, y: 0, width:  (self.frame.width - 48 - 10) / 2, height: 1000)
            let dummyCell = ReviewCell(frame: frame)
//            dummyCell.review = reviews[indexPath.item]
//            dummyCell.review2 = reviews2[indexPath.item]
            dummyCell.layoutIfNeeded()
            
//            let imageRatio = reviews2[indexPath.item].image.size.height / reviews2[indexPath.item].image.size.width
//            let imageHeight = imageRatio * (frame.width - 48 - 10) / 2
            
            let textHeight = dummyCell.postLabel.sizeThatFits(dummyCell.postLabel.frame.size).height
            
            // review controller에서는 125.5가 맞았는데 여기서는 그렇게하면 오류남.
            // 숫자를 220정도부터 오류가 안나고 300정도는 해야 글자가 안날라가고 다 있는듯. 지금 현재는 230으로 설정.(height)
            // 근데 다른거에 여백이 너무 남아서 나중에 체크해야될듯.
            return CGSize(width: (frame.width - 48 - 10) / 2, height: 230 + 0 + textHeight)
        }
}


class myReviewMapCell: UICollectionViewCell {
    var entireView: UIView = {
        let view = UIView()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var entireViewConstraint: NSLayoutConstraint?
    
    fileprivate func setupLayouts() {
        backgroundColor = .green
        
        let camera = GMSCameraPosition.camera(withLatitude: 37.552468, longitude: 126.923139, zoom: 17.5)
        let mapview = GMSMapView.map(withFrame: .zero, camera: camera)
        
        entireView = mapview
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 37.552468, longitude: 126.923139)
        let image = UIImage(named: "1")
        let markerView = UIImageView(image: image)
        markerView.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        markerView.layer.borderWidth = 3
        markerView.layer.borderColor = UIColor.white.cgColor
        markerView.layer.cornerRadius = 10
        markerView.layer.masksToBounds = true

        marker.iconView = markerView
        marker.map = mapview
        
        addSubview(entireView)
        entireViewConstraint = entireView.anchor(self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
    }
}

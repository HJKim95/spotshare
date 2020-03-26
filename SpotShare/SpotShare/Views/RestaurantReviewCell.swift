//
//  RestaurantReviewCell.swift
//  SpotShare
//
//  Created by 김희중 on 16/01/2020.
//  Copyright © 2020 김희중. All rights reserved.
//

import UIKit
import collection_view_layouts
import Cosmos

// https://github.com/rubygarage/collection-view-layouts
// https://github.com/evgenyneu/Cosmos

class RestaurantReviewCell: UICollectionViewCell, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, ContentDynamicLayoutDelegate, UIGestureRecognizerDelegate {
    
    weak var delegate: RestaurantViewController?
    
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
    
    var reviews = [Review]()
    var reviews2 = [Review2]()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var reviewCollectionViewConstraint: NSLayoutConstraint?

    
    fileprivate func setupLayouts() {
        backgroundColor = .white
        
        for text in texts {
            let review = Review(text: text)
            self.reviews.append(review)
        }
        for image in images2 {
            let image = Review2(image: image)
            self.reviews2.append(image)
        }
        
        addSubview(reviewCollectionView)
        
        reviewCollectionView.register(ReviewCell.self, forCellWithReuseIdentifier: cellid)
        
        let barheight = UIApplication.shared.statusBarFrame.height
        
        reviewCollectionViewConstraint = reviewCollectionView.anchor(self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 30 + barheight + 12, leftConstant: 24, bottomConstant: 40, rightConstant: 24, widthConstant: 0, heightConstant: 0).first
        reviewCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        
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
        cell.review = reviews[indexPath.item]
        cell.review2 = reviews2[indexPath.item]
        
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
        dummyCell.review = reviews[indexPath.item]
        dummyCell.review2 = reviews2[indexPath.item]
        dummyCell.layoutIfNeeded()
        
        let imageRatio = reviews2[indexPath.item].image.size.height / reviews2[indexPath.item].image.size.width
        let imageHeight = imageRatio * (self.frame.width - 48 - 10) / 2
        
        let textHeight = dummyCell.postLabel.sizeThatFits(dummyCell.postLabel.frame.size).height
        
        
        return CGSize(width: (self.frame.width - 48 - 10) / 2, height: 125.5 + imageHeight + textHeight)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.animatingResBar(scrolling: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        delegate?.animatingResBar(scrolling: false)
    }
    
}

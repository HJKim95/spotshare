//
//  RestaurantBar.swift
//  SpotShare
//
//  Created by 김희중 on 03/11/2019.
//  Copyright © 2019 김희중. All rights reserved.
//

import UIKit

class RestaurantBar: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    private let resID = "resID"
    
    let resGroups = ["정보", "리뷰" , "메뉴"]
    
    weak var infoCell: RestaurantViewController?
    
    lazy var barCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.dataSource = self
        cv.delegate = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.layer.cornerRadius = 18
        cv.layer.masksToBounds = true
        cv.backgroundColor = .darkGray
        cv.alpha = 0.7
        return cv
    }()
    
    let horizontalBackground = UIView()
    
    var barCollectionviewConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(barCollectionView)
        
        barCollectionView.register(RestaurantBarCell.self, forCellWithReuseIdentifier: resID)
        barCollectionviewConstraint = barCollectionView.anchor(self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
        
        let selectedIndexPath = NSIndexPath(item: 0, section: 0)
        barCollectionView.selectItem(at: selectedIndexPath as IndexPath, animated: false, scrollPosition: [])
        
        setupHorizontalBackground()
    }
    
    func setupHorizontalBackground() {
        
        horizontalBackground.backgroundColor = .init(white: 1, alpha: 0.3)
        horizontalBackground.layer.cornerRadius = 18
        horizontalBackground.layer.masksToBounds = true
        
        
        insertSubview(horizontalBackground, at: 1)
        horizontalBackground.frame = CGRect(x: 5, y: 0, width: (210 / 3) - 10, height: 36)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let x = CGFloat(indexPath.item) * frame.width / 3
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.horizontalBackground.frame = CGRect(x: x + 5, y: 0, width: (210 / 3) - 10, height: 36)
        }, completion: nil)
        
        infoCell?.scrollToMenuIndex(menuIndex: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: resID, for: indexPath) as! RestaurantBarCell
        cell.barLabels.text = resGroups[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 3, height: frame.height)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class RestaurantBarCell: UICollectionViewCell {
    
    let barLabels: UILabel = {
        let label = UILabel()
        label.textAlignment = NSTextAlignment.center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont(name: "DMSans-Medium", size: 15)
        label.layer.cornerRadius = 15
        label.layer.masksToBounds = true
        return label
    }()
    
    override var isHighlighted: Bool {
        didSet {
            barLabels.textColor = isHighlighted ? UIColor.white : UIColor.black
        }
    }
    
    override var isSelected: Bool {
        didSet {
            barLabels.textColor = isSelected ? UIColor.white : UIColor.black
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    var barImageConstraint: NSLayoutConstraint?
    var barLabelsConstraint: NSLayoutConstraint?
    
    
    func setupViews() {
        backgroundColor = .clear
        addSubview(barLabels)

        barLabelsConstraint = barLabels.anchor(self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 5, bottomConstant: 0, rightConstant: 5, widthConstant: 0, heightConstant: 0).first
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

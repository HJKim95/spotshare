//
//  MyPageBar.swift
//  SpotShare
//
//  Created by 김희중 on 08/08/2019.
//  Copyright © 2019 김희중. All rights reserved.
//

import UIKit

class MyPageBar: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    private let resID = "resID"
    //*****이거 이름 통일해서 array 하나로 만들자!!!!******** --> 해결! 2019-09-28
    let resGroups = ["Favorites", "My Reviews" , "Last Viewed"]
//    let imageNames = ["favorites", "reviews" , "lastViewed"]
    
    var users: ProfileScrollCell?
    
    lazy var barCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.dataSource = self
        cv.delegate = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    var barCollectionviewConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(barCollectionView)
        
        barCollectionView.register(usersCell.self, forCellWithReuseIdentifier: resID)
        barCollectionviewConstraint = barCollectionView.anchor(self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
        
        let selectedIndexPath = NSIndexPath(item: 0, section: 0)
        barCollectionView.selectItem(at: selectedIndexPath as IndexPath, animated: false, scrollPosition: [])
        
//        setupHorizontalBar()
    }
    let horizontalBarView = UIView()
    var horizontalBarViewleftAnchor: NSLayoutConstraint?
    
    func setupHorizontalBar() {
        
//        horizontalBarView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        horizontalBarView.backgroundColor = .mainColor
        horizontalBarView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(horizontalBarView)
        
        horizontalBarViewleftAnchor = horizontalBarView.leftAnchor.constraint(equalTo: self.leftAnchor)
        horizontalBarViewleftAnchor?.isActive = true
        horizontalBarView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        horizontalBarView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/3).isActive = true
        horizontalBarView.heightAnchor.constraint(equalToConstant: 2).isActive = true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        users?.scrollToMenuIndex(menuIndex: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: resID, for: indexPath) as! usersCell
        cell.barLabels.text = resGroups[indexPath.item]
        cell.barImage.image = UIImage(named: resGroups[indexPath.item])
        cell.barImage.image = cell.barImage.image?.withRenderingMode(.alwaysTemplate)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 3, height: frame.height)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class usersCell: UICollectionViewCell {
    
    let barImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .mainGray
        return iv
    }()
    
    let barLabels: UILabel = {
        let label = UILabel()
        label.textAlignment = NSTextAlignment.center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .darkGray
        label.font = UIFont(name: "DMSans-Medium", size: 13)
        return label
    }()
    
    override var isHighlighted: Bool {
        didSet {
            barImage.tintColor  = isHighlighted ? UIColor.mainColor : UIColor.mainGray
            barLabels.textColor = isHighlighted ? UIColor.mainColor : UIColor.mainGray
        }
    }
    
    override var isSelected: Bool {
        didSet {
            barImage.tintColor  = isSelected ? UIColor.mainColor : UIColor.mainGray
            barLabels.textColor = isSelected ? UIColor.mainColor : UIColor.mainGray
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    var barImageConstraint: NSLayoutConstraint?
    var barLabelsConstraint: NSLayoutConstraint?
    
    
    func setupViews() {
        backgroundColor = .white
        addSubview(barImage)
        addSubview(barLabels)
        
        let barImageSize: CGFloat = 30.0
        
        barLabelsConstraint = barLabels.anchor(nil, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 6, rightConstant: 0, widthConstant: 0, heightConstant: 16).first
        barImage.frame = CGRect(x: (frame.width / 2) - (barImageSize / 2), y: 5, width: barImageSize, height: barImageSize)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

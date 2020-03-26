//
//  MainMagazineCellj.swift
//  SpotShare
//
//  Created by 김희중 on 18/06/2019.
//  Copyright © 2019 김희중. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

// https://github.com/SDWebImage/SDWebImage

class MainMagazineCell: UICollectionViewCell, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let cellid = "cellid"
    var mainCollection: MainCollectionCell?
    
    lazy var innerMagaizneCollectionview: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.alwaysBounceHorizontal = true
        collectionview.showsHorizontalScrollIndicator = false
        collectionview.isPagingEnabled = true
        return collectionview
    }()
    
    let pageControl: HorizontalPageControlView = {
        let pc = HorizontalPageControlView()
        pc.selectedColor = .white
        pc.backgroundColor = UIColor(white: 1, alpha: 0.3)
        pc.layer.masksToBounds = true
        return pc
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var innerMagaizneCollectionviewConstraint: NSLayoutConstraint?
    var pageControlConstraint: NSLayoutConstraint?
    
    //total cell size 260
    fileprivate func setupViews() {
        self.backgroundColor = .white
        innerMagaizneCollectionview.backgroundColor = .white
        
        let pageControlHeight: CGFloat = 8
        
        addSubview(innerMagaizneCollectionview)
        addSubview(pageControl)
        
        innerMagaizneCollectionviewConstraint = innerMagaizneCollectionview.anchor(self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
        pageControlConstraint = pageControl.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, topConstant: 180, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 70, heightConstant: pageControlHeight).first

        innerMagaizneCollectionview.register(innerMagazineCell.self, forCellWithReuseIdentifier: cellid)
        
        pageControl.layer.cornerRadius = pageControlHeight / 2
        
        getMagazine_firebase()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pageControl.totalPageCount = mainMagazineInfos.count
        return mainMagazineInfos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath) as! innerMagazineCell

        if let magazineTitle = mainMagazineInfos[indexPath.item].title {
            // letter spacing -0.33
            let attributedString = NSMutableAttributedString(string: magazineTitle)
            attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(-0.33), range: NSRange(location: 0, length: attributedString.length))
//            cell.magazineLabel.attributedText = attributedString
            // 추후에 title 보여주는거 좀 수정(디자인적으로나 기술적으로 이쁘게 보여지게)
        }
        
        if let magazineUrl = URL(string: mainMagazineInfos[indexPath.item].imageUrl ?? "") {
            cell.imageView.sd_setImage(with: magazineUrl, completed: nil)
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: frame.height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x / scrollView.bounds.width
        pageControl.indicatorOffset = offset
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let magTitle = mainMagazineInfos[indexPath.item].title else {return}
        goInnerMagazine(magTitle: magTitle)
    }
    
    var mainMagazineInfos = [MainMagazineModel]()
    
    fileprivate func getMagazine_firebase() {
        let ref = Database.database().reference().child("FirstEditor")
        ref.observe(.childAdded, with: { (snapshot) in
            if snapshot.value as! Int == 1 {
                let magId = snapshot.key
                let magazineReference = Database.database().reference().child("매거진").child(magId)
                
                magazineReference.observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
                    if let dictionary = snapshot.value as? [String:Any] {
                        
                        let magazineInfo = MainMagazineModel()
                        
                        magazineInfo.imageUrl = dictionary["originalImage"] as? String
                        magazineInfo.title = dictionary["Title"] as? String
                        self?.mainMagazineInfos.append(magazineInfo)

                    }
                    
                    DispatchQueue.main.async {
                        self?.innerMagaizneCollectionview.reloadData()
                    }
                }, withCancel: { (err) in
                    print("Failed to fetch magData:", err)
                })
            }
            
        }, withCancel: { (err) in
            print("Failed to fetch all magDatas:", err)
        })
    }
    
    fileprivate func goInnerMagazine(magTitle: String) {
        mainCollection?.goInnerMagazine(magTitle: magTitle)
    }
}

class innerMagazineCell: UICollectionViewCell {
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let magazineLabel: UILabel = {
        let lb = UILabel()
        lb.backgroundColor = .clear
        lb.textColor = .white
        lb.font = UIFont(name: "DMSans-Medium", size: 22)
        lb.numberOfLines = 0
        return lb
    }()
    
    let moreButton: UILabel = {
        let lb = UILabel()
        lb.backgroundColor = .clear
        lb.textColor = .white
        // letter spacing 0.9
        let attributedString = NSMutableAttributedString(string: "READ MORE")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(0.9), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.font = UIFont(name: "DMSans-Bold", size: 12)
        lb.textAlignment = .center
        lb.layer.borderWidth = 2
        lb.layer.borderColor = UIColor.white.cgColor
        lb.layer.masksToBounds = true
        lb.layer.cornerRadius = 18
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var imageViewConstraint: NSLayoutConstraint?
    var magazineLabelConstraint: NSLayoutConstraint?
    var moreButtonConstraint: NSLayoutConstraint?
    
    
    fileprivate func setupViews() {
        addSubview(imageView)
        addSubview(magazineLabel)
        addSubview(moreButton)
        
        imageViewConstraint = imageView.anchor(self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
        magazineLabelConstraint = magazineLabel.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, topConstant: 120, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 200, heightConstant: 60).first
        moreButtonConstraint = moreButton.anchor(magazineLabel.bottomAnchor, left: self.leftAnchor, bottom: nil, right: nil, topConstant: 16, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 120, heightConstant: 36).first

    }
}

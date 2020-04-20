//
//  MyFavoriteCell.swift
//  SpotShare
//
//  Created by 김희중 on 08/08/2019.
//  Copyright © 2019 김희중. All rights reserved.
//

import UIKit

class MyFavoriteCell: UICollectionViewCell, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let cellid = "cellid"
    
    var mypagecell: ProfileScrollCell?
    
    lazy var FavoriteCollectionview: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionview.backgroundColor = .white
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.showsVerticalScrollIndicator = false
        return collectionview
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupViews() {
        backgroundColor = .white
        FavoriteCollectionview.frame = CGRect(x: 24, y: 0, width: frame.width - 48, height: frame.height - 10)
        
        FavoriteCollectionview.register(innerSpotCell.self, forCellWithReuseIdentifier: cellid)
        
        addSubview(FavoriteCollectionview)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath) as! innerSpotCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.frame.width - (24+15+24) ) / 2, height: 157)
    }
    
    // tabbar icon 눌르면 위로 올라가게
    func goTopCollectionView() {
        let indexPath = IndexPath(item: 0, section: 0)
        self.FavoriteCollectionview.scrollToItem(at: indexPath, at: .bottom, animated: true)
    }

    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let size = scrollView.contentSize
//        let offset = scrollView.contentOffset.y
//        mypagecell?.scrollTogether(offset: offset, size: size)
//        
//        scrollView.bounces = scrollView.contentOffset.y > 0
//    }
    
}

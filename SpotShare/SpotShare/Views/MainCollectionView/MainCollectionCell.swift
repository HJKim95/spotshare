//
//  MainControllerCell.swift
//  SpotShare
//
//  Created by 김희중 on 29/04/2019.
//  Copyright © 2019 김희중. All rights reserved.
//

import UIKit

class MainCollectionCell: UICollectionViewCell, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var maincontroll: MainController?
    
    let cellid = "cellid"
    let explorecellid = "explorecellid"
    let weatherid = "weatherid"
    let recommendid = "recommendid"
    let hotspotid = "hotspotid"
    let contactid = "contactid"
    
    lazy var innerMainCollectionview: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.alwaysBounceVertical = true
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
    
    var innerMainCollectionviewConstraint: NSLayoutConstraint?
    
    fileprivate func setupViews() {
        self.backgroundColor = .white
        innerMainCollectionview.backgroundColor = .white
        
        addSubview(innerMainCollectionview)
        innerMainCollectionviewConstraint = innerMainCollectionview.anchor(self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first

        registerCells()
    }
    
    fileprivate func registerCells() {
        innerMainCollectionview.register(MainMagazineCell.self, forCellWithReuseIdentifier: cellid)
        innerMainCollectionview.register(ExploreCell.self, forCellWithReuseIdentifier: explorecellid)
        innerMainCollectionview.register(WeatherCell.self, forCellWithReuseIdentifier: weatherid)
        innerMainCollectionview.register(RecommendCell.self, forCellWithReuseIdentifier: recommendid)
        innerMainCollectionview.register(HotSpotCell.self, forCellWithReuseIdentifier: hotspotid)
        innerMainCollectionview.register(ContactCell.self, forCellWithReuseIdentifier: contactid)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath) as! MainMagazineCell
            cell.mainCollection = self
            return cell
        }
        
        if indexPath.item == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: explorecellid, for: indexPath) as! ExploreCell
            cell.mainCollection = self
            return cell
        }
        
        else if indexPath.item == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: weatherid, for: indexPath) as! WeatherCell
            return cell
        }
            
        else if indexPath.item == 3 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: recommendid, for: indexPath) as! RecommendCell
            return cell
        }
            
        else if indexPath.item == 4 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: hotspotid, for: indexPath) as! HotSpotCell
            cell.categoryNameLabel.letterSpacing(text: "HOT SPOTS OF THE MONTH", spacing: 1.0)
            cell.delegate = self
            return cell
        }
        
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: contactid, for: indexPath) as! ContactCell
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 {
            //MainMagazine
            return CGSize(width: frame.width, height: 260)
        }
        else if indexPath.item == 1 {
            //Explore
            return CGSize(width: frame.width, height: 158)
        }
        else if indexPath.item == 2 {
            //Weather
            return CGSize(width: frame.width, height: 144)
        }
        else if indexPath.item == 3 {
            //Recommend
            return CGSize(width: frame.width, height: 226)
        }
        else if indexPath.item == 4 {
            //HotSpot
            // 42 + 18 + 16 + cell * 2 + 20(line space) + 2
            let width = (self.frame.width - (24+15+24) ) / 2
            let cellheight = width + 44
            return CGSize(width: frame.width, height: 76 + (cellheight * 2) + 22)
        }
        else if indexPath.item == 5 {
            //Contact
            return CGSize(width: frame.width, height: 122)
        }
        return CGSize(width: frame.width, height: 150)
    }
    
    fileprivate var lastContentOffset: CGFloat = 0
    
    //searchBar pop up
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if lastContentOffset > scrollView.contentOffset.y && lastContentOffset < scrollView.contentSize.height - scrollView.frame.height {
            //move up
            UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseInOut, animations: {
                self.maincontroll?.searchbar.transform = .identity
            }, completion: nil)
        }
        else if lastContentOffset < scrollView.contentOffset.y && scrollView.contentOffset.y > 0 {
            //move down
            UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseInOut, animations: {
                self.maincontroll?.searchbar.transform = CGAffineTransform(translationX: 0, y: self.maincontroll?.view.frame.height ?? 0)
            }, completion: nil)}

        // update the new position acquired
        self.lastContentOffset = scrollView.contentOffset.y
    }
    
    func goCategory(category: String) {
        maincontroll?.OpenCategoryCollectionView(category: category)
    }
    
    // tabbar icon 눌르면 위로 올라가게
    func goTopCollectionView() {
        let indexPath = IndexPath(item: 0, section: 0)
        self.innerMainCollectionview.scrollToItem(at: indexPath, at: .bottom, animated: true)
    }
    
    func goRestaurant(resinfo: ResInfoModel) {
        maincontroll?.goRestaurant(resInfo: resinfo)
    }
    
    func goInnerMagazine(magTitle: String) {
        maincontroll?.goInnerMagazine(magTitle: magTitle)
    }
}

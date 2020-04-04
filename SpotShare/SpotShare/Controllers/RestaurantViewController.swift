//
//  RestaurantView.swift
//  SpotShare
//
//  Created by 김희중 on 28/09/2019.
//  Copyright © 2019 김희중. All rights reserved.
//

import UIKit

class RestaurantViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    deinit {
        print("no retain cycle in RestaurantViewController")
    }
    
    weak var resinfo: ResInfoModel?
    
    let infoid = "cellid"
    let reviewid = "reviewid"
    let menuid = "menuid"
    
    lazy var infoCollectionView: UICollectionView = {
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
        cv.isScrollEnabled = false
        return cv
    }()
    
    lazy var myRestaurantBar: RestaurantBar = {
        let rb = RestaurantBar()
        rb.infoCell = self
        rb.translatesAutoresizingMaskIntoConstraints = false
        return rb
    }()

    var infoCollectionViewConstraint: NSLayoutConstraint?
    var myRestaurantBarConstraint: NSLayoutConstraint?

    override func viewDidLoad() {
        view.backgroundColor = .white
        
        // swipe로 back 구현하려면 두개 다 써줘야함.
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        infoCollectionView.register(bigRestaurantCell.self, forCellWithReuseIdentifier: infoid)
        infoCollectionView.register(RestaurantReviewCell.self, forCellWithReuseIdentifier: reviewid)
        infoCollectionView.register(RestaurantMenuCell.self, forCellWithReuseIdentifier: menuid)
        
        setupLayouts()
    }
    
    fileprivate func setupLayouts() {
        view.addSubview(infoCollectionView)
        view.addSubview(myRestaurantBar)
        
//        let barheight = UIApplication.shared.statusBarFrame.height
        let resBarWidth: CGFloat = 210
        
        infoCollectionViewConstraint = infoCollectionView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
        myRestaurantBarConstraint = myRestaurantBar.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: nil, topConstant: 0, leftConstant: (view.frame.width / 2) - (resBarWidth / 2), bottomConstant: 50, rightConstant: 0, widthConstant: resBarWidth, heightConstant: 36).first
        //        blackView.setGradientBackgroundVertical(gradientLayer: gradient, colorOne:UIColor(white: 0, alpha: 0.6), colorTwo: UIColor(white: 0, alpha: 0))
    }
    
    // autolayout 사용시에는 gradient 설정하고 밑에 viewDidLayoutSubviews를 설정해주어야함.
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        gradient.frame = footButtons.bounds
//    }
    
    func scrollToMenuIndex(menuIndex: Int) {
            let indexPath = NSIndexPath(item: menuIndex, section: 0)
            infoCollectionView.scrollToItem(at: indexPath as IndexPath, at: [], animated: true)
        }
    
    func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: infoid, for: indexPath) as! bigRestaurantCell
            cell.delegate = self
            cell.resinfo = resinfo
            return cell
        }
        else if indexPath.item == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reviewid, for: indexPath) as! RestaurantReviewCell
            cell.delegate = self
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: menuid, for: indexPath) as! RestaurantMenuCell
            return cell
        }
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }

    
    func goImproveListing() {
        
        // https://github.com/ergunemr/BottomPopup
        let vc = ImproveListingViewController()
        vc.height = view.frame.height - 100
        vc.topCornerRadius = 20
        vc.presentDuration = 0.5
        vc.dismissDuration = 0.5
        present(vc, animated: true, completion: nil)
    }
    
    func animatingResBar(scrolling: Bool) {
        if scrolling {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                self.myRestaurantBar.alpha = 0
            }, completion: nil)
        }
        else {
            UIView.animate(withDuration: 0.5, delay: 0.3, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                self.myRestaurantBar.alpha = 1
            }, completion: nil)
        }
    }
}


class bigRestaurantCell: UICollectionViewCell, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    fileprivate let cellid = "cellid"
    fileprivate let cellid2 = "cellid2"
    
    weak var delegate: RestaurantViewController?
    weak var resinfo: ResInfoModel?
    
    lazy var infoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.dataSource = self
        cv.delegate = self
        cv.showsVerticalScrollIndicator = false
        cv.backgroundColor = .clear
        cv.alwaysBounceVertical = true
        return cv
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var infoCollectionViewConstraint: NSLayoutConstraint?
    
    fileprivate func setupLayouts() {
        backgroundColor = .white
        
        addSubview(infoCollectionView)

        infoCollectionViewConstraint = infoCollectionView.anchor(self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: -45, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
        
        infoCollectionView.register(RestaurantHeaderCell.self, forCellWithReuseIdentifier: cellid)
        infoCollectionView.register(RestaurantInfoCell.self, forCellWithReuseIdentifier: cellid2)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 {
            
//            let barheight = UIApplication.shared.statusBarFrame.height
            // 뒤에 +10 은 map과의 여백
            return CGSize(width: collectionView.frame.width, height: frame.width - 50 + 188 + 10)
        }
        else {
            return CGSize(width: collectionView.frame.width, height: 900)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            if indexPath.item == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath) as! RestaurantHeaderCell
                cell.resinfo = resinfo
                cell.delegate = self
                return cell
            }

            else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid2, for: indexPath) as! RestaurantInfoCell
                cell.delegate = self
                cell.resinfo = resinfo
                return cell
            }
        }
    
    var firstSetup: Bool = true
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        if offset > 0 {
            delegate?.animatingResBar(scrolling: true)
        }
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        delegate?.animatingResBar(scrolling: false)
    }
    
    func goImproveListing() {
        delegate?.goImproveListing()
    }
    
    func goBack() {
        delegate?.goBack()
    }

    
}



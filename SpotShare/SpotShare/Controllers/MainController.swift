//
//  ViewController.swift
//  SpotShare
//
//  Created by 김희중 on 28/04/2019.
//  Copyright © 2019 김희중. All rights reserved.
//

import UIKit
// https://www.youtube.com/watch?v=Ldz-J7Xrk28
// https://github.com/ergunemr/BottomPopup
protocol circleDelegate {
    func goReview()
    func goRestMonth()
    func OpenCategoryCollectionView(category: String)
    func goMagazine()
    func goTodayMeal()
}

protocol searchDelegate {
    func goSearchResult()
}

class MainController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, circleDelegate, searchDelegate {
    
    let cellid = "mainId"
    let cellid2 = "myId"
    
    lazy var mainCollectionview: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.showsHorizontalScrollIndicator = false
        cv.isPagingEnabled = true
        cv.isUserInteractionEnabled = true
        cv.isScrollEnabled = false
        return cv
    }()
    
    lazy var tabview: TabView = {
        let tv = TabView()
        tv.maincontroller = self
        return tv
    }()
    
    lazy var searchbar: searchBar = {
        let sb = searchBar()
        sb.backgroundColor = .white
        sb.layer.cornerRadius = 15
        sb.layer.borderColor = UIColor(white: 0.3, alpha: 0.3).cgColor
        sb.layer.borderWidth = 0.1
        sb.layer.masksToBounds = true
        sb.maincontroller = self
        sb.searchText.text = "Search for anything"
        return sb
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: -0.05)
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 15
        view.layer.masksToBounds = false
        return view
    }()

    let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 252, green: 252, blue: 252)
        return view
    }()
    
    lazy var mainCircle: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "mainCircle")
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .heavy)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        view.backgroundColor = .white
        
        mainCircle.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(OpenMainCircle)))
        impactFeedbackgenerator.prepare()
        
        setupCollectionview()
        setupSearchBar()
        setupTabBar()
        
        print("teststetetetetetetet")
        print("hahahahahahahaha"
        
    }
    

    var mainControllerLayout: NSLayoutConstraint?
    var BottomContatinerViewLayout: NSLayoutConstraint?
    var tabbarLayout: NSLayoutConstraint?
    var mainCircleLayout: NSLayoutConstraint?
    var bottomViewConstraint: NSLayoutConstraint?
    var searchbarConstraint: NSLayoutConstraint?
    var searchContainerConstraint: NSLayoutConstraint?
    
    fileprivate func setupCollectionview() {
        mainCollectionview.backgroundColor = .white
        
        if #available(iOS 11.0, *) {
            mainCollectionview.contentInsetAdjustmentBehavior = .never
        }
        
        mainCollectionview.register(MainCollectionCell.self, forCellWithReuseIdentifier: cellid)
        mainCollectionview.register(MyPageCell.self, forCellWithReuseIdentifier: cellid2)
        view.addSubview(mainCollectionview)

        
        let tabViewHeight: CGFloat = 49.0
        
//        let barheight = UIApplication.shared.statusBarFrame.height
        
        if #available(iOS 11.0, *) {
            mainControllerLayout = mainCollectionview.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: tabViewHeight, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
        }
        else {
            mainControllerLayout = mainCollectionview.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: tabViewHeight, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
        }

        
    }
    
    fileprivate func setupSearchBar() {

        view.addSubview(containerView)
        containerView.addSubview(searchbar)
        
        //밑에 cornerRadius 안보이게 하기위해
        let contentInset: CGFloat = 15

        if #available(iOS 11.0, *) {
            searchContainerConstraint = containerView.anchor(nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 49 - contentInset, rightConstant: 0, widthConstant: 0, heightConstant: 80 + contentInset).first
            searchbarConstraint = searchbar.anchor(containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
        }
        else {
            searchContainerConstraint = containerView.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 49 - contentInset, rightConstant: 0, widthConstant: 0, heightConstant: 80 + contentInset).first
            searchbarConstraint = searchbar.anchor(containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
        }
    }
    
    func goUpDownSearchBar(index: Int) {
        if index == 0 {
            UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut, animations: {
                self.searchbar.transform = .identity
            }, completion: nil)
        }
        else {
            UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut, animations: {
                self.searchbar.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height )
            }, completion: nil)
        }
    }
    
    fileprivate func setupTabBar() {
        let containerView = UIView()
        view.addSubview(containerView)
        containerView.addSubview(tabview)
        view.addSubview(bottomView)
        view.addSubview(mainCircle)
        
        if #available(iOS 11.0, *) {
            BottomContatinerViewLayout = containerView.anchor(mainCollectionview.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
            tabbarLayout = tabview.anchor(containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
            bottomViewConstraint = bottomView.anchor(view.safeAreaLayoutGuide.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
            mainCircleLayout = mainCircle.anchor(containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: nil, topConstant: 3, leftConstant: (view.frame.width / 2) - 22, bottomConstant: 0, rightConstant: 0, widthConstant: 44, heightConstant: 44).first
        }
        else {
            BottomContatinerViewLayout = containerView.anchor(mainCollectionview.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
            tabbarLayout = tabview.anchor(containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
            bottomViewConstraint = bottomView.anchor(view.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
            mainCircleLayout = mainCircle.anchor(containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: nil, topConstant: 5, leftConstant: (view.frame.width / 2) - 22, bottomConstant: 0, rightConstant: 0, widthConstant: 44, heightConstant: 44).first
        }
    }
    
    //TabView Icon 누르면 CollectionView 맨 위로 올라가는거.
    func goTopCollectionView(index: Int) {
        if index == 0 {
            let indexPath = IndexPath(item: index, section: 0)
            let cell = mainCollectionview.cellForItem(at: indexPath) as? MainCollectionCell
            cell?.goTopCollectionView()
        }
        
        else {
            let indexPath = IndexPath(item: index, section: 0)
            let cell = mainCollectionview.cellForItem(at: indexPath) as? MyPageCell
            cell?.goTopCollectionView()
        }
    }
    // https://github.com/ergunemr/BottomPopup
    @objc func OpenSearchBar() {
        let vc = SearchController()
        vc.height = view.frame.height - 100
        vc.topCornerRadius = 35
        vc.presentDuration = 0.5
        vc.dismissDuration = 0.5
        
        vc.delegate = self
        present(vc, animated: true, completion: nil)
        
    }
    
    //ExploreCell 눌렀을때
    @objc func OpenCategoryCollectionView(category: String) {
        let cv = CategoryCollectionView()
        cv.category = category
        self.navigationController?.pushViewController(cv, animated: true)
        
    }
    
    @objc func goRestaurant(resInfo: ResInfoModel) {
        //present 띄운거에서 pushviewcontroller가 안되기 때문에 한것.
        // 그치만 present 띄운거 뒤에서 push가 되기 때문에 추후 방법을 다시 고쳐봐야할듯. 2019-09-28
        // 수첩 내용 확인하고 CategoryCollectionview도 수정해줄것. 그냥 처음부터 push로 하고 review 쓰는것만 present로 깔끔히 하자.
        let restaurant = RestaurantViewController()
        restaurant.resinfo = resInfo
        self.navigationController?.pushViewController(restaurant, animated: true)
    }
    
    @objc func OpenMainCircle() {
        
        impactFeedbackgenerator.impactOccurred()
        
        let maincircle = MainCircleController()
        // https://www.youtube.com/watch?v=Ldz-J7Xrk28
        maincircle.delegate = self
        let circlecontroller = UINavigationController(rootViewController: maincircle)
        self.present(circlecontroller, animated: true, completion: nil)
    }
    
    func OpenController(controller: UIViewController) {
        self.present(controller, animated: true, completion: nil)
    }
    
    func scrollToMenuIndex(menuIndex: Int) {
        let indexPath = IndexPath(item: menuIndex, section: 0)
        mainCollectionview.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath) as! MainCollectionCell
            cell.maincontroll = self
            return cell
        }

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid2, for: indexPath) as! MyPageCell
        cell.maincontroll = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func goReview() {
        let review = ReviewController()
        self.navigationController?.pushViewController(review, animated: true)
    }
    
    func goRestMonth() {
        let restMonth = RestaurantMonthController()
        self.navigationController?.pushViewController(restMonth, animated: true)
    }
    
    func goMagazine() {
        let restMonth = MagazineController()
        self.navigationController?.pushViewController(restMonth, animated: true)
    }
    
    func goInnerMagazine(magTitle: String) {
        let innerMagazine = innerMagazineViewController()
        innerMagazine.magTitle = magTitle
        self.navigationController?.pushViewController(innerMagazine, animated: true)
    }
    
    func goSearchResult() {
        let searchResult = SearchResultController()
        self.navigationController?.pushViewController(searchResult, animated: true)
    }
    
    func goTodayMeal() {
        let todaymeal = TodaysMealController()
        self.navigationController?.pushViewController(todaymeal, animated: true)
    }
    
    func goEditProfile() {
        let edit = EditProfileController()
        self.navigationController?.pushViewController(edit, animated: true)
    }
    
    func goSettings() {
        let setting = SettingController()
        self.navigationController?.pushViewController(setting, animated: true)
    }
    
}



//
//  CategoryCollectionView.swift
//  SpotShare
//
//  Created by 김희중 on 13/09/2019.
//  Copyright © 2019 김희중. All rights reserved.
//

import UIKit
import GoogleMaps
import Firebase
import SDWebImage

class CategoryCollectionView: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    
    deinit {
        print("no retain cycle in CategoryCollectionViewController")
    }

    let cellid = "cellid"
    let listid = "listid"
    let mapid = "mapid"
    let dropdownid = "dropdownid"
    
    var category: String? {
        didSet {
            searchText.text = category
        }
    }
    
    let resCategories = ["한식", "중식", "일식", "양식", "아시아"]
    let sulCategories = ["소주,맥주", "칵테일,와인"]

    let searchBackView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.mainColor
        return view
    }()
    
    // 리뷰작성할때 복붙하자
    let thumbView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 217, green: 217, blue: 217)
        view.layer.cornerRadius = 2.5
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var searchView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.mainColor.cgColor
        view.layer.masksToBounds = true
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chooseCategory)))
        return view
    }()
    
    lazy var backImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "back")
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goBack)))
        return iv
    }()
    
    let searchText: UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor.rgb(red: 51, green: 51, blue: 51)
        lb.font = UIFont(name: "DMSans-Medium", size: 16)
        lb.textAlignment = .center
        return lb
    }()
    
    let arrowImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "down_arrow")
        return iv
    }()
    
    lazy var mapImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "map")
        iv.contentMode = .scaleAspectFit
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showMap)))
        return iv
    }()
    
    lazy var innerCategoryFilterview: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 5
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.alwaysBounceHorizontal = true
        collectionview.showsHorizontalScrollIndicator = false
        collectionview.backgroundColor = UIColor.mainColor
        return collectionview
    }()
    
    lazy var innerCategoryCollectionview: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.showsHorizontalScrollIndicator = false
        collectionview.isPagingEnabled = true
        collectionview.isScrollEnabled = false
        collectionview.backgroundColor = .white
        return collectionview
    }()
    
    lazy var dropDownCollectionview: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.showsVerticalScrollIndicator = false
        collectionview.isScrollEnabled = true
        collectionview.backgroundColor = .white
        collectionview.translatesAutoresizingMaskIntoConstraints = false
        collectionview.layer.cornerRadius = 10
        collectionview.clipsToBounds = true
        return collectionview
    }()
    
    
    var searchBackViewConstraint: NSLayoutConstraint?
    var searchViewConstraint: NSLayoutConstraint?
    var backImageViewConstraint: NSLayoutConstraint?
    var searchTextConstraint: NSLayoutConstraint?
    var mapImageViewConstraint: NSLayoutConstraint?
    var innerCategoryFilterviewConstraint: NSLayoutConstraint?
    var restaurantLabelConstraint: NSLayoutConstraint?
    var innerCategoryCollectionviewConstraint: NSLayoutConstraint?
    var dropDownCollectionviewConstraint: NSLayoutConstraint?
    var dropDownHeightConstraint: NSLayoutConstraint!
    var arrowImageViewConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        
        // swipe로 back 구현하려면 두개 다 써줘야함.
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        setStatusbarColor()
        setupLayouts()

        innerCategoryFilterview.register(CategoryFilterCell.self, forCellWithReuseIdentifier: cellid)
        innerCategoryCollectionview.register(CategoryListCell.self, forCellWithReuseIdentifier: listid)
        innerCategoryCollectionview.register(CategoryMapCell.self, forCellWithReuseIdentifier: mapid)
        
        dropDownCollectionview.register(dropDownCell.self, forCellWithReuseIdentifier: dropdownid)
        
//        test()
    }
    
    let arr = ["맛이차이나", "산왕반점", "소고산제일루", "심양", "아빠의양식당", "중화가정", "중화복춘", "진가", "진만두", "징기스", "초마", "한양중식", "항방양꼬치"]
    let testArr = [2.1,3.3,4.5,5.0,2.1,2.3,4.3,2.3,2.4,1.2,1.4,1.5,1.5]
    let toiletArr = ["남녀구분","공용","남녀구분","공용","남녀구분","공용","남녀구분","공용","남녀구분","공용","남녀구분","공용","남녀구분"]
    let a = ["월","화","수","목","금","토","일"]
    let b = ["1130","1130","1130","1130","1130","1130","1130"]
    let c = ["2130","2130","2130","2130","2130","2130","2300"]
    let d = ["1600","1600","1600","1600","1600","1600","없음"]
    let e = ["1700","1700","1700","1700","1700","1700","없음"]
//    월~토 11:30 ~ 16:00, 17:00 ~ 21:30, 일 11:30 ~ 23:00"
    fileprivate func test() {
        // 데이터 추가
//        for i in 0..<a.count {
//            let ref = Database.database().reference().child("맛집").child("맛이차이나").child("open")
//            let values = [a[i]:b[i]] as [String : Any]
//            ref.updateChildValues(values)
//        }
        
        let ref = Database.database().reference().child("search_keywords")
        let values = ["카페":1] as [String : Any]
        ref.updateChildValues(values)
        
        // 데이터 읽기
        //key는 snapshot에서 맨앞부분을 칭함.
        //snapshot 불러올때부터 filter해서 가져와서 바로 밑에 원래 하던 거 넣으면 될듯!!!! 개꾸르!!!!!
        
//        let ref = Database.database().reference().child("Test")
//        var query = ref.queryOrdered(byChild: "points")
//        query.observe(.childAdded) { (snapshot) in
//            print(snapshot)
//
//        }
    }
    
    
    
    fileprivate func setStatusbarColor() {
        let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        let statusBarColor = UIColor.mainColor
        statusBarView.backgroundColor = statusBarColor
        view.addSubview(statusBarView)
    }
    
    fileprivate func setupLayouts() {
        view.addSubview(searchBackView)
        view.addSubview(searchView)
        view.addSubview(backImageView)
        view.addSubview(searchText)
        view.addSubview(mapImageView)
        view.addSubview(innerCategoryFilterview)
        view.addSubview(innerCategoryCollectionview)
        view.addSubview(dropDownCollectionview)
        view.addSubview(arrowImageView)
        
        if #available(iOS 11.0, *) {
            searchBackViewConstraint = searchBackView.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 115).first
            backImageViewConstraint = backImageView.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 24, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 24, heightConstant: 24).first
            searchViewConstraint = searchView.anchor(view.safeAreaLayoutGuide.topAnchor, left: backImageView.rightAnchor, bottom: nil, right: view.rightAnchor, topConstant: 12, leftConstant: 24, bottomConstant: 0, rightConstant: 64, widthConstant: 0, heightConstant: 48).first
            dropDownCollectionviewConstraint = dropDownCollectionview.anchor(searchView.bottomAnchor, left: searchView.leftAnchor, bottom: nil, right: searchView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
            arrowImageViewConstraint = arrowImageView.anchor(searchView.topAnchor, left: nil, bottom: nil, right: searchView.rightAnchor, topConstant: 18, leftConstant: 0, bottomConstant: 0, rightConstant: 24, widthConstant: 12, heightConstant: 12).first
            searchTextConstraint = searchText.anchor(searchView.topAnchor, left: searchView.leftAnchor, bottom: nil, right: arrowImageView.leftAnchor, topConstant: 14, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 20).first
            mapImageViewConstraint = mapImageView.anchor(view.safeAreaLayoutGuide.topAnchor, left: searchView.rightAnchor, bottom: nil, right: view.rightAnchor, topConstant: 24, leftConstant: 16, bottomConstant: 0, rightConstant: 24, widthConstant: 24, heightConstant: 24).first
            innerCategoryFilterviewConstraint = innerCategoryFilterview.anchor(searchView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 12, leftConstant: 24, bottomConstant: 0, rightConstant: 5, widthConstant: 0, heightConstant: 32).first
            innerCategoryCollectionviewConstraint = innerCategoryCollectionview.anchor(searchBackView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
            
        }
        else {
            searchBackViewConstraint = searchBackView.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 115).first
            backImageViewConstraint = backImageView.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 24, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 24, heightConstant: 24).first
            searchViewConstraint = searchView.anchor(view.topAnchor, left: backImageView.rightAnchor, bottom: nil, right: view.rightAnchor, topConstant: 12, leftConstant: 24, bottomConstant: 0, rightConstant: 64, widthConstant: 0, heightConstant: 48).first
            dropDownCollectionviewConstraint = dropDownCollectionview.anchor(searchView.bottomAnchor, left: searchView.leftAnchor, bottom: nil, right: searchView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
            arrowImageViewConstraint = arrowImageView.anchor(searchView.topAnchor, left: nil, bottom: nil, right: searchView.rightAnchor, topConstant: 18, leftConstant: 0, bottomConstant: 0, rightConstant: 24, widthConstant: 12, heightConstant: 12).first
            searchTextConstraint = searchText.anchor(searchView.topAnchor, left: searchView.leftAnchor, bottom: nil, right: arrowImageView.leftAnchor, topConstant: 14, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 20).first
            mapImageViewConstraint = mapImageView.anchor(view.topAnchor, left: searchView.rightAnchor, bottom: nil, right: view.rightAnchor, topConstant: 24, leftConstant: 16, bottomConstant: 0, rightConstant: 24, widthConstant: 24, heightConstant: 24).first
            innerCategoryFilterviewConstraint = innerCategoryFilterview.anchor(searchView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 12, leftConstant: 24, bottomConstant: 0, rightConstant: 5, widthConstant: 0, heightConstant: 32).first
            innerCategoryCollectionviewConstraint = innerCategoryCollectionview.anchor(searchBackView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
        }
        
        // https://stackoverflow.com/questions/28866865/changing-constraint-after-adding-it-causes-constraint-error-swift
        dropDownHeightConstraint = NSLayoutConstraint(item:dropDownCollectionview, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier:1.0, constant:0)
        dropDownCollectionview.addConstraint(dropDownHeightConstraint)
        
        let selectedIndexPath = NSIndexPath(item: 0, section: 0)
        innerCategoryFilterview.selectItem(at: selectedIndexPath as IndexPath, animated: false, scrollPosition: [])
    }
    
    @objc fileprivate func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    let filterNames = ["A to Z","Top rating", "Now Open", "Seperate Toilet", "Liked"]
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == innerCategoryFilterview {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath) as! CategoryFilterCell
            cell.layer.cornerRadius = 4
            cell.layer.masksToBounds = true
            
            let filterName = filterNames[indexPath.item]

            cell.filterImageView.image = UIImage(named: filterName)?.withRenderingMode(.alwaysTemplate)
            cell.filterLabel.letterSpacing(text: filterName, spacing: -0.1)
            if indexPath.item == 0 {
                // 이렇게 해도 처음엔 didSelect가 호출되지 않음.
//                cell.isSelected = true
            }
            return cell
        }
        else if collectionView == dropDownCollectionview {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: dropdownid, for: indexPath) as! dropDownCell
            if category == "한식" {
                cell.searchText.text = resCategories[indexPath.item]
            }
            else if category == "소주,맥주" {
                cell.searchText.text = sulCategories[indexPath.item]
            }
            
            return cell
        }
            
        else {
            if indexPath.item == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: listid, for: indexPath) as! CategoryListCell
                cell.categoryDelegate = self
                cell.category = category
                return cell
            }
            else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: mapid, for: indexPath) as! CategoryMapCell
                cell.category = category
                cell.delegate = self
                return cell
            }
        }
    }
    
    
    @objc func goRestaurant(resInfo: ResInfoModel) {
        let restaurant = RestaurantViewController()
        restaurant.resinfo = resInfo
        self.navigationController?.pushViewController(restaurant, animated: true)
    }
    
    var clickedMap: Bool = false
    
    @objc func showMap() {
        if clickedMap == false {
            print("pressed map")
            self.clickedMap = true
            let indexPath = IndexPath(item: 1, section: 0)
            innerCategoryCollectionview.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
            mapImageView.image = UIImage(named: "listView")
        }
        else {
            print("pressed list")
            self.clickedMap = false
            let indexPath = IndexPath(item: 0, section: 0)
            innerCategoryCollectionview.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
            mapImageView.image = UIImage(named: "map")
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == innerCategoryFilterview {
            return filterNames.count
        }
        else if collectionView == dropDownCollectionview {
            if category == "한식" {
                return resCategories.count
            }
            else if category == "소주,맥주" {
                return sulCategories.count
            }
            else {
                self.arrowImageView.alpha = 0
                return 0
            }
        }
        else {
            return 2
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == innerCategoryFilterview {
            let frame = CGRect(x: 0, y: 0, width:  1000, height: 32)
            let dummyCell = CategoryFilterCell(frame: frame)
            let filterName = filterNames[indexPath.item]
            dummyCell.filterLabel.letterSpacing(text: filterName, spacing: -0.1)
            dummyCell.layoutIfNeeded()

            let textWidth = dummyCell.filterLabel.sizeThatFits(dummyCell.filterLabel.frame.size).width
            return CGSize(width: textWidth + 32 + 10, height: 32)
        }
            
        else if collectionView == dropDownCollectionview {
            return CGSize(width: collectionView.frame.width, height: 40)
        }
        
        else {
            
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }
    }
    
    var checkOpen: Bool = false
    
    
    @objc fileprivate func chooseCategory() {
        // https://stackoverflow.com/questions/28866865/changing-constraint-after-adding-it-causes-constraint-error-swift
        let animateDuration = 0.3
        let cellHeight: CGFloat = 40
        if checkOpen == false {
            if category == "한식" {
                self.dropDownHeightConstraint.constant = CGFloat(resCategories.count) * cellHeight
            }
            else if category == "소주,맥주" {
                self.dropDownHeightConstraint.constant = CGFloat(sulCategories.count) * cellHeight
            }
            self.arrowImageView.transform = self.arrowImageView.transform.rotated(by: .pi)
            UIView.animate(withDuration: animateDuration, delay: 0, options: .curveEaseInOut, animations: {
                self.view.layoutIfNeeded()
            }) { (complete) in
                self.checkOpen = true
            }
        }
        
        else {
            self.dropDownHeightConstraint.constant = 0
            self.arrowImageView.transform = self.arrowImageView.transform.rotated(by: .pi)
            UIView.animate(withDuration: animateDuration, delay: 0, options: .curveEaseInOut, animations: {
                self.view.layoutIfNeeded()
            }) { (complete) in
                self.checkOpen = false
            }
        }
        
    }
    
//    var topRatingReverse: Bool = false
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == dropDownCollectionview {
            var selectedCategory = ""
            if category == "한식" {
                selectedCategory = resCategories[indexPath.item]
            }
            else if category == "소주,맥주" {
                selectedCategory = sulCategories[indexPath.item]
            }
            searchText.text = selectedCategory
            
            let index = IndexPath(item: 0, section: 0)
            let cell = innerCategoryCollectionview.cellForItem(at: index) as! CategoryListCell
            cell.category = searchText.text ?? "한식"
            chooseCategory()
        }
        
        let index = IndexPath(item: 0, section: 0)
        
        guard let categoryCell = innerCategoryCollectionview.cellForItem(at: index) as? CategoryListCell else {return}
        // 임시방편
        let location = CLLocationCoordinate2D(latitude: 37.551597, longitude: 126.924976)
        if collectionView == innerCategoryFilterview {
            let filterName = filterNames[indexPath.item]
            if filterName == "Top rating" {
                categoryCell.getCategory_firebase(category: category ?? "Test", location: location, orderChild: "points", reverse: true)
            }
            else if filterName == "A to Z" {
                categoryCell.getCategory_firebase(category: category ?? "Test", location: location, orderChild: "resName", reverse: false)
            }
            else if filterName == "Seperate Toilet" {
                categoryCell.getCategory_firebase(category: category ?? "Test", location: location, orderChild: "toilet", reverse: true)
            }
        }
    }
    
}

class dropDownCell: UICollectionViewCell {
    
    let searchText: UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor.rgb(red: 51, green: 51, blue: 51)
        lb.font = UIFont(name: "DMSans-Medium", size: 16)
        lb.textAlignment = .center
        return lb
    }()
    
    let dividerLine: UIView = {
        let viewview = UIView()
        viewview.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        return viewview
    }()
    
    override var isHighlighted: Bool {
        didSet {
            self.backgroundColor = isHighlighted ? UIColor.mainColor.withAlphaComponent(0.3) : UIColor(white: 1, alpha: 0.3)
        }
    }
    
    override var isSelected: Bool {
        didSet {
            self.backgroundColor = isSelected ? UIColor.mainColor.withAlphaComponent(0.3) : UIColor(white: 1, alpha: 0.3)
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var searchTextConstraint: NSLayoutConstraint?
    var dividerLineConstraint: NSLayoutConstraint?
    
    fileprivate func setupLayouts() {
        backgroundColor = .white
        
        addSubview(searchText)
        addSubview(dividerLine)
        
        
        searchTextConstraint = searchText.anchor(self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 12, bottomConstant: 0, rightConstant: 36, widthConstant: 0, heightConstant: 0).first
        dividerLineConstraint = dividerLine.anchor(nil, left: self.leftAnchor, bottom: self.bottomAnchor
            , right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 1, rightConstant: 0, widthConstant: 0, heightConstant: 0.5).first
        
        
    }
}

class CategoryFilterCell: UICollectionViewCell {
    
    let filterImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .white
        return iv
    }()
    
    let filterLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "DMSans-Regular", size: 14)
        lb.textColor = .white
        lb.textAlignment = .left
        return lb
    }()
    
    override var isHighlighted: Bool {
        didSet {
            filterImageView.tintColor = isHighlighted ? UIColor.mainColor : UIColor.white
            filterLabel.textColor = isHighlighted ? UIColor.mainColor : UIColor.white
            self.backgroundColor = isHighlighted ? UIColor.white : UIColor(white: 1, alpha: 0.3)
        }
    }
    
    override var isSelected: Bool {
        didSet {
            filterImageView.tintColor = isSelected ? UIColor.mainColor : UIColor.white
            filterLabel.textColor = isSelected ? UIColor.mainColor : UIColor.white
            self.backgroundColor = isSelected ? UIColor.white : UIColor(white: 1, alpha: 0.3)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var filterImageViewConstraint: NSLayoutConstraint?
    var filterLabelConstraint: NSLayoutConstraint?
    
    fileprivate func setupViews() {
        backgroundColor = UIColor(white: 1, alpha: 0.3)
        addSubview(filterImageView)
        addSubview(filterLabel)
        
        filterImageViewConstraint = filterImageView.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, topConstant: 8, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 16, heightConstant: 16).first
        filterLabelConstraint = filterLabel.anchor(self.topAnchor, left: filterImageView.rightAnchor, bottom: nil, right: self.rightAnchor, topConstant: 7, leftConstant: 6, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 18).first
        
    }

}

class CategoryListCell: UICollectionViewCell, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    
    let cellid = "celldid"
    
    weak var categoryDelegate: CategoryCollectionView?
    var category: String? {
        didSet {
            // 임시방편
            let location = CLLocationCoordinate2D(latitude: 37.551597, longitude: 126.924976)
            getCategory_firebase(category: category ?? "Test", location: location, orderChild: "resName", reverse: false)
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    
    lazy var innerCategoryCollectionview: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.alwaysBounceVertical = true
        collectionview.showsVerticalScrollIndicator = false
        collectionview.backgroundColor = .white
        return collectionview
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var innerCategoryCollectionviewConstraint: NSLayoutConstraint?
    
    fileprivate func setupLayouts() {
        
        addSubview(innerCategoryCollectionview)
        
        innerCategoryCollectionviewConstraint = innerCategoryCollectionview.anchor(self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 0, heightConstant: 0).first
        
        innerCategoryCollectionview.register(innerSpotCell.self, forCellWithReuseIdentifier: cellid)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath) as! innerSpotCell
//        print(indexPath.item, "indexPath", self.pagingCount, "pagingCount", finishedPaging, "finishedPaging")
        if indexPath.item == self.pagingCount - 1 && finishedPaging {
            self.finishedPaging = false
            self.pagingCount += self.fixedCount
            // 임시 location
            let location = CLLocationCoordinate2D(latitude: 37.551597, longitude: 126.924976)
            pagingStart = 0
            getCategory_firebase(category: category ?? "Test", location: location, orderChild: saveChild, reverse: false)
        }
        if let resinfo = categoryResInfos[category ?? "Test"]?[indexPath.item] {

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
            
            if let urlString = resinfo.resImageUrl {
                let url = URL(string: urlString)
                cell.resImageView.sd_setImage(with: url, completed: nil)
            }
        }
        
        //이런식으로 indexPath.item 넘겨주기.
        cell.tag = indexPath.item
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goRestaurant(sender:))))
        return cell
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 16(위 여백) + 97 + 9 + 18 + 1 + 16
        let width = (self.frame.width - (24+15+24) ) / 2
        return CGSize(width: width, height: width + 44)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryResInfos[category ?? "Test"]?.count ?? 0
    }
    
    @objc fileprivate func goRestaurant(sender: UITapGestureRecognizer) {
        let indexPath = IndexPath(item: sender.view?.tag ?? 0, section: 0)
        if let resinfo = categoryResInfos[category ?? "Test"]?[indexPath.item] {
            categoryDelegate?.goRestaurant(resInfo: resinfo)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while get location \(error)")
    }
    
    var myLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 37.537774, longitude: 127.072661)
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        
        guard let lat = location?.coordinate.latitude else {return}
        guard let long = location?.coordinate.longitude else {return}
        let convertLocation = CLLocationCoordinate2D(latitude: lat, longitude: long)
//        self.myLocation = convertLocation
//        getCategory_firebase(category: category ?? "한식", location: convertLocation)
        self.locationManager.stopUpdatingLocation()
    }
    
    var category_name: String?
    
    var resInfos = [ResInfoModel]()
    let fetchCount = 13

    var categoryResInfos = [String:[ResInfoModel]]()
    var checkCategory: String?
    
    
    
    
 
    var AllObject = [String]()
    // pagingCount ==> paging 주요 변수
    var pagingCount = 3
    // fixedCount ==> 고정 paging 수(얼마씩 paging 할것인가?)
    let fixedCount = 3
    var finishedPaging = false
    // saveChild ==> category 저장용. (위에 filter 눌렀을때 바뀌는거 check 용)
    var saveChild: String = "resName"
    // pagingStart ==> 같은 category에서 paging할때 오류 제거용
    var pagingStart = 0
    var checkPagingCount = 1
    
    fileprivate func getCategory_firebase(category: String, location: CLLocationCoordinate2D, orderChild: String, reverse: Bool) {
        // function 몇번 했는지 확인.
        print("Paging operating..", checkPagingCount, "번")
        checkPagingCount += 1
        let ref = Database.database().reference().child(category)
        let query = ref.queryOrdered(byChild: orderChild)
        
        var snapshotCount = 0
        if self.saveChild != orderChild {
            self.AllObject.removeAll()
            self.resInfos.removeAll()
            self.pagingCount = fixedCount
        }
        // value로 해야 first children의 count 총합을 구할수있다.
        query.observeSingleEvent(of: .value) { (snapshot) in
            snapshotCount = snapshot.children.allObjects.count
//            print(snapshotCount, "snapshot count")
            query.observe(.childAdded, with: { [weak self] (snapshot) in
                self?.saveChild = orderChild
                if self?.pagingCount == self?.fixedCount {
                    // 처음 firebase 받아올때.
                    self?.AllObject.append(snapshot.key)
                }
                // firebase에서 해당 맛집들 다 가져왔을 때 실행. or 기존에서 paging할때 한번만 할수있게.
                if snapshotCount == self?.AllObject.count && self?.pagingStart == 0 {
                    // pagination 할때 반복되지 않기 위함..
                    self?.pagingStart += 1
                    if reverse { self?.AllObject.reverse() }
                    // 여기서 pagination을 추후 적용하면 된다.
//                    print(snapshotCount, "snapshot count",self!.pagingCount, "pagingcount")
                    if snapshotCount - (self!.pagingCount - self!.fixedCount) < self!.fixedCount { return }
                    for i in (self!.pagingCount - self!.fixedCount)..<self!.pagingCount {
                        guard let object = self?.AllObject[i] else {return}
//                        print(object)
                        self?.getResData_firebase(resName: object, category: category, location: location)
                    }
                }
                }) { (err) in
                    print("@@@Failed to fetch resData_AllObject:", err)
                }
        }
    }
    
    fileprivate func getResData_firebase(resName: String, category: String, location: CLLocationCoordinate2D) {
        let resReference = Database.database().reference().child("맛집").child(resName)
        resReference.observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
            if let dictionary = snapshot.value as? [String:Any] {
                let resmodel = ResInfoModel()
                
                resmodel.resName = dictionary["resName"] as? String
                resmodel.starPoint = dictionary["resPoints"] as? Double
                guard let lat = (dictionary["lat"] as? CLLocationDegrees) else {return}
                guard let long = (dictionary["long"] as? CLLocationDegrees) else {return}
                resmodel.resLocation = CLLocationCoordinate2D(latitude: lat, longitude: long)
                resmodel.distance = location.distance(from: CLLocationCoordinate2D(latitude: lat, longitude: long))
                resmodel.locationText = (dictionary["location"] as? String)
                resmodel.toilet = dictionary["toilet"] as? String
                // 추후에 resImage 항목 새로 음식 사진으로 넣어서 받자.
                // FirstResImage로 받기에는 오류가 걸린다!
                resmodel.resImageUrl = dictionary["resBackImage"] as? String
                
                // 해당 요일에 오픈 시간들 받아오기
                let openReference = Database.database().reference().child("맛집").child(resName).child("open").child(self?.getWeekDate() ?? "")
                openReference.observeSingleEvent(of: .value) { (snapshot) in
                    if let value = snapshot.value {
                        resmodel.open = value as? String
                    }
                }
                
                let closeReference = Database.database().reference().child("맛집").child(resName).child("close").child(self?.getWeekDate() ?? "")
                closeReference.observeSingleEvent(of: .value) { (snapshot) in
                    if let value = snapshot.value {
                        resmodel.close = value as? String
                    }
                }
                
              // 해당 맛집에서 hashtag 따오기
                let ref = Database.database().reference().child("맛집").child(resName).child("hashTag")
                ref.observeSingleEvent(of: .value) { (snapshot) in
                    if let dictionary = snapshot.value as? [String:Any] {
                        // 만약 hashTag가 DB에 없다면 결국 최종 append가 안된다고 생각.
                        resmodel.hash1 = dictionary["hash1"] as? String ?? ""
                        resmodel.hash2 = dictionary["hash2"] as? String ?? ""
                        resmodel.hash3 = dictionary["hash3"] as? String ?? ""
                        resmodel.hash4 = dictionary["hash4"] as? String ?? ""
                        resmodel.hash5 = dictionary["hash5"] as? String ?? ""
                    }
                }
                
                self?.resInfos.append(resmodel)
                if self!.resInfos.count % self!.fixedCount == 0 {
                    self?.finishedPaging = true
                }
                else {
                    self?.finishedPaging = false
                }
                self?.categoryResInfos[category] = self?.resInfos
                self?.checkCategory = category
            }
            DispatchQueue.main.async {
                self?.innerCategoryCollectionview.reloadData()
            }
        }) { (err) in
            print("Failed to fetch resData:", err)
        }

    }
     
    fileprivate func getWeekDate() -> String {
        let now = Date()
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "EEEE"
        let today = dateFormater.string(from: now)
        return today.convertDate()
    }
    
}


class CategoryMapCell: UICollectionViewCell, GMSMapViewDelegate {
    
    var category: String? {
        didSet {
            // 임시방편
            let location = CLLocationCoordinate2D(latitude: 37.551597, longitude: 126.924976)
            testCategory_firebase(category: category ?? "Test", location: location, orderChild: "resName", reverse: false)
//            locationManager.delegate = self
//            locationManager.requestWhenInUseAuthorization()
//            locationManager.desiredAccuracy = kCLLocationAccuracyBest
//            locationManager.startUpdatingLocation()
        }
    }
    
    weak var delegate: CategoryCollectionView?
    
    var entireView: UIView = {
        let view = UIView()
        return view
    }()
    
    var infoWindow: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    let whiteBackView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.masksToBounds = true
        return view
    }()
    
    let whiteTriBackView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    
    let resTitle: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "DMSans-Medium", size: 14)
        lb.textAlignment = .left
        lb.numberOfLines = 0
        lb.textColor = UIColor.rgb(red: 51, green: 51, blue: 51)
        return lb
    }()
    
    let infoLabel: UILabel = {
        let lb = UILabel()
        // https://zeddios.tistory.com/406
        lb.sizeToFit()
        lb.font = UIFont(name: "DMSans-Regular", size: 12)
        lb.textColor = UIColor.rgb(red: 68, green: 68, blue: 68)
        lb.textAlignment = .left
        lb.numberOfLines = 0
        return lb
    }()
    
    let resPoint: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "DMSans-Regular", size: 12)
        lb.textAlignment = .center
        lb.numberOfLines = 0
        lb.textColor = UIColor.rgb(red: 68, green: 68, blue: 68)
        lb.layer.cornerRadius = 12
        lb.layer.masksToBounds = true
        return lb
    }()
    
    let detailButton: UILabel = {
        let lb = UILabel()
        // letter spacing 1.0
        let attributedString = NSMutableAttributedString(string: "DETAILS")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(1.0), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.font = UIFont(name: "DMSans-Medium", size: 11)
        lb.textAlignment = .center
        lb.numberOfLines = 0
        lb.textColor = .white
        lb.backgroundColor = .mainColor
        lb.layer.cornerRadius = 11
        lb.layer.masksToBounds = true
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var entireViewConstraint: NSLayoutConstraint?


    var mapview = GMSMapView()
    
    
    fileprivate func setupLayouts() {
        backgroundColor = .green
        
        setupInfoWindow()
        
        
        let camera = GMSCameraPosition.camera(withLatitude: 37.552468, longitude: 126.923139, zoom: 17.5)
        mapview = GMSMapView.map(withFrame: .zero, camera: camera)
        mapview.delegate = self
        entireView = mapview
        

        addSubview(entireView)
        entireViewConstraint = entireView.anchor(self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
    }
    
    fileprivate func setupMarkers(location: CLLocationCoordinate2D, markerData: ResInfoModel) {
        let marker = GMSMarker(position: location)
        marker.map = mapview
        marker.icon = UIImage(named: "marker_pin")
        marker.userData = markerData
    }

    var resInfos = [ResInfoModel]()
    
    // test
    var testAllObject = [String]()
    var testCount = 6
    var saveChild: String = "resName"
    
    fileprivate func testCategory_firebase(category: String, location: CLLocationCoordinate2D, orderChild: String, reverse: Bool) {
        let ref = Database.database().reference().child(category)
        let query = ref.queryOrdered(byChild: orderChild)
        
        var snapshotCount = 0
        if self.saveChild != orderChild {
            self.testAllObject.removeAll()
            self.resInfos.removeAll()
        }
        // value로 해야 first children의 count 총합을 구할수있다.
        query.observeSingleEvent(of: .value) { (snapshot) in
            snapshotCount = snapshot.children.allObjects.count
            query.observe(.childAdded, with: { [weak self] (snapshot) in
                self?.saveChild = orderChild
                self?.testAllObject.append(snapshot.key)
                if snapshotCount == self?.testAllObject.count {
                    if reverse { self?.testAllObject.reverse() }
                    // 여기서 pagination을 추후 적용하면 된다.
                    for i in self?.testAllObject ?? [""] {
                        let resReference = Database.database().reference().child("맛집").child(i)
                        resReference.observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
                            if let dictionary = snapshot.value as? [String:Any] {
                                let resmodel = ResInfoModel()
                                
                                resmodel.resName = dictionary["resName"] as? String
                                resmodel.starPoint = dictionary["resPoints"] as? Double
                                guard let lat = (dictionary["lat"] as? CLLocationDegrees) else {return}
                                guard let long = (dictionary["long"] as? CLLocationDegrees) else {return}
                                resmodel.resLocation = CLLocationCoordinate2D(latitude: lat, longitude: long)
                                resmodel.distance = location.distance(from: CLLocationCoordinate2D(latitude: lat, longitude: long))
                                
                                // 해당 요일에 오픈 시간들 받아오기
                                let openReference = Database.database().reference().child("맛집").child(i).child("open").child(self?.getWeekDate() ?? "")
                                openReference.observeSingleEvent(of: .value) { (snapshot) in
                                    if let value = snapshot.value {
                                        resmodel.open = value as? String
                                    }
                                }
                                
                                let closeReference = Database.database().reference().child("맛집").child(i).child("close").child(self?.getWeekDate() ?? "")
                                closeReference.observeSingleEvent(of: .value) { (snapshot) in
                                    if let value = snapshot.value {
                                        resmodel.close = value as? String
                                    }
                                }
                                
                                guard let location = resmodel.resLocation else {return}
                                self?.setupMarkers(location: location, markerData: resmodel)
                            }
                            
                        }) { (err) in
                            print("Failed to fetch resData:", err)
                        }
                    }
                }
                }) { (err) in
                    print("@@@Failed to fetch resData_AllObject:", err)
                }
        }
        
    }

    fileprivate func getWeekDate() -> String {
        let now = Date()
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "EEEE"
        let today = dateFormater.string(from: now)
        return today.convertDate()
    }
    
    // infoWindow에는 autolayout 적용 불가능.
    fileprivate func setupInfoWindow() {
        let width:CGFloat = 143
        let height:CGFloat = 103
        infoWindow.frame = CGRect(x: 0, y: 0, width: width, height: height)
        let mapinfoview = MapinfoView(frame: infoWindow.frame)
        mapinfoview.backgroundColor = .clear
        infoWindow.addSubview(mapinfoview)
        
        infoWindow.addSubview(whiteBackView)
        whiteBackView.layer.cornerRadius = width * 0.04
        
        infoWindow.addSubview(whiteTriBackView)
        
        infoWindow.addSubview(resTitle)
        infoWindow.addSubview(infoLabel)
        infoWindow.addSubview(resPoint)
        infoWindow.addSubview(detailButton)
        
        whiteBackView.frame = CGRect(x: 0, y: 0, width: width, height: height * 6/7)
        whiteTriBackView.frame = CGRect(x: width * 2/5, y: height * 6/7, width: width * 1/5, height: 1)
        
        resTitle.frame = CGRect(x: 12, y: 12, width: 143 - 12, height: 18)
        infoLabel.frame = CGRect(x: 12, y: 32, width: 143, height: 16)
        resPoint.frame = CGRect(x: 12, y: 32 + 16 + 6, width: 32, height: 22)
        detailButton.frame = CGRect(x: width - 13 - 81, y: 32 + 16 + 6, width: 81, height: 22)
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        marker.tracksInfoWindowChanges = true
     return false
     }
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let data = marker.userData as! ResInfoModel?
        if data != nil {
            resTitle.letterSpacing(text: data?.resName ?? "", spacing: -0.1)
            
            var distanceString = ""
            if let distance = data?.distance {
                if distance < 1000.0 {
                    distanceString = String(format: "%.0f", distance) + "m"
                }
                else {
                    let kmDistance = distance / 1000.0
                    distanceString = String(format: "%.0f", kmDistance) + "km"
                }
            }
            
            let open: String = data?.open ?? "00"
            let close: String = data?.close ?? "00"
            
            let now = Date()
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HHmm"
            let time = timeFormatter.string(from: now)
            var openString = ""
            if time.convertInt() > open.convertInt() && time.convertInt() < close.convertInt() {
                openString = "Open"
            }
            else {
                openString = "Closed"
            }
            
            let attributedString = NSMutableAttributedString(string: "")
            let seperator = NSTextAttachment()
            seperator.image = UIImage(named: "time")
            seperator.bounds = CGRect(x: 0, y: 0, width: 10, height: 10)
            attributedString.append(NSAttributedString(attachment: seperator))
            attributedString.append(NSAttributedString(string: " \(openString) "))
            let locationImage = NSTextAttachment()
            locationImage.image = UIImage(named: "location")
            locationImage.bounds = CGRect(x: 0, y: -1, width: 10, height: 10)
            attributedString.append(NSAttributedString(attachment: locationImage))
            attributedString.append(NSAttributedString(string: " \(distanceString)"))
            infoLabel.attributedText = attributedString
            
            let point = data?.starPoint ?? 3.5
            resPoint.text = "\(String(describing: point))"
            if point < 3.0 {
                resPoint.backgroundColor = .pink
            }
            else if point < 4 {
                resPoint.backgroundColor = .wheat
            }
            else {
                resPoint.backgroundColor = .lightGreen
            }
        }
        
     return self.infoWindow
    }
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
//        delegate?.goRestaurant()
    }

}

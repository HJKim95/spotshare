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
    }
    
    @objc fileprivate func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    let filterNames = ["Top rating", "Now Open", "Liked", "A to Z", "Seperate Toilet"]
    let filterSizes = [106, 109, 76, 80, 138]
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == innerCategoryFilterview {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath) as! CategoryFilterCell
            cell.layer.cornerRadius = 4
            cell.layer.masksToBounds = true
            
            let filterName = filterNames[indexPath.item]
            let attributedString = NSMutableAttributedString(string: filterName)
            //letter spacing -0.1
            attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(-0.1), range: NSRange(location: 0, length: attributedString.length))
            
            cell.filterImageView.image = UIImage(named: filterName)?.withRenderingMode(.alwaysTemplate)
            cell.filterLabel.attributedText = attributedString
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
            let customWidth = filterSizes[indexPath.item]
            return CGSize(width: customWidth, height: 32)
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
//        getCategory_firebase()
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

        if indexPath.item == indexInfo - 1 && finishedPaging {
            getCategory_firebase(category: category ?? "한식", location: myLocation)
        }
        if let resinfo = categoryResInfos[category ?? "한식"]?[indexPath.item] {
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
            cell.distanceLabel.text = resinfo.distance
            
            let url = URL(string: resinfo.resImageUrl ?? "")
            cell.resImageView.sd_setImage(with: url, completed: nil)
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
        return categoryResInfos[category ?? "한식"]?.count ?? 0
    }
    
    @objc fileprivate func goRestaurant(sender: UITapGestureRecognizer) {
        let indexPath = IndexPath(item: sender.view?.tag ?? 0, section: 0)
        if let resinfo = categoryResInfos[category ?? "한식"]?[indexPath.item] {
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
        self.myLocation = convertLocation
        getCategory_firebase(category: category ?? "한식", location: convertLocation)
        self.locationManager.stopUpdatingLocation()
    }
    
    var category_name: String?
    
    var allobject = [String]()
    var resInfos = [ResInfoModel]()
    let fetchCount = 6
    
    var countInfo = 0
    var indexInfo = 0
    var checkCount = 6
    
    var categoryResInfos = [String:[ResInfoModel]]()
    var checkCategory: String?
    var finishedPaging = false
    
    fileprivate func getCategory_firebase(category: String, location: CLLocationCoordinate2D) {
        let ref = Database.database().reference().child(category)
        var query = ref.queryOrderedByKey()
        if allobject.count > 0 {
            
            if self.checkCategory != category {
                self.resInfos.removeAll()
                self.indexInfo = 0
                self.checkCount = 6
            }
            
            else {
                let value = allobject.last
                query = query.queryStarting(atValue: value)
                checkCount = 5
            }
            
        }
        
        allobject.removeAll()
        
        self.countInfo = 0
        query.queryLimited(toFirst: 6).observe(.childAdded, with: { [weak self] (snapshot) in
            self?.allobject.append(snapshot.key)
            if self?.allobject.count == self?.fetchCount {
                if self?.resInfos.count ?? -1 > 0 {
                    self?.allobject.removeFirst()
                }
                
                for i in self?.allobject ?? [""] {
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
                            resmodel.locationText = (dictionary["location"] as? String)
                            resmodel.toilet = dictionary["toilet"] as? String
                            
                            
//                             해당 맛집에서 첫번째 이미지 따오기.
                            let firstImageReference = Database.database().reference().child("맛집").child(i).child("FirstResimage")
                            firstImageReference.observeSingleEvent(of: .childAdded, with: { (snapshot) in
                                if let dictionary = snapshot.value as? [String:Any] {
                                    resmodel.resImageUrl = dictionary["url"] as? String
                                }
                            })
                            
                            // 해당 맛집에서 hashtag 따오기
                            let ref = Database.database().reference().child("맛집").child(i).child("hashTag")
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
                            self?.categoryResInfos[category] = self?.resInfos
                            self?.checkCategory = category
                            self?.countInfo += 1
                            self?.indexInfo += 1
                            if self?.countInfo == self?.checkCount {
                                self?.finishedPaging = true
                            }
                            else {
                                self?.finishedPaging = false
                            }
                        }
                        DispatchQueue.main.async {
                            self?.innerCategoryCollectionview.reloadData()
                        }
                    }) { (err) in
                        print("Failed to fetch resData:", err)
                    }
                }
                
            }
        }) { (err) in
            print("Failed to fetch 한식Data:", err)
        }
        
    }
    
}


class CategoryMapCell: UICollectionViewCell, GMSMapViewDelegate {
    
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
        // letter spacing -0.1
        let attributedString = NSMutableAttributedString(string: "Cool Restaurant")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(-0.1), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.font = UIFont(name: "DMSans-Medium", size: 14)
        lb.textAlignment = .left
        lb.numberOfLines = 0
        lb.textColor = UIColor.rgb(red: 51, green: 51, blue: 51)
        return lb
    }()
    
    let infoLabel: UILabel = {
        let lb = UILabel()
        // https://zeddios.tistory.com/406
        let attributedString = NSMutableAttributedString(string: "")
        let seperator = NSTextAttachment()
        seperator.image = UIImage(named: "time")
        seperator.bounds = CGRect(x: 0, y: 0, width: 10, height: 10)
        attributedString.append(NSAttributedString(attachment: seperator))
        attributedString.append(NSAttributedString(string: " Open "))
        let locationImage = NSTextAttachment()
        locationImage.image = UIImage(named: "location")
        locationImage.bounds = CGRect(x: 0, y: -1, width: 10, height: 10)
        attributedString.append(NSAttributedString(attachment: locationImage))
        attributedString.append(NSAttributedString(string: " 5km"))
        lb.attributedText = attributedString
        lb.sizeToFit()
        lb.font = UIFont(name: "DMSans-Regular", size: 12)
        lb.textColor = UIColor.rgb(red: 68, green: 68, blue: 68)
        lb.textAlignment = .left
        lb.numberOfLines = 0
        return lb
    }()
    
    let resPoint: UILabel = {
        let lb = UILabel()
        // letter spacing 0.0
        let attributedString = NSMutableAttributedString(string: "4.2")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(0.0), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.font = UIFont(name: "DMSans-Regular", size: 12)
        lb.textAlignment = .center
        lb.numberOfLines = 0
        lb.textColor = UIColor.rgb(red: 68, green: 68, blue: 68)
        lb.backgroundColor = .lightGreen
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

    
    var marker = GMSMarker()
    var mapview = GMSMapView()
    
    
    fileprivate func setupLayouts() {
        backgroundColor = .green
        
        setupInfoWindow()
        
        
        let camera = GMSCameraPosition.camera(withLatitude: 37.552468, longitude: 126.923139, zoom: 17.5)
        mapview = GMSMapView.map(withFrame: .zero, camera: camera)
        mapview.delegate = self
        entireView = mapview
        
        marker.position = CLLocationCoordinate2D(latitude: 37.552468, longitude: 126.923139)
        marker.icon = UIImage(named: "marker_pin")
        marker.map = mapview
        
        addSubview(entireView)
        entireViewConstraint = entireView.anchor(self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
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
     return false
     }
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
     return self.infoWindow
    }
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
//        delegate?.goRestaurant()
    }

}

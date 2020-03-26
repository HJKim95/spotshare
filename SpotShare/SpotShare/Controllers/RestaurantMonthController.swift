//
//  RestaurantMonth.swift
//  SpotShare
//
//  Created by 김희중 on 18/11/2019.
//  Copyright © 2019 김희중. All rights reserved.
//

import UIKit
import Cosmos
import Firebase
import GoogleMaps
import SDWebImage

// https://github.com/ink-spot/UPCarouselFlowLayout
// https://github.com/evgenyneu/Cosmos/blob/master/README.md
// https://github.com/SDWebImage/SDWebImage

class RestaurantMonthController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    deinit {
        print("no retain cycle in RestaurantMonthController")
    }
    
    fileprivate let cellid = "cellid"
    fileprivate let cellPercentWidth: CGFloat = 0.7
    // https://github.com/ink-spot/UPCarouselFlowLayout
    

    let backGroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "restMonth_mask")
        iv.layer.masksToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    lazy var backImageView: UIImageView = {
           let iv = UIImageView()
           iv.image = UIImage(named: "back")
           iv.contentMode = .scaleAspectFit
           iv.isUserInteractionEnabled = true
           iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goBack)))
           return iv
       }()
    
    let TitleLabel: UILabel = {
        let lb = UILabel()
        // letter spacing -0.5
        lb.letterSpacing(text: "Restaurant of the Month", spacing: -0.5)
        lb.font = UIFont(name: "DMSans-Medium", size: 28)
        lb.textColor = .darkGray
        lb.textAlignment = .center
        lb.numberOfLines = 0
        return lb
    }()
    
    let restDate: UILabel = {
        let lb = UILabel()
        // letter spacing -0.1
        lb.letterSpacing(text: "June 2019", spacing: -0.1)
        lb.font = UIFont(name: "DMSans-Regular", size: 16)
        lb.textColor = .gray
        lb.textAlignment = .center
        lb.numberOfLines = 0
        return lb
    }()
    
    // https://github.com/ink-spot/UPCarouselFlowLayout
    let flowLayout = UPCarouselFlowLayout()
    
    lazy var innerCollectionview: UICollectionView = {
        flowLayout.scrollDirection = .horizontal
        flowLayout.spacingMode = UPCarouselFlowLayoutSpacingMode.fixed(spacing: 30)
        flowLayout.sideItemScale = 0.9
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.alwaysBounceHorizontal = true
        collectionview.showsHorizontalScrollIndicator = false
        collectionview.backgroundColor = .clear
        return collectionview
    }()
    
    let pageIndicator: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "DMSans-Regular", size: 16)
        lb.textColor = .gray
        lb.textAlignment = .center
        lb.numberOfLines = 0
        return lb
    }()
    
    fileprivate var pageSize: CGSize {
        let layout = self.innerCollectionview.collectionViewLayout as! UPCarouselFlowLayout
        var pageSize = layout.itemSize
        if layout.scrollDirection == .horizontal {
            pageSize.width += layout.minimumLineSpacing
        } else {
            pageSize.height += layout.minimumLineSpacing
        }
        return pageSize
    }
     
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        // swipe로 back 구현하려면 두개 다 써줘야함.
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        setupLayouts()
        
        innerCollectionview.register(innerRestMonthCell.self, forCellWithReuseIdentifier: cellid)

        getResMonth_firebase()
    }
    
    var resInfos = [ResInfoModel]()
    var checkOpen = [Bool]()
    
    fileprivate func getResMonth_firebase() {
        let ref = Database.database().reference().child("추천")
        ref.observe(.childAdded, with: { [weak self] (snapshot) in
            let snapid = snapshot.key
            let magazineReference = Database.database().reference().child("맛집").child(snapid)
            
            magazineReference.observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
                if let dictionary = snapshot.value as? [String:Any] {
                    let resInfo = ResInfoModel()
                    
                    // 주석한 부분은 그 다음 RestaurantViewController 넘어갈때 추가로 데이터 받아오기
                    // 그래야 각각 데이터 가져오는데 시간이 빠르고 효율적일듯.
                    resInfo.resName = dictionary["resName"] as? String
                    resInfo.starPoint = dictionary["resPoints"] as? Double
                    guard let lat = (dictionary["lat"] as? CLLocationDegrees) else {return}
                    guard let long = (dictionary["long"] as? CLLocationDegrees) else {return}
                    resInfo.resLocation = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    resInfo.locationText = (dictionary["location"] as? String)
                    resInfo.toilet = dictionary["toilet"] as? String
                    
                    // 해당 맛집에서 첫번째 이미지 따오기.
                    let magazineReference = Database.database().reference().child("맛집").child(snapid).child("FirstResimage")
                    magazineReference.observeSingleEvent(of: .childAdded, with: { (snapshot) in
                        if let dictionary = snapshot.value as? [String:Any] {
                            resInfo.resImageUrl = dictionary["url"] as? String
                        }
                    })
                    
                    // 해당 맛집에서 hashtag 따오기
                    let ref = Database.database().reference().child("맛집").child(snapid).child("hashTag")
                    ref.observeSingleEvent(of: .value) { [weak self] (snapshot) in
                        if let dictionary = snapshot.value as? [String:Any] {
                            // 만약 hashTag가 DB에 없다면 결국 최종 append가 안된다고 생각.
                            resInfo.hash1 = dictionary["hash1"] as? String ?? ""
                            resInfo.hash2 = dictionary["hash2"] as? String ?? ""
                            resInfo.hash3 = dictionary["hash3"] as? String ?? ""
                            resInfo.hash4 = dictionary["hash4"] as? String ?? ""
                            resInfo.hash5 = dictionary["hash5"] as? String ?? ""

                            self?.checkOpen.append(false)
                            self?.resInfos.append(resInfo)
                            
                        }
                        DispatchQueue.main.async {
                            self?.innerCollectionview.reloadData()
                        }
                    }
                    
                }
                
            }, withCancel: { (err) in
                print("Failed to fetch resMonthData:", err)
            })
            
        }, withCancel: { (err) in
            print("Failed to fetch all resMonthDatas:", err)
        })
    }

    
    
    
    var backGroundImageViewConstraint: NSLayoutConstraint?
    var backImageViewConstraint: NSLayoutConstraint?
    var innerCollectionviewConstraint: NSLayoutConstraint?
    var TitleLabelConstraint: NSLayoutConstraint?
    var restDateConstraint: NSLayoutConstraint?
    var pageIndicatorConstraint: NSLayoutConstraint?
    var cosmosViewConstraint: NSLayoutConstraint?

    fileprivate func setupLayouts() {
        
        view.addSubview(backGroundImageView)
        view.addSubview(backImageView)
        view.addSubview(TitleLabel)
        view.addSubview(restDate)
        view.addSubview(innerCollectionview)
        view.addSubview(pageIndicator)
        
        

        if #available(iOS 11.0, *) {
            
            // iphone se,7,8 etc
            if view.frame.height < 800 {
                let height: CGFloat = 430
                self.flowLayout.itemSize = setCellImageWidth(height: height)
                
                
                backGroundImageViewConstraint = backGroundImageView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
                backImageViewConstraint = backImageView.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 16, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 24, heightConstant: 24).first
                TitleLabelConstraint = TitleLabel.anchor(backImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 10, leftConstant: 100, bottomConstant: 0, rightConstant: 100, widthConstant: 0, heightConstant: 84).first
                restDateConstraint = restDate.anchor(TitleLabel.bottomAnchor, left: TitleLabel.leftAnchor, bottom: nil, right: TitleLabel.rightAnchor, topConstant: 6, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 26).first
                innerCollectionviewConstraint = innerCollectionview.anchor(restDate.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 20.5, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: height).first
                pageIndicatorConstraint = pageIndicator.anchor(nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 30, rightConstant: 0, widthConstant: 0, heightConstant: 26).first
            }
            else {
                let height: CGFloat = 450
                self.flowLayout.itemSize = setCellImageWidth(height: height)
                
                
                backGroundImageViewConstraint = backGroundImageView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
                backImageViewConstraint = backImageView.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 16, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 24, heightConstant: 24).first
                TitleLabelConstraint = TitleLabel.anchor(backImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 30, leftConstant: 100, bottomConstant: 0, rightConstant: 100, widthConstant: 0, heightConstant: 84).first
                restDateConstraint = restDate.anchor(TitleLabel.bottomAnchor, left: TitleLabel.leftAnchor, bottom: nil, right: TitleLabel.rightAnchor, topConstant: 6, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 26).first
                innerCollectionviewConstraint = innerCollectionview.anchor(restDate.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 20.5, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: height).first
                pageIndicatorConstraint = pageIndicator.anchor(nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 34, rightConstant: 0, widthConstant: 0, heightConstant: 26).first
            }
            
        }
            
        else {
            // iphone se,7,8 etc
            if view.frame.height < 800 {
                let height: CGFloat = 430
                self.flowLayout.itemSize = setCellImageWidth(height: height)
                
                
                backGroundImageViewConstraint = backGroundImageView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
                backImageViewConstraint = backImageView.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 16, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 24, heightConstant: 24).first
                TitleLabelConstraint = TitleLabel.anchor(backImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 10, leftConstant: 100, bottomConstant: 0, rightConstant: 100, widthConstant: 0, heightConstant: 84).first
                innerCollectionviewConstraint = innerCollectionview.anchor(restDate.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 20.5, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: height).first
                pageIndicatorConstraint = pageIndicator.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 30, rightConstant: 0, widthConstant: 0, heightConstant: 26).first
            }
            else {
                let height: CGFloat = 450
                self.flowLayout.itemSize = setCellImageWidth(height: height)
                
                
                backGroundImageViewConstraint = backGroundImageView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
                backImageViewConstraint = backImageView.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 16, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 24, heightConstant: 24).first
                TitleLabelConstraint = TitleLabel.anchor(backImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 30, leftConstant: 100, bottomConstant: 0, rightConstant: 100, widthConstant: 0, heightConstant: 84).first
                innerCollectionviewConstraint = innerCollectionview.anchor(restDate.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 20.5, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: height).first
                pageIndicatorConstraint = pageIndicator.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 34, rightConstant: 0, widthConstant: 0, heightConstant: 26).first
            }
        }
    }
    
    fileprivate func setCellImageWidth(height: CGFloat) -> CGSize{
        // width/height
        let imageRatio: CGFloat = 5/9
        let width = imageRatio * height
        return CGSize(width: width, height: height)
    }
    
    @objc fileprivate func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let pageCount = resInfos.count
        // letter spacing -0.1
        pageIndicator.letterSpacing(text: "1/\(pageCount)", spacing: -0.1)
        return pageCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath) as! innerRestMonthCell
        cell.delegate = self
        cell.index = indexPath.item
        let resInfo = resInfos[indexPath.item]
        
        
        // letter spacing -0.4
        cell.resNameLabel.letterSpacing(text: resInfo.resName ?? "", spacing: -0.4)
        
        cell.cosmosView.rating = resInfo.starPoint ?? 3.5
        
        let url = URL(string: resInfo.resImageUrl ?? "")
        cell.resImageView.sd_setImage(with: url, completed: nil)
        
        let toilet = resInfo.toilet ?? "공용"
        cell.toilet = toilet
        
        
        cell.hash1 = resInfo.hash1 ?? ""
        cell.hash2 = resInfo.hash2 ?? ""


        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(openCell2(sender:)))
        swipeDownGesture.direction = .down
        let swipeUpGesture = UISwipeGestureRecognizer(target: self, action: #selector(closeCell2(sender:)))
        swipeUpGesture.direction = .up
        // 이렇게 tag를 이용해서 selector의 parameter를 가져오자..
        cell.tag = indexPath.item
        cell.addGestureRecognizer(swipeUpGesture)
        cell.addGestureRecognizer(swipeDownGesture)
        
        
        
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let layout = self.innerCollectionview.collectionViewLayout as! UPCarouselFlowLayout
        
      // check if the currentCenteredPage is not the page that was touched
        let currentCenteredPage = layout.currentCenteredPage
      if currentCenteredPage != indexPath.row {
        // trigger a scrollToPage(index: animated:)
        
        layout.scrollToPage(index: indexPath.row, animated: true)
        
        
        let pageCount = resInfos.count
        // letter spacing -0.1
        pageIndicator.letterSpacing(text: "\(indexPath.row + 1)/\(pageCount)", spacing: -0.1)
      }

        let checkCurrentPage = currentCenteredPage
        
        if checkCurrentPage == indexPath.item {
            if self.checkOpen[indexPath.item] == false {
                self.openCell(indexPath: indexPath)
            }
            else {
                self.goRestaurant(indexPath: indexPath)
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let layout = self.innerCollectionview.collectionViewLayout as! UPCarouselFlowLayout
        let pageSide = (layout.scrollDirection == .horizontal) ? self.pageSize.width : self.pageSize.height
        let offset = (layout.scrollDirection == .horizontal) ? scrollView.contentOffset.x : scrollView.contentOffset.y
        let currentPage = Int(floor((offset - pageSide / 2) / pageSide) + 1) + 1
        
        let pageCount = resInfos.count
        // letter spacing -0.1
        pageIndicator.letterSpacing(text: "\(currentPage)/\(pageCount)", spacing: -0.1)
        
    }
    
    
    @objc fileprivate func openCell2(sender: UISwipeGestureRecognizer) {
        // 이렇게 tag를 이용해서 selector의 parameter를 가져오자..
        let indexPath = IndexPath(item: sender.view?.tag ?? 0, section: 0)
        let cell = innerCollectionview.cellForItem(at: indexPath) as? innerRestMonthCell
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            cell?.whiteView.transform = CGAffineTransform(scaleX: 1.1, y: 1).translatedBy(x: 0, y: 70)
            cell?.resImageView.transform = CGAffineTransform(scaleX: 1, y: 1).translatedBy(x: 0, y: -30)
            cell?.containerView.layer.shadowOpacity = 0.1
            self.checkOpen[indexPath.item] = true
        }, completion: nil)
    }
    
    @objc fileprivate func closeCell2(sender: UISwipeGestureRecognizer) {
        // 이렇게 tag를 이용해서 selector의 parameter를 가져오자..
        let indexPath = IndexPath(item: sender.view?.tag ?? 0, section: 0)
        let cell = innerCollectionview.cellForItem(at: indexPath) as? innerRestMonthCell
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            cell?.whiteView.transform = CGAffineTransform.identity
            cell?.resImageView.transform = CGAffineTransform.identity
            cell?.containerView.layer.shadowOpacity = 0.0
            self.checkOpen[indexPath.item] = false
        }, completion: nil)
    }
    
    fileprivate func openCell(indexPath: IndexPath) {
        
        let cell = innerCollectionview.cellForItem(at: indexPath) as? innerRestMonthCell
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            cell?.whiteView.transform = CGAffineTransform(scaleX: 1.1, y: 1).translatedBy(x: 0, y: 70)
            cell?.resImageView.transform = CGAffineTransform(scaleX: 1, y: 1).translatedBy(x: 0, y: -30)
            cell?.containerView.layer.shadowOpacity = 0.1
            self.checkOpen[indexPath.item] = true
        }, completion: nil)
    }
    
    fileprivate func goRestaurant(indexPath: IndexPath) {
        let resinfo = resInfos[indexPath.item]
        
        let rest = RestaurantViewController()
        rest.resinfo = resinfo
        self.navigationController?.pushViewController(rest, animated: true)
    }
}

class innerRestMonthCell: UICollectionViewCell, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    weak var delegate: RestaurantMonthController?
    var index: Int?
    
    fileprivate let cellid = "cellid"
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowOpacity = 0.0
        view.layer.shadowRadius = 10
        view.layer.masksToBounds = false
        return view
    }()
    
    let whiteView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    
    let resImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .clear
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = 10
        return iv
    }()
    
    var open_Bool: String = "Closed"
    var far_location: String = "14 min walk"
    var toilet: String? {
        didSet {
            setupInfos()
        }
    }
    
    let infoLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "DMSans-Regular", size: 12)
        lb.textColor = .gray
        lb.textAlignment = .center
        lb.numberOfLines = 0
        return lb
    }()
    
    lazy var hashCollecionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.dataSource = self
        cv.delegate = self
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .white
        return cv
    }()
    
    let resNameLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .white
        lb.textAlignment = .center
        lb.numberOfLines = 0
        lb.font = UIFont(name: "DMSans-Regular", size: 22)
        return lb
    }()
    
    lazy var cosmosView: CosmosView = {
        var cv = CosmosView()
        cv.settings.updateOnTouch = false
        cv.settings.totalStars = 5
        cv.settings.starSize = 16
        cv.settings.starMargin = 1
        cv.settings.fillMode = .half
        cv.settings.filledImage = UIImage(named: "filledStar")
        cv.settings.emptyImage = UIImage(named: "emptyStar")
        return cv
    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var containerViewConstraint: NSLayoutConstraint?
    var whiteViewConstraint: NSLayoutConstraint?
    var resImageViewConstraint: NSLayoutConstraint?
    var infoLabelConstraint: NSLayoutConstraint?
    var seperatorImageViewConstraint: NSLayoutConstraint?
    var locationImageViewConstraint: NSLayoutConstraint?
    var locationLabelConstraint: NSLayoutConstraint?
    var toiletImageViewConstraint: NSLayoutConstraint?
    var toiletLabelConstraint: NSLayoutConstraint?
    var hashCollecionViewConstraint: NSLayoutConstraint?
    var cosmosViewConstraint: NSLayoutConstraint?
    var restNameLabelConstraint: NSLayoutConstraint?
    
    var hashtagArray = [String]()
    
    var hash1: String? {
        didSet {
            hashtagArray.append(hash1 ?? "")
        }
    }
    
    var hash2: String? {
        didSet {
            hashtagArray.append(hash2 ?? "")
        }
    }

    
    var gradient = CAGradientLayer()
    
    fileprivate func setupViews() {
        backgroundColor = .clear
        
        addSubview(containerView)
        containerView.addSubview(whiteView)
        addSubview(resImageView)
        whiteView.addSubview(infoLabel)
        whiteView.addSubview(hashCollecionView)
        resImageView.addSubview(cosmosView)
        resImageView.addSubview(resNameLabel)
        
        hashCollecionView.register(infoHashCell.self, forCellWithReuseIdentifier: cellid)
        
        containerViewConstraint = containerView.anchor(self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 30, leftConstant: 0, bottomConstant: 100, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
        whiteViewConstraint = whiteView.anchor(self.containerView.topAnchor, left: self.containerView.leftAnchor, bottom: self.containerView.bottomAnchor, right: self.containerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
        resImageViewConstraint = resImageView.anchor(self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 30, leftConstant: 0, bottomConstant: 100, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
        infoLabelConstraint = infoLabel.anchor(nil, left: whiteView.leftAnchor, bottom: whiteView.bottomAnchor, right: whiteView.rightAnchor, topConstant: 0, leftConstant: 15, bottomConstant: 60, rightConstant: 15, widthConstant: 0, heightConstant: 16).first
        hashCollecionViewConstraint = hashCollecionView.anchor(infoLabel.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 15, leftConstant: 25, bottomConstant: 0, rightConstant: 25, widthConstant: 0, heightConstant: 24).first
        cosmosViewConstraint = cosmosView.anchor(nil, left: self.leftAnchor, bottom: resImageView.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 80, bottomConstant: 26, rightConstant: 80, widthConstant: 0, heightConstant: 18).first
        restNameLabelConstraint = resNameLabel.anchor(nil, left: self.leftAnchor, bottom: cosmosView.topAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 10, rightConstant: 0, widthConstant: 0, heightConstant: 25).first
        
        resImageView.setGradientBackgroundVertical(gradientLayer: gradient, colorOne:UIColor(white: 0, alpha: 0), colorTwo: UIColor(white: 0, alpha: 0.6))
        
        
    }
     // https://fluffy.es/solve-duplicated-cells/
    // 3번째 cell부터 reuse되는걸 막음.
    override func prepareForReuse() {
        super.prepareForReuse()

        whiteView.transform = CGAffineTransform.identity
        resImageView.transform = CGAffineTransform.identity
        containerView.layer.shadowOpacity = 0.0
        delegate?.checkOpen[index ?? 0] = false
        
        // 밑에 두줄은 신의 한수!
        hashtagArray.removeAll()
        cellWidthArr.removeAll()
        hashCollecionView.reloadData()

    }
    
    fileprivate func setupInfos() {
        // https://zeddios.tistory.com/406
        let attributedString = NSMutableAttributedString(string: "\(open_Bool) ")
        let seperator = NSTextAttachment()
        seperator.image = UIImage(named: "seperator")
        seperator.bounds = CGRect(x: 0, y: 0, width: 9, height: 9)
        attributedString.append(NSAttributedString(attachment: seperator))
        attributedString.append(NSAttributedString(string: " "))
        let locationImage = NSTextAttachment()
        locationImage.image = UIImage(named: "location")
        locationImage.bounds = CGRect(x: 0, y: 0, width: 12, height: 12)
        attributedString.append(NSAttributedString(attachment: locationImage))
        attributedString.append(NSAttributedString(string: " \(far_location)  "))
        let toiletImage = NSTextAttachment()
        if toilet == "공용" {
            toiletImage.image = UIImage(named: "Unisex Toilet_gray")
        }
        else {
            toiletImage.image = UIImage(named: "Seperate Toilet_gray")
        }
        toiletImage.bounds = CGRect(x: 0, y: -1, width: 14, height: 14)
        attributedString.append(NSAttributedString(attachment: toiletImage))
        attributedString.append(NSAttributedString(string: " \(toilet ?? "공용")"))
        infoLabel.attributedText = attributedString
        infoLabel.sizeToFit()
    }
    
    // autolayout 사용시에는 gradient 설정하고 밑에 viewDidLayoutSubviews를 설정해주어야함.
    // collectionview 안에 있는 cell은 이걸로 설정!!
    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = resImageView.bounds
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hashtagArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath) as! infoHashCell
        // spacing -0.1
        cell.hashLabel.letterSpacing(text: "#" + hashtagArray[indexPath.item], spacing: -0.1)
        cell.hashLabel.font = UIFont(name: "DMSans-Regular", size: 13)

        return cell
    }
    var cellWidthArr = [CGFloat]()
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 밑에 frame의 width에 따라 width가 너무 작으면 오류가 나더라.. constraint관련해서
        let frame = CGRect(x: 0, y: 0, width:  1000, height: 24)
        let dummyCell = infoHashCell(frame: frame)
        dummyCell.hashLabel.letterSpacing(text: "#" + hashtagArray[indexPath.item], spacing: -0.1)
        dummyCell.layoutIfNeeded()

        let textWidth = dummyCell.hashLabel.sizeThatFits(dummyCell.hashLabel.frame.size).width + 10
        cellWidthArr.append(textWidth)

        return CGSize(width: textWidth, height: 24)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        // cell 크기가 유동적으로 변하기 때문에 popular 한 68크기로 잡음
        // cell들이 중앙에 위치하게 하는 코드.
        // https://stackoverflow.com/questions/34267662/how-to-center-horizontally-uicollectionview-cells
        
        let totalCellWidth: CGFloat = cellWidthArr[0] + cellWidthArr[1]
        let totalSpacingWidth: CGFloat = 8 * CGFloat(hashtagArray.count - 1)
        let collectionViewWidth = self.frame.width - 50
        let leftInset = (collectionViewWidth - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
        let rightInset = leftInset
        
        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
    }
    
}

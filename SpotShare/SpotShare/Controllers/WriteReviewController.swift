//
//  WriteReviewController.swift
//  SpotShare
//
//  Created by 김희중 on 20/01/2020.
//  Copyright © 2020 김희중. All rights reserved.
//

import UIKit
import Cosmos
import YPImagePicker

// https://github.com/ergunemr/BottomPopup
// https://github.com/evgenyneu/Cosmos
// https://github.com/Yummypets/YPImagePicker

class WriteReviewController: BottomPopupViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    deinit {
        print("no retain cycle in WriteReivewController")
    }
    
    fileprivate let cellid = "cellid"
    fileprivate let cellid2 = "cellid2"
    fileprivate let cellid3 = "cellid3"
    fileprivate let cellid4 = "cellid4"
    fileprivate let cellid5 = "celli5"
    
    
    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?
    
    // Bottom popup attribute methods
    // You can override the desired method to change appearance
    
    override func getPopupHeight() -> CGFloat {
        return height ?? CGFloat(300)
    }
    
    override func getPopupTopCornerRadius() -> CGFloat {
        return topCornerRadius ?? CGFloat(10)
    }
    
    override func getPopupPresentDuration() -> Double {
        return presentDuration ?? 1.0
    }
    
    override func getPopupDismissDuration() -> Double {
        return dismissDuration ?? 1.0
    }
    
    override func shouldPopupDismissInteractivelty() -> Bool {
        return shouldDismissInteractivelty ?? true
    }
    
    let thumbView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 204, green: 204, blue: 204)
        view.layer.cornerRadius = 2.5
        view.layer.masksToBounds = true
        return view
    }()
    
    let shareLabel: UILabel = {
        let lb = UILabel()
        // letter spacing 1.17
        let attributedString = NSMutableAttributedString(string: "SHARE YOUR REVIEW")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(1.17), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.font = UIFont(name: "DMSans-Medium", size: 14)
        lb.textColor = .lightGray
        lb.textAlignment = .center
        lb.numberOfLines = 0
        return lb
    }()
    
    let dividerLine: UIView = {
        let viewview = UIView()
        viewview.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        return viewview
    }()
    
    
    
    let centerLine: UIView = {
        let viewview = UIView()
        viewview.backgroundColor = UIColor.rgb(red: 232, green: 232, blue: 232)
        return viewview
    }()
    
    lazy var firstCircle: UIView = {
        let viewview = UIView()
        viewview.backgroundColor = UIColor.mainColor
        viewview.layer.cornerRadius = 24
        viewview.layer.masksToBounds = true
        viewview.isUserInteractionEnabled = true
        viewview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goBackCellFirst)))
        return viewview
    }()
    
    let firstImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "where")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    lazy var secondCircle: UIView = {
        let viewview = UIView()
        viewview.backgroundColor = UIColor.rgb(red: 232, green: 232, blue: 232)
        viewview.layer.cornerRadius = 24
        viewview.layer.masksToBounds = true
        viewview.isUserInteractionEnabled = true
        viewview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goBackCellSecond)))
        return viewview
    }()
    
    let secondImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "rate")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    lazy var thirdCircle: UIView = {
        let viewview = UIView()
        viewview.backgroundColor = UIColor.rgb(red: 232, green: 232, blue: 232)
        viewview.layer.cornerRadius = 24
        viewview.layer.masksToBounds = true
        viewview.isUserInteractionEnabled = true
        viewview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goBackCellThird)))
        return viewview
    }()
    
    let thirdImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "photo")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    var fourthCircle: UIView = {
        let viewview = UIView()
        viewview.backgroundColor = UIColor.rgb(red: 232, green: 232, blue: 232)
        viewview.layer.cornerRadius = 24
        viewview.layer.masksToBounds = true
        return viewview
    }()
    
    let fourthImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "write")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    lazy var reviewCollectionview: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.alwaysBounceHorizontal = true
        collectionview.showsVerticalScrollIndicator = false
        collectionview.backgroundColor = .white
        collectionview.isPagingEnabled = true
        collectionview.isScrollEnabled = false
        return collectionview
    }()
    
    
    var thumbViewConstraint: NSLayoutConstraint?
    var shareLabelConstraint: NSLayoutConstraint?
    var dividerLineConstraint: NSLayoutConstraint?
    
    var centerLineConstraint: NSLayoutConstraint?
    var firstCircleConstraint: NSLayoutConstraint?
    var secondCircleConstraint: NSLayoutConstraint?
    var thirdCircleConstraint: NSLayoutConstraint?
    var fourthCircleConstraint: NSLayoutConstraint?
    var firstImageViewConstraint: NSLayoutConstraint?
    var secondImageViewConstraint: NSLayoutConstraint?
    var thirdImageViewConstraint: NSLayoutConstraint?
    var fourthImageViewConstraint: NSLayoutConstraint?
    
    var reviewCollectionviewConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(thumbView)
        view.addSubview(shareLabel)
        view.addSubview(dividerLine)
        
        view.addSubview(centerLine)
        view.addSubview(firstCircle)
        view.addSubview(secondCircle)
        view.addSubview(thirdCircle)
        view.addSubview(fourthCircle)
        view.addSubview(firstImageView)
        view.addSubview(secondImageView)
        view.addSubview(thirdImageView)
        view.addSubview(fourthImageView)
        
        view.addSubview(reviewCollectionview)
        
        thumbViewConstraint = thumbView.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 12, leftConstant: (view.frame.width / 2) - 40, bottomConstant: 0, rightConstant: 0, widthConstant: 80, heightConstant: 5).first
        shareLabelConstraint = shareLabel.anchor(thumbView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 18).first
        dividerLineConstraint = dividerLine.anchor(shareLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 15.5, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0.5).first
        
        centerLineConstraint = centerLine.anchor(dividerLine.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 47.5, leftConstant: (view.frame.width / 2) - 96, bottomConstant: 0, rightConstant: 0, widthConstant: 192, heightConstant: 2).first
        firstCircleConstraint = firstCircle.anchor(dividerLine.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 23.5, leftConstant: (view.frame.width / 2) - 120, bottomConstant: 0, rightConstant: 0, widthConstant: 48, heightConstant: 48).first
        firstImageViewConstraint = firstImageView.anchor(firstCircle.topAnchor, left: firstCircle.leftAnchor, bottom: nil, right: nil, topConstant: 12.5, leftConstant: 12.5, bottomConstant: 0, rightConstant: 0, widthConstant: 23, heightConstant: 23).first
        secondCircleConstraint = secondCircle.anchor(firstCircle.topAnchor, left: firstCircle.rightAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 16, bottomConstant: 0, rightConstant: 0, widthConstant: 48, heightConstant: 48).first
        secondImageViewConstraint = secondImageView.anchor(secondCircle.topAnchor, left: secondCircle.leftAnchor, bottom: nil, right: nil, topConstant: 12, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: 24, heightConstant: 24).first
        thirdCircleConstraint = thirdCircle.anchor(firstCircle.topAnchor, left: secondCircle.rightAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 16, bottomConstant: 0, rightConstant: 0, widthConstant: 48, heightConstant: 48).first
        thirdImageViewConstraint = thirdImageView.anchor(thirdCircle.topAnchor, left: thirdCircle.leftAnchor, bottom: nil, right: nil, topConstant: 12, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: 24, heightConstant: 24).first
        fourthCircleConstraint = fourthCircle.anchor(firstCircle.topAnchor, left: thirdCircle.rightAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 16, bottomConstant: 0, rightConstant: 0, widthConstant: 48, heightConstant: 48).first
        fourthImageViewConstraint = fourthImageView.anchor(fourthCircle.topAnchor, left: fourthCircle.leftAnchor, bottom: nil, right: nil, topConstant: 12, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: 24, heightConstant: 24).first

        reviewCollectionviewConstraint = reviewCollectionview.anchor(fourthCircle.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 32, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
        
        reviewCollectionview.register(firstWriteReviewCell.self, forCellWithReuseIdentifier: cellid)
        reviewCollectionview.register(secondWriteReviewCell.self, forCellWithReuseIdentifier: cellid2)
        reviewCollectionview.register(thirdWriteReviewCell.self, forCellWithReuseIdentifier: cellid3)
        reviewCollectionview.register(fourthWriteReviewCell.self, forCellWithReuseIdentifier: cellid4)
        reviewCollectionview.register(LastWriteReviewCell.self, forCellWithReuseIdentifier: cellid5)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath) as! firstWriteReviewCell
            cell.delegate = self
            return cell
        }
        else if indexPath.item == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid2, for: indexPath) as! secondWriteReviewCell
            cell.delegate = self
            return cell
        }
        else if indexPath.item == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid3, for: indexPath) as! thirdWriteReviewCell
            cell.delegate = self
            return cell
        }
        else if indexPath.item == 3 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid4, for: indexPath) as! fourthWriteReviewCell
            cell.delegate = self
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid5, for: indexPath) as! LastWriteReviewCell
            cell.delegate = self
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func goNextCell(index: Int) {
        let indexPath = IndexPath(item: index + 1, section: 0)
        reviewCollectionview.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        changeCircleBackground(index: index)
    }
    
    fileprivate func keyboardViewUp() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.view.frame.origin.y -= 50
        }, completion: nil)
    }
    
    fileprivate func keyboardViewDown() {
        UIView.animate(withDuration: 0.5, delay: 0,
                       usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.view.frame.origin.y = 70
        }, completion: nil)
    }
    
    @objc fileprivate func goBackCellFirst() {
        let indexPath = IndexPath(item: 0, section: 0)
        reviewCollectionview.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        grayCircleBackground(index: 0)
        grayCircleBackground(index: 1)
        grayCircleBackground(index: 2)
        secondCircle.tag = 0
        thirdCircle.tag = 0
        fourthCircle.tag = 0
    }
    
    @objc fileprivate func goBackCellSecond() {
        if thirdCircle.tag == 1 {
            thirdCircle.tag = 0
            fourthCircle.tag = 0
            let indexPath = IndexPath(item: 1, section: 0)
            reviewCollectionview.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            grayCircleBackground(index: 1)
            grayCircleBackground(index: 2)
        }
    }
    
    @objc fileprivate func goBackCellThird() {
        if fourthCircle.tag == 1 {
            fourthCircle.tag = 0
            let indexPath = IndexPath(item: 2, section: 0)
            reviewCollectionview.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            grayCircleBackground(index: 2)
        }
    }
    
    fileprivate func changeCircleBackground(index: Int) {
        if index == 0 {
            self.secondCircle.backgroundColor = .wheat
            self.secondCircle.tag = 1
        }
        else if index == 1 {
            self.thirdCircle.backgroundColor = .lightGreen
            self.thirdCircle.tag = 1
        }
        
        else if index == 2 {
            self.fourthCircle.backgroundColor = .apricot
            self.fourthCircle.tag = 1
        }
    }
    
    fileprivate func grayCircleBackground(index: Int) {
        if index == 0 {
            self.secondCircle.backgroundColor = UIColor.rgb(red: 232, green: 232, blue: 232)
        }
        else if index == 1 {
            self.thirdCircle.backgroundColor = UIColor.rgb(red: 232, green: 232, blue: 232)
        }
        
        else if index == 2 {
            self.fourthCircle.backgroundColor = UIColor.rgb(red: 232, green: 232, blue: 232)
        }
    }
    
    func goFinish() {
        centerLine.alpha = 0
        firstCircle.alpha = 0
        firstImageView.alpha = 0
        secondCircle.alpha = 0
        secondImageView.alpha = 0
        thirdCircle.alpha = 0
        thirdImageView.alpha = 0
        fourthCircle.alpha = 0
        fourthImageView.alpha = 0
    }
    
    func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func selectPhoto() {
        var config = YPImagePickerConfiguration()
        config.albumName = "DefaultYPImagePickerAlbumName"
        config.startOnScreen = YPPickerScreen.photo
        config.screens = [.library]
        config.showsCrop = .none
//        config.targetImageSize = YPImageSize.original
        config.overlayView = UIView()
        config.hidesStatusBar = true
        config.hidesBottomBar = false
        config.preferredStatusBarStyle = UIStatusBarStyle.default
//        config.bottomMenuItemSelectedColour = UIColor(r: 38, g: 38, b: 38)
//        config.bottomMenuItemUnSelectedColour = UIColor(r: 153, g: 153, b: 153)
        config.library.options = nil
        config.library.onlySquare = false
        config.library.isSquareByDefault = true
        config.library.minWidthForItem = nil
        config.library.mediaType = YPlibraryMediaType.photo
        config.library.defaultMultipleSelection = true
        config.library.maxNumberOfItems = 5
        config.library.minNumberOfItems = 1
        config.library.numberOfItemsInRow = 4
        config.library.spacingBetweenItems = 1.0
        config.library.skipSelectionsGallery = false
        config.library.preselectedItems = nil
        YPImagePickerConfiguration.shared = config
        let picker = YPImagePicker()
        let indexPath = IndexPath(item: 2, section: 0)
        let cell = reviewCollectionview.cellForItem(at: indexPath) as! thirdWriteReviewCell
        picker.didFinishPicking { [unowned picker] items, cancelled in
            cell.photoImageView.alpha = 0
            cell.photoLabel.alpha = 0
            if cell.imageArray.count > 0 {
                cell.imageArray.removeAll()
            }
            for item in items {
                switch item {
                case .photo(let photo):
                    cell.imageArray.append(photo.image)
                    DispatchQueue.main.async {
                        cell.imageCollectionview.reloadData()
                    }
                case .video(let video):
                    print(video)
                }
            }
            picker.dismiss(animated: true) {
                if cell.imageArray.count > 0 {
                    cell.nextLabel.letterSpacing(text: "NEXT", spacing: 1.0)
                }
            }
        }
        // 꼭! didFinishPicking 다음에 present 해야함!!
        present(picker, animated: true, completion: nil)
    }
    
}

class firstWriteReviewCell: UICollectionViewCell, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate {
    
    var index: Int = 0
    weak var delegate: WriteReviewController?
    
    fileprivate let cellid = "cellid"
    
    let titleLabel: UILabel = {
        let lb = UILabel()
        lb.letterSpacing(text: "Where to review?", spacing: -0.3)
        lb.font = UIFont(name: "DMSans-Medium", size: 20)
        lb.textColor = .black
        lb.textAlignment = .center
        lb.numberOfLines = 0
        return lb
    }()
    
    let subtitleLabel: UILabel = {
        let lb = UILabel()
        lb.letterSpacing(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit duis eu.", spacing: -0.1)
        lb.font = UIFont(name: "DMSans-Regular", size: 16)
        lb.textColor = .lightGray
        lb.textAlignment = .center
        lb.numberOfLines = 0
        return lb
    }()
    
    lazy var searchView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.rgb(red: 232, green: 232, blue: 232)
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickSearch)))
        return view
    }()
    
    let searchImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "searchLine")
        iv.image = iv.image?.withRenderingMode(.alwaysTemplate)
        iv.contentMode = .scaleAspectFit
        iv.tintColor =  UIColor.rgb(red: 153, green: 153, blue: 153)
        return iv
    }()
    
    let searchLabel: UILabel = {
        let lb = UILabel()
        lb.letterSpacing(text: "Search a place to review...", spacing: -0.1)
        lb.font = UIFont(name: "DMSans-Regular", size: 14)
        lb.textColor = UIColor.rgb(red: 153, green: 153, blue: 153)
        lb.textAlignment = .left
        lb.numberOfLines = 0
        return lb
    }()
    
    lazy var nextLabel: UILabel = {
        let lb = UILabel()
        lb.letterSpacing(text: "NEXT", spacing: 1.0)
        lb.font = UIFont(name: "DMSans-Bold", size: 14)
        lb.textColor = .white
        lb.backgroundColor = .mainColor
        lb.textAlignment = .center
        lb.numberOfLines = 0
        lb.layer.cornerRadius = 12
        lb.layer.masksToBounds = true
        lb.alpha = 0.5
        lb.isUserInteractionEnabled = true
        lb.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goNextCell)))
        return lb
    }()
    
    let backWhiteView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.alpha = 0
        return view
    }()
    
    let searchView2: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.rgb(red: 232, green: 232, blue: 232)
        view.alpha = 0
        return view
    }()
    
    lazy var backImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "back")
        iv.contentMode = .scaleAspectFit
        iv.alpha = 0
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backClicked)))
        return iv
    }()
    
    lazy var innerWriteCollectionview: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.alwaysBounceVertical = true
        collectionview.showsVerticalScrollIndicator = true
        collectionview.backgroundColor = .white
        collectionview.alpha = 0
        return collectionview
    }()
    
    var dividerLineConstraint: NSLayoutConstraint?
    var clearButtonConstraint: NSLayoutConstraint?
    var closeButtonConstraint: NSLayoutConstraint?
    
    lazy var contatinerView: UIView = {
        let containerview = UIView()
        containerview.backgroundColor = .white
        containerview.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        
        let dividerLine = UIView()
        dividerLine.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        containerview.addSubview(dividerLine)
        dividerLineConstraint = dividerLine.anchor(containerview.topAnchor, left: containerview.leftAnchor, bottom: nil, right: containerview.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0.5).first
        
        let clearButton = UIButton(type: .system)
        clearButton.setTitle("CLEAR", for: .normal)
        clearButton.setTitleColor(.gray, for: .normal)
        clearButton.titleLabel?.font = UIFont(name: "DMSans-Medium", size: 12)
        clearButton.addTarget(self, action: #selector(clearText), for: .touchUpInside)
        containerview.addSubview(clearButton)
        clearButtonConstraint = clearButton.anchor(containerview.topAnchor, left: containerview.leftAnchor, bottom: containerview.bottomAnchor, right: nil, topConstant: 0, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: 50, heightConstant: 0).first
        
        let closeButton = UIButton(type: .system)
        closeButton.setTitle("CLOSE", for: .normal)
        closeButton.setTitleColor(.gray, for: .normal)
        closeButton.titleLabel?.font = UIFont(name: "DMSans-Bold", size: 12)
        closeButton.addTarget(self, action: #selector(closeText), for: .touchUpInside)
        containerview.addSubview(closeButton)
        closeButtonConstraint = closeButton.anchor(containerview.topAnchor, left: nil, bottom: containerview.bottomAnchor, right: containerview.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 12, widthConstant: 50, heightConstant: 0).first
        return containerview
    }()
    
    lazy var searchTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "검색어를 입력하세요"
        tf.font = UIFont(name: "DMSans-Regular", size: 14)
        tf.returnKeyType = .search
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.delegate = self
        tf.alpha = 0
        return tf
    }()
    
    override var inputAccessoryView: UIView? {
        get {
            return contatinerView
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var titleLabelConstraint: NSLayoutConstraint?
    var subtitleLabelConstraint: NSLayoutConstraint?
    var searchViewConstraint: NSLayoutConstraint?
    var searchImageViewConstraint: NSLayoutConstraint?
    var searchLabelConstraint: NSLayoutConstraint?
    var nextLabelConstraint: NSLayoutConstraint?
    
    var searchTextFieldConstraint: NSLayoutConstraint?
    var backWhiteViewConstraint: NSLayoutConstraint?
    var searchView2Constraint: NSLayoutConstraint?
    var backImageViewConstraint: NSLayoutConstraint?
    var searchLabel2Constraint: NSLayoutConstraint?
    var innerWriteCollectionviewConstraint: NSLayoutConstraint?
    
    fileprivate func setupLayouts() {
        backgroundColor = .white
        
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(searchView)
        addSubview(searchImageView)
        addSubview(searchLabel)
        addSubview(nextLabel)
        
        addSubview(backWhiteView)
        addSubview(searchView2)
        addSubview(backImageView)
        addSubview(searchTextField)
        addSubview(innerWriteCollectionview)
        
        titleLabelConstraint = titleLabel.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 28).first
        subtitleLabelConstraint = subtitleLabel.anchor(titleLabel.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 8, leftConstant: 48, bottomConstant: 0, rightConstant: 48, widthConstant: 0, heightConstant: 56).first
        searchViewConstraint = searchView.anchor(subtitleLabel.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 24, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 0, heightConstant: 48).first
        searchImageViewConstraint = searchImageView.anchor(searchView.topAnchor, left: searchView.leftAnchor, bottom: nil, right: nil, topConstant: 12, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: 24, heightConstant: 24).first
        searchLabelConstraint = searchLabel.anchor(searchView.topAnchor, left: searchImageView.rightAnchor, bottom: nil, right: searchView.rightAnchor, topConstant: 14, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 20).first
        nextLabelConstraint = nextLabel.anchor(searchView.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 36, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 0, heightConstant: 56).first
        
        backWhiteViewConstraint = backWhiteView.anchor(self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
        searchView2Constraint = searchView2.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 0, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 0, heightConstant: 48).first
        backImageViewConstraint = backImageView.anchor(searchView2.topAnchor, left: searchView2.leftAnchor, bottom: nil, right: nil, topConstant: 12, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: 24, heightConstant: 24).first
        searchTextFieldConstraint = searchTextField.anchor(searchView2.topAnchor, left: backImageView.rightAnchor, bottom: nil, right: nil, topConstant: 14, leftConstant: 9, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 20).first
        innerWriteCollectionviewConstraint = innerWriteCollectionview.anchor(searchView2.bottomAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 24, leftConstant: 24, bottomConstant: 100, rightConstant: 24, widthConstant: 0, heightConstant: 0).first
        
        innerWriteCollectionview.register(innerFirstWriteCell.self, forCellWithReuseIdentifier: cellid)
    }
    
    @objc fileprivate func goSearchResult(searchText: String) {
//        self.dismiss(animated: true) {
//            self.delegate?.goSearchResult(searchText: searchText)
//        }
    }
    
    @objc fileprivate func clearText() {
        self.searchTextField.text = nil
    }
    
    @objc func closeText() {
        self.searchTextField.endEditing(true)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 검색 버튼 눌렀을때.
        textField.endEditing(true)
        return true
    }
    
    @objc fileprivate func goNextCell() {
        if searchLabel.text != "Search a place to review..." {
            delegate?.goNextCell(index: index)
        }
    }
    
    @objc fileprivate func clickSearch() {
        searchTextField.becomeFirstResponder()
        backWhiteView.alpha = 1
        searchView2.alpha = 1
        backImageView.alpha = 1
        searchTextField.alpha = 1
        innerWriteCollectionview.alpha = 1
    }
    
    @objc fileprivate func backClicked() {
        backWhiteView.alpha = 0
        searchView2.alpha = 0
        backImageView.alpha = 0
        searchTextField.alpha = 0
        innerWriteCollectionview.alpha = 0
        
        closeText()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath) as! innerFirstWriteCell
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 48)
    }
    
    @objc func restClicked() {
        backWhiteView.alpha = 0
        searchView2.alpha = 0
        backImageView.alpha = 0
        searchTextField.alpha = 0
        innerWriteCollectionview.alpha = 0
        
        searchLabel.letterSpacing(text: "Cool Restaurant", spacing: -0.1)
        searchLabel.textColor = .black
        
        searchImageView.image = UIImage(named: "imsi_restaurant")
        searchImageView.contentMode = .scaleAspectFill
        searchImageView.layer.cornerRadius = 12
        searchImageView.layer.masksToBounds = true
        
        nextLabel.alpha = 1
        // 추후 자세하게 parameter까지 해서
        // next 그제서야 누르면 넘어가게
    }
    
}

class innerFirstWriteCell: UICollectionViewCell {
    
    weak var delegate: firstWriteReviewCell?
    
    let restImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "imsi_restaurant")
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 8
        iv.layer.masksToBounds = true
        return iv
    }()
    
    let restLabel: UILabel = {
        let lb = UILabel()
        lb.letterSpacing(text: "Cool Restaurant", spacing: -0.1)
        lb.font = UIFont(name: "DMSans-Medium", size: 14)
        lb.textColor = .black
        lb.textAlignment = .left
        lb.numberOfLines = 0
        return lb
    }()
    
    let locationImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "location")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let locationLabel: UILabel = {
        let lb = UILabel()
        lb.letterSpacing(text: "100m", spacing: 0.0)
        lb.font = UIFont(name: "DMSans-Regular", size: 12)
        lb.textColor = .gray
        lb.textAlignment = .left
        lb.numberOfLines = 0
        return lb
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var restImageViewConstraint: NSLayoutConstraint?
    var restLabelConstraint: NSLayoutConstraint?
    var locationImageViewConstraint: NSLayoutConstraint?
    var locationLabelConstraint: NSLayoutConstraint?
    
    fileprivate func setupLayouts() {
        backgroundColor = .white
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(restClicked)))
        
        addSubview(restImageView)
        addSubview(restLabel)
        addSubview(locationImageView)
        addSubview(locationLabel)
        
        restImageViewConstraint = restImageView.anchor(self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 48, heightConstant: 0).first
        restLabelConstraint = restLabel.anchor(self.topAnchor, left: restImageView.rightAnchor, bottom: nil, right: self.rightAnchor, topConstant: 5, leftConstant: 16, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 18).first
        locationImageViewConstraint = locationImageView.anchor(restLabel.bottomAnchor, left: restImageView.rightAnchor, bottom: nil, right: nil, topConstant: 7, leftConstant: 16, bottomConstant: 0, rightConstant: 0, widthConstant: 10, heightConstant: 10).first
        locationLabelConstraint = locationLabel.anchor(restLabel.bottomAnchor, left: locationImageView.rightAnchor, bottom: nil, right: self.rightAnchor, topConstant: 4, leftConstant: 3, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 16).first
    }
    
    @objc fileprivate func restClicked() {
        delegate?.closeText()
        delegate?.restClicked()
    }
    
}

class secondWriteReviewCell: UICollectionViewCell {
    
    var index: Int = 1
    weak var delegate: WriteReviewController?
    
    let titleLabel: UILabel = {
       let lb = UILabel()
       // letter spacing -0.3
       let attributedString = NSMutableAttributedString(string: "Do you like it?")
       attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(-0.3), range: NSRange(location: 0, length: attributedString.length))
       lb.attributedText = attributedString
       lb.font = UIFont(name: "DMSans-Medium", size: 20)
       lb.textColor = .black
       lb.textAlignment = .center
       lb.numberOfLines = 0
       return lb
   }()
       
   let subtitleLabel: UILabel = {
       let lb = UILabel()
       // letter spacing -0.1
       let attributedString = NSMutableAttributedString(string: "Lorem ipsum dolor sit amet, consectetur adipiscing elit duis eu.")
       attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(-0.1), range: NSRange(location: 0, length: attributedString.length))
       lb.attributedText = attributedString
       lb.font = UIFont(name: "DMSans-Regular", size: 16)
       lb.textColor = .lightGray
       lb.textAlignment = .center
       lb.numberOfLines = 0
       return lb
   }()
    
    lazy var cosmosView: CosmosView = {
        var cv = CosmosView()
        cv.settings.updateOnTouch = true
        cv.settings.totalStars = 5
        cv.settings.starSize = 40
        cv.settings.starMargin = 4
        cv.settings.fillMode = .half
        cv.rating = 0
        cv.settings.filledImage = UIImage(named: "filledStar")
        cv.settings.emptyImage = UIImage(named: "emptyStar")
        return cv
    }()
    
    lazy var nextLabel: UILabel = {
        let lb = UILabel()
        // letter spacing 1.0
        let attributedString = NSMutableAttributedString(string: "NEXT")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(1.0), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.font = UIFont(name: "DMSans-Bold", size: 14)
        lb.textColor = .white
        lb.backgroundColor = .mainColor
        lb.textAlignment = .center
        lb.numberOfLines = 0
        lb.layer.cornerRadius = 12
        lb.layer.masksToBounds = true
        lb.alpha = 0.5
        lb.isUserInteractionEnabled = true
        lb.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goNextCell)))
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var titleLabelConstraint: NSLayoutConstraint?
    var subtitleLabelConstraint: NSLayoutConstraint?
    var cosmosViewConstraint: NSLayoutConstraint?
    var nextLabelConstraint: NSLayoutConstraint?
    
    fileprivate func setupLayouts() {
        backgroundColor = .white
        
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(cosmosView)
        addSubview(nextLabel)
        
        titleLabelConstraint = titleLabel.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 28).first
        subtitleLabelConstraint = subtitleLabel.anchor(titleLabel.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 8, leftConstant: 48, bottomConstant: 0, rightConstant: 48, widthConstant: 0, heightConstant: 56).first
        cosmosViewConstraint = cosmosView.anchor(subtitleLabel.bottomAnchor, left: self.leftAnchor, bottom: nil, right: nil, topConstant: 16, leftConstant: (self.frame.width / 2) - 108, bottomConstant: 0, rightConstant: 0, widthConstant: 216, heightConstant: 40).first
        nextLabelConstraint = nextLabel.anchor(cosmosView.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 32, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 0, heightConstant: 56).first
        
        cosmosView.didTouchCosmos = { rating in
            self.nextLabel.alpha = 1
        }
        // present한 viewcontroller에서 pangesture로 터치하기위해사는 아래처럼 해주어야함.(이름은 조금 잘못된듯..)
        cosmosView.settings.disablePanGestures = true
    }
    
    @objc fileprivate func goNextCell() {
        if cosmosView.rating > 0 {
            delegate?.goNextCell(index: index)
        }
    }
}

class thirdWriteReviewCell: UICollectionViewCell, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource  {
    
    fileprivate let cellid = "cellid"
    
    var index: Int = 2
    weak var delegate: WriteReviewController?
    
    let titleLabel: UILabel = {
        let lb = UILabel()
        // letter spacing -0.3
        let attributedString = NSMutableAttributedString(string: "How it looks?")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(-0.3), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.font = UIFont(name: "DMSans-Medium", size: 20)
        lb.textColor = .black
        lb.textAlignment = .center
        lb.numberOfLines = 0
        return lb
    }()
        
    let subtitleLabel: UILabel = {
        let lb = UILabel()
        // letter spacing -0.1
        let attributedString = NSMutableAttributedString(string: "Lorem ipsum dolor sit amet, consectetur adipiscing elit duis eu.")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(-0.1), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.font = UIFont(name: "DMSans-Regular", size: 16)
        lb.textColor = .lightGray
        lb.textAlignment = .center
        lb.numberOfLines = 0
        return lb
    }()
    
    lazy var imageCollectionview: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.alwaysBounceHorizontal = true
        collectionview.showsHorizontalScrollIndicator = false
        collectionview.backgroundColor = UIColor.rgb(red: 232, green: 232, blue: 232)
        collectionview.isPagingEnabled = true
        collectionview.layer.cornerRadius = 10
        collectionview.layer.masksToBounds = true
        collectionview.isUserInteractionEnabled = true
        collectionview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectPhoto)))
        return collectionview
    }()
    
    
    let photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "photo")?.withRenderingMode(.alwaysTemplate)
        iv.contentMode = .scaleAspectFit
        iv.tintColor = UIColor.rgb(red: 153, green: 153, blue: 153)
        return iv
    }()
    
    let photoLabel: UILabel = {
        let lb = UILabel()
        // letter spacing -0.1
        let attributedString = NSMutableAttributedString(string: "Add Photo")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(-0.1), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.font = UIFont(name: "DMSans-Regular", size: 16)
        lb.textColor = UIColor.rgb(red: 153, green: 153, blue: 153)
        lb.textAlignment = .center
        lb.numberOfLines = 0
        return lb
    }()
    
    lazy var nextLabel: UILabel = {
        let lb = UILabel()
        lb.letterSpacing(text: "SKIP", spacing: 1.0)
        lb.font = UIFont(name: "DMSans-Bold", size: 14)
        lb.textColor = .white
        lb.backgroundColor = .mainColor
        lb.textAlignment = .center
        lb.numberOfLines = 0
        lb.layer.cornerRadius = 12
        lb.layer.masksToBounds = true
        lb.isUserInteractionEnabled = true
        lb.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goNextCell)))
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var titleLabelConstraint: NSLayoutConstraint?
    var subtitleLabelConstraint: NSLayoutConstraint?
    var imageCollectionviewConstraint: NSLayoutConstraint?
    var photoImageViewConstraint: NSLayoutConstraint?
    var photoLabelConstraint: NSLayoutConstraint?
    var nextLabelConstraint: NSLayoutConstraint?
    
    var imageArray = [UIImage]()
    
    fileprivate func setupLayouts() {
        backgroundColor = .white
        
        imageCollectionview.register(innerImageCell.self, forCellWithReuseIdentifier: cellid)
        
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(imageCollectionview)
        addSubview(photoImageView)
        addSubview(photoLabel)
        addSubview(nextLabel)
        
        titleLabelConstraint = titleLabel.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 28).first
        subtitleLabelConstraint = subtitleLabel.anchor(titleLabel.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 8, leftConstant: 48, bottomConstant: 0, rightConstant: 48, widthConstant: 0, heightConstant: 56).first
        imageCollectionviewConstraint = imageCollectionview.anchor(subtitleLabel.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 16, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 0, heightConstant: 150).first
        photoImageViewConstraint = photoImageView.anchor(imageCollectionview.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, topConstant: 42, leftConstant: (self.frame.width / 2) - 16, bottomConstant: 0, rightConstant: 0, widthConstant: 32, heightConstant: 32).first
        photoLabelConstraint = photoLabel.anchor(photoImageView.bottomAnchor, left: imageCollectionview.leftAnchor, bottom: nil, right: imageCollectionview.rightAnchor, topConstant: 8, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 26).first
        nextLabelConstraint = nextLabel.anchor(imageCollectionview.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 24, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 0, heightConstant: 56).first
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath) as! innerImageCell
        cell.photoImageView.image = imageArray[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    @objc fileprivate func selectPhoto() {
        print("photo selecting..")
        delegate?.selectPhoto()
    }
    
    @objc fileprivate func goNextCell() {
        // 사진 선택했을때는 Skip을 Next로 바꿔주기.
        delegate?.goNextCell(index: index)
    }
}

class innerImageCell: UICollectionViewCell {
    
    let photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 12
        iv.layer.masksToBounds = true
        return iv
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var photoImageViewConstraint: NSLayoutConstraint?
    
    fileprivate func setupLayouts() {
        addSubview(photoImageView)
        photoImageViewConstraint = photoImageView.anchor(self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
    }
}

class fourthWriteReviewCell: UICollectionViewCell, UITextViewDelegate {
    
    var index: Int = 3
    weak var delegate: WriteReviewController?
    
    let titleLabel: UILabel = {
        let lb = UILabel()
        // letter spacing -0.3
        let attributedString = NSMutableAttributedString(string: "What’s good or bad here?")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(-0.3), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.font = UIFont(name: "DMSans-Medium", size: 20)
        lb.textColor = .black
        lb.textAlignment = .center
        lb.numberOfLines = 0
        return lb
    }()
        
    let subtitleLabel: UILabel = {
        let lb = UILabel()
        // letter spacing -0.1
        let attributedString = NSMutableAttributedString(string: "Lorem ipsum dolor sit amet, consectetur adipiscing elit duis eu.")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(-0.1), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.font = UIFont(name: "DMSans-Regular", size: 16)
        lb.textColor = .lightGray
        lb.textAlignment = .center
        lb.numberOfLines = 0
        return lb
    }()
    
    let postBackView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 1
        view.layer.masksToBounds = true
        return view
    }()
    
    var dividerLineConstraint: NSLayoutConstraint?
    var clearButtonConstraint: NSLayoutConstraint?
    var closeButtonConstraint: NSLayoutConstraint?
    
    lazy var contatinerView: UIView = {
        let containerview = UIView()
        containerview.backgroundColor = .white
        containerview.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        
        let dividerLine = UIView()
        dividerLine.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        containerview.addSubview(dividerLine)
        dividerLineConstraint = dividerLine.anchor(containerview.topAnchor, left: containerview.leftAnchor, bottom: nil, right: containerview.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0.5).first
        
        let clearButton = UIButton(type: .system)
        clearButton.setTitle("CLEAR", for: .normal)
        clearButton.setTitleColor(.gray, for: .normal)
        clearButton.titleLabel?.font = UIFont(name: "DMSans-Medium", size: 12)
        clearButton.addTarget(self, action: #selector(clearText), for: .touchUpInside)
        containerview.addSubview(clearButton)
        clearButtonConstraint = clearButton.anchor(containerview.topAnchor, left: containerview.leftAnchor, bottom: containerview.bottomAnchor, right: nil, topConstant: 0, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: 50, heightConstant: 0).first
        
        let closeButton = UIButton(type: .system)
        closeButton.setTitle("CLOSE", for: .normal)
        closeButton.setTitleColor(.gray, for: .normal)
        closeButton.titleLabel?.font = UIFont(name: "DMSans-Bold", size: 12)
        closeButton.addTarget(self, action: #selector(closeText), for: .touchUpInside)
        containerview.addSubview(closeButton)
        closeButtonConstraint = closeButton.anchor(containerview.topAnchor, left: nil, bottom: containerview.bottomAnchor, right: containerview.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 12, widthConstant: 50, heightConstant: 0).first
        return containerview
    }()
    
    lazy var searchTextView: UITextView = {
        let tv = UITextView()
        tv.text = "Tell us about the restaurant!\n\nReviews unrelated to the restaurant may be deleted without notice."
        tv.textColor = .lightGray
        tv.font = UIFont(name: "DMSans-Regular", size: 14)
        tv.returnKeyType = .default
        tv.autocorrectionType = .no
        tv.autocapitalizationType = .none
        tv.delegate = self
        return tv
    }()
    
    override var inputAccessoryView: UIView? {
        get {
            return contatinerView
        }
    }
    
    let countLabel: UILabel = {
        let lb = UILabel()
        lb.text = "0/300"
        lb.font = UIFont(name: "DMSans-Regular", size: 12)
        lb.textColor = .darkGray
        lb.textAlignment = .center
        lb.backgroundColor = .pink
        lb.layer.cornerRadius = 9
        lb.layer.masksToBounds = true
        lb.numberOfLines = 0
        return lb
    }()
    
    lazy var nextLabel: UILabel = {
        let lb = UILabel()
        // letter spacing 1.0
        let attributedString = NSMutableAttributedString(string: "PUBLISH")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(1.0), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.font = UIFont(name: "DMSans-Bold", size: 14)
        lb.textColor = .white
        lb.backgroundColor = .mainColor
        lb.textAlignment = .center
        lb.numberOfLines = 0
        lb.layer.cornerRadius = 12
        lb.layer.masksToBounds = true
        lb.isUserInteractionEnabled = true
        lb.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goNextCell)))
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var titleLabelConstraint: NSLayoutConstraint?
    var subtitleLabelConstraint: NSLayoutConstraint?
    var postBackViewConstraint: NSLayoutConstraint?
    var searchTextViewConstraint: NSLayoutConstraint?
    var countLabelConstraint: NSLayoutConstraint?
    var nextLabelConstraint: NSLayoutConstraint?
    
    fileprivate func setupLayouts() {
        backgroundColor = .white
        
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(postBackView)
        addSubview(searchTextView)
        addSubview(countLabel)
        addSubview(nextLabel)
        
        titleLabelConstraint = titleLabel.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 28).first
        subtitleLabelConstraint = subtitleLabel.anchor(titleLabel.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 8, leftConstant: 48, bottomConstant: 0, rightConstant: 48, widthConstant: 0, heightConstant: 56).first
        postBackViewConstraint = postBackView.anchor(subtitleLabel.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 12, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 0, heightConstant: 166).first
        searchTextViewConstraint = searchTextView.anchor(postBackView.topAnchor, left: postBackView.leftAnchor, bottom: nil, right: postBackView.rightAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 88).first
        countLabelConstraint = countLabel.anchor(nil, left: nil, bottom: postBackView.bottomAnchor, right: postBackView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 12, rightConstant: 12, widthConstant: 46, heightConstant: 18).first
        nextLabelConstraint = nextLabel.anchor(postBackView.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 24, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 0, heightConstant: 56).first
    }
    
    @objc func closeText() {
        self.searchTextView.endEditing(true)
    }
    
    @objc fileprivate func clearText() {
        self.searchTextView.text = nil
        countLabel.text = "0/300"
    }
    
    @objc fileprivate func goNextCell() {
        delegate?.goNextCell(index: index)
        delegate?.goFinish()
    }
    
    // TextView Place Holder
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
            delegate?.keyboardViewUp()
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let count = textView.text.count
        countLabel.text = "\(count)/300"
    }
    
    // TextView Place Holder
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Tell us about the restaurant!\n\nReviews unrelated to the restaurant may be deleted without notice."
            textView.textColor = UIColor.lightGray
            delegate?.keyboardViewDown()
        }
    }

    
}

class LastWriteReviewCell: UICollectionViewCell {
    
    var index: Int = 4
    weak var delegate: WriteReviewController?
    
    let finishImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "congrats")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let titleLabel: UILabel = {
        let lb = UILabel()
        // letter spacing -0.3
        let attributedString = NSMutableAttributedString(string: "Your review is published!")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(-0.3), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.font = UIFont(name: "DMSans-Medium", size: 20)
        lb.textColor = .black
        lb.textAlignment = .center
        lb.numberOfLines = 0
        return lb
    }()
        
    let subtitleLabel: UILabel = {
        let lb = UILabel()
        // letter spacing -0.1
        let attributedString = NSMutableAttributedString(string: "Lorem ipsum dolor sit amet, consectetur adipiscing elit duis eu.")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(-0.1), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.font = UIFont(name: "DMSans-Regular", size: 16)
        lb.textColor = .lightGray
        lb.textAlignment = .center
        lb.numberOfLines = 0
        return lb
    }()
    
    lazy var nextLabel: UILabel = {
        let lb = UILabel()
        // letter spacing 1.0
        let attributedString = NSMutableAttributedString(string: "GO TO REVIEW")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(1.0), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.font = UIFont(name: "DMSans-Bold", size: 14)
        lb.textColor = .white
        lb.backgroundColor = .mainColor
        lb.textAlignment = .center
        lb.numberOfLines = 0
        lb.layer.cornerRadius = 12
        lb.layer.masksToBounds = true
        lb.isUserInteractionEnabled = true
        lb.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissView)))
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var finishImageViewConstraint: NSLayoutConstraint?
    var titleLabelConstraint: NSLayoutConstraint?
    var subtitleLabelConstraint: NSLayoutConstraint?
    var nextLabelConstraint: NSLayoutConstraint?
    
    fileprivate func setupLayouts() {
        backgroundColor = .white
        
        addSubview(finishImageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(nextLabel)
        
        finishImageViewConstraint = finishImageView.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: (self.frame.width / 2) - 135, bottomConstant: 0, rightConstant: 0, widthConstant: 270, heightConstant: 200).first
        titleLabelConstraint = titleLabel.anchor(finishImageView.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 16, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 28).first
        subtitleLabelConstraint = subtitleLabel.anchor(titleLabel.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 8, leftConstant: 48, bottomConstant: 0, rightConstant: 48, widthConstant: 0, heightConstant: 56).first
        nextLabelConstraint = nextLabel.anchor(subtitleLabel.bottomAnchor, left: self.leftAnchor, bottom: nil, right: nil, topConstant: 16, leftConstant: (self.frame.width / 2) - 100, bottomConstant: 0, rightConstant: 0, widthConstant: 200, heightConstant: 56).first
    }
    
    @objc fileprivate func dismissView() {
        delegate?.dismissView()
    }
    
}



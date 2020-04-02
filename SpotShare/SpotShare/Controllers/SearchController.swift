//
//  SearchController.swift
//  SpotShare
//
//  Created by 김희중 on 04/05/2019.
//  Copyright © 2019 김희중. All rights reserved.
//

import UIKit
// https://github.com/ergunemr/BottomPopup
// **** 추후에 main search bar에서 그대로 올라올수있게 업데이트 하자!!!
class SearchController: BottomPopupViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate {
    
    deinit {
        print("no retain cycle in SearchController")
    }
    
    let cellid = "cellid"
    
    var delegate: searchDelegate?
    
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
    
    let thumbBackView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    let thumbView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 1, alpha: 0.5)
        view.layer.cornerRadius = 2.5
        view.layer.masksToBounds = true
        return view
    }()
    
    let whiteBackView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        return view
    }()
    
    let searchView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 3
        view.layer.borderColor = UIColor.mainColor.cgColor
        view.layer.masksToBounds = true
        return view
    }()
    
    let searchImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "searchLine")
        return iv
    }()
    
    // FLOG CommentInputTextView 확인.
    // https://www.letsbuildthatapp.com/course/Instagram-Firebase
    // LBTA 확인.
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
        return tf
    }()
    
    override var inputAccessoryView: UIView? {
        get {
            return contatinerView
        }
    }
    
    lazy var innerSearchCollectionview: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.alwaysBounceVertical = true
        collectionview.showsVerticalScrollIndicator = false
        collectionview.backgroundColor = .white
        return collectionview
    }()
    
    
    var thumbBackViewConstraint: NSLayoutConstraint?
    var thumbViewConstraint: NSLayoutConstraint?
    var whiteBackViewConstraint: NSLayoutConstraint?
    var searchViewConstraint: NSLayoutConstraint?
    var searchImageViewConstraint: NSLayoutConstraint?
    var searchTextFieldConstraint: NSLayoutConstraint?
    var searchTextConstraint: NSLayoutConstraint?
    var innerSearchConstraint: NSLayoutConstraint?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.searchTextField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        view.addSubview(thumbBackView)
        thumbBackView.addSubview(thumbView)
        view.addSubview(whiteBackView)
        whiteBackView.addSubview(searchView)
        searchView.addSubview(searchImageView)
        searchView.addSubview(searchTextField)
        whiteBackView.addSubview(innerSearchCollectionview)
        
        thumbBackViewConstraint = thumbBackView.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 27).first
        thumbViewConstraint = thumbView.anchor(thumbBackView.topAnchor, left: thumbBackView.leftAnchor, bottom: nil, right: nil, topConstant: 12, leftConstant: (view.frame.width / 2) - 40, bottomConstant: 0, rightConstant: 0, widthConstant: 80, heightConstant: 5).first
        whiteBackViewConstraint = whiteBackView.anchor(thumbBackView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
        searchViewConstraint = searchView.anchor(whiteBackView.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 0, heightConstant: 48).first
        searchImageViewConstraint = searchImageView.anchor(searchView.topAnchor, left: searchView.leftAnchor, bottom: nil, right: nil, topConstant: 12, leftConstant: 13, bottomConstant: 0, rightConstant: 0, widthConstant: 24, heightConstant: 24).first
        searchTextFieldConstraint = searchTextField.anchor(searchView.topAnchor, left: searchImageView.rightAnchor, bottom: nil, right: searchView.rightAnchor, topConstant: 14, leftConstant: 8, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: 20).first
        innerSearchConstraint = innerSearchCollectionview.anchor(searchView.bottomAnchor, left: whiteBackView.leftAnchor, bottom: whiteBackView.bottomAnchor, right: whiteBackView.rightAnchor, topConstant: 20, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 0, heightConstant: 0).first
        
        innerSearchCollectionview.register(RecentSearchCell.self, forCellWithReuseIdentifier: cellid)
        
    }
    
    @objc fileprivate func goSearchResult() {
        self.dismiss(animated: true) {
            self.delegate?.goSearchResult()
        }
    }
    
    @objc fileprivate func clearText() {
        self.searchTextField.text = nil
    }
    
    @objc fileprivate func closeText() {
        self.searchTextField.endEditing(true)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let text = textField.text
        print(text)
        goSearchResult()
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath) as! RecentSearchCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width - 48, height: 32)
    }
}

class RecentSearchCell: UICollectionViewCell {
    
    let recentImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "clock")
        return iv
    }()
    
    let recentSearchText: UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor.rgb(red: 51, green: 51, blue: 51)
        lb.font = UIFont(name: "DMSans-Medium", size: 14)
        // letter spacing -0.1
        let attributedString = NSMutableAttributedString(string: "Recent")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(-0.1), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.textAlignment = .left
        lb.backgroundColor = .white
        return lb
    }()

    let recentDeleteImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "cross")
        return iv
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var recentImageViewConstraint: NSLayoutConstraint?
    var recentSearchTextConstraint: NSLayoutConstraint?
    var recentDeleteImageViewConstraint: NSLayoutConstraint?
    
    fileprivate func setupViews() {
        addSubview(recentImageView)
        addSubview(recentSearchText)
        addSubview(recentDeleteImageView)
        
        recentImageViewConstraint = recentImageView.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 32, heightConstant: 32).first
        recentDeleteImageViewConstraint = recentDeleteImageView.anchor(self.topAnchor, left: nil, bottom: nil, right: self.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 4, widthConstant: 12, heightConstant: 12).first
        recentSearchTextConstraint = recentSearchText.anchor(self.topAnchor, left: recentImageView.rightAnchor, bottom: nil, right: recentDeleteImageView.leftAnchor, topConstant: 7, leftConstant: 12, bottomConstant: 0, rightConstant: 3, widthConstant: 0, heightConstant: 18).first
        
        
    }
}

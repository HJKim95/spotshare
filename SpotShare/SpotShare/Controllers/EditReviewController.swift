//
//  EditReviewController.swift
//  SpotShare
//
//  Created by 김희중 on 25/02/2020.
//  Copyright © 2020 김희중. All rights reserved.
//

import UIKit
import Cosmos

class EditReviewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, UINavigationControllerDelegate {
    
    deinit {
        print("no retain cycle in EditReviewController")
    }
    
    let headerid = "headerid"
    let cellid = "cellid"
    
    lazy var backImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "back")
        iv.contentMode = .scaleAspectFit
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goBack)))
        return iv
    }()
    
    lazy var threedotsImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "threedots")?.withRenderingMode(.alwaysTemplate)
        iv.contentMode = .scaleAspectFit
        iv.tintColor = UIColor.rgb(red: 68, green: 68, blue: 68)
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pressDots)))
        return iv
    }()
    
    
    lazy var innerReviewCollectionview: UICollectionView = {
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
    
    var imageHeight:CGFloat?
    var reviewImage: UIImage?
    var textHeight: CGFloat?
    var reviewText: String?
    var userName: String?
    var userImage: UIImage?
    var resName: String?
    var reviewPoint: Double?
    
    var backImageViewConstraint: NSLayoutConstraint?
    var threedotsImageViewConstraint: NSLayoutConstraint?
    var innerReviewCollectionviewConstraint: NSLayoutConstraint?
    
    private var interactionController: UIPercentDrivenInteractiveTransition?
    private var edgeSwipeGestureRecognizer: UIScreenEdgePanGestureRecognizer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // swipe로 back 구현하려면 두개 다 써줘야함.
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
//        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        edgeSwipeGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        edgeSwipeGestureRecognizer!.edges = .left
        view.addGestureRecognizer(edgeSwipeGestureRecognizer!)

        
        innerReviewCollectionview.register(innerReviewHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerid)
        innerReviewCollectionview.register(innerReviewCell.self, forCellWithReuseIdentifier: cellid)
        
        view.addSubview(backImageView)
        view.addSubview(threedotsImageView)
        
        view.addSubview(innerReviewCollectionview)
        
        if #available(iOS 11.0, *) {
            backImageViewConstraint = backImageView.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 16, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 24, heightConstant: 24).first
            threedotsImageViewConstraint = threedotsImageView.anchor(view.safeAreaLayoutGuide.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, topConstant: 13, leftConstant: 0, bottomConstant: 0, rightConstant: 24, widthConstant: 24, heightConstant: 24).first
            innerReviewCollectionviewConstraint = innerReviewCollectionview.anchor(backImageView.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, topConstant: 27, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 0, heightConstant: 0).first

            
        }
        else {
            backImageViewConstraint = backImageView.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 16, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 24, heightConstant: 24).first
            threedotsImageViewConstraint = threedotsImageView.anchor(view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, topConstant: 13, leftConstant: 0, bottomConstant: 0, rightConstant: 24, widthConstant: 24, heightConstant: 24).first
            innerReviewCollectionviewConstraint = innerReviewCollectionview.anchor(backImageView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 27, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 0, heightConstant: 0).first

        }
        
    }
    

    @objc func handleSwipe(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        // 1
        let percent = gestureRecognizer.translation(in: gestureRecognizer.view!).x / gestureRecognizer.view!.bounds.size.width
        
        if gestureRecognizer.state == .began {
            // 2
            interactionController = UIPercentDrivenInteractiveTransition()
            print("began",percent)
//            self.navigationController?.popViewController(animated: true)
        } else if gestureRecognizer.state == .changed {
            // 3
            interactionController?.update(percent)
            print("change",percent)
        } else if gestureRecognizer.state == .ended {
            // 4
            if percent > 0.5 && gestureRecognizer.state != .cancelled {
                self.navigationController?.popViewController(animated: true)
                interactionController?.finish()
            } else {
                interactionController?.cancel()
            }
            interactionController = nil
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerid, for: indexPath) as! innerReviewHeaderCell
        header.foodImageView.image = reviewImage
        header.foodImageView.heightAnchor.constraint(equalToConstant: imageHeight ?? 185).isActive = true
        
//        header.postLabel.text = reviewText
        //letter spacing -0.1
        let attributedTextString = NSMutableAttributedString(string: reviewText ?? "")
        attributedTextString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(-0.1), range: NSRange(location: 0, length: attributedTextString.length))
        let mutableParagraphStyle = NSMutableParagraphStyle()
        // line spacing 7
        mutableParagraphStyle.lineSpacing = 7
        let stringLength = reviewText?.count ?? 30
        attributedTextString.addAttribute(NSAttributedString.Key.paragraphStyle, value: mutableParagraphStyle, range: NSMakeRange(0, stringLength))
        header.postLabel.attributedText = attributedTextString
        header.postLabel.heightAnchor.constraint(equalToConstant: textHeight ?? 300).isActive = true
        header.userImageView.image = userImage
        if let username = userName {
            header.restaurantLabel.letterSpacing(text: "\(String(describing: username))", spacing: -0.2)
        }
        
        
        // letter spacing -0.1
        if let point = reviewPoint {
            header.starPoint.letterSpacing(text: "\(String(describing: point))", spacing: -0.1)
            header.cosmosView.rating = reviewPoint ?? 0
        }
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath) as! innerReviewCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        // ** 20(commentCount 간격) + 20(commentCount Height) + 16(밑에 cell 간격) = 58
        return CGSize(width: collectionView.frame.width, height: 125 + (imageHeight ?? 185) + (self.textHeight ?? 300) + 56)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 64)
    }
    
    @objc fileprivate func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc fileprivate func pressDots() {
           print("pressDotsss")
       }
}

class innerReviewHeaderCell: UICollectionViewCell {
    
    let userImageView: UIImageView = {
        let iv = UIImageView()
//        iv.image = UIImage(named: "imsi_user")
        iv.backgroundColor = .white
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 24
        iv.layer.masksToBounds = true
        return iv
    }()
    
    let restaurantLabel: UILabel = {
        let lb = UILabel()
        // letter spacing -0.2
        lb.font = UIFont(name: "DMSans-Medium", size: 17)
        lb.textColor = .darkGray
        lb.textAlignment = .left
        lb.numberOfLines = 0
        return lb
    }()
    
    let foodImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .blue
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 10
        iv.layer.masksToBounds = true
        return iv
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
    
    let starPoint: UILabel = {
       let lb = UILabel()
       // attributtedString(text)는 위에 cell에서 처리해줌.
       lb.font = UIFont(name: "DMSans-Regular", size: 20)
       lb.textColor = .darkGray
       lb.textAlignment = .center
       lb.numberOfLines = 0
       return lb
   }()
    
    let postLabel: UITextView = {
        let lb = UITextView()
        lb.font = UIFont(name: "DMSans-Regular", size: 16)
        lb.isScrollEnabled = false
        // 색 조정 필요.
        lb.textColor = .darkGray
        lb.textAlignment = .left
        lb.isUserInteractionEnabled = false
        return lb
    }()
    
    let heartImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "heart")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let heartLabel: UILabel = {
        let lb = UILabel()
        // letter spacing -0.1
        let attributedString = NSMutableAttributedString(string: "150")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(-0.1), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.font = UIFont(name: "DMSans-Regular", size: 14)
        lb.textColor = .gray
        lb.textAlignment = .left
        lb.numberOfLines = 0
        return lb
    }()
    
    let commentImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "comment")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let commentLabel: UILabel = {
        let lb = UILabel()
        // letter spacing -0.1
        let attributedString = NSMutableAttributedString(string: "4")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(-0.1), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.font = UIFont(name: "DMSans-Regular", size: 14)
        lb.textColor = .gray
        lb.textAlignment = .left
        lb.numberOfLines = 0
        return lb
    }()
    
    let commentCountLabel: UILabel = {
        let lb = UILabel()
        // letter spacing -0.1
        let attributedString = NSMutableAttributedString(string: "4 Comments")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(-0.1), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.font = UIFont(name: "DMSans-Medium", size: 15)
        lb.textColor = .darkGray
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
    
    var userImageViewConstraint: NSLayoutConstraint?
    var restaurantLabelConstraint: NSLayoutConstraint?
    var foodImageViewConstraint: NSLayoutConstraint?
    var cosmosViewConstraint: NSLayoutConstraint?
    var starPointConstraint: NSLayoutConstraint?
    var postLabelConstraint: NSLayoutConstraint?
    var heartImageViewConstraint: NSLayoutConstraint?
    var heartLabelConstraint: NSLayoutConstraint?
    var commentImageViewConstraint: NSLayoutConstraint?
    var commentLabelConstraint: NSLayoutConstraint?
    var commentCountLabelConsraint: NSLayoutConstraint?
    
    
    fileprivate func setupLayouts() {
        backgroundColor = .white
        
        addSubview(userImageView)
        addSubview(restaurantLabel)
        addSubview(foodImageView)
        addSubview(cosmosView)
        addSubview(starPoint)
        addSubview(postLabel)
        addSubview(heartImageView)
        addSubview(heartLabel)
        addSubview(commentImageView)
        addSubview(commentLabel)
        addSubview(commentCountLabel)

        
        userImageViewConstraint = userImageView.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, topConstant: 1, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 48, heightConstant: 48).first
        starPointConstraint = starPoint.anchor(self.topAnchor, left: nil, bottom: nil, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 32, heightConstant: 28).first
        cosmosViewConstraint = cosmosView.anchor(starPoint.bottomAnchor, left: nil, bottom: nil, right: self.rightAnchor, topConstant: 6, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 90, heightConstant: 16).first
        restaurantLabelConstraint = restaurantLabel.anchor(self.topAnchor, left: self.userImageView.rightAnchor, bottom: nil, right: cosmosView.leftAnchor, topConstant: 0, leftConstant: 11, bottomConstant: 0, rightConstant: 30, widthConstant: 0, heightConstant: 52).first
        
        postLabelConstraint = postLabel.anchor(restaurantLabel.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 16, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
        foodImageViewConstraint = foodImageView.anchor(postLabel.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 16, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
        
        heartImageViewConstraint = heartImageView.anchor(foodImageView.bottomAnchor, left: self.leftAnchor, bottom: nil, right: nil, topConstant: 18, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 16, heightConstant: 16).first
        heartLabelConstraint = heartLabel.anchor(foodImageView.bottomAnchor, left: heartImageView.rightAnchor, bottom: nil, right: nil, topConstant: 16, leftConstant: 4, bottomConstant: 0, rightConstant: 0, widthConstant: 25, heightConstant: 20).first
        commentImageViewConstraint = commentImageView.anchor(foodImageView.bottomAnchor, left: heartLabel.rightAnchor, bottom: nil, right: nil, topConstant: 18, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 16, heightConstant: 16).first
        commentLabelConstraint = commentLabel.anchor(foodImageView.bottomAnchor, left: commentImageView.rightAnchor, bottom: nil, right: nil, topConstant: 16, leftConstant: 4, bottomConstant: 0, rightConstant: 0, widthConstant: 25, heightConstant: 20).first
        commentCountLabelConsraint = commentCountLabel.anchor(heartImageView.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 20).first

        
    }
}

class innerReviewCell: UICollectionViewCell {
    
    let userImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "imsi_user")
        iv.backgroundColor = .white
        iv.contentMode = .scaleAspectFit
        iv.layer.cornerRadius = 16
        iv.layer.masksToBounds = true
        return iv
    }()
    
    let userNameLabel: UILabel = {
        let lb = UILabel()
        // letter spacing -0.1
        let attributedString = NSMutableAttributedString(string: "Jessica")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(-0.1), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.font = UIFont(name: "DMSans-Medium", size: 14)
        lb.textColor = .darkGray
        lb.textAlignment = .left
        lb.numberOfLines = 0
        return lb
    }()
    
    let replyLabel: UILabel = {
        let lb = UILabel()
        // letter spacing -0.1
        let attributedString = NSMutableAttributedString(string: "Great review!")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(-0.1), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.font = UIFont(name: "DMSans-Regular", size: 14)
        lb.textColor = .darkGray
        lb.textAlignment = .left
        lb.numberOfLines = 0
        return lb
    }()
    
    let timeLabel: UILabel = {
        let lb = UILabel()
        // letter spacing -0.1
        let attributedString = NSMutableAttributedString(string: "2 hours ago")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(-0.1), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.font = UIFont(name: "DMSans-Regular", size: 14)
        lb.textColor = .gray
        lb.textAlignment = .left
        lb.numberOfLines = 0
        return lb
    }()
    
    let replyImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "reply")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let replyButton: UILabel = {
        let lb = UILabel()
        // letter spacing -0.1
        let attributedString = NSMutableAttributedString(string: "Reply")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(-0.1), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.font = UIFont(name: "DMSans-Regular", size: 14)
        lb.textColor = .gray
        lb.textAlignment = .left
        lb.numberOfLines = 0
        return lb
    }()
    
    let heartImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "heart")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var userImageViewConstraint: NSLayoutConstraint?
    var userNameLabelConstraint: NSLayoutConstraint?
    var replyLabelConstraint: NSLayoutConstraint?
    var timeLabelConstraint: NSLayoutConstraint?
    var replyImageViewConstraint: NSLayoutConstraint?
    var replyButtonConstraint: NSLayoutConstraint?
    var heartImageViewConstraint: NSLayoutConstraint?
    
    fileprivate func setupLayouts() {
        backgroundColor = .white
        
        addSubview(userImageView)
        addSubview(userNameLabel)
        addSubview(replyLabel)
        addSubview(timeLabel)
        addSubview(replyImageView)
        addSubview(replyButton)
        addSubview(heartImageView)
        
        userImageViewConstraint = userImageView.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 32, heightConstant: 32).first
        userNameLabelConstraint = userNameLabel.anchor(self.topAnchor, left: userImageView.rightAnchor, bottom: nil, right: self.rightAnchor, topConstant: 0, leftConstant: 9, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 18).first
        heartImageViewConstraint = heartImageView.anchor(userNameLabel.bottomAnchor, left: nil, bottom: nil, right: self.rightAnchor, topConstant: 6, leftConstant: 0, bottomConstant: 0, rightConstant: 10, widthConstant: 16, heightConstant: 16).first
        replyLabelConstraint = replyLabel.anchor(userNameLabel.bottomAnchor, left: userNameLabel.leftAnchor, bottom: nil, right: heartImageView.leftAnchor, topConstant: 4, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 20).first
        timeLabelConstraint = timeLabel.anchor(replyLabel.bottomAnchor, left: replyLabel.leftAnchor, bottom: nil, right: nil, topConstant: 2, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 75, heightConstant: 20).first
        replyImageViewConstraint = replyImageView.anchor(timeLabel.topAnchor, left: timeLabel.rightAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 16, heightConstant: 16).first
        replyButtonConstraint = replyButton.anchor(replyLabel.bottomAnchor, left: replyImageView.rightAnchor, bottom: nil, right: nil, topConstant: 2, leftConstant: 4, bottomConstant: 0, rightConstant: 0, widthConstant: 36, heightConstant: 20).first
        
    }
}

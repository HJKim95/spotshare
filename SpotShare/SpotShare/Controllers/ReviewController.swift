//
//  ReviewController.swift
//  SpotShare
//
//  Created by 김희중 on 13/11/2019.
//  Copyright © 2019 김희중. All rights res`erved.
//

import UIKit
import collection_view_layouts
import Cosmos
import Firebase
import GoogleMaps

// https://github.com/rubygarage/collection-view-layouts
// https://github.com/evgenyneu/Cosmos

class ReviewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, ContentDynamicLayoutDelegate, UINavigationControllerDelegate {
    
    deinit {
        print("no retain cycle in ReviewController")
    }
    
    fileprivate let cellid = "cellid"
    fileprivate let headerid = "headerid"
    
    var images2: [UIImage] = [UIImage(named: "2")!,UIImage(named: "3")!,UIImage(named: "4")!,UIImage(named: "5")!,UIImage(named: "6")!,UIImage(named: "7")!,UIImage(named: "8")!,UIImage(named: "9")!,UIImage(named: "10")!,UIImage(named: "1")!]
    var texts: [String] = ["Lorem ipsum dolor sit amet, consectetur adipiscing elit…Lorem ipsum dolor sit amet, consectetur adipiscing elit…Lorem ipsum dolor sit amet, consectetur adipiscing elit…끝끝끝끝끝끝","Lorem ipsum dolor sit amet, consectetur adipiscing elit…끝끝끝끝끝끝끝끝끝","Lorem ipsum dolor sit amet, consectetur adipiscing elit…끝끝끝끝끝끝끝끝끝","Lorem ipsum dolor sit amet, consectetur adipiscing elit…Lorem ipsum dolor sit amet, consectetur adipiscing elit…Lorem ipsum dolor sit amet, consectetur adipiscing elit…Lorem ipsum dolor sit amet, cons끝끝끝","Lorem ipsum dolor sit amet, consectetur adipiscing elit…끝끝끝","Lorem ipsum dolor sit amet, consectetur adipiscing elit…끝끝끝","Lorem ipsum dolor sit amet, consectetur adipiscing elit…끝끝끝","Lorem ipsum dolor sit amet, consectetur adipiscing elit…끝끝끝","Lorem ipsum dolor sit amet, consectetur adipiscing elit…끝끝끝","Lorem ipsum dolor sit amet, consectetur adipiscing elit…ing elit…ing elit…ing elit…ing elit…ing elit…ing elit…끝끝끝"]
    
    var imsiRating: [Double] = [4.5,2.5,3.0,1.5,1.0,5,4.4,3.3,2.8,4.5]

    
    lazy var backImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "back")
        iv.contentMode = .scaleAspectFit
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goBack)))
        return iv
    }()
    
    
    let postLabel: UILabel = {
        let lb = UILabel()
        // letter spacing 0.86
        let attributedString = NSMutableAttributedString(string: "WRITE A REVIEW")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(0.86), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.font = UIFont(name: "DMSans-Bold", size: 12)
        lb.textColor = .mainColor
        lb.textAlignment = .center
        lb.numberOfLines = 0
        return lb
    }()
    
    let postImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "addReview")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    lazy var postView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 18
        view.layer.borderColor = UIColor.mainColor.cgColor
        view.layer.borderWidth = 2
        view.layer.masksToBounds = true
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(writeReview)))
        return view
    }()
    
    lazy var reviewCollectionView: UICollectionView = {
        let layout = PinterestStyleFlowLayout()
        layout.columnsCount = 2
        layout.delegate = self
        layout.contentPadding = ItemsPadding(horizontal: 0, vertical: 0)
        layout.cellsPadding = ItemsPadding(horizontal: 10, vertical: 10)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.dataSource = self
        cv.delegate = self
        cv.showsVerticalScrollIndicator = false
        cv.backgroundColor = .white
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        // swipe로 back 구현하려면 두개 다 써줘야함.
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        self.navigationController?.delegate = self

        setupLayouts()
        getReview_firebase()
    }
    
    var backImageViewConstraint: NSLayoutConstraint?
    var postLabelConstraint: NSLayoutConstraint?
    var postImageViewConstraint: NSLayoutConstraint?
    var postViewConstraint: NSLayoutConstraint?
    var reviewCollectionViewConstraint: NSLayoutConstraint?
    
    fileprivate func setupLayouts() {
        view.addSubview(backImageView)
        view.addSubview(postView)
        postView.addSubview(postLabel)
        postView.addSubview(postImageView)
        
        view.addSubview(reviewCollectionView)

        reviewCollectionView.register(ReviewCell.self, forCellWithReuseIdentifier: cellid)
        
        if #available(iOS 11.0, *) {
            backImageViewConstraint = backImageView.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 16, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 24, heightConstant: 24).first
            postViewConstraint = postView.anchor(view.safeAreaLayoutGuide.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 24, widthConstant: 160, heightConstant: 36).first
            postLabelConstraint = postLabel.anchor(postView.topAnchor, left: postView.leftAnchor, bottom: nil, right: nil, topConstant: 10, leftConstant: 19, bottomConstant: 0, rightConstant: 0, widthConstant: 108, heightConstant: 16).first
            postImageViewConstraint = postImageView.anchor(postView.topAnchor, left: postLabel.rightAnchor, bottom: nil, right: nil, topConstant: 10, leftConstant: 6, bottomConstant: 0, rightConstant: 0, widthConstant: 16, heightConstant: 16).first
            reviewCollectionViewConstraint = reviewCollectionView.anchor(postView.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, topConstant: 16, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 0, heightConstant: 0).first
            
        }
        else {
            backImageViewConstraint = backImageView.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 16, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 24, heightConstant: 24).first
            postViewConstraint = postView.anchor(view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 24, widthConstant: 160, heightConstant: 36).first
            postLabelConstraint = postLabel.anchor(postView.topAnchor, left: postView.leftAnchor, bottom: nil, right: nil, topConstant: 10, leftConstant: 19, bottomConstant: 0, rightConstant: 0, widthConstant: 108, heightConstant: 16).first
            postImageViewConstraint = postImageView.anchor(postView.topAnchor, left: postLabel.rightAnchor, bottom: nil, right: nil, topConstant: 10, leftConstant: 6, bottomConstant: 0, rightConstant: 0, widthConstant: 16, heightConstant: 16).first
            reviewCollectionViewConstraint = reviewCollectionView.anchor(postView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 16, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 0, heightConstant: 0).first
        }
        
        
    }
    
    
    var reviewinfos = [ReviewModel]()

    var AllObject = [String]()
    var testCount = 6
    var saveChild: String = "resName"
    
    fileprivate func getReview_firebase() {
        print("Start paging for more posts")
        let ref = Database.database().reference().child("messages")
        var query = ref.queryOrdered(byChild: "time")
        if reviewinfos.count > 0 {
//            let value = reviewinfos.last?.time
//            query = query.queryEnding(atValue: value)
        }
        query.queryLimited(toLast: 6).observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
            guard var allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
            allObjects.reverse()
            
            if allObjects.count < 6 {
//                self.isFinishedPaging = true
            }
            
            if self?.reviewinfos.count ?? 0 > 0 && allObjects.count > 0 {
                allObjects.removeFirst()
                    
            }
            
            allObjects.forEach({ [weak self] (snapshot) in
                if let dictionary = snapshot.value as? [String:Any] {
                    
                    let review = ReviewModel()
                    review.reviewId = dictionary["id"] as? String
                    review.reviewName = dictionary["name"] as? String
                    review.reviewResName = dictionary["resName"] as? String
                    review.starPoint = dictionary["points"] as? Double
                    review.reviewText = dictionary["text"] as? String
                    review.reviewProfUrl = dictionary["profUrl"] as? String
                    review.reviewImageUrl = dictionary["resImageUrl"] as? String
                    review.reviewTime = dictionary["time"] as? NSNumber
                    

                    self?.reviewinfos.append(review)

                    DispatchQueue.main.async {
                        self?.reviewCollectionView.reloadData()
                    }

                }
            })
            
        }) { (error) in
    
            print("observing reviews occurred error ",error)
            
        }
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reviewinfos.count
    }
    
    var aspectRatioConstraint: NSLayoutConstraint?
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath) as! ReviewCell
        let reviewInfo = reviewinfos[indexPath.item]
        
        //letter spacing -0.1
        let attributedString = NSMutableAttributedString(string: reviewInfo.reviewText ?? "")
        let mutableParagraphStyle = NSMutableParagraphStyle()
        // line spacing 7
        mutableParagraphStyle.lineSpacing = 7
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(-0.1), range: NSRange(location: 0, length: attributedString.length))
        let stringLength = reviewInfo.reviewText?.count ?? 0
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: mutableParagraphStyle, range: NSMakeRange(0, stringLength))
        cell.postLabel.attributedText = attributedString
        
        if let urlString = reviewInfo.reviewImageUrl {
            let url = URL(string: urlString)
            cell.foodImageView.sd_setImage(with: url) { [weak self] (image, err, SDImageCacheType, URL) in
                guard let imageSize = image?.size else {return}
                // https://www.raywenderlich.com/1169-easier-auto-layout-coding-constraints-in-ios-9
                let ratio = imageSize.height / imageSize.width
//                self?.aspectRatioConstraint?.isActive = false
                self?.aspectRatioConstraint = cell.foodImageView.heightAnchor.constraint(equalTo: cell.foodImageView.widthAnchor, multiplier: ratio, constant: 0)
                self?.aspectRatioConstraint?.isActive = true
            }
        }
        
        if let userUrlString = reviewInfo.reviewProfUrl {
            let url = URL(string: userUrlString)
            cell.userImageView.sd_setImage(with: url, placeholderImage: nil, options: .scaleDownLargeImages, completed: nil)
        }
        
        if let userName = reviewInfo.reviewName {
            if let resName = reviewInfo.reviewResName {
                // 추후에 두줄로 바꾸자..
                cell.restaurantLabel.letterSpacing(text: userName + " in " + resName, spacing: -0.1)
            }
        }
        
        if let point = reviewInfo.starPoint {
            cell.cosmosView.rating = point
            cell.starPoint.letterSpacing(text: "\(point)", spacing: -0.1)
        }

        return cell
    }
    
    
    func cellSize(indexPath: IndexPath) -> CGSize {
        // 고정 height = 36 + 12 + 13 + 20 + 5 + 11 + 16 = 113
        // 변수 height(사진, text
        // 밑에 frame의 height에 따라 height가 너무 작으면 오류가 나더라.. constraint관련해서
        let frame = CGRect(x: 0, y: 0, width:  (view.frame.width - 48 - 10) / 2, height: 1000)
        let cellWidth = (view.frame.width - 48 - 10) / 2
        let dummyCell = ReviewCell(frame: frame)
        
        let reviewInfo = reviewinfos[indexPath.item]
        
        //letter spacing -0.1
        let attributedString = NSMutableAttributedString(string: reviewInfo.reviewText ?? "")
        let mutableParagraphStyle = NSMutableParagraphStyle()
        // line spacing 7
        mutableParagraphStyle.lineSpacing = 7
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(-0.1), range: NSRange(location: 0, length: attributedString.length))
        let stringLength = reviewInfo.reviewText?.count ?? 0
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: mutableParagraphStyle, range: NSMakeRange(0, stringLength))
        dummyCell.postLabel.attributedText = attributedString
        
        // 추후에 image는 리뷰 올릴때부터 size(height, width)를 받아와서 DB에 올려준걸 받아와서 처리하자 ***
        dummyCell.layoutIfNeeded()
        
        let textHeight = dummyCell.postLabel.sizeThatFits(dummyCell.postLabel.frame.size).height
        
        return CGSize(width: cellWidth, height: 113 + 159 + textHeight)
    }
    
    @objc fileprivate func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // https://github.com/ergunemr/BottomPopup
    @objc fileprivate func writeReview() {
        let vc = WriteReviewController()
        vc.height = view.frame.height - 70
        vc.topCornerRadius = 35
        vc.presentDuration = 0.5
        vc.dismissDuration = 0.5
//        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    
    var originFrame: CGRect?
    var originImage: UIImage?
    var imageSize: CGSize?
    var textHeight: CGFloat?
    
    
    // https://www.raywenderlich.com/322-custom-uiviewcontroller-transitions-getting-started
    // FLOG 참고.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let attribute = collectionView.layoutAttributesForItem(at: indexPath) else {return}
        let frame = collectionView.convert(attribute.frame, to: collectionView.superview)
        let cell = collectionView.cellForItem(at: indexPath) as! ReviewCell
        self.originFrame = frame
        // 이미지를 현재 array에서 따오고 있고, 이거에 대한 크기를 따와서 넘겨줌.
        let reviewInfo = reviewinfos[indexPath.item]
        let originalImage = cell.foodImageView.image
        let originalTexts = reviewInfo.reviewText
        self.imageSize = originalImage?.size

        // reviewImage
        self.originImage = cell.foodImageView.image
        guard let originHeight = originalImage?.size.height else {return}
        guard let originWidth = originalImage?.size.width else {return}
        let sizeHeight = originHeight * (view.frame.width - 48) / originWidth
        
        
        // reviewText
        let textFrame = CGRect(x: 24, y: 0, width: view.frame.width - 48, height: 1000)
        let dummyCell = innerReviewHeaderCell(frame: textFrame)
        //letter spacing -0.1
        let attributedTextString = NSMutableAttributedString(string: originalTexts ?? "")
        attributedTextString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(-0.1), range: NSRange(location: 0, length: attributedTextString.length))
        let mutableParagraphStyle = NSMutableParagraphStyle()
        // line spacing 7
        mutableParagraphStyle.lineSpacing = 7
        guard let stringLength = originalTexts?.count else { return }
        attributedTextString.addAttribute(NSAttributedString.Key.paragraphStyle, value: mutableParagraphStyle, range: NSMakeRange(0, stringLength))
        dummyCell.postLabel.attributedText = attributedTextString
        dummyCell.layoutIfNeeded()

        let textHeight = dummyCell.postLabel.sizeThatFits(dummyCell.postLabel.frame.size).height
        self.textHeight = textHeight
        
        let point = reviewInfo.starPoint
        
        let editreview = EditReviewController()
        editreview.reviewImage = cell.foodImageView.image
        editreview.imageHeight = sizeHeight
        editreview.reviewText = originalTexts
        editreview.textHeight = textHeight
        editreview.userImage = cell.userImageView.image
        editreview.userName = cell.restaurantLabel.text
        editreview.reviewPoint = point

        self.navigationController?.pushViewController(editreview, animated: true)
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let frame = originFrame else {return CGRect(x: 0, y: 0, width: 100, height: 100) as? UIViewControllerAnimatedTransitioning}
        guard let image = originImage else {return nil}
        guard let imageSize = imageSize else {return CGSize(width: 350, height: 350) as? UIViewControllerAnimatedTransitioning}
        
        // originFrame에서의 y값에는 statusHeight가 포함 안되어있어서 추가해주어야 제대로 된 y값을 구할수있다.
        let statusHeight = UIApplication.shared.statusBarFrame.height
        switch operation {
        case .push:
            if toVC.isKind(of: EditReviewController.self) {
                return ReviewTransitionAnimator(duration: TimeInterval(UINavigationController.hideShowBarDuration), isPresenting: true, originFrame: frame, image: image, height: statusHeight, imageSize: imageSize, textHeight: textHeight ?? 300)
            }
        default:
            if fromVC.isKind(of: EditReviewController.self) {
                return ReviewTransitionAnimator(duration: TimeInterval(UINavigationController.hideShowBarDuration), isPresenting: false, originFrame: frame, image: image, height: statusHeight, imageSize: imageSize, textHeight: textHeight ?? 300)
            }
        }
        return nil
    }
    
    
}


class ReviewCell: UICollectionViewCell {
    
    let userImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "imsi_user")
        iv.backgroundColor = .white
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 16
        iv.layer.masksToBounds = true
        return iv
    }()
    
    let restaurantLabel: UILabel = {
        let lb = UILabel()

        lb.font = UIFont(name: "DMSans-Medium", size: 14)
        lb.textColor = .darkGray
        lb.textAlignment = .left
        lb.numberOfLines = 0
        return lb
    }()
    
    let foodImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .white
        // .scaleAspectFill 로 해야될까..?
        iv.contentMode = .scaleAspectFit
        iv.layer.cornerRadius = 10
        //iv.clipstoBounds 와 동일
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
       lb.font = UIFont(name: "DMSans-Regular", size: 14)
       lb.textColor = .darkGray
       lb.textAlignment = .left
       lb.numberOfLines = 0
       return lb
   }()
    
    let postLabel: UITextView = {
        let lb = UITextView()
        lb.font = UIFont(name: "DMSans-Regular", size: 14)
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
    
    let dotsImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "dots")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
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
    var dotsImageViewConsraint: NSLayoutConstraint?
    
    
    fileprivate func setupViews() {
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
        addSubview(dotsImageView)
        
        userImageViewConstraint = userImageView.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, topConstant: 2, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 32, heightConstant: 32).first
        restaurantLabelConstraint = restaurantLabel.anchor(self.topAnchor, left: self.userImageView.rightAnchor, bottom: nil, right: self.rightAnchor, topConstant: 0, leftConstant: 11, bottomConstant: 0, rightConstant: 4, widthConstant: 0, heightConstant: 38).first
//        //dynamc cell sizing을 위해서 위에 따로 cell 설정하는곳에 foodImageView Constraint 작성했음.
        foodImageViewConstraint = foodImageView.anchor(restaurantLabel.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 12, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
        cosmosViewConstraint = cosmosView.anchor(foodImageView.bottomAnchor, left: self.leftAnchor, bottom: nil, right: nil, topConstant: 14, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 84, heightConstant: 14).first
        starPointConstraint = starPoint.anchor(foodImageView.bottomAnchor, left: cosmosView.rightAnchor, bottom: nil, right: self.rightAnchor, topConstant: 13, leftConstant: 4, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 20).first
        heartImageViewConstraint = heartImageView.anchor(nil, left: self.leftAnchor, bottom: self.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 16, heightConstant: 16).first
        heartLabelConstraint = heartLabel.anchor(nil, left: heartImageView.rightAnchor, bottom: self.bottomAnchor, right: nil, topConstant: 0, leftConstant: 4, bottomConstant: 0, rightConstant: 0, widthConstant: 25, heightConstant: 19).first
        commentImageViewConstraint = commentImageView.anchor(nil, left: heartLabel.rightAnchor, bottom: self.bottomAnchor, right: nil, topConstant: 11, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 16, heightConstant: 16).first
        commentLabelConstraint = commentLabel.anchor(nil, left: commentImageView.rightAnchor, bottom: self.bottomAnchor, right: nil, topConstant: 9, leftConstant: 4, bottomConstant: 0, rightConstant: 0, widthConstant: 25, heightConstant: 19).first
        dotsImageViewConsraint = dotsImageView.anchor(nil, left: nil, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 1, rightConstant: 0, widthConstant: 16, heightConstant: 16).first
        postLabelConstraint = postLabel.anchor(self.starPoint.bottomAnchor, left: self.leftAnchor, bottom: heartImageView.topAnchor, right: self.rightAnchor, topConstant: 5, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
        
        
    
        
    }
    
    
    
}


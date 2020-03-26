//
//  TodaysMealController.swift
//  SpotShare
//
//  Created by 김희중 on 14/01/2020.
//  Copyright © 2020 김희중. All rights reserved.
//

import UIKit
import MultiSlider

// https://github.com/mischa-hildebrand/AlignedCollectionViewFlowLayout
// https://github.com/yonat/MultiSlider

class TodaysMealController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    deinit {
        print("no retain cycle in TodayMealController")
    }
    
    fileprivate let cellid = "cellid"
    fileprivate let cellid2 = "cellid2"
    fileprivate let headerid = "headerid"
    fileprivate let footerid = "footerid"
    
    lazy var backImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "back")
        iv.contentMode = .scaleAspectFit
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goBack)))
        return iv
    }()
    
    lazy var innerTodayMealCollectionview: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 24
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.alwaysBounceVertical = true
        collectionview.showsVerticalScrollIndicator = false
        collectionview.backgroundColor = .white
        return collectionview
    }()
    
    var questionArr: [String] = ["Who are you eating with?", "What's in your mind?", "Except these", "What's your mood?", "Preferred Locations", "Price range per person", "Rate range"]
    
    var firstAnswerArr: [String] = ["ALONE","FRIENDS","LOVER","FAMILY"]
    var secondAnswerArr: [String] = ["FOOD","LIQUOR","CAFE"]
    var thirdAnswerArr: [String] = ["KOREAN","CHINESE","JAPANESE","WESTERN","ASIAN"]
    var fourthAnswerArr: [String] = ["GLOOMY","NORMAL","HAPPY"]
    var fifthAnswerArr: [String] = ["SANGSU","HAPJEONG","SEOGYO","YEONAM"]
    
    var answerArrays = [Array<String>]()
    
    var backImageViewConstraint: NSLayoutConstraint?
    var innerTodayMealCollectionviewConstraint: NSLayoutConstraint?
    var todayTitleConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        // swipe로 back 구현하려면 두개 다 써줘야함.
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        view.addSubview(backImageView)
        view.addSubview(innerTodayMealCollectionview)
        
        if #available(iOS 11.0, *) {
            backImageViewConstraint = backImageView.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 16, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 24, heightConstant: 24).first
            innerTodayMealCollectionviewConstraint = innerTodayMealCollectionview.anchor(backImageView.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, topConstant: 16, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 0, heightConstant: 0).first
            
        }
        else {
            backImageViewConstraint = backImageView.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 16, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 24, heightConstant: 24).first
            innerTodayMealCollectionviewConstraint = innerTodayMealCollectionview.anchor(backImageView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 16, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 0, heightConstant: 0).first
        }
        answerArrays = [firstAnswerArr,secondAnswerArr,thirdAnswerArr,fourthAnswerArr,fifthAnswerArr]
        innerTodayMealCollectionview.reloadData()
        innerTodayMealCollectionview.register(TodayMealCell.self, forCellWithReuseIdentifier: cellid)
        innerTodayMealCollectionview.register(SliderCell.self, forCellWithReuseIdentifier: cellid2)
        innerTodayMealCollectionview.register(TodayMealHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerid)
        innerTodayMealCollectionview.register(TodayMealFooterCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerid)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
            
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerid, for: indexPath) as! TodayMealHeaderCell
            return header
        
        case UICollectionView.elementKindSectionFooter:
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerid, for: indexPath) as! TodayMealFooterCell
            return footer
            
        default:
            assert(false, "Unexpected element kind")
        }
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerid, for: indexPath) as! TodayMealHeaderCell
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item < 5 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath) as! TodayMealCell
            // letter spacing -0.11
            let attributedString = NSMutableAttributedString(string: questionArr[indexPath.item])
            attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(-0.11), range: NSRange(location: 0, length: attributedString.length))
            cell.questionLabel.attributedText = attributedString
            cell.answerArr = answerArrays[indexPath.item]
            return cell
        }
        
            // slider 부분
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid2, for: indexPath) as! SliderCell
            cell.delegate = self
            // letter spacing -0.11
            let attributedString = NSMutableAttributedString(string: questionArr[indexPath.item])
            attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(-0.11), range: NSRange(location: 0, length: attributedString.length))
            cell.questionLabel.attributedText = attributedString
            
            if indexPath.item == 5 {
                // positiveSuffix를 제일 먼저 써주어야 처음부터 바로 적용된다.
                cell.multiSlider.valueLabelFormatter.positiveSuffix = "만원"
//                cell.multiSlider.valueLabels.forEach { (valueLabel) in
//                    valueLabel.font =  UIFont(name: "DMSans-Regular", size: 11)
//                }
                // valueLabel font 설정 어떻게 할지 다시 고민. (원래는 되는데 positiveSuffix 설정하면 안됨.)
                cell.multiSlider.minimumValue = 0.5
                cell.multiSlider.maximumValue = 4.0
                cell.multiSlider.value = [1.0, 3.0]
                cell.multiSlider.snapStepSize = 0.5
                
            }
            else if indexPath.item == 6 {
//                cell.multiSlider.valueLabels.forEach { (valueLabel) in
//                    valueLabel.font =  UIFont(name: "DMSans-Regular", size: 11)
//                }
                cell.multiSlider.minimumValue = 0.5
                cell.multiSlider.maximumValue = 5.0
                cell.multiSlider.value = [3.0, 4.0]
                cell.multiSlider.snapStepSize = 0.5
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        // 76 + 8 + 56 + 20
        return CGSize(width: collectionView.frame.width, height: 160)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        // 33 + 56 + 24
        return CGSize(width: collectionView.frame.width, height: 113)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item < 5 {
            let answersCount = answerArrays[indexPath.item].count
             if answersCount < 7 {
                 if answersCount > 3 {
                     // 28 + 16 + 36 + 10 + 36
                     return CGSize(width: collectionView.frame.width, height: 126)
                 }
             }
             else if answersCount < 10 {
                 if answersCount > 3 {
                     // 28 + 16 + 36 + 10 + 36 + 10 + 36
                     return CGSize(width: collectionView.frame.width, height: 172)
                 }
             }
            // 28 + 16 + 36
             return CGSize(width: collectionView.frame.width, height: 80)
        }
            // slider 부분
        else {
            return CGSize(width: collectionView.frame.width, height: 100)
        }
        
    }
    
    @objc fileprivate func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func stopScroll() {
        print("disabled scrolling")
        innerTodayMealCollectionview.isScrollEnabled = false
    }
    
    func keepScroll() {
        print("enabled scrolling")
        innerTodayMealCollectionview.isScrollEnabled = true
    }
}

class TodayMealCell: UICollectionViewCell, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    fileprivate let cellid = "cellid"
    
    let questionLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "DMSans-Regular", size: 20)
        lb.textAlignment = .left
        lb.numberOfLines = 0
        lb.textColor = .darkGray
        return lb
    }()
    
    lazy var innerTodayMealCellCollectionview: UICollectionView = {
        let layout = AlignedCollectionViewFlowLayout()
        // https://github.com/mischa-hildebrand/AlignedCollectionViewFlowLayout
        layout.horizontalAlignment = .left
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 10
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.alwaysBounceHorizontal = false
        collectionview.showsHorizontalScrollIndicator = false
        collectionview.backgroundColor = .white
        return collectionview
    }()
    
    
    var answerArr = [String]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var questionLabelConstraint: NSLayoutConstraint?
    var innerTodayMealCellCollectionviewConstraint: NSLayoutConstraint?
    var tagListViewConstraint: NSLayoutConstraint?
    
    fileprivate func setupLayouts() {
        backgroundColor = .white
        
        addSubview(questionLabel)
        addSubview(innerTodayMealCellCollectionview)
        
        questionLabelConstraint = questionLabel.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 28).first
        innerTodayMealCellCollectionviewConstraint = innerTodayMealCellCollectionview.anchor(questionLabel.bottomAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 16, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first

        
        innerTodayMealCellCollectionview.register(TodayMealAnswerCell.self, forCellWithReuseIdentifier: cellid)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath) as! TodayMealAnswerCell
        // letter spacing 0.86
        let attributedString = NSMutableAttributedString(string: answerArr[indexPath.item])
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(0.86), range: NSRange(location: 0, length: attributedString.length))
        cell.answerLabel.attributedText = attributedString
        return cell
            
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return answerArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let answerCounts = answerArr[indexPath.item].count
        
        if answerCounts > 9 {
            return CGSize(width: answerCounts * 11, height: 36)
        }
        else if answerCounts > 7 {
            return CGSize(width: answerCounts * 12, height: 36)
        }
        else if answerCounts > 5 {
            return CGSize(width: answerCounts * 13, height: 36)
        }
        else {
            return CGSize(width: 78, height: 36)
        }
    }
}

class TodayMealAnswerCell: UICollectionViewCell {
    
    let answerLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "DMSans-Bold", size: 12)
        lb.textAlignment = .center
        lb.numberOfLines = 0
        lb.textColor = .mainColor
        lb.layer.cornerRadius = 18
        lb.layer.masksToBounds = true
        lb.layer.borderColor = UIColor.mainColor.cgColor
        lb.layer.borderWidth = 2
        return lb
    }()
    
    override var isHighlighted: Bool {
        didSet {
            answerLabel.backgroundColor = isHighlighted ? UIColor.mainColor : UIColor.white
            answerLabel.textColor = isHighlighted ? UIColor.white : UIColor.mainColor
        }
    }
    
    override var isSelected: Bool {
        didSet {
            answerLabel.backgroundColor = isSelected ? UIColor.mainColor : UIColor.white
            answerLabel.textColor = isSelected ? UIColor.white : UIColor.mainColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var answerLabelConstraint: NSLayoutConstraint?
    
    fileprivate func setupLayouts() {
        backgroundColor = .white
        
        addSubview(answerLabel)
        
        answerLabelConstraint = answerLabel.anchor(self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
    }
}

class SliderCell: UICollectionViewCell {
    
    weak var delegate: TodaysMealController?
    
    
    let questionLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "DMSans-Regular", size: 20)
        lb.textAlignment = .left
        lb.numberOfLines = 0
        lb.textColor = .darkGray
        return lb
    }()
    
    lazy var multiSlider: MultiSlider = {
        let ms = MultiSlider()
        ms.orientation = .horizontal
        ms.outerTrackColor = UIColor.rgb(red: 232, green: 232, blue: 232)
        ms.isHapticSnap = true
        ms.valueLabelPosition = .bottom
        // 나중에 원 표시 하려면 밑에꺼 쓰기
//        ms.valueLabelFormatter.positiveSuffix = " 𝞵s"
        ms.tintColor = .mainColor
        // trachWidth는 orientation에 따라 vertical이면 width, horizontal이면 height를 가리킴.
        // 그리고 trackWidth는 말 그래도 원이 아닌 선의 두께를 가리킴.
        ms.trackWidth = 2
        ms.showsThumbImageShadow = false
        ms.hasRoundTrackEnds = true
        ms.thumbImage = UIImage(named: "dot")
        ms.addTarget(self, action: #selector(sliderChanged(slider:)), for: .valueChanged)
        ms.addTarget(self, action: #selector(sliderEnded(slider:)), for: .touchUpInside)
        return ms
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var questionLabelConstraint: NSLayoutConstraint?
    var multiSliderConstraint: NSLayoutConstraint?
    
    fileprivate func setupLayouts() {
        backgroundColor = .white
        
        addSubview(questionLabel)
        addSubview(multiSlider)
        
//        multiSlider.valueLabels.forEach { (valueLabel) in
//            valueLabel.font =  UIFont(name: "DMSans-Regular", size: 11)
//        }
        
        questionLabelConstraint = questionLabel.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 28).first
        multiSliderConstraint = multiSlider.anchor(questionLabel.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 16, leftConstant: 30, bottomConstant: 0, rightConstant: 30, widthConstant: 0, heightConstant: 0).first

    }
    
    @objc func sliderChanged(slider: MultiSlider) {
        print("thumb \(slider.draggedThumbIndex) moved")
        print("now thumbs are at \(slider.value)") // e.g., [1.0, 4.5, 5.0]
        
        delegate?.stopScroll()
    }
    
    @objc func sliderEnded(slider: MultiSlider) {
        print("slider ended")
//        print("now thumbs are at \(slider.value)") // e.g., [1.0, 4.5, 5.0]
        
        delegate?.keepScroll()
    }
}

class TodayMealHeaderCell: UICollectionViewCell {
    
    
    let TitleLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "DMSans-Medium", size: 28)
        // letter spacing -0.3
        let attributedString = NSMutableAttributedString(string: "Today's Recommendations")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(-0.3), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.textAlignment = .left
        lb.numberOfLines = 0
        lb.textColor = .black
        return lb
    }()
    
    let subTitleLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "DMSans-Regular", size: 16)
        // letter spacing -0.1
        let attributedString = NSMutableAttributedString(string: "Answer questions below and get your recommended places for today.")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(-0.1), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.textAlignment = .left
        lb.numberOfLines = 0
        lb.textColor = .gray
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var TitleLabelConstraint: NSLayoutConstraint?
    var subTitleLabelConstraint: NSLayoutConstraint?
    
    fileprivate func setupLayouts() {
        backgroundColor = .white
        
        addSubview(TitleLabel)
        addSubview(subTitleLabel)
        
        
        TitleLabelConstraint = TitleLabel.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 30, widthConstant: 0, heightConstant: 76).first
        subTitleLabelConstraint = subTitleLabel.anchor(TitleLabel.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 8, leftConstant: 0, bottomConstant: 0, rightConstant: 30, widthConstant: 0, heightConstant: 56).first

    }
    
}

class TodayMealFooterCell: UICollectionViewCell {
    
    
    let recommendLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "DMSans-Bold", size: 14)
        // letter spacing 1.0
        let attributedString = NSMutableAttributedString(string: "SEE RECOMMENDATIONS")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(1.0), range: NSRange(location: 0, length: attributedString.length))
        lb.attributedText = attributedString
        lb.textAlignment = .center
        lb.numberOfLines = 0
        lb.textColor = .white
        lb.backgroundColor = .mainColor
//        lb.alpha = 0.5
        lb.layer.cornerRadius = 12
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
    
    var recommendLabelConstraint: NSLayoutConstraint?
    
    fileprivate func setupLayouts() {
        backgroundColor = .white
        
        addSubview(recommendLabel)
        
        
        recommendLabelConstraint = recommendLabel.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 33, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 56).first

    }
    
}

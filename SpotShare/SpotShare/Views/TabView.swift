//
//  TabView.swift
//  SpotShare
//
//  Created by 김희중 on 29/04/2019.
//  Copyright © 2019 김희중. All rights reserved.
//

import UIKit

@IBDesignable
class TabView: UIView {
    
    var maincontroller: MainController?
    
    lazy var homeView: UIView = {
        let view = UIView()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goHome)))
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = true
        return view
    }()
    
    lazy var homeButton: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "home_pink")
        iv.contentMode = .scaleAspectFit
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goHome)))
        return iv
    }()
    
    lazy var homeButtonLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor.mainColor
        lb.text = "Home"
        lb.font = UIFont(name: "DMSans-Regular", size: 12)
        lb.textAlignment = .center
        lb.isUserInteractionEnabled = true
        lb.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goHome)))
        return lb
    }()
    
    lazy var myPageView: UIView = {
        let view = UIView()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goMyPage)))
        view.isUserInteractionEnabled = true
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var myPageButton: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "profile_gray")
        iv.contentMode = .scaleAspectFit
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goMyPage)))
        return iv
    }()
    
    lazy var myPageButtonLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor.mainGray
        lb.text = "Profile"
        lb.font = UIFont(name: "DMSans-Regular", size: 12)
        lb.textAlignment = .center
        lb.isUserInteractionEnabled = true
        lb.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goMyPage)))
        return lb
    }()
    
    let dividerLine: UIView = {
        let viewview = UIView()
        viewview.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        return viewview
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayouts()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var homeViewConstraint: NSLayoutConstraint?
    var homeButtonLayer: NSLayoutConstraint?
    var homeButtonLabelConstratint: NSLayoutConstraint?
    var myPageConstraint: NSLayoutConstraint?
    var myPageButtonLayer: NSLayoutConstraint?
    var myPageButtonLabelConstratint: NSLayoutConstraint?
    var dividerLineConstraint: NSLayoutConstraint?
    
    fileprivate func setupLayouts() {
        backgroundColor = UIColor.rgb(red: 252, green: 252, blue: 252)
        addSubview(homeView)
        homeView.addSubview(homeButton)
        homeView.addSubview(homeButtonLabel)
        addSubview(myPageView)
        myPageView.addSubview(myPageButton)
        myPageView.addSubview(myPageButtonLabel)
        addSubview(dividerLine)
        
        homeViewConstraint = homeView.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 60, bottomConstant: 0, rightConstant: 0, widthConstant: 48, heightConstant: 60).first
        homeButtonLayer = homeButton.anchor(homeView.topAnchor, left: homeView.leftAnchor, bottom: nil, right: nil, topConstant: 5, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: 24, heightConstant: 24).first
        homeButtonLabelConstratint = homeButtonLabel.anchor(homeButton.bottomAnchor, left: homeView.leftAnchor, bottom: nil, right: nil, topConstant: 2, leftConstant: 7, bottomConstant: 0, rightConstant: 0, widthConstant: 34, heightConstant: 18).first
        myPageConstraint = myPageView.anchor(self.topAnchor, left: nil, bottom: nil, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 60, widthConstant: 46, heightConstant: 60).first
        myPageButtonLayer = myPageButton.anchor(myPageView.topAnchor, left: nil, bottom: nil, right: myPageView.rightAnchor, topConstant: 5, leftConstant: 0, bottomConstant: 0, rightConstant: 11, widthConstant: 24, heightConstant: 24).first
        myPageButtonLabelConstratint = myPageButtonLabel.anchor(myPageButton.bottomAnchor, left: nil, bottom: nil, right: myPageView.rightAnchor, topConstant: 2, leftConstant: 0, bottomConstant: 0, rightConstant: 5, widthConstant: 36, heightConstant: 18).first
        dividerLineConstraint = dividerLine.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0.5).first
    }
    
    @objc fileprivate func goHome() {
        maincontroller?.scrollToMenuIndex(menuIndex: 0)
        homeButton.image = UIImage(named: "home_pink")
        homeButtonLabel.textColor = UIColor.mainColor
        myPageButton.image = UIImage(named: "profile_gray")
        myPageButtonLabel.textColor = UIColor.mainGray
        
        maincontroller?.goTopCollectionView(index: 0)
        maincontroller?.goUpDownSearchBar(index: 0)
    }
    
    
    @objc fileprivate func goMyPage() {
        maincontroller?.scrollToMenuIndex(menuIndex: 1)
        myPageButton.image = UIImage(named: "profile_pink")
        myPageButtonLabel.textColor = UIColor.mainColor
        homeButtonLabel.textColor = .mainGray
        homeButton.image = UIImage(named: "home_gray")
        
        maincontroller?.goTopCollectionView(index: 1)
        maincontroller?.goUpDownSearchBar(index: 1)
    }
    
    
}

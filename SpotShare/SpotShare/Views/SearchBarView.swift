//
//  SearchBarView.swift
//  SpotShare
//
//  Created by 김희중 on 07/09/2019.
//  Copyright © 2019 김희중. All rights reserved.
//

import UIKit

class searchBar: UIView {
    
    weak var maincontroller: MainController?
    weak var magazinecontroller: MagazineController?
    
    lazy var searchView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.rgb(red: 228, green: 228, blue: 228).cgColor
        view.layer.masksToBounds = true
        view.isUserInteractionEnabled = true
        return view
    }()
    
    let searchImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "searchLine")
        return iv
    }()
    
    let searchText: UILabel = {
        let lb = UILabel()
//        lb.text = "Search for anything"
        lb.textColor = .gray
        lb.font = UIFont(name: "DMSans-Regular", size: 14)
        lb.textAlignment = .left
        return lb
    }()
    
    let micImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "mic")
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
    
    var searchViewConstraint: NSLayoutConstraint?
    var searchImageViewConstraint: NSLayoutConstraint?
    var searchTextConstraint: NSLayoutConstraint?
    var micImageViewConstraint: NSLayoutConstraint?
    
    fileprivate func setupViews() {
        
        searchView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openSearchView)))
        
        addSubview(searchView)
        addSubview(searchImageView)
        addSubview(searchText)
        addSubview(micImageView)
        
        searchViewConstraint = searchView.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 16, leftConstant: 24, bottomConstant: 0, rightConstant: 64, widthConstant: 0, heightConstant: 48).first
        searchImageViewConstraint = searchImageView.anchor(searchView.topAnchor, left: searchView.leftAnchor, bottom: nil, right: nil, topConstant: 12, leftConstant: 13, bottomConstant: 0, rightConstant: 0, widthConstant: 24, heightConstant: 24).first
        searchTextConstraint = searchText.anchor(searchView.topAnchor, left: searchImageView.rightAnchor, bottom: nil, right: searchView.rightAnchor, topConstant: 14, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 20).first
        micImageViewConstraint = micImageView.anchor(self.topAnchor, left: searchView.rightAnchor, bottom: nil, right: self.rightAnchor, topConstant: 28, leftConstant: 16, bottomConstant: 0, rightConstant: 24, widthConstant: 24, heightConstant: 24).first
    }
    
    @objc func openSearchView() {
        maincontroller?.OpenSearchBar()
    }
}

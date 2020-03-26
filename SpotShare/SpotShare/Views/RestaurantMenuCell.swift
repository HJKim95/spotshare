//
//  RestaurantMenuCell.swift
//  SpotShare
//
//  Created by 김희중 on 2020/03/22.
//  Copyright © 2020 김희중. All rights reserved.
//

import UIKit

class RestaurantMenuCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupLayouts() {
        backgroundColor = .lightGreen
    }
}

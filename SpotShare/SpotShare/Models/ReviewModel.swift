//
//  ReviewModel.swift
//  SpotShare
//
//  Created by 김희중 on 2020/03/30.
//  Copyright © 2020 김희중. All rights reserved.
//

import UIKit
import GoogleMaps

@objcMembers
class ReviewModel: NSObject {
    var reviewId: String?
    var reviewName: String?
    var starPoint: Double?
    var reviewProfUrl: String?
    var reviewImageUrl: String?
    var reviewResName : String?
    var reviewText: String?
    var reviewTime: NSNumber?

}

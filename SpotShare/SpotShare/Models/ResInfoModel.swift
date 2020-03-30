//
//  ResInfoModel.swift
//  SpotShare
//
//  Created by 김희중 on 2020/03/05.
//  Copyright © 2020 김희중. All rights reserved.
//

import UIKit
import GoogleMaps

@objcMembers
class ResInfoModel: NSObject {
    var resImageUrl: String?
    var resName: String?
    var starPoint: Double?
    var locationText: String?
    var resLocation: CLLocationCoordinate2D?
    var toilet : String?
    var hourText: String?
    var tele: String?
    var teleText: String?
    var menuText: String?
    var priceText: String?
    var holidayText: String?
    var reservation: String?
    var distance: Double?
    
    var open: String?
    var close: String?
    var breakStart: String?
    var breakFinish: String?
    
    
    var hash1: String?
    var hash2: String?
    var hash3: String?
    var hash4: String?
    var hash5: String?
}

//
//  Extensions.swift
//  SpotShare
//
//  Created by 김희중 on 29/04/2019.
//  Copyright © 2019 김희중. All rights reserved.
//

import UIKit
import GoogleMaps

// icon 색상 바꾸기
// https://icons8.com/articles/how-to-recolor-a-raster-icon-in-photoshop/

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    @nonobjc class var apricot: UIColor {
        return UIColor(red: 1.0, green: 190.0 / 255.0, blue: 115.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var pink: UIColor {
        return UIColor(red: 1.0, green: 216.0 / 255.0, blue: 212.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var wheat: UIColor {
        return UIColor(red: 1.0, green: 220.0 / 255.0, blue: 127.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var lightGreen: UIColor {
        return UIColor(red: 219.0 / 255.0, green: 236.0 / 255.0, blue: 192.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var mainGray: UIColor {
        return UIColor(white: 153.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var mainColor: UIColor {
        return UIColor(red: 246.0 / 255.0, green: 166.0 / 255.0, blue: 158.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var mainText: UIColor {
        return UIColor(red: 68.0 / 255.0, green: 68.0 / 255.0, blue: 68.0 / 255.0, alpha: 1.0)
    }

}

extension UILabel {
    func letterSpacing(text: String, spacing: Double) {
        // letter spacing -> spacing
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(spacing), range: NSRange(location: 0, length: attributedString.length))
        self.attributedText = attributedString
    }
}

extension UIView {
    
    func anchor(_ top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, topConstant: CGFloat = 0, leftConstant: CGFloat = 0, bottomConstant: CGFloat = 0, rightConstant: CGFloat = 0, widthConstant: CGFloat = 0, heightConstant: CGFloat = 0) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        
        var anchors = [NSLayoutConstraint]()
        
        if let top = top {
            anchors.append(topAnchor.constraint(equalTo: top, constant: topConstant))
        }
        
        if let left = left {
            anchors.append(leftAnchor.constraint(equalTo: left, constant: leftConstant))
        }
        
        if let bottom = bottom {
            anchors.append(bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant))
        }
        
        if let right = right {
            anchors.append(rightAnchor.constraint(equalTo: right, constant: -rightConstant))
        }
        
        if widthConstant > 0 {
            anchors.append(widthAnchor.constraint(equalToConstant: widthConstant))
        }
        
        if heightConstant > 0 {
            anchors.append(heightAnchor.constraint(equalToConstant: heightConstant))
        }
        
        anchors.forEach({$0.isActive = true})
        
        return anchors
    }
    
    func setGradientBackgroundVertical(gradientLayer: CAGradientLayer ,colorOne: UIColor, colorTwo: UIColor) {
        
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        
        // startpoit y=0은 바닥
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        // startpoit y=1은 맨위
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        
        layer.insertSublayer(gradientLayer, at: 0)
        
    }
    
    func setGradientBackgroundHorizontal(gradientLayer: CAGradientLayer ,colorOne: UIColor, colorTwo: UIColor) {
        
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        
        // startpoit x=0은 왼쪽
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        // startpoit x=1은 오른쪽
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        layer.insertSublayer(gradientLayer, at: 0)
        
    }

}

extension String {
    func convertName() -> String {
        switch self {
        case "맛집": return "Restaurant"
        case "카페": return "Cafe"
        case "피자,버거": return "Pizza"
        case "치킨": return "Chicken"
        case "분식": return "FastFood"
        case "술집": return "Pub"
        case "베이커리": return "Bakery"
        case "기타": return "Others"
        default: return ""
        }
    }
    
    func convertDate() -> String {
        switch self {
        case "Monday","월요일": return "월"
        case "Tuesday","화요일": return "화"
        case "Wednesday","수요일": return "수"
        case "Thursday","목요일": return "목"
        case "Friday", "금요일": return "금"
        case "Saturday", "토요일": return "토"
        case "Sunday", "일요일": return "일"
        default: return ""
        }
    }
}

extension CLLocationCoordinate2D {
    //distance in meters, as explained in CLLoactionDistance definition
    func distance(from: CLLocationCoordinate2D) -> String {
        let destination = CLLocation(latitude:from.latitude,longitude:from.longitude)
        let distance = CLLocation(latitude: latitude, longitude: longitude).distance(from: destination).rounded()
        var distanceString = ""
        if distance < 1000 {
            distanceString = String(format: "%.0f", distance) + "m"
        }
        else {
            let kmDistance = distance / 1000
            distanceString = String(format: "%.0f", kmDistance) + "km"
        }
        return distanceString
    }
}

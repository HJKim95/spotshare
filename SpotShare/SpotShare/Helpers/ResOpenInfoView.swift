//
//  ResOpenInfoView.swift
//  SpotShare
//
//  Created by 김희중 on 2020/03/30.
//  Copyright © 2020 김희중. All rights reserved.
//

import UIKit

class ResOpenInfoView: UIView {

    var color:UIColor = .white

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {

        let rounding:CGFloat = rect.width * 0.04
        let angleRounding:CGFloat = rect.width * 0.02

        //Draw the main frame

        let bubbleFrame = CGRect(x: 0, y: rect.height * 1 / 7, width: rect.width, height: rect.height * 6 / 7)
        let bubblePath = UIBezierPath(roundedRect: bubbleFrame, byRoundingCorners: UIRectCorner.allCorners, cornerRadii: CGSize(width: rounding, height: rounding))

        //Color the bubbleFrame

        color.setStroke()
        color.setFill()
        bubblePath.stroke()
        bubblePath.fill()
        
        guard let context = UIGraphicsGetCurrentContext() else {return}
        
        
        //Start the line

        context.beginPath()
        context.move(to: CGPoint(x: bubbleFrame.minX + bubbleFrame.width * 1/5, y: bubbleFrame.minY))

        //Draw a rounded point
        
        context.addArc(tangent1End: CGPoint(x: bubbleFrame.width * 3/10, y: rect.minY), tangent2End: CGPoint(x: bubbleFrame.maxX, y: bubbleFrame.maxY), radius: angleRounding)

        //Close the line

        context.addLine(to: CGPoint(x: bubbleFrame.minX + bubbleFrame.width * 2/5, y: bubbleFrame.maxY))
        context.closePath()

        //fill the color

        context.fillPath()
        
        
    }

}



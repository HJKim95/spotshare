//
//  magazineAnimator.swift
//  FLOG
//
//  Created by 김희중 on 2018. 4. 24..
//  Copyright © 2018년 flog. All rights reserved.
//

import UIKit


class ReviewTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private var originFrame: CGRect
    var duration : TimeInterval
    var isPresenting : Bool
    var image : UIImage
    var height: CGFloat
    var imageSize: CGSize
    var textHeight: CGFloat
    
    
    init(duration : TimeInterval, isPresenting : Bool, originFrame : CGRect, image : UIImage, height: CGFloat, imageSize: CGSize, textHeight: CGFloat) {
        self.duration = duration
        self.isPresenting = isPresenting
        self.originFrame = originFrame
        self.image = image
        self.height = height
        self.imageSize = imageSize
        self.textHeight = textHeight
    }
    
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        
        guard let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) else { return }
        guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else { return }
        
        self.isPresenting ? container.addSubview(toView) : container.insertSubview(toView, belowSubview: fromView)
        
        let detailView = isPresenting ? toView : fromView
        
        let sizeRatio = imageSize.height / imageSize.width
        let sizeHeight = sizeRatio * (toView.frame.width - 48)
        // 67 + 28 + 6 + 16 + 17 + textHeight + 16 = 150 + textHeight + statusHeight + 1(밑에 originFrame처럼 statusHeight와 오차)
        let frame = CGRect(x: 24, y: 150 + textHeight + height + 1, width: toView.frame.width - 48, height: sizeHeight)
        // 눌렀을때 해당 imageview의 frame
        // originFrame에서의 y값에는 statusHeight(height)가 포함 안되어있어서 추가해주어야 제대로 된 y값을 구할수있다. + 6은 약간의 오차 때문에 추가한 것.
        let transitionImageView = UIImageView(frame: isPresenting ? CGRect(x: originFrame.origin.x, y: 6 + height + originFrame.origin.y, width: originFrame.size.width, height: sizeRatio * originFrame.size.width) : frame)
        transitionImageView.image = image
        transitionImageView.layer.cornerRadius = 10
        transitionImageView.layer.masksToBounds = true
//
        container.addSubview(transitionImageView)
        
        toView.frame = isPresenting ?  CGRect(x: fromView.frame.width, y: 0, width: toView.frame.width, height: toView.frame.height) : toView.frame
        toView.alpha = isPresenting ? 0 : 1
        toView.layoutIfNeeded()
        
        UIView.animate(withDuration: duration, animations: {
            transitionImageView.frame = self.isPresenting ? frame : CGRect(x: self.originFrame.origin.x, y: 6 + self.height + self.originFrame.origin.y, width: self.originFrame.size.width, height: sizeRatio * self.originFrame.size.width)
            detailView.frame = self.isPresenting ? fromView.frame : CGRect(x: toView.frame.width, y: 0, width: toView.frame.width, height: toView.frame.height)
            detailView.alpha = self.isPresenting ? 1 : 0
        }, completion: { (finished) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            transitionImageView.removeFromSuperview()
        })
    }
    
}


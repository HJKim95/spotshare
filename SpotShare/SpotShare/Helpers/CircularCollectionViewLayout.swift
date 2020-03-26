//
//  CircularCollectionViewLayout.swift
//  SpotShare
//
//  Created by 김희중 on 10/09/2019.
//  Copyright © 2019 김희중. All rights reserved.
//

import UIKit


class CircularCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
    // 1
    var anchorPoint = CGPoint(x: 0.5, y: 0.5)
    var angle: CGFloat = 0 {
        // 2
        didSet {
            zIndex = Int(angle * 1000000)
            transform = CGAffineTransform(rotationAngle: angle)
        }
    }
    // 3 override
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let copiedAttributes: CircularCollectionViewLayoutAttributes = super.copy(with: zone) as! CircularCollectionViewLayoutAttributes
        copiedAttributes.anchorPoint = self.anchorPoint
        copiedAttributes.angle = self.angle
        return copiedAttributes
    }
    
}

class CircularCollectionViewLayout: UICollectionViewLayout {
    
    fileprivate var checkFirst: Bool = false
    
    let itemSize = CGSize(width: 100, height: 100 + 120)
    let offSetAngle = CGFloat.pi / 5
    
    var angleAtExtreme: CGFloat {
        return collectionView!.numberOfItems(inSection: 0) > 0 ?
            -CGFloat(collectionView!.numberOfItems(inSection: 0) - 1) * anglePerItem + 2 * offSetAngle : 0
    }
    var angle: CGFloat {
        return angleAtExtreme * collectionView!.contentOffset.x / (collectionViewContentSize.width -
            collectionView!.bounds.width) - offSetAngle
    }
    
    //radius 크기가 작을수록 cell 사이 간격 더 벌어짐
    var radius: CGFloat = 250 {
        didSet {
            invalidateLayout()
        }
    }
    
    var anglePerItem: CGFloat {
        return atan(itemSize.width / radius)
    }
    
    var attributesList = [CircularCollectionViewLayoutAttributes]()
    
    
    override var collectionViewContentSize: CGSize {
        let collection = collectionView!
        let width = CGFloat(collection.numberOfItems(inSection: 0)) * itemSize.width
        let height = collectionView!.bounds.height
        
        return CGSize(width: width, height: height)
    }
    
    class func layoutAttributesClass() -> AnyClass {
        return CircularCollectionViewLayoutAttributes.self
    }
    
    override func prepare() {
        super.prepare()
        
        let centerX = collectionView!.contentOffset.x + (collectionView!.bounds.width / 2.0)
        let anchorPointY = ((itemSize.height / 2.0) + radius) / itemSize.height
        
        let theta = atan2(collectionView!.bounds.width / 2.0,
                          radius + (itemSize.height / 2.0) - (collectionView!.bounds.height / 2.0))
        // 2
        var startIndex = 0
        var endIndex = collectionView!.numberOfItems(inSection: 0) - 1
        // 3
        if (angle < -theta) {
            startIndex = Int(floor((-theta - angle) / anglePerItem))
        }
        // 4
        endIndex = min(endIndex, Int(ceil((theta - angle) / anglePerItem)))
        // 5
        if (endIndex < startIndex) {
            endIndex = 0
            startIndex = 0
        }
        
        attributesList = (startIndex...endIndex).map { (i)
            -> CircularCollectionViewLayoutAttributes in
            // 1
            let attributes = CircularCollectionViewLayoutAttributes(forCellWith: IndexPath(item: i, section: 0))
            
            attributes.size = self.itemSize
            // 2
            attributes.center = CGPoint(x: centerX, y: self.collectionView!.bounds.midY)
            // 3
            attributes.angle = self.angle + (self.anglePerItem * CGFloat(i))
            
            attributes.anchorPoint = CGPoint(x: 0.5, y: anchorPointY)
            return attributes
        }
        
        customContentOffset()
        
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        return attributesList
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return attributesList[indexPath.row]
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    

    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        var finalContentOffset = proposedContentOffset
        let factor = -angleAtExtreme/(collectionViewContentSize.width - collectionView!.bounds.width)
        let proposedAngle = proposedContentOffset.x*factor
        let ratio = proposedAngle/anglePerItem
        var multiplier: CGFloat
        if (velocity.x > 0) {
            multiplier = ceil(ratio)
            finalContentOffset.x = multiplier*anglePerItem/factor
        } else if (velocity.x < 0) {
            multiplier = floor(ratio)
            finalContentOffset.x = multiplier*anglePerItem/factor
        } else {
            multiplier = round(ratio)
            finalContentOffset.x = multiplier*anglePerItem/factor
        }
        return finalContentOffset
    }
    
    fileprivate func customContentOffset() {
        if checkFirst == false {
            let factor = -self.angleAtExtreme/(self.collectionViewContentSize.width - self.collectionView!.bounds.width)
            let angle = self.anglePerItem/factor
            collectionView?.contentOffset = CGPoint(x: -5 * angle, y: 0.0)
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveLinear, animations: {
                self.collectionView?.setContentOffset(.zero, animated: true)
            }) { (Bool) in
                self.checkFirst = true
            }
            
        }
    }
}


//
//  PinterestLayout.swift
//  ChefNote
//
//  Created by Jason Cheng on 9/30/15.
//  Copyright © 2015 Jason. All rights reserved.
//

import UIKit

protocol PinterestLayoutDelegate {

    func collectionView(collectionView:UICollectionView, heightForItemAtIndexPath indexPath:NSIndexPath) -> CGFloat
    
}


class PinterestLayout: UICollectionViewLayout {
    // 1
    var delegate: PinterestLayoutDelegate!
    
    // 2
    var numberOfColumns = 2
    var cellPadding: CGFloat = 6.0
    
    // 3
    private var allItemAttributes = [UICollectionViewLayoutAttributes]()
    
    // 4
    private var contentHeight: CGFloat  = 0.0
    private var contentWidth: CGFloat {
        let insets = collectionView!.contentInset
        return CGRectGetWidth(collectionView!.bounds) - (insets.left + insets.right)
    }
    
    // perform up-front calculations needed to provide layout information
    // called when collectionView.reloadData() is called
    override func prepareLayout() {
        super.prepareLayout()
        
        // Remove attributes just in case more items are added and numbers need to be
        // recacuated
        allItemAttributes.removeAll()

            // 2
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset = [CGFloat]()
        for column in 0 ..< numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth )
        }
        var column = 0
        var yOffset = [CGFloat](count: numberOfColumns, repeatedValue: 0)
        
        // 3
        for item in 0 ..< collectionView!.numberOfItemsInSection(0) {
            
            let indexPath = NSIndexPath(forItem: item, inSection: 0)
            
            // 4
            let width = columnWidth - cellPadding * 2

            
//          let height = cellPadding +  photoHeight + annotationHeight + cellPadding
            let height = delegate.collectionView(collectionView!, heightForItemAtIndexPath: indexPath)
            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
            let insetFrame = CGRectInset(frame, cellPadding, cellPadding)
            
            // 5
            let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
            attributes.frame = insetFrame
            allItemAttributes.append(attributes)
            
            // 6
            contentHeight = max(contentHeight, CGRectGetMaxY(frame))
            yOffset[column] = yOffset[column] + height
            
            column = column >= (numberOfColumns - 1) ? 0 : ++column
        }
    }
    
    // Overall size of the entire content area
    override func collectionViewContentSize() -> CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    // Return attributs for cells and views that are in the specified rectangle
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attributes  in allItemAttributes {
            if CGRectIntersectsRect(attributes.frame, rect) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
    
}

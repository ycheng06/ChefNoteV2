//
//  PinterestLayout.swift
//  ChefNote
//
//  Created by Jason Cheng on 9/30/15.
//  Copyright © 2015 Jason. All rights reserved.
//

import UIKit

public protocol PinterestLayoutDelegate {

    func collectionView(collectionView:UICollectionView, heightForItemAtIndexPath indexPath:NSIndexPath) -> CGFloat
    func collectionView(collectionView:UICollectionView, heightForHeaderInSection section:Int) -> Float
    func collectionView(collectionView:UICollectionView, insetForHeaderInSection section:Int) -> UIEdgeInsets
}


public class PinterestLayout: UICollectionViewLayout {
    public var delegate: PinterestLayoutDelegate!
    public var headerInsets: UIEdgeInsets?
    
    private var numberOfColumns = 2
    private var cellPadding: CGFloat = 6.0
    private var allItemAttributes = [UICollectionViewLayoutAttributes]()
    private var contentHeight: CGFloat  = 0.0
    private var contentWidth: CGFloat {
        let insets = collectionView!.contentInset
        return CGRectGetWidth(collectionView!.bounds) - (insets.left + insets.right)
    }
    
    // perform up-front calculations needed to provide layout information
    // called when collectionView.reloadData() is called
    override public func prepareLayout() {
        super.prepareLayout()
        
        // Remove attributes just in case more items are added and numbers need to be
        // recacuated
        allItemAttributes.removeAll()

        // Basic calculations / settings
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset = [CGFloat]()
        for column in 0 ..< numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth )
        }
        var column = 0
        var yOffset = [CGFloat](count: numberOfColumns, repeatedValue: 0)
        
        // Header
        
        
        
        // Items
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
    override public func collectionViewContentSize() -> CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    // Return attributs for cells and views that are in the specified rectangle
    override public func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attributes  in allItemAttributes {
            if CGRectIntersectsRect(attributes.frame, rect) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
    
}

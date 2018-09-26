//
//  UICollectionView.swift
//  Extended
//
//  Created by Amir Shayegh on 2018-09-26.
//

import Foundation

extension UICollectionView {

    public var centerPoint : CGPoint {
        get {
            return CGPoint(x: self.center.x + self.contentOffset.x, y: self.center.y + self.contentOffset.y);
        }
    }

    public var centerCellIndexPath: IndexPath? {
        if let centerIndexPath = self.indexPathForItem(at: self.centerPoint) {
            return centerIndexPath
        }
        return nil
    }
}

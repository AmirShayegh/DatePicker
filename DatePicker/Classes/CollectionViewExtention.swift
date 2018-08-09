//
//  CollectionViewExtention.swift
//  FreshDate
//
//  Created by Amir Shayegh on 2018-08-06.
//
import Foundation

extension UICollectionView {

    var centerPoint : CGPoint {
        get {
            return CGPoint(x: self.center.x + self.contentOffset.x, y: self.center.y + self.contentOffset.y);
        }
    }

    var centerCellIndexPath: IndexPath? {
        if let centerIndexPath = self.indexPathForItem(at: self.centerPoint) {
            return centerIndexPath
        }
        return nil
    }
}

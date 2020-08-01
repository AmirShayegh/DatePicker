//
//  UIScrollView.swift
//  Extended
//
//  Created by Skyler Smith on 2018-11-09.
//

import UIKit

extension UIScrollView {
    public var isScrolledToBottom: Bool {
        return isScrolledWithin(distanceFromBottom: 0)
    }
    
    public var isScrolledToTop: Bool {
        return contentOffset.y <= 0
    }
    
    public var isScrolledToLeftSide: Bool {
        return contentOffset.x <= 0
    }
    
    public var isScrolledToRightSide: Bool {
        return isScrolledWithin(distanceFromRight: 0)
    }
    
    public var maxVerticalScrollOffset: CGFloat {
        return max(contentSize.height - frame.size.height, 0)
    }
    
    public var maxHorizontalScrollOffset: CGFloat {
        return max(contentSize.width - frame.size.width, 0)
    }
    
    public func isScrolledWithin(distanceFromBottom distance: CGFloat) -> Bool {
        return contentOffset.y >= maxVerticalScrollOffset - distance
    }
    
    public func isScrolledWithin(distanceFromRight distance: CGFloat) -> Bool {
        return contentOffset.x >= maxHorizontalScrollOffset - distance
    }
}

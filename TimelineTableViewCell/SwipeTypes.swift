//
//  SwipeTypes.swift
//  TimelineTableViewCell
//
//  Created by mby on 2020/3/27.
//  Copyright © 2020 Zheng-Xiang Ke. All rights reserved.
//

import Foundation

let kSwipeableCellActionDefaultWidth: CGFloat = 90
let kSwipeableCellActionDefaultIconWidth: CGFloat = 45
let kSwipeableCellActionDefaultVerticalSpace: CGFloat = 6

public struct SwipeableCellAction {
    public var title: NSAttributedString?
    public var image: UIImage?
    public var backgroundColor: UIColor?
    public var action: () -> ()
    public var width: CGFloat = kSwipeableCellActionDefaultWidth
    public var iconWidth: CGFloat = kSwipeableCellActionDefaultIconWidth
    public var verticalSpace: CGFloat = kSwipeableCellActionDefaultVerticalSpace

    public init(title: NSAttributedString?, image: UIImage?, backgroundColor: UIColor, action: @escaping () -> ()) {
        self.title = title
        self.image = image
        self.backgroundColor = backgroundColor
        self.action = action
    }
}

let kAccessoryTrailingSpace: CGFloat = 15
let kSectionIndexWidth: CGFloat = 15
let kTableViewPanState = "state"

public enum SwipeableCellState {
    case closed
    case swiped
}

public protocol SwipeableTableViewCellDelegate: class {
    func swipeableCell(_ cell: TimelineTableViewCell, isScrollingToState state: SwipeableCellState)
    func swipeableCellSwipeEnabled(_ cell: TimelineTableViewCell) -> Bool
    func allowMultipleCellsSwipedSimultaneously() -> Bool
    func swipeableCellDidEndScroll(_ cell: TimelineTableViewCell)
}

public extension SwipeableTableViewCellDelegate {
    func swipeableCell(_ cell: TimelineTableViewCell, isScrollingToState state: SwipeableCellState) {

    }

    func swipeableCellSwipeEnabled(_ cell: TimelineTableViewCell) -> Bool {
        return true
    }

    func allowMultipleCellsSwipedSimultaneously() -> Bool {
        return false
    }

    func swipeableCellDidEndScroll(_ cell: TimelineTableViewCell) {

    }
}

public class SwipeableCellScrollView: UIScrollView {
    override public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == panGestureRecognizer {
            let gesture = gestureRecognizer as! UIPanGestureRecognizer
            let translation = gesture.translation(in: gesture.view)
            return abs(translation.y) <= abs(translation.x)
        }
        return true
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UIPanGestureRecognizer {
            let gesture = gestureRecognizer as! UIPanGestureRecognizer
            let yVelocity = gesture.velocity(in: gesture.view).y
            return abs(yVelocity) <= 0.25
        }
        return true
    }
}

public extension UITableView {
    func hideAllSwipeableCellsActions(animated: Bool) {
        for cell in visibleCells {
            if let cell = cell as? TimelineTableViewCell {
                cell.hideActions(animated: animated)
            }
        }
    }

    func hasSwipedCells() -> Bool {
        for cell in visibleCells {
            if let cell = cell as? TimelineTableViewCell {
                if cell.state == .swiped {
                    return true
                }
            }
        }
        return false
    }
}

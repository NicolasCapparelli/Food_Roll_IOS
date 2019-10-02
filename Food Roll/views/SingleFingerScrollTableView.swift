import Foundation
import UIKit

// Solution to single scroll: https://stackoverflow.com/a/40071412/5266445
class SingleFingerScrollTableView : UITableView {
    override init(frame: CGRect, style: Style) {
        super.init(frame: frame, style: style)
        self.backgroundColor = .clear
        self.translatesAutoresizingMaskIntoConstraints = false
        self.panGestureRecognizer.minimumNumberOfTouches = 1;
        self.panGestureRecognizer.maximumNumberOfTouches = 2;
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if (gestureRecognizer == self.panGestureRecognizer) {
            if (gestureRecognizer.numberOfTouches > 1) {
                return false;
            } else {
                return true;
            }
        } else {
            return true;
        }
    }
}
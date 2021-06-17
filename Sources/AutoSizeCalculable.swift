#if os(iOS) || os(tvOS)
import UIKit
#else
import AppKit
#endif

public protocol AutoSizeCalculable {
    func setAutoSizingRect(_ rect: CGRect, margins: PEdgeInsets)
    func autoSizeThatFits(_ size: CGSize, layoutClosure: () -> Void, filter: ((_ isInclude: UIView) -> Bool)?) -> CGSize
}

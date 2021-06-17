//  Copyright (c) 2018 Luc Dion
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import Foundation

#if os(iOS) || os(tvOS)
import UIKit

extension UIView: Layoutable, SizeCalculable {
    public typealias View = UIView

    public var pin: PinLayout<UIView> {
        return PinLayout(view: self, keepTransform: true)
    }

    public var pinFrame: PinLayout<UIView> {
        return PinLayout(view: self, keepTransform: false)
    }

    @objc public var pinObjc: PinLayoutObjC {
        return PinLayoutObjCImpl(view: self, keepTransform: true)
    }

    public func getRect(keepTransform: Bool) -> CGRect {
        guard !Pin.autoSizingInProgress || autoSizingRect == nil else { return autoSizingRect ?? CGRect.zero }

        if keepTransform {
            /*
             To adjust the view's position and size, we don't set the UIView's frame directly, because we want to keep the
             view's transform (UIView.transform).
             By setting the view's center and bounds we really set the frame of the non-transformed view, and this keep
             the view's transform. So view's transforms won't be affected/altered by PinLayout.
             */
            let size = bounds.size
            // See setRect(...) for details about this calculation.
            let origin = CGPoint(x: center.x - (size.width * layer.anchorPoint.x),
                                 y: center.y - (size.height * layer.anchorPoint.y))

            return CGRect(origin: origin, size: size)
        } else {
            return frame
        }
    }

    public func setRect(_ rect: CGRect, keepTransform: Bool) {
        let adjustedRect = Coordinates<View>.adjustRectToDisplayScale(rect)

        if keepTransform {
            /*
             To adjust the view's position and size, we don't set the UIView's frame directly, because we want to keep the
             view's transform (UIView.transform).
             By setting the view's center and bounds we really set the frame of the non-transformed view, and this keep
             the view's transform. So view's transforms won't be affected/altered by PinLayout.
             */

            // NOTE: The center is offset by the layer.anchorPoint, so we have to take it into account.
            center = CGPoint(x: adjustedRect.origin.x + (adjustedRect.width * layer.anchorPoint.x),
                             y: adjustedRect.origin.y + (adjustedRect.height * layer.anchorPoint.y))
            // NOTE: We must set only the bounds's size and keep the origin.
            bounds.size = adjustedRect.size
        } else {
            frame = adjustedRect
        }
    }

    public func isLTR() -> Bool {
        switch Pin.layoutDirection {
        case .auto:
            if #available(iOS 10.0, tvOS 10.0, *) {
                return effectiveUserInterfaceLayoutDirection == .leftToRight
            } else if #available(iOS 9.0, *) {
                return UIView.userInterfaceLayoutDirection(for: semanticContentAttribute) == .leftToRight
            } else if let shared = UIApplication.value(forKey: "sharedApplication") as? UIApplication {
                return shared.userInterfaceLayoutDirection == .leftToRight
            } else {
                return true
            }
        case .ltr: return true
        case .rtl: return false
        }
    }
}

extension UIView: AutoSizeCalculable {
    private struct pinlayoutAssociatedKeys {
        static var pinlayoutAutoSizingRect = UnsafeMutablePointer<Int8>.allocate(capacity: 1)
        static var pinlayoutAutoSizingRectWithMargins = UnsafeMutablePointer<Int8>.allocate(capacity: 1)
    }

    private var autoSizingRect: CGRect? {
        get {
            return objc_getAssociatedObject(self, &pinlayoutAssociatedKeys.pinlayoutAutoSizingRect) as? CGRect
        }
        set {
            objc_setAssociatedObject(self, &pinlayoutAssociatedKeys.pinlayoutAutoSizingRect, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    private var autoSizingRectWithMargins: CGRect? {
        get {
            return objc_getAssociatedObject(self, &pinlayoutAssociatedKeys.pinlayoutAutoSizingRectWithMargins) as? CGRect
        }
        set {
            objc_setAssociatedObject(self, &pinlayoutAssociatedKeys.pinlayoutAutoSizingRectWithMargins, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    public func setAutoSizingRect(_ rect: CGRect, margins: PEdgeInsets) {
        self.autoSizingRect = Coordinates<View>.adjustRectToDisplayScale(rect)
        self.autoSizingRectWithMargins = Coordinates<View>.adjustRectToDisplayScale(rect.inset(by: margins))
    }

    public func autoSizeThatFits(_ size: CGSize, layoutClosure: () -> Void, filter: ((_ isInclude: UIView) -> Bool)? = nil) -> CGSize {
        let isAlreadyAutoSizing = Pin.autoSizingInProgress

        if (!isAlreadyAutoSizing) {
            Pin.autoSizingInProgress = true
        }

        autoSizingRect = CGRect(origin: CGPoint.zero, size: size)

        layoutClosure()
        
        var subviews = subviews
        if let filter = filter {
            subviews = subviews.filter(filter)
        }
        let boundingRect = subviews.compactMap({ $0.autoSizingRectWithMargins }).reduce(CGRect.zero) { (result: CGRect, autoSizingRect: CGRect) -> CGRect in
            return result.union(autoSizingRect)
        }

        if !isAlreadyAutoSizing {
            Pin.autoSizingInProgress = false
        }

        return boundingRect.size
    }
}

#endif

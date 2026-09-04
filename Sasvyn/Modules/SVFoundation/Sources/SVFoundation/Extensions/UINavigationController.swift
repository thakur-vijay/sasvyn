//
//  File.swift
//  SVFoundation
//
//  Created by Vijay Thakur on 04/09/26.
//

import UIKit

extension UINavigationController {
    open override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
}

extension UINavigationController: @retroactive UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(
        _ gestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        viewControllers.count > 1
    }
}

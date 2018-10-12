//
//  PTDetailViewController.swift
//
// Copyright (c)  21/12/15. Ramotion Inc. (http://ramotion.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit

/// Base UIViewController for preview transition
open class PTDetailViewController: UIViewController {

    var bgImage: UIImage?
    var titleText: String?

    var useCustomTransition = false
    fileprivate var backgroundImageView: UIImageView?

    open override func viewDidLoad() {
        super.viewDidLoad()
        
        if let titleText = self.titleText {
            title = titleText
        }

        // hack
        if let navigationController = self.navigationController {
            for case let label as UILabel in navigationController.view.subviews {
                label.isHidden = true
            }
        }
    }

    /**
     Pops the top view controller from the navigation stack and updates the display with custom animation.
     */
    @objc public func popViewController() {
        guard useCustomTransition else {
            _ = navigationController?.popViewController(animated: true)
            return
        }
        
        if let navigationController = self.navigationController {
            for case let label as UILabel in navigationController.view.subviews {
                label.isHidden = false
            }
        }
        _ = navigationController?.popViewController(animated: false)
    }
}

//
//  DemoDetailViewController.swift
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

public class DemoDetailViewController: PTDetailViewController {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var topBarViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bgImageView: UIImageView!
    
    // bottom control icons
    @IBOutlet var controlView: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var bottomBarBottomConstraint: NSLayoutConstraint!
    
    @IBAction func closeButton(_ sender: Any) {
        popViewController()
    }

    var event: TCJsonEvent?
    
    var isFullScreened = false {
        didSet {
            if isFullScreened {
                topBarViewTopConstraint.constant = -topBarView.frame.maxY
                bottomBarBottomConstraint.constant = controlView.frame.height
            } else {
                topBarViewTopConstraint.constant = 0
                bottomBarBottomConstraint.constant = 0
            }
            
            UIView.animate(withDuration: 0.3) {
                self.topBarView.superview?.layoutIfNeeded()
                self.topBarView.alpha = self.isFullScreened ? 0 : 1
                
                self.controlView.superview?.layoutIfNeeded()
                self.controlView.alpha = self.isFullScreened ? 0 : 1
            }
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
        bgImageView.addGestureRecognizer(tap)
        bgImageView.isUserInteractionEnabled = true
        
        // set up content
        // bgImageView.image = bgImage
        bgImageView.sdSetImage(withString: event?.images.first?.path)
        titleLabel.text = event?.title
        textView.text = event?.desc
    }
    
    @objc private func tapped(_ target: Any) {
        guard UIDevice.current.orientation.isPortrait else { return }
        isFullScreened = !isFullScreened
    }
}

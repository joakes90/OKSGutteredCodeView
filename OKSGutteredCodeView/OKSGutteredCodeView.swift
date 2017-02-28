//
//  OKSGutteredCodeView.swift
//  OKSGutteredCodeView
//
//  Created by Justin Oakes on 5/12/16.
//  Copyright © 2016 Oklasoft LLC. All rights reserved.
//

import UIKit

open class OKSGutteredCodeView: UIView, UITextViewDelegate, UIScrollViewDelegate {

    @IBOutlet weak var gutterView: UIScrollView!
    @IBOutlet weak var textView: UITextView!
    
    open weak var delegate: CodeViewDelegate?
    
    var view: UIView!
    
    //Properties set by users
    var font: UIFont?
    var fontColor: UIColor?
    
    // initalization
    fileprivate var numberOfLines = 1
    fileprivate var gutterSubViews: [UILabel] = []
    
    func xibSetUp() {
        view = loadFromXib()
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        addSubview(view)
    }
    
    func loadFromXib() -> UIView {
        let bundle: Bundle = Bundle(for: type(of: self))
        let xib: UINib = UINib(nibName: "OKSGutteredCodeView", bundle: bundle)
        let view: UIView = xib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        xibSetUp()
        self.addObserver(self, forKeyPath: "bounds", options: .initial, context: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.textViewDidChange(self.textView)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetUp()
        self.addObserver(self, forKeyPath: "bounds", options: .initial, context: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.textViewDidChange(self.textView)
    }
    
    //MARK: custimization methods
    
    @objc open func setGutterBackgroundColor(_ color: UIColor) {
        self.gutterView.backgroundColor = color
    }
    
    @objc open func setfont(_ font: UIFont) {
        self.font = font
        self.textView.font = font
    }
    
    @objc open func setText(_ text: String) {
        self.textView.text = text
    }
    
    @objc open func getText() -> String {
        return self.textView.text!
    }
    
    @objc open func getFont() -> UIFont? {
        return self.font
    }
    
    @objc open func addTextViewAccessoryView(_ toolbar: UIToolbar) {
        toolbar.sizeToFit()
        self.textView.inputAccessoryView = toolbar
    }
    
    @objc open func insertTextAtCurser(_ text: String) {
        self.textView.replace(self.textView.selectedTextRange!, withText: text)
    }
    
    @objc open func appendText(_ text: String) {
        self.textView.text = "\(self.textView.text)\(text)"
    }
    
    @objc open func setAttributedText(_ text: NSAttributedString) {
        let curserPosition: NSRange = self.textView.selectedRange
        self.textView.attributedText = text
        self.textView.selectedRange = curserPosition
    }
    
    @objc open func addFontColor(_ color: UIColor) {
        self.fontColor = color
        self.textView.textColor = color
    }
    
    @objc open func setTextViewBackgroundColor(_ color: UIColor) {
        self.textView.backgroundColor = color
    }
    
    //MARK: UITextView Delegate Methods
    
    @objc open func textViewDidChange(_ textView: UITextView) {
        for label in self.gutterSubViews {
            label.removeFromSuperview()
        }
        self.numberOfLines = self.countNumberOfLines()
        self.addNumberToGutter()
        self.delegate?.textUpdated(self.textView.text)
    }
    
    func keyboardWillShow(_ notification: Notification) {
        self.delegate?.keyboardWillAppear(notification)
    }
    
    func keyboardWillHide(_ notification: Notification) {
        self.delegate?.keyboardWillHide(notification)
    }
    
    //MARK: UIScrollView Delegate Mathods
    
    @objc open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffSet = self.textView.contentOffset.y
        self.gutterView.scrollRectToVisible(CGRect(x: 0, y: yOffSet, width: self.gutterView.frame.width, height: self.gutterView.frame.height), animated: false)
    }
    
    //MARK: sorting out number and location of lines
    
    func countNumberOfLines() -> Int {
        let text = self.textView.text
        let seperatedLines = text?.components(separatedBy: "\n")
        return seperatedLines!.count - 1
    }
    
    func addNumberToGutter() {
        let curserPosition = self.textView.caretRect(for: self.textView.selectedTextRange!.start).origin
        let text = self.textView.text
        let seperatedLines = text?.components(separatedBy: "\n")
        var numberInsertionPoint: CGFloat = 8
        self.gutterView.contentSize = self.gutterView.frame.size
        var counter: Int = 1
        for line in seperatedLines! {
            let label: UILabel = UILabel(frame: CGRect(x: 0, y: numberInsertionPoint, width: 35, height: self.textView.font!.lineHeight))
            label.font = self.font != nil ? self.font : UIFont(name: "Courier New", size: 17.0)
            label.textAlignment = .right
            label.text = "\(counter)"
            label.textColor = self.fontColor == nil ? UIColor.black : self.fontColor!
            self.gutterView.addSubview(label)
            self.gutterSubViews.append(label)
            counter += 1
            numberInsertionPoint = numberInsertionPoint + heightOfLine(line)
            if numberInsertionPoint > self.gutterView.contentSize.height {
                let contentHeight = self.gutterView.contentSize.height
                let contentWidth = self.gutterView.contentSize.width
                self.gutterView.contentSize = CGSize(width: contentWidth, height: contentHeight + heightOfLine(line))
            }
        }
        self.textView.scrollRectToVisible(CGRect(x: 0, y: curserPosition.y, width: self.textView.bounds.width, height: self.textView.bounds.height), animated: false)
        self.gutterView.scrollRectToVisible(CGRect(x: 0, y: curserPosition.y, width: self.textView.bounds.width, height: self.textView.bounds.height), animated: false)
    }
    
    func heightOfLine(_ line: String) -> CGFloat {
        let font: UIFont = self.textView.font!
        let textViewWidth: CGFloat = self.textView.frame.width
        let lineHeight = line.boundingRect(with: CGSize(width: textViewWidth, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName : font], context: nil).height
        return lineHeight
    }
    
    
    //MARK: KVO methods
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath != nil && keyPath == "bounds" && ((object as AnyObject).isEqual(self)) {
            perform(#selector(textViewDidChange), with: self.textView, afterDelay: 0.51)
        }
    }
    
}

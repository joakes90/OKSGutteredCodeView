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
    
    var delegate: CodeViewDelegate?
    
    //Properties set by users
    var viewFont: UIFont?
    var fontColor: UIColor?
    
    // initalization
    fileprivate var numberOfLines = 1
    fileprivate var gutterSubViews: [UILabel] = []
    
    func xibSetUp() {
        let xibView: UIView = loadFromXib()
        xibView.frame = bounds
        xibView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        addSubview(xibView)
    }
    
    func loadFromXib() -> UIView {
        let xib: UINib = UINib(nibName: "OKSGutteredCodeView", bundle: Bundle.main)
        let view: UIView = xib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetUp()
        addObserver(self, forKeyPath: "bounds", options: .initial, context: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        textViewDidChange(textView)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetUp()
        addObserver(self, forKeyPath: "bounds", options: .initial, context: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        textViewDidChange(textView)
    }
    
    //MARK: custimization methods
    
    @objc open func setGutterBackgroundColor(_ color: UIColor) {
        gutterView.backgroundColor = color
    }
    
    @objc open func setfont(_ font: UIFont) {
        viewFont = font
        textView.font = font
    }
    
    @objc open func setText(_ text: String) {
        textView.text = text
    }
    
    @objc open func getText() -> String {
        return textView.text
    }
    
    @objc open func getFont() -> UIFont? {
        return viewFont
    }
    
    @objc open func addTextViewAccessoryView(_ toolbar: UIToolbar) {
        toolbar.sizeToFit()
        textView.inputAccessoryView = toolbar
    }
    
    @objc open func insertTextAtCurser(_ text: String) {
        textView.replace(textView.selectedTextRange ?? UITextRange() , withText: text)
    }
    
    @objc open func appendText(_ text: String) {
        textView.text = "\(textView.text)\(text)"
    }
    
    @objc open func setAttributedText(_ text: NSAttributedString) {
        let curserPosition: NSRange = textView.selectedRange
        textView.attributedText = text
        textView.selectedRange = curserPosition
    }
    
    @objc open func addFontColor(_ color: UIColor) {
        fontColor = color
        textView.textColor = color
    }
    
    @objc open func setTextViewBackgroundColor(_ color: UIColor) {
        textView.backgroundColor = color
    }
    
    //MARK: UITextView Delegate Methods
    
    @objc open func textViewDidChange(_ textView: UITextView) {
        for label in gutterSubViews {
            label.removeFromSuperview()
        }
        numberOfLines = countNumberOfLines()
        addNumberToGutter()
        delegate?.textUpdated(textView.text)
    }
    
    func keyboardWillShow(_ notification: Notification) {
        delegate?.keyboardWillAppear(notification)
    }
    
    func keyboardWillHide(_ notification: Notification) {
        delegate?.keyboardWillHide(notification)
    }
    
    //MARK: UIScrollView Delegate Mathods
    
    @objc open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffSet = textView.contentOffset.y
        gutterView.scrollRectToVisible(CGRect(x: 0, y: yOffSet, width: gutterView.frame.width, height: gutterView.frame.height), animated: false)
    }
    
    //MARK: sorting out number and location of lines
    
    func countNumberOfLines() -> Int {
        let text = textView.text
        let seperatedLines = text?.components(separatedBy: "\n")
        let newLines = seperatedLines?.count ?? 0
        return newLines > 0 ? newLines - 1 : newLines
    }
    
    func addNumberToGutter() {
        let curserPosition = textView.caretRect(for: textView.selectedTextRange?.start ?? UITextRange().start).origin
        let text: String = textView.text
        let seperatedLines: [String] = text.components(separatedBy: "\n")
        var numberInsertionPoint: CGFloat = 8
        gutterView.contentSize = gutterView.frame.size
        var counter: Int = 1
        for line in seperatedLines {
            let label: UILabel = UILabel(frame: CGRect(x: 0, y: numberInsertionPoint, width: 35, height: (textView.font ?? UIFont.preferredFont(forTextStyle: .body)).lineHeight))
            label.font = viewFont ?? UIFont(name: "Courier New", size: 17.0)
            label.textAlignment = .right
            label.text = "\(counter)"
            label.textColor = fontColor ?? UIColor.black
            gutterView.addSubview(label)
            gutterSubViews.append(label)
            counter += 1
            numberInsertionPoint += heightOfLine(line)
            if numberInsertionPoint > gutterView.contentSize.height {
                let contentHeight = gutterView.contentSize.height
                let contentWidth = gutterView.contentSize.width
                gutterView.contentSize = CGSize(width: contentWidth, height: contentHeight + heightOfLine(line))
            }
        }
        textView.scrollRectToVisible(CGRect(x: 0, y: curserPosition.y, width: textView.bounds.width, height: textView.bounds.height), animated: false)
        gutterView.scrollRectToVisible(CGRect(x: 0, y: curserPosition.y, width: textView.bounds.width, height: textView.bounds.height), animated: false)
    }
    
    func heightOfLine(_ line: String) -> CGFloat {
        let font: UIFont = textView.font ?? UIFont.preferredFont(forTextStyle: .body)
        let textViewWidth: CGFloat = textView.bounds.width
        let lineHeight = line.boundingRect(with: CGSize(width: textViewWidth, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName : font], context: nil).height
        return lineHeight
    }
    
    
    //MARK: KVO methods
    
    // recalcualtes and redraws everything relavent to where text is positioned on the screen when the bounds of the view chnges
    // (rotation, splitview, priview window sliding over etc...)
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath != nil && keyPath == "bounds" && ((object as AnyObject).isEqual(self)) {
            perform(#selector(textViewDidChange), with: textView, afterDelay: 0.51)
        }
    }
    
}

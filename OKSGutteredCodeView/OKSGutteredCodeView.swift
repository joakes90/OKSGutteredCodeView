//
//  OKSGutteredCodeView.swift
//  OKSGutteredCodeView
//
//  Created by Justin Oakes on 5/12/16.
//  Copyright © 2016 Oklasoft LLC. All rights reserved.
//

import UIKit

public class OKSGutteredCodeView: UIView, UITextViewDelegate, UIScrollViewDelegate {

    @IBOutlet weak var gutterView: UIScrollView!
    @IBOutlet weak var textView: UITextView!
    var view: UIView!
    var font: UIFont?
    private var numberOfLines = 1
    private var gutterSubViews: [UILabel] = []
    private var visableKeyboard = false
    private var keyboardDementions: CGRect?
    func xibSetUp() {
        view = loadFromXib()
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        addSubview(view)
    }
    
    func loadFromXib() -> UIView {
        let bundle: NSBundle = NSBundle(forClass: self.dynamicType)
        let xib: UINib = UINib(nibName: "OKSGutteredCodeView", bundle: bundle)
        let view: UIView = xib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        return view
    }
    
    override public init(frame: CGRect) {
        
        super.init(frame: frame)
        xibSetUp()
        self.addObserver(self, forKeyPath: "bounds", options: .Initial, context: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)
        self.textViewDidChange(self.textView)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        xibSetUp()
        self.addObserver(self, forKeyPath: "bounds", options: .Initial, context: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)
        self.textViewDidChange(self.textView)
    }
    
    //MARK: custimization methods
    
    @objc public func setGutterBackgroundColor(color: UIColor) {
        self.gutterView.backgroundColor = color
    }
    
    @objc public func setfont(font: UIFont) {
        self.font = font
        self.textView.font = font
    }
    
    @objc public func setText(text: String) {
        self.textView.text = text
    }
    
    //MARK: UITextView Delegate Methods
    
    @objc public func textViewDidChange(textView: UITextView) {
        for label in self.gutterSubViews {
            label.removeFromSuperview()
        }
        self.numberOfLines = self.countNumberOfLines()
        self.addNumberToGutter()
        if self.visableKeyboard {
            
            let userInfo: [NSObject : AnyObject] = [UIKeyboardFrameEndUserInfoKey : NSValue(CGRect: self.keyboardDementions!)]
            let notification: NSNotification = NSNotification(name: UIKeyboardWillShowNotification, object: nil, userInfo: userInfo)
            NSNotificationCenter.defaultCenter().postNotification(notification)
           
        }
        if textView.text.characters.last == "\n" {
            let curserPosition = self.textView.caretRectForPosition(self.textView.selectedTextRange!.start).origin
            let newViewRect = CGRectMake(0, curserPosition.y, self.textView.bounds.width, self.textView.bounds.height)
            self.textView.scrollRectToVisible(newViewRect, animated: false)
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        // figures out the frame of the keyboard when it appears
        self.visableKeyboard = true
        
        let info  = notification.userInfo!
        let value: AnyObject = info[UIKeyboardFrameEndUserInfoKey]!
        
        let rawFrame = value.CGRectValue
        let keyboardFrame = view.convertRect(rawFrame, fromView: nil)
        self.keyboardDementions = keyboardFrame
        // adds content size if needed
        
        if self.heightOfLine(self.textView.text) > self.textView.bounds.height - keyboardFrame.height {
            self.textView.contentSize = CGSizeMake(self.textView.bounds.width, self.textView.contentSize.height + keyboardFrame.height)
            self.gutterView.contentSize = CGSizeMake(self.gutterView.bounds.width, self.gutterView.contentSize.height + keyboardFrame.height)
        }
    }
    
    func keepCurserVisable() {
    
    }
    func keyboardWillHide() {
        if self.visableKeyboard {
            self.visableKeyboard = false
            self.textView.contentSize = CGSizeMake(self.textView.bounds.width, self.textView.contentSize.height - self.keyboardDementions!.height)
            self.gutterView.contentSize = CGSizeMake(self.gutterView.bounds.width, self.gutterView.contentSize.height - self.keyboardDementions!.height)
            self.keyboardDementions = nil
        }
    }
    
    //MARK: UIScrollView Delegate Mathods
    
    @objc public func scrollViewDidScroll(scrollView: UIScrollView) {
        let yOffSet = self.textView.contentOffset.y
        self.gutterView.scrollRectToVisible(CGRectMake(0, yOffSet, self.gutterView.frame.width, self.gutterView.frame.height), animated: false)
    }
    //MARK: sorting out number and location of lines
    
    func countNumberOfLines() -> Int {
        let text = self.textView.text
        let seperatedLines = text.componentsSeparatedByString("\n")
        return seperatedLines.count - 1
    }
    
    func addNumberToGutter() {
        let curserPosition = self.textView.caretRectForPosition(self.textView.selectedTextRange!.start).origin
        let text = self.textView.text
        let seperatedLines = text.componentsSeparatedByString("\n")
        var numberInsertionPoint: CGFloat = 8
        self.gutterView.contentSize = self.gutterView.frame.size
        var counter: Int = 1
        for line in seperatedLines {
            let label: UILabel = UILabel(frame: CGRectMake(0, numberInsertionPoint, 35, self.textView.font!.lineHeight))
            label.font = self.font != nil ? self.font : UIFont(name: "Courier New", size: 17.0)
            label.textAlignment = .Right
            label.text = "\(counter)"
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
        self.textView.scrollRectToVisible(CGRectMake(0, curserPosition.y, self.textView.bounds.width, self.textView.bounds.height), animated: false)
        self.gutterView.scrollRectToVisible(CGRectMake(0, curserPosition.y, self.textView.bounds.width, self.textView.bounds.height), animated: false)
    }
    
    func heightOfLine(line: String) -> CGFloat {
        let font: UIFont = self.textView.font!
        let textViewWidth: CGFloat = self.textView.bounds.width
        let lineHeight = line.boundingRectWithSize(CGSizeMake(textViewWidth, CGFloat.max), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName : font], context: nil).height
        return lineHeight
    }
    
    func updatekeyboardSize() {
        self.textView.resignFirstResponder()
        self.textView.becomeFirstResponder()
    }
    
    //MARK: KVO methods
    
    override public func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath != nil && keyPath == "bounds" && (object?.isEqual(self))! {
            if self.visableKeyboard {
                self.textView.contentSize = CGSizeMake(0, 0)
                self.gutterView.contentSize = CGSizeMake(0, 0)
            }
            performSelector(#selector(updatekeyboardSize), withObject: self.textView, afterDelay: 0.5)
            performSelector(#selector(textViewDidChange), withObject: self.textView, afterDelay: 0.51)
        }
    }
}
//
//  OKSGutteredCodeView.swift
//  OKSGutteredCodeView
//
//  Created by Justin Oakes on 5/12/16.
//  Copyright © 2016 J.B. Hunt. All rights reserved.
//

import UIKit

class OKSGutteredCodeView: UIView {

    @IBOutlet weak var gutterView: UIScrollView!
    @IBOutlet weak var textView: UITextView!
    var view: UIView!
    
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
    
    override init(frame: CGRect) {
        //setup properties later
        
        super.init(frame: frame)
        xibSetUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        //set up properties later
        
        super.init(coder: aDecoder)
        xibSetUp()
    }
    
    func setGutterBackgroundColor(color: UIColor) {
        self.gutterView.backgroundColor = color
    }
    
    func setGutterFont(font: UIFont) {
        //implement this later
    }
    
    func setTextViewFont(font: UIFont) {
        self.textView.font = font
    }
    
}

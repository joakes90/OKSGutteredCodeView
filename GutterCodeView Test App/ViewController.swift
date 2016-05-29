//
//  ViewController.swift
//  GutterCodeView Test App
//
//  Created by Justin Oakes on 5/12/16.
//  Copyright © 2016 Oklasoft LLC. All rights reserved.
//

import UIKit
import OKSGutteredCodeView

class ViewController: UIViewController, CodeViewDelegate {

    @IBOutlet weak var gutterView: OKSGutteredCodeView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       self.gutterView.setGutterBackgroundColor(UIColor.blueColor())
        self.gutterView.setfont(UIFont(name: "Hack", size: 17.0)!)
        self.gutterView.setText("Hello \n \n \n World")
        self.gutterView.delegate = self
        
        let testToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, 100, 70))
        let flexSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let testButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Bookmarks, target: nil, action: nil)
       testToolbar.items = [flexSpace, testButton]
        
        self.gutterView.addTextViewAccessoryView(testToolbar)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//MARK: CodeViewDelegate Methods
    func textUpdated(text: String) {
        print(text)
    }

}


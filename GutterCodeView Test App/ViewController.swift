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
        gutterView.setGutterBackgroundColor(#colorLiteral(red: 1, green: 0.6120633388, blue: 0.02601929553, alpha: 1))
        gutterView.setfont(UIFont(name: "Hack", size: 17.0)!)
        gutterView.setText("Hello \n \n \n World")
        gutterView.delegate = self
        
        let testToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 100, height: 70))
        let flexSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let testButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: nil, action: nil)
       testToolbar.items = [flexSpace, testButton]
        
        self.gutterView.addTextViewAccessoryView(testToolbar)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//MARK: CodeViewDelegate Methods
    
    func textUpdated(_ text: String) {
        print(text)
    }
    
    func keyboardWillAppear(_ notification: Notification) {
        print("It appeared")
    }
    
    func keyboardWillHide(_ notification: Notification) {
        print("It hid")
    }
}

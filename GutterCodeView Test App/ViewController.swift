//
//  ViewController.swift
//  GutterCodeView Test App
//
//  Created by Justin Oakes on 5/12/16.
//  Copyright © 2016 Oklasoft LLC. All rights reserved.
//

import UIKit
import OKSGutteredCodeView

class ViewController: UIViewController {

    @IBOutlet weak var gutterView: OKSGutteredCodeView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       self.gutterView.setGutterBackgroundColor(UIColor.blueColor())
        self.gutterView.setfont(UIFont(name: "Hack", size: 17.0)!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


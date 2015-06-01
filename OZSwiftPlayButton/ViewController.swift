
//
//  ViewController.swift
//  OZSwiftPlayButton
//
//  Created by Otavio Zabaleta on 01/06/2015.
//  Copyright (c) 2015 DXI. All rights reserved.
//

import UIKit

class ViewController: UIViewController, OZSwiftPlayButtonDelegate {
    var isPlaying: Bool = false
    
    @IBOutlet weak var txtTime: UITextField!
    @IBOutlet weak var btn: OZSwiftPlayButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        btn.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func btn_TouchpInside(sender: UIButton) {
        if !isPlaying {
            btn.duration = NSTimeInterval((txtTime.text as NSString).doubleValue)
        }
        
        btn.touchUpInside()
    }
    
    func didFinish() {
        isPlaying = false
    }
}


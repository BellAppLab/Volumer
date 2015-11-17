//
//  ViewController.swift
//  Volumer
//
//  Created by Bell App Lab on 11/16/2015.
//  Copyright (c) 2015 Bell App Lab. All rights reserved.
//

import UIKit
import Volumer

class ViewController: UIViewController {

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //Register a volume up block
        Volume.when(.Up) {
            print("UP!")
        }
        
        //Register a volume down block
        Volume.Down.when {
            print("Down")
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        
        //Be sure to call this when you're finished
        Volume.reset()
        
        super.viewDidDisappear(animated)
    }

}


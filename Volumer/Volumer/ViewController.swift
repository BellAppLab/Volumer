//
//  ViewController.swift
//  Volumer
//
//  Created by Bell App Lab on 06.09.17.
//  Copyright © 2017 Bell App Lab. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Register a volume up block
        Volume.when(.up) {
            print("UP!")
        }
        
        //Register a volume down block
        Volume.down.when {
            print("Down")
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        //Be sure to call this when you're finished
        Volume.reset()
        
        super.viewDidDisappear(animated)
    }


}


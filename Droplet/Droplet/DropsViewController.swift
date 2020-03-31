//
//  DropsViewController.swift
//  Droplet
//
//  Created by Owen Thompson on 3/27/20.
//  Copyright © 2020 DropTeam. All rights reserved.
//

import UIKit
import CoreNFC

class DropsViewController: UIViewController {

    @IBOutlet weak var btnSettings: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func actionSettings(_ sender: Any) {
    }
    
    @IBAction func actionScan(_ sender: Any) {
        // https://developer.apple.com/documentation/corenfc/building_an_nfc_tag-reader_app
    }
}

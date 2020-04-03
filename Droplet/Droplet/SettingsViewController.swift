//
//  SettingsViewController.swift
//  Droplet
//
//  Created by Owen Thompson on 3/30/20.
//  Copyright © 2020 DropTeam. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func actionLogOut(_ sender: Any) {
        //TODO clear all user-related Global Variables here, such as:
        GlobalVariables.loggedInUser = nil
        
        let loginView = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.present(loginView, animated: true, completion: nil)
    }
}

//
//  LoginViewController.swift
//  Droplet
//
//  Created by Owen Thompson on 3/27/20.
//  Copyright © 2020 DropTeam. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var txtID: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var swtRemember: UISwitch!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnTeacherLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func actionLogin(_ sender: Any) {
        // Validate credentials with firebase - TODO
        // Segue to Table View
        performSegue(withIdentifier: "Login", sender: sender)
    }
    
    @IBAction func actionTeacherLogin(_ sender: Any) {
        //Same as above but segue to teacher views instead
    }
}

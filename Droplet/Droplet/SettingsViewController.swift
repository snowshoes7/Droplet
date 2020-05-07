//
//  SettingsViewController.swift
//  Droplet
//
//  Created by Owen Thompson on 3/30/20.
//  Copyright © 2020 DropTeam. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {

    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtpass1: UITextField!
    @IBOutlet weak var txtpass2: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var swtTeacher: UISwitch!
    
    let db = Firestore.firestore()
    
    override func viewWillAppear(_ animated: Bool) {
        lblUsername.text = GlobalVariables.loggedInUser?.username
        txtUsername.text = GlobalVariables.loggedInUser?.username
        txtEmail.text = GlobalVariables.loggedInUser?.email
        
        if ((GlobalVariables.loggedInUser?.isTeacher) == true) {
            swtTeacher.isOn = true
        } else {
            swtTeacher.isOn = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func actionSaveProfile(_ sender: Any) {
        db.collection("users")
            .whereField("name", isEqualTo: (GlobalVariables.loggedInUser?.username)!)
        .getDocuments() { (querySnapshot, err) in
            if err != nil {
                // Some error occured
            } else {
                let document = querySnapshot!.documents.first
                document!.reference.updateData([
                    "username": self.txtUsername.text!,
                    "email": self.txtEmail.text!
                ])
            }
        }
    }
    
    @IBAction func actionLogOut(_ sender: Any) {
        //TODO clear all user-related Global Variables here, such as:
        GlobalVariables.loggedInUser = nil
        
        let loginView = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.present(loginView, animated: true, completion: nil)
    }
}

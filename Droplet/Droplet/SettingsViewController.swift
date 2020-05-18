//
//  SettingsViewController.swift
//  Droplet
//
//  Created by Owen Thompson on 3/30/20.
//  Copyright © 2020 DropTeam. All rights reserved.
//

import UIKit
import Firebase
import CoreData

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
        var setpassword : String = ""
        var execute : Bool = true
        
        if (txtpass1.text != "" || txtpass2.text != "") {
            if (txtpass1.text == txtpass2.text) {
                setpassword = txtpass2.text!
            } else {
                let alertController = UIAlertController(
                    title: "Passwords Do Not Match",
                    message: "Make sure your passwords match and try again.",
                    preferredStyle: .alert
                )
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                execute = false
            }
        }
        
        if (execute) {
            if (txtUsername.text == "" || txtEmail.text == "" || ((txtUsername.text?.contains(" ")) != nil) || ((txtEmail.text?.contains(" ")) != nil) || ((txtpass1.text?.contains(" ")) != nil) || ((txtpass2.text?.contains(" ")) != nil)) {
                let alertController2 = UIAlertController(
                    title: "Entry Error",
                    message: "Make sure you didn't erase your DropID or email. You can't use any spaces in your DropID, email, or password.",
                    preferredStyle: .alert
                )
                alertController2.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertController2, animated: true, completion: nil)
                execute = false
            }
        }
        
        if (execute) {
            db.collection("users")
                .whereField("username", isEqualTo: (GlobalVariables.loggedInUser?.username)!)
            .getDocuments() { (querySnapshot, err) in
                if err != nil {
                    print("CRITICAL FIREBASE RETRIEVAL ERROR: \(String(describing: err))")
                } else {
                    let document = querySnapshot!.documents.first
                    document!.reference.updateData([
                        "username": self.txtUsername.text!,
                        "email": self.txtEmail.text!,
                        "password": setpassword
                    ])
                    self.clearRemembered()
                    self.logOut()
                }
            }
        }
    }
    
    @IBAction func actionLogOut(_ sender: Any) {
        logOut()
    }
    
    func logOut() {
        //TODO clear all user-related Global Variables here, such as:
        GlobalVariables.loggedInUser = nil
        
        //let loginView = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        //self.present(loginView, animated: true, completion: nil)
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    func clearRemembered() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "StoredUser")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
            print("Successfully removed stored user")
        } catch {
            print ("There was an error clearing remembered user")
        }
    }
}

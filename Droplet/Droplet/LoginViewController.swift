//
//  LoginViewController.swift
//  Droplet
//
//  Created by Owen Thompson on 3/27/20.
//  Copyright © 2020 DropTeam. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var txtID: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var swtRemember: UISwitch!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnTeacherLogin: UIButton!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func actionLogin(_ sender: Any) {
        // Validate credentials with firebase - TODO
        var name : String = ""
        var password : String = ""
        var isTeacher : Bool = false
        var myClasses : [String] = []
        db.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("CRITICAL FIREBASE RETRIEVAL ERROR: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    name = document.get("username") as! String
                    password = document.get("password") as! String
                    isTeacher = document.get("isTeacher") as! Bool
                    myClasses = document.get("classes") as! [String]
                    if (self.txtID.text == name && self.txtPassword.text == password) {
                        if (isTeacher == false) {
                            //Login successful, break and segue
                            var newClasses : [AcademicClass] = []
                            for x in myClasses {
                                newClasses.append(AcademicClass(pullFromFBName: x))
                            }
                            GlobalVariables.loggedInUser = User(myClasses: newClasses, isTeacher: isTeacher, username: name, password: password)
                            print(GlobalVariables.loggedInUser!)
                            // Segue to Table View
                            self.performSegue(withIdentifier: "Login", sender: sender)
                            break
                        } else {
                             let alertController = UIAlertController(
                                           title: "Teacher Account Detected",
                                           message: "Use the teacher login button instead for this account!",
                                           preferredStyle: .alert
                                       )
                                       alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                       self.present(alertController, animated: true, completion: nil)
                            break
                        }
                    } else {
                        let alertController = UIAlertController(
                            title: "Username or Password Incorrect",
                            message: "This login information is incorrect and no such user exists in our database. Maybe you made a typo?",
                            preferredStyle: .alert
                        )
                        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alertController, animated: true, completion: nil)
                        continue
                    }
                }
            }
        }
    }
    
    @IBAction func actionTeacherLogin(_ sender: Any) {
        //Same as above but segue to teacher views instead -- extra validation required?
    }
}

//
//  LoginViewController.swift
//  Droplet
//
//  Created by Owen Thompson on 3/27/20.
//  Copyright © 2020 DropTeam. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var txtID: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var swtRemember: UISwitch!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnTeacherLogin: UIButton!
    
    let db = Firestore.firestore()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        checkForRemembered()
        preLoadAllClassesAndDroppers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func preLoadAllClassesAndDroppers() {
        print("FB retrieval initiated.")
        
        var remoteurl : String = ""
        var remotedroppers : String = ""
        var remotename : String = ""
        var remoteteacher : String = ""
        
        db.collection("classes").getDocuments() { (querySnapshot, errr) in
            if let errr = errr {
                print("CRITICAL FIREBASE RETRIEVAL ERROR: \(errr)")
            } else {
                for document in querySnapshot!.documents {
                    remotename = document.get("name") as! String
                    remoteurl = document.get("assignmentURL") as! String
                    remoteteacher = document.get("teacher") as! String
                    remotedroppers = document.get("droppers") as! String
                }
            }
        }
    }
    
    func checkForRemembered() {
        // Check Core
        print("Checking Core")
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName:"StoredUser")
        request.returnsObjectsAsFaults = false
        
        var username: String
        var password: String
        
        do {
            let result = try context.fetch(request)
            if result.count == 0 {
                print("No logins found.")
            }
            for data in result as! [NSManagedObject] {
                print("Found a Login!")
                // Grabs Username
                username = data.value(forKey: "username") as! String
                // Grabs Password
                password = data.value(forKey: "password") as! String
                // Sets TextBoxes Appropriately
                txtID.text = username
                txtPassword.text = password
                // Sets Switch
                swtRemember.setOn(true, animated: true)
            }
        } catch {
            print("Encountered an error")
        }
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
    
    @IBAction func actionLogin(_ sender: Any) {
        // Validate credentials with firebase
        var name : String = ""
        var password : String = ""
        var isTeacher : Bool = false
        var myClasses : String = ""
        var email : String = ""
        
        var badCount : Int = 0
        
        db.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("CRITICAL FIREBASE RETRIEVAL ERROR: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    name = document.get("username") as! String
                    password = document.get("password") as! String
                    isTeacher = document.get("isTeacher") as! Bool
                    myClasses = document.get("classes") as! String
                    email = document.get("email") as! String
                    if (self.txtID.text == name && self.txtPassword.text == password) {
                        if (isTeacher == false) {
                            //Login successful, break and segue
                            var newClasses : [AcademicClass] = []
                            let myClassesSplit : [Substring] = myClasses.split(separator: ";")
//                            for x in myClassesSplit {
//                                print(x as! String)
//                                print("That is a class name of the logged in user")
//                            }
                            GlobalVariables.loggedInUser = User(myClasses: newClasses, isTeacher: isTeacher, username: name, password: password, email: email)
                            //print(GlobalVariables.loggedInUser!)
                            // Set Remember Me
                            if self.swtRemember.isOn {
                                // Clear in case we already have a stored record
                                self.clearRemembered()
                                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                                
                                
                                let entity = NSEntityDescription.entity(forEntityName: "StoredUser", in: context)
                                
                                let newEntity = NSManagedObject(entity: entity!, insertInto: context)
                                
                                newEntity.setValue(self.txtID.text, forKey: "username")
                                newEntity.setValue(self.txtPassword.text, forKey: "password")
                                
                                
                                do {
                                    try context.save()
                                    print("Stored the user", self.txtID.text!, ":", self.txtPassword.text!)
                                } catch {
                                    print("Encountered an error storing the user")
                                }
                            } else if !self.swtRemember.isOn {
                                self.clearRemembered()
                            }
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
                        badCount += 1
                        if (badCount) == querySnapshot!.documents.count {
                            let alertController = UIAlertController(
                                title: "Username or Password Incorrect",
                                message: "This login information is incorrect and no such user exists in our database. Maybe you made a typo?",
                                preferredStyle: .alert
                            )
                            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(alertController, animated: true, completion: nil)
                        }
                        continue
                    }
                }
            }
        }
    }
    
    @IBAction func actionTeacherLogin(_ sender: Any) {
        //Same as above but segue to teacher views instead -- ensure they are actually a teacher before segue
    }
}

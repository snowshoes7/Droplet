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
    
    // Labels for Animation Purposes
    @IBOutlet weak var labelID: UILabel!
    @IBOutlet weak var labelPw: UILabel!
    @IBOutlet weak var labelRemember: UILabel!
    
    //var didGetClassesOnLoad : Bool = false
    
    let db = Firestore.firestore()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        checkForRemembered()
        if !(GlobalVariables.retrievedYet) {
            preLoadAllClasses()
            sleep(2) //THIS SLEEP CALL IS NECESSARY. This is because FB retrievals happen asynchronously and since constructing Droppers relies on having all AcademicClasses retrieved, then we need to wait for FB to load on startup of the program and complete that before we can do anything else. Consequently this means the LaunchScreen will almost always be at least ~3 seconds long.
            preLoadAllDroppers()
            GlobalVariables.retrievedYet = true
        } else {
            print("we already have all that stuff")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("Hid things")
        self.txtID.frame = CGRect(x: 20, y: 1208, width: self.txtID.frame.width, height: self.txtID.frame.height)
        self.txtPassword.frame = CGRect(x: 20, y: 1310, width: self.txtPassword.frame.width, height: self.txtPassword.frame.height)
        self.swtRemember.frame = CGRect(x: 20, y: 1373, width: self.swtRemember.frame.width, height: self.swtRemember.frame.height)
        self.btnLogin.frame = CGRect(x: 63, y: 1440, width: self.btnLogin.frame.width, height: self.btnLogin.frame.height)
        self.btnTeacherLogin.frame = CGRect(x: 63, y: 1526, width: self.btnTeacherLogin.frame.width, height: self.btnTeacherLogin.frame.height)
        self.labelID.isHidden = true
        self.labelPw.isHidden = true
        self.labelRemember.isHidden = true
        anim()
        //Hide everything on start so then we can animate in
    }
    
    func anim() {
        // Might butcher this, let's see
        print("anim was called")
        UIView.animate(withDuration: 0.3, delay: 1, options: .curveLinear, animations: {
            self.txtID.frame = CGRect(x: 20, y: 408, width: self.txtID.frame.width, height: self.txtID.frame.height)
            self.txtPassword.frame = CGRect(x: 20, y: 510, width: self.txtPassword.frame.width, height: self.txtPassword.frame.height)
            self.swtRemember.frame = CGRect(x: 20, y: 573, width: self.swtRemember.frame.width, height: self.swtRemember.frame.height)
            self.btnLogin.frame = CGRect(x: 63, y: 640, width: self.btnLogin.frame.width, height: self.btnLogin.frame.height)
            self.btnTeacherLogin.frame = CGRect(x: 63, y: 726, width: 288, height: 27)
        }, completion: { _ in
            print("anim finished")
            self.labelID.isHidden = false
            self.labelPw.isHidden = false
            self.labelRemember.isHidden = false
        })
        //Create animation movements
    }
    
    func preLoadAllDroppers() {
        print("FB dropper retrieval initiated...")
        GlobalVariables.localDroppers = []
        
        //Get droppers from Firebase
        var remoteid : String = ""
        var remoteassociatedClassName : String = ""
        var remotetitle : String = ""
        var remotemodifiable : Bool = false
        var remoteinteractions : Int = 0

        db.collection("droppers").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("CRITICAL FIREBASE RETRIEVAL ERROR: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    remotetitle = document.get("title") as! String
                    remoteid = document.get("id") as! String
                    remotemodifiable = document.get("modifiable") as! Bool
                    remoteassociatedClassName = document.get("class") as! String
                    remoteinteractions = document.get("interactions") as! Int
                    
                    print("\(remoteassociatedClassName) is the class name we are looking for...")
                    
                    var toAddAcademicClass : AcademicClass? = nil
                    
                    for x in GlobalVariables.localAcademicClasses {
                        if (x.name == remoteassociatedClassName) {
                            toAddAcademicClass = x
                            break
                        }
                    }
                    
                    GlobalVariables.localDroppers.append(Dropper(associatedClass: toAddAcademicClass ?? AcademicClass(url: "", droppers: [], name: "", teacher: "", assignmentStr: ""), id: remoteid, modifiable: remotemodifiable, title: remotetitle, interactions: remoteinteractions))
                }
            }
        }
    }
    
    func preLoadAllClasses() {
        print("FB class retrieval initiated...")
        GlobalVariables.localAcademicClasses = []
        
        //Get classes from Firebase
        var remoteurl : String = ""
        var remotedroppers : String = ""
        var remotename : String = ""
        var remoteteacher : String = ""
        var remoteassignstr : String = ""
        
        db.collection("classes").getDocuments() { (querySnapshot, errr) in
            if let errr = errr {
                print("CRITICAL FIREBASE RETRIEVAL ERROR: \(errr)")
            } else {
                for document in querySnapshot!.documents {
                    remotename = document.get("name") as! String
                    remoteurl = document.get("assignmentURL") as! String
                    remoteteacher = document.get("teacher") as! String
                    remotedroppers = document.get("droppers") as! String
                    remoteassignstr = document.get("assignmentStr") as! String
                    
                    var toAddDroppers : [String] = []
                    
                    for x in remotedroppers.split(separator: ";") {
                        toAddDroppers.append(String(x))
                    }
                    
                    print("\(remotename) is the name detected")
                    
                    GlobalVariables.localAcademicClasses.append(AcademicClass(url: remoteurl, droppers: toAddDroppers, name: remotename, teacher: remoteteacher, assignmentStr: remoteassignstr))
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
            print("Encountered a Core Data error. Please attempt app reinstallation if changes were made to the .xcdatamodeld file.")
        }
    }
    
    func clearRemembered() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "StoredUser")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        //Apple contexts for deleting core data
        do {
            try context.execute(deleteRequest)
            try context.save()
            print("Successfully removed stored user")
        } catch {
            print ("There was an error clearing remembered user")
        }
    }
    
    @IBAction func actionLogin(_ sender: Any) {
        userLogin()
    }
    
    @IBAction func actionTeacherLogin(_ sender: Any) {
        //Same as above but segue to teacher views instead -- ensure they are actually a teacher before segue
        teacherLogin()
    }
    //The two above just spin off login functions
    
    func teacherLogin() {
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
                        if (isTeacher == true) {
                            //Login successful, break and segue
                            var newClasses : [AcademicClass] = []
                            let myClassesSplit : [Substring] = myClasses.split(separator: ";")
                            for x in myClassesSplit {
                                for y in GlobalVariables.localAcademicClasses {
                                    if (x == y.name) {
                                        newClasses.append(y)
                                    }
                                }
                            }
                            //Reconstruct classes out of FB data since we don't store all classes in FB
                            GlobalVariables.loggedInUser = User(myClasses: newClasses, isTeacher: isTeacher, username: name, password: password, email: email)
                            print(GlobalVariables.loggedInUser!)
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
                            self.performSegue(withIdentifier: "LoginTeacher", sender: nil)
                            break
                        } else {
                             let alertController = UIAlertController(
                                           title: "Student Account Detected",
                                           message: "Use the normal login button instead for this account!",
                                           preferredStyle: .alert
                                       )
                                       alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                       self.present(alertController, animated: true, completion: nil)
                            break
                            //wrong button pressed
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
                        //Data incorrect
                        continue
                    }
                }
            }
        }
    }
    
    func userLogin() {
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
                            for x in myClassesSplit {
                                for y in GlobalVariables.localAcademicClasses {
                                    if (x == y.name) {
                                        newClasses.append(y)
                                    }
                                }
                            }
                            //Same as above--we can't store everything in FB so reconstruction is key
                            GlobalVariables.loggedInUser = User(myClasses: newClasses, isTeacher: isTeacher, username: name, password: password, email: email)
                            print(GlobalVariables.loggedInUser!)
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
                            self.performSegue(withIdentifier: "Login", sender: nil)
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
                        //Wrong login
                        continue
                    }
                }
            }
        }
    }
}

//
//  AddNewViewController.swift
//  Droplet
//
//  Created by Owen Thompson on 5/17/20.
//  Copyright © 2020 DropTeam. All rights reserved.
//

import UIKit
import Firebase

class AddNewViewController: UIViewController {
    
    @IBOutlet weak var lblClassWarning: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var lblURL: UILabel!
    @IBOutlet weak var txtURL: UITextField!
    @IBOutlet weak var navTitle: UINavigationItem!
    @IBOutlet weak var btnPickClass: UIButton!
    @IBOutlet weak var lblDropID: UILabel!
    @IBOutlet weak var txtID: UITextField!
    @IBOutlet weak var btnInfoID: UIButton!
    @IBOutlet weak var swtModifiable: UISwitch!
    @IBOutlet weak var lblModifiable: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var txtDesc: UITextField!
    @IBOutlet weak var btnFileType: UIButton!
    @IBOutlet weak var lblLinkToFile: UILabel!
    @IBOutlet weak var txtFile: UITextField!
    
    var setClass : AcademicClass? = nil
    var setFileType : String? = nil
    
    let db = Firestore.firestore()
    
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
                    
                    GlobalVariables.localDroppers.append(Dropper(associatedClass: toAddAcademicClass!, id: remoteid, modifiable: remotemodifiable, title: remotetitle, interactions: remoteinteractions))
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
    
    override func viewWillAppear(_ animated: Bool) {
        //This method just dictates what shows up depending on what you are adding or not.
        setClass = nil
        setFileType = nil
        
        if (GlobalVariables.addMode == "Class") {
            navTitle.title = "Add New Class"
            lblClassWarning.isHidden = false
            
            lblName.isHidden = false
            txtName.isHidden = false
            lblURL.isHidden = false
            txtURL.isHidden = false
            
            btnPickClass.isHidden = true
            
            btnFileType.isHidden = true
            
            lblDropID.isHidden = true
            txtID.isHidden = true
            btnInfoID.isHidden = true
            
            swtModifiable.isHidden = true
            lblModifiable.isHidden = true
            
            lblDesc.isHidden = true
            txtDesc.isHidden = true
            
            lblLinkToFile.isHidden = true
            txtFile.isHidden = true
        } else if (GlobalVariables.addMode == "Dropper") {
            navTitle.title = "Add New Dropper"
            lblClassWarning.isHidden = true
            
            lblName.isHidden = false
            txtName.isHidden = false
            lblURL.isHidden = true
            txtURL.isHidden = true
            
            btnPickClass.isHidden = false
            
            btnFileType.isHidden = true
            
            lblDropID.isHidden = false
            txtID.isHidden = false
            btnInfoID.isHidden = false
            
            swtModifiable.isHidden = false
            lblModifiable.isHidden = false
            
            lblDesc.isHidden = true
            txtDesc.isHidden = true
            
            lblLinkToFile.isHidden = true
            txtFile.isHidden = true
        } else if (GlobalVariables.addMode == "Assignment") {
            navTitle.title = "Add New Assignment"
            lblClassWarning.isHidden = true
            
            lblName.isHidden = false
            txtName.isHidden = false
            lblURL.isHidden = true
            txtURL.isHidden = true
            
            btnPickClass.isHidden = false
            
            btnFileType.isHidden = false
            
            lblDropID.isHidden = true
            txtID.isHidden = true
            btnInfoID.isHidden = true
            
            swtModifiable.isHidden = true
            lblModifiable.isHidden = true
            
            lblDesc.isHidden = false
            txtDesc.isHidden = false
            
            lblLinkToFile.isHidden = false
            txtFile.isHidden = false
        } else {
            print("ERROR - GlobalVariables.addMode is not properly defined.")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func doAddition() {
        //Add the requested data to FB and local.
        let myAlert = UIAlertController(title: "Please wait...", message: "Updating data...", preferredStyle: .alert)
        let load: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 35, y: 15, width: 50, height: 50)) as UIActivityIndicatorView
        load.hidesWhenStopped = true
        load.style = UIActivityIndicatorView.Style.medium
        load.startAnimating()

        myAlert.view.addSubview(load)
        //Create an alert with a loading icon and only do the work in the completion block so the loading icon is actually present.
        
        self.present(myAlert, animated: true, completion: {
            if (GlobalVariables.addMode == "Class") {
                self.db.collection("classes").addDocument(data: [
                    "assignmentStr": "",
                    "assignmentURL": self.txtURL.text!,
                    "droppers": "",
                    "name": self.txtName.text!,
                    "teacher": (GlobalVariables.loggedInUser?.username)!
                ])
                var newStr : String = ""
                for i in (GlobalVariables.loggedInUser?.myClasses)! {
                    newStr.append("\(i.name);")
                }
                newStr.append("\(self.txtName.text!);")
                
                self.db.collection("users")
                    .whereField("username", isEqualTo: (GlobalVariables.loggedInUser?.username)!)
                .getDocuments() { (querySnapshot, err) in
                    if err != nil {
                        print("CRITICAL FIREBASE RETRIEVAL ERROR: \(String(describing: err))")
                    } else {
                        let document = querySnapshot!.documents.first
                        document!.reference.updateData([
                            "classes": newStr
                        ])
                    }
                }
                
                let newClass : AcademicClass = AcademicClass(url: self.txtURL.text!, droppers: [], name: self.txtName.text!, teacher: (GlobalVariables.loggedInUser?.username)!, assignmentStr: "")
                
                GlobalVariables.localAcademicClasses.append(newClass)
                GlobalVariables.loggedInUser?.myClasses.append(newClass)
                //Just like before we create a class and add our user to that class, both on FB and GlobalVariables.
            } else if (GlobalVariables.addMode == "Dropper") {
                var setVal : Bool = true
                
                if (self.swtModifiable.isOn) {
                    setVal = true
                } else {
                    setVal = false
                }
                
                self.db.collection("droppers").addDocument(data: [
                    "class": (self.setClass?.name)!,
                    "id": self.txtID.text!,
                    "interactions": 0,
                    "modifiable": setVal,
                    "title": self.txtName.text!
                ])
                
                var toBeUsedAcademicClass : AcademicClass = AcademicClass(url: "", droppers: [], name: "ERROR", teacher: "", assignmentStr: "")
                
                for x in GlobalVariables.localAcademicClasses {
                    if (x.name == self.setClass!.name) {
                        toBeUsedAcademicClass = x
                        break
                    }
                }
                
                GlobalVariables.localDroppers.append(Dropper(associatedClass: toBeUsedAcademicClass, id: self.txtID.text!, modifiable: setVal, title: self.txtName.text!, interactions: 0))
                
                self.setClass?.droppers.append(self.txtID.text!)
                var newDropStr : String = ""
                for x in self.setClass!.droppers {
                    newDropStr.append("\(x);")
                }
                
                self.db.collection("classes")
                    .whereField("name", isEqualTo: (self.setClass?.name)!)
                .getDocuments() { (querySnapshot, err) in
                    if err != nil {
                        print("CRITICAL FIREBASE RETRIEVAL ERROR: \(String(describing: err))")
                    } else {
                        let document = querySnapshot!.documents.first
                        document!.reference.updateData([
                            "droppers": newDropStr
                        ])
                    }
                }
                
                var b : Int = 0
                for x in GlobalVariables.localAcademicClasses {
                    if (x.name == self.setClass!.name) {
                        GlobalVariables.localAcademicClasses[b].droppers = self.setClass?.droppers as! [String]
                        break
                    }
                    b += 1
                }
                //We iterate through a lot of stuff here with droppers to ensure that ALL dropper references are updated properly both in FB and locally. Actions might be redone here a few times for redundancy since FB uploads asynchronously.
            } else if (GlobalVariables.addMode == "Assignment") {
                //Get the date and necessary info about the assignment and pack it into a string with commas.
                let now = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "d MMM"
                let dateString = dateFormatter.string(from: now)
                print(dateString)
                
                var thisAssignmentStr : String = ""
                thisAssignmentStr.append("\((self.txtName.text!)),")
                thisAssignmentStr.append("\((self.txtDesc.text!)),")
                thisAssignmentStr.append("\((self.setFileType!)),")
                thisAssignmentStr.append("\((dateString)),")
                thisAssignmentStr.append("\((self.txtFile.text!));")
                
                self.setClass?.assignmentStr.append(thisAssignmentStr)
                let newStr : String = self.setClass!.assignmentStr
                
                self.db.collection("classes")
                    .whereField("name", isEqualTo: (self.setClass?.name)!)
                .getDocuments() { (querySnapshot, err) in
                    if err != nil {
                        print("CRITICAL FIREBASE RETRIEVAL ERROR: \(String(describing: err))")
                    } else {
                        let document = querySnapshot!.documents.first
                        document!.reference.updateData([
                            "assignmentStr": newStr
                        ])
                    }
                }
                //Put that in the old assignment string and upload to FB.
                
                var b : Int = 0
                for x in GlobalVariables.localAcademicClasses {
                    if (x.name == self.setClass!.name) {
                        GlobalVariables.localAcademicClasses[b].assignmentStr = self.setClass?.assignmentStr as! String
                        break
                    }
                    b += 1
                }
                
                var g : Int = 0
                for m in GlobalVariables.localDroppers {
                    var newClass : AcademicClass = AcademicClass(url: "", droppers: [], name: "ERROR", teacher: "", assignmentStr: "")
                    for n in GlobalVariables.localAcademicClasses {
                        if (m.associatedClass!.name == n.name) {
                            GlobalVariables.localDroppers[g].associatedClass = n
                        }
                    }
                    g += 1
                }
            }
            
            //self.preLoadAllClasses()
            sleep(2) //THIS SLEEP CALL IS NECESSARY. This is because FB retrievals happen asynchronously and since constructing Droppers relies on having all AcademicClasses retrieved, then we need to wait for FB to load on startup of the program and complete that before we can do anything else. Consequently this means the LaunchScreen will almost always be at least ~3 seconds long.
            //self.preLoadAllDroppers()
            GlobalVariables.clickedOnDropper = nil
            
            self.dismiss(animated: false, completion: {
                if self.presentedViewController == nil {
                    let backView = self.storyboard?.instantiateViewController(withIdentifier: "DropsTeacherViewController") as! DropsTeacherViewController
                    backView.modalPresentationStyle = .fullScreen
                    backView.modalTransitionStyle = .flipHorizontal
                    self.present(backView, animated: true)
                } else {
                    self.dismiss(animated: false, completion: nil)
                    let backView = self.storyboard?.instantiateViewController(withIdentifier: "DropsTeacherViewController") as! DropsTeacherViewController
                    backView.modalPresentationStyle = .fullScreen
                    backView.modalTransitionStyle = .flipHorizontal
                    self.present(backView, animated: true)
                }
                //Redundancy just to be safe and go back to the old view.
            })
        })
    }

    @IBAction func addAction(_ sender: Any) {
        let badPopup : UIAlertController = UIAlertController(title: "Error", message: "You did not fill out all the fields correctly. Please try again.", preferredStyle: .alert)
        badPopup.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        if (GlobalVariables.addMode == "Class") {
            if ((txtName.text == "") || (txtURL.text == "")) {
                self.present(badPopup, animated: true, completion: nil)
            } else {
                doAddition()
            }
        } else if (GlobalVariables.addMode == "Dropper") {
            if ((txtName.text == "") || (setClass == nil) || (txtID.text == "")) {
                self.present(badPopup, animated: true, completion: nil)
            } else {
                doAddition()
            }
        } else if (GlobalVariables.addMode == "Assignment") {
            if ((txtName.text == "") || (txtFile.text == "" || (txtDesc.text == "" || (setClass == nil) || (setFileType == nil)))) {
                self.present(badPopup, animated: true, completion: nil)
            } else {
                doAddition()
            }
        }
        //error messages if user makes mistakes.
    }
    
    @IBAction func actionPickFileType(_ sender: Any) {
        let pickAlert2 = UIAlertController(title: "Choose A File Type", message: nil, preferredStyle: .actionSheet)
        pickAlert2.addAction(UIAlertAction(title: ".docx", style: .default, handler: { (action: UIAlertAction!) in
            self.setFileType = "docx"
        }))
        pickAlert2.addAction(UIAlertAction(title: ".jpeg", style: .default, handler: { (action: UIAlertAction!) in
            self.setFileType = "jpeg"
        }))
        pickAlert2.addAction(UIAlertAction(title: ".jpg", style: .default, handler: { (action: UIAlertAction!) in
            self.setFileType = "jpg"
        }))
        pickAlert2.addAction(UIAlertAction(title: ".png", style: .default, handler: { (action: UIAlertAction!) in
            self.setFileType = "png"
        }))
        pickAlert2.addAction(UIAlertAction(title: ".pdf", style: .default, handler: { (action: UIAlertAction!) in
            self.setFileType = "pdf"
        }))
        pickAlert2.addAction(UIAlertAction(title: "Other", style: .default, handler: { (action: UIAlertAction!) in
            self.setFileType = "code"
        }))
        pickAlert2.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(pickAlert2, animated: true, completion: nil)
        //Picking file icon from a possible list.
    }
    
    @IBAction func actionBack(_ sender: Any) {
        let backView = self.storyboard?.instantiateViewController(withIdentifier: "DropsTeacherViewController") as! DropsTeacherViewController
        backView.modalPresentationStyle = .fullScreen
        backView.modalTransitionStyle = .flipHorizontal
        self.present(backView, animated: true)
    }
    
    @IBAction func actionInfo(_ sender: Any) {
        let infoAlert = UIAlertController(title: "Information", message: "This can be anything you want. It's a unique ID that will be associated with this Dropper.", preferredStyle: .alert)
        infoAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(infoAlert, animated: true, completion: nil)
    }
    
    @IBAction func actionPickClass(_ sender: Any) {
        let pickAlert = UIAlertController(title: "Choose A Class", message: nil, preferredStyle: .actionSheet)
        for x in (GlobalVariables.loggedInUser?.myClasses)! {
            let p = UIAlertAction(title: x.name, style: .default, handler: { (action: UIAlertAction!) in
                self.setClass = x
            })
            pickAlert.addAction(p)
        }
        
        pickAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(pickAlert, animated: true, completion: nil)
        //Picking classes out of teacher's list.
    }
}

//
//  DropsViewController.swift
//  Droplet
//
//  Created by Owen Thompson on 3/27/20.
//  Copyright © 2020 DropTeam. All rights reserved.
//

import UIKit
import CoreNFC
import Firebase

class DropsViewController: UIViewController {
    
    //let reuseIdentifier = "reuseIdentifier"
    var detectedMessages = [NFCNDEFMessage]()
    var session: NFCNDEFReaderSession?
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var btnSettings: UIButton!
    @IBOutlet weak var outletTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        outletTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        outletTableView.dataSource = self
        outletTableView.delegate = self
    }
    
    @IBAction func actionSettings(_ sender: Any) {
        //any additional work to be done before segue to settings screen - not really. This function exists as a buffer before segue
    }
    
    @IBAction func actionScan(_ sender: Any) {
        var triggerBadAlert : Bool = false
        //Will show alert if class does not exist
        
        let addAlert : UIAlertController = UIAlertController(title: "Add What Class?", message: nil, preferredStyle: .alert)
        addAlert.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "New Class To Add"
        })
        addAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            let lookingFor : String = addAlert.textFields![0].text!
            print(lookingFor)
            if (lookingFor == "") {
                //print("NOTHING")
                triggerBadAlert = true
            } else {
                for academicclass in GlobalVariables.localAcademicClasses {
                    if (academicclass.name == lookingFor) {
                        GlobalVariables.loggedInUser?.addClass(classToAdd: academicclass)
                        var newStr : String = ""
                        for i in (GlobalVariables.loggedInUser?.myClasses)! {
                            newStr.append("\(i.name);")
                        }
                        
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
                        //Add class to the big long string of classes in FB and also in local data
                        self.outletTableView.reloadData()
                        triggerBadAlert = false
                        break
                    } else {
                        triggerBadAlert = true
                    }
                }
            }
            if (triggerBadAlert) {
                print("bad alert")
                let badAlert : UIAlertController = UIAlertController(title: "Error", message: "Something went wrong. Maybe that class doesn't exist?", preferredStyle: .alert)
                badAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(badAlert, animated: true, completion: nil)
            }
        }))
        self.present(addAlert, animated: true, completion: nil)
    }
    
    func saveLocalDropperToFirebase(id: Int) {
        db.collection("droppers")
            .whereField("id", isEqualTo: GlobalVariables.localDroppers[id].id)
        .getDocuments() { (querySnapshot, err) in
            if err != nil {
                print("CRITICAL FIREBASE RETRIEVAL ERROR: \(String(describing: err))")
            } else {
                let document = querySnapshot!.documents.first
                document!.reference.updateData([
                    "class": (GlobalVariables.localDroppers[id].associatedClass?.name)!,
                    "id": GlobalVariables.localDroppers[id].id,
                    "interactions": GlobalVariables.localDroppers[id].interactions,
                    "modifiable": GlobalVariables.localDroppers[id].modifiable,
                    "title": GlobalVariables.localDroppers[id].title
                ])
            }
        }
    }
    
    func saveUser(newClassStr: String) {
        db.collection("users")
            .whereField("username", isEqualTo: (GlobalVariables.loggedInUser?.username)!)
        .getDocuments() { (querySnapshot, err) in
            if err != nil {
                print("CRITICAL FIREBASE RETRIEVAL ERROR: \(String(describing: err))")
            } else {
                let document = querySnapshot!.documents.first
                document!.reference.updateData([
                    "classes": newClassStr
                ])
            }
        }
    }
    //Above are just some save functions for droppers and users for convenience. They just upload given data to FB
}

extension DropsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tallyDroppers() -> [Dropper] {
        var allOfMyDroppers : [Dropper] = []
        
        if !(GlobalVariables.loggedInUser == nil) {
            
            for a in GlobalVariables.localAcademicClasses {
                var c : Int = 0
                for b in GlobalVariables.loggedInUser!.myClasses {
                    if (a.name == b.name) {
                        GlobalVariables.loggedInUser?.myClasses[c] = a
                    }
                    c += 1
                }
            }
            
            for x in GlobalVariables.loggedInUser!.myClasses {
                for y in x.droppers {
                    for z in GlobalVariables.localDroppers {
                        if (y == z.id) {
                            allOfMyDroppers.append(z)
                        }
                    }
                }
            }
        } else {
            allOfMyDroppers = []
        }
        
        return allOfMyDroppers
        //This updates all my classes and droppers locally so functions don't get out of sync whenever FB updates or changes--since this function is called a lot it made sense to put these instructions in here.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tallyDroppers().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let allOfMyDroppers = tallyDroppers()
        var ident : String = "DropCell"
        
        if (allOfMyDroppers[indexPath.row].modifiable) {
            ident = "DropCell"
        } else {
            ident = "DropCellCheckIn"
        }
        
        let cell : DropsTableViewCell = tableView.dequeueReusableCell(withIdentifier: ident) as! DropsTableViewCell
        
        //Configure the cell with its method
        cell.setDropper(dropper: allOfMyDroppers[indexPath.row], isModifiable: allOfMyDroppers[indexPath.row].modifiable)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        GlobalVariables.clickedOnDropper = tallyDroppers()[indexPath.row]
        
        //Add to interactions count for dropper selected.
        var dropperToBeChanged : Dropper = tallyDroppers()[indexPath.row]
        dropperToBeChanged.interactions += 1
        var i : Int = 0
        for x in GlobalVariables.localDroppers {
            if (x.id == dropperToBeChanged.id) {
                GlobalVariables.localDroppers[i] = dropperToBeChanged
                break
            } else {
                i += 1
            }
        }
        saveLocalDropperToFirebase(id: i)
        //Segue to assignments view for a specific dropper.
        if (tallyDroppers()[indexPath.row].modifiable) {
            let assignView = self.storyboard?.instantiateViewController(withIdentifier: "AssignmentsTableViewControllerLead") as! UINavigationController
            assignView.modalPresentationStyle = .fullScreen
            assignView.modalTransitionStyle = .flipHorizontal
            self.present(assignView, animated: true, completion: nil)
        } else {
            //Do not show an assignment view. Instead show alert about incrementing check-in count.
            let alertController = UIAlertController(
                title: "Checked In Successfully",
                message: "You checked in to the Dropper \((GlobalVariables.clickedOnDropper?.title)!) for class \((GlobalVariables.clickedOnDropper?.associatedClass?.name)!).",
                preferredStyle: .alert
            )
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Leave Class"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let alertController = UIAlertController(
            title: "Are you sure?",
            message: "Do you really want to leave the class \((tallyDroppers()[indexPath.row].associatedClass?.name)!)? This will remove all of the Droppers associated with that class.",
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action: UIAlertAction!) in
            var y : Int = 0
            for x in GlobalVariables.localDroppers {
                if (x.id == self.tallyDroppers()[indexPath.row].id) {
                    
                    break
                } else {
                    y += 1
                }
            }
            
            var toLookFor : AcademicClass = GlobalVariables.localDroppers[y].associatedClass!
            var z : Int = 0
            for a in GlobalVariables.localAcademicClasses {
                if (a.name == toLookFor.name) {
                    break
                } else {
                    z += 1
                }
            }
            //Above 2 blocks tell us what to leave
            
            print("DELETING \(GlobalVariables.localAcademicClasses[z].name)")
            
            var x : Int = 0
            for g in GlobalVariables.localAcademicClasses {
                x = 0
                for h in (GlobalVariables.loggedInUser?.myClasses)! {
                    if (GlobalVariables.localAcademicClasses[z].name == h.name) {
                        GlobalVariables.loggedInUser?.myClasses.remove(at: x)
                        break
                    } else {
                        x += 1
                    }
                }
            }
            print(GlobalVariables.loggedInUser?.myClasses)
            //Removes from local

            var newStringOfClasses : String = ""
            var j : Int = 0
            while j < (GlobalVariables.loggedInUser?.myClasses.count)! {
                newStringOfClasses.append("\((GlobalVariables.loggedInUser?.myClasses[y].name)!);")
                j += 1
            }
            
            print(newStringOfClasses)
            
            self.db.collection("users")
                .whereField("username", isEqualTo: (GlobalVariables.loggedInUser?.username)!)
            .getDocuments() { (querySnapshot, err) in
                if err != nil {
                    print("CRITICAL FIREBASE RETRIEVAL ERROR: \(String(describing: err))")
                } else {
                    let document = querySnapshot!.documents.first
                    document!.reference.updateData([
                        "classes": newStringOfClasses
                    ])
                }
            }
            //Reuploads the new, removed string to FB so it is saved.
            
            //self.saveUser(newClassStr: newStringOfClasses)
            tableView.reloadData()
        }))
        alertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
}

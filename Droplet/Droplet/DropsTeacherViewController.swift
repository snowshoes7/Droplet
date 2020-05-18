//
//  DropsTeacherViewController.swift
//  Droplet
//
//  Created by Owen Thompson on 4/2/20.
//  Copyright © 2020 DropTeam. All rights reserved.
//

import UIKit
import CoreNFC
import Firebase

class DropsTeacherViewController: UIViewController, NFCNDEFReaderSessionDelegate {

    //let reuseIdentifier = "reuseIdentifier"
    var detectedMessages = [NFCNDEFMessage]()
    var session: NFCNDEFReaderSession?
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var btnSettings: UIButton!
    @IBOutlet weak var outletTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        outletTableView.dataSource = self
        outletTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        outletTableView.reloadData()
    }
    
    @IBAction func actionSettings(_ sender: Any) {
        //any additional work to be done before segue to settings screen - not really. This function exists as a buffer before segue
    }
    
    @IBAction func actionScanOld(_ sender: Any) {
        // https://developer.apple.com/documentation/corenfc/building_an_nfc_tag-reader_app
        // Modified from sample project:
        guard NFCNDEFReaderSession.readingAvailable else {
            let alertController = UIAlertController(title: "Scanning Not Supported", message: "This device doesn't support tag scanning. You are either on a simulator or have an older device.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
        }

        session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: false)
        session?.alertMessage = "Hold your iPhone near the Dropper to interact with it."
        session?.begin()
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
         // Catch-all for errors that we can't directly control for.
               if let readerError = error as? NFCReaderError {
                   if (readerError.code != .readerSessionInvalidationErrorFirstNDEFTagRead)
                       && (readerError.code != .readerSessionInvalidationErrorUserCanceled) {
                       let alertController = UIAlertController(
                           title: "Session Invalidated",
                           message: error.localizedDescription,
                           preferredStyle: .alert
                       )
                       alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                       DispatchQueue.main.async {
                           self.present(alertController, animated: true, completion: nil)
                       }
                   }
               }

               // To read new tags, a new session instance is required, so we nullify this one.
               self.session = nil
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        DispatchQueue.main.async {
            // Process detected NFCNDEFMessage objects all at once. This is not complete.
            self.detectedMessages.append(contentsOf: messages)
            self.outletTableView.reloadData()
            
            // Remove any/all messages from detectedMessages that do not include i
            var i = 0
            for message in self.detectedMessages {
                // Convert msg to string
                let msg: String = "" // = message in decoded form
                // Check for header and isolate body
                if !msg.hasPrefix("445230504c3337") {
                    self.detectedMessages.remove(at: i)
                }
                i += 1
            }
        }
    }

    @IBAction func actionAdd(_ sender: Any) {
        let menuAlert = UIAlertController(title: "Add New", message: nil, preferredStyle: .actionSheet)
        menuAlert.modalPresentationStyle = .automatic
        menuAlert.addAction(UIAlertAction(title: "New Class", style: .default, handler: { (action: UIAlertAction!) in
            GlobalVariables.addMode = "Class"
            let newView = self.storyboard?.instantiateViewController(withIdentifier: "AddNewViewControllerLead") as! UINavigationController
            newView.modalPresentationStyle = .fullScreen
            newView.modalTransitionStyle = .flipHorizontal
            self.present(newView, animated: true, completion: nil)
        }))
        menuAlert.addAction(UIAlertAction(title: "New Dropper", style: .default, handler: { (action: UIAlertAction!) in
            GlobalVariables.addMode = "Dropper"
            let newView = self.storyboard?.instantiateViewController(withIdentifier: "AddNewViewControllerLead") as! UINavigationController
            newView.modalPresentationStyle = .fullScreen
            newView.modalTransitionStyle = .flipHorizontal
            self.present(newView, animated: true, completion: nil)
        }))
        menuAlert.addAction(UIAlertAction(title: "New Assignment", style: .default, handler: { (action: UIAlertAction!) in
            GlobalVariables.addMode = "Assignment"
            let newView = self.storyboard?.instantiateViewController(withIdentifier: "AddNewViewControllerLead") as! UINavigationController
            newView.modalPresentationStyle = .fullScreen
            newView.modalTransitionStyle = .flipHorizontal
            self.present(newView, animated: true, completion: nil)
        }))
        menuAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(menuAlert, animated: true, completion: nil)
    }
}

    extension DropsTeacherViewController: UITableViewDataSource, UITableViewDelegate {
        
        func tallyDroppers() -> [Dropper] {
            var allOfMyDroppers : [Dropper] = []
            
//            db.collection("users").getDocuments() { (querySnapshot, err) in
//                if let err = err {
//                    print("CRITICAL FIREBASE RETRIEVAL ERROR: \(err)")
//                } else {
//                    for document in querySnapshot!.documents {
//                        let myClasses = document.get("classes") as! String
//                            //Login successful, break and segue
//                            var newClasses : [AcademicClass] = []
//                            let myClassesSplit : [Substring] = myClasses.split(separator: ";")
//                            for x in myClassesSplit {
//                                for y in GlobalVariables.localAcademicClasses {
//                                    if (x == y.name) {
//                                        newClasses.append(y)
//                                    }
//                                }
//                            }
//                        GlobalVariables.loggedInUser?.myClasses = newClasses
//                    }
//                }
//            }
            
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
            
            let cell : DropsTeacherTableViewCell = tableView.dequeueReusableCell(withIdentifier: ident) as! DropsTeacherTableViewCell
            
            cell.setDropper(dropper: allOfMyDroppers[indexPath.row], isModifiable: allOfMyDroppers[indexPath.row].modifiable)
            
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            GlobalVariables.clickedOnDropper = tallyDroppers()[indexPath.row]
            //Segue to assignments view for a specific dropper.
            if (tallyDroppers()[indexPath.row].modifiable) {
                let assignView = self.storyboard?.instantiateViewController(withIdentifier: "AssignmentsTeacherTableViewControllerLead") as! UINavigationController
                assignView.modalPresentationStyle = .fullScreen
                assignView.modalTransitionStyle = .flipHorizontal
                self.present(assignView, animated: true, completion: nil)
            } else {
                //Do nothing
            }
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 80.0
        }
}

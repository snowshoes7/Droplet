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

class DropsViewController: UIViewController, NFCNDEFReaderSessionDelegate {
    
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
    
    @IBAction func actionSettings(_ sender: Any) {
        //any additional work to be done before segue to settings screen - not really. This function exists as a buffer before segue
    }
    
    @IBAction func actionScan(_ sender: Any) {
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
    
    func saveLocalDropperToFirebase(id: Int) {
        db.collection("droppers")
            .whereField("id", isEqualTo: GlobalVariables.localDroppers[id].id)
        .getDocuments() { (querySnapshot, err) in
            if err != nil {
                print("CRITICAL FIREBASE RETRIEVAL ERROR: \(String(describing: err))")
            } else {
                let document = querySnapshot!.documents.first
                document!.reference.updateData([
                    "class": GlobalVariables.localDroppers[id].associatedClass?.name,
                    "id": GlobalVariables.localDroppers[id].id,
                    "interactions": GlobalVariables.localDroppers[id].interactions,
                    "modifiable": GlobalVariables.localDroppers[id].modifiable,
                    "title": GlobalVariables.localDroppers[id].title
                ])
            }
        }
    }
}

extension DropsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tallyDroppers() -> [Dropper] {
        var allOfMyDroppers : [Dropper] = []
        
        for x in GlobalVariables.loggedInUser!.myClasses {
            for y in x.droppers {
                for z in GlobalVariables.localDroppers {
                    if (y == z.id) {
                        allOfMyDroppers.append(z)
                    }
                }
            }
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
        
        let cell : DropsTableViewCell = tableView.dequeueReusableCell(withIdentifier: ident) as! DropsTableViewCell
        
        cell.setDropper(dropper: allOfMyDroppers[indexPath.row], isModifiable: allOfMyDroppers[indexPath.row].modifiable)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
            GlobalVariables.clickedOnDropper = tallyDroppers()[indexPath.row]
            let assignView = self.storyboard?.instantiateViewController(withIdentifier: "AssignmentsTableViewControllerLead") as! UINavigationController
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

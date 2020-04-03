//
//  DropsViewController.swift
//  Droplet
//
//  Created by Owen Thompson on 3/27/20.
//  Copyright © 2020 DropTeam. All rights reserved.
//

import UIKit
import CoreNFC

class DropsViewController: UIViewController, NFCNDEFReaderSessionDelegate {
    
    //let reuseIdentifier = "reuseIdentifier"
    var detectedMessages = [NFCNDEFMessage]()
    var session: NFCNDEFReaderSession?
    
    @IBOutlet weak var btnSettings: UIButton!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func actionSettings(_ sender: Any) {
        //any additional work to be done before segue to settings screen
    }
    
    @IBAction func actionScan(_ sender: Any) {
        // https://developer.apple.com/documentation/corenfc/building_an_nfc_tag-reader_app
        // Modified from sample project:
        guard NFCNDEFReaderSession.readingAvailable else {
            let alertController = UIAlertController(
                title: "Scanning Not Supported",
                message: "This device doesn't support tag scanning. You are either on a simulator or have an older device.",
                preferredStyle: .alert
            )
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
        }

        session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: false)
        session?.alertMessage = "Hold your iPhone near the Dropper to see more."
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
            // Process detected NFCNDEFMessage objects all at once. This is not complete, and ideally this function will include multi-tag detection code but that might be a little bit overkill.
            self.detectedMessages.append(contentsOf: messages)
            self.tableView.reloadData()
        }
    }
}

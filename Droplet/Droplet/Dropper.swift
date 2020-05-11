//
//  Dropper.swift
//  Droplet
//
//  Created by Owen Thompson on 3/31/20.
//  Copyright © 2020 DropTeam. All rights reserved.
//

import Foundation
import CoreNFC
import Firebase

struct Dropper {
    var associatedClass: AcademicClass? = nil
    var id: String = ""
    var modifiable: Bool = false
    var title: String = ""
    var interactions: Int = 0
    let db = Firestore.firestore()
    
    init(associatedClass: AcademicClass, id: String, modifiable: Bool, title: String, interactions: Int) {
        self.associatedClass = associatedClass
        self.id = id
        self.modifiable = modifiable
        self.title = title
        self.interactions = interactions
    }
    
//    init(pullFromFBID: String) {
//        var id : String = ""
//        var associatedClassName : String = ""
//        var title : String = ""
//        var modifiable : Bool = false
//
//        db.collection("droppers").getDocuments() { (querySnapshot, err) in
//            if let err = err {
//                print("CRITICAL FIREBASE RETRIEVAL ERROR: \(err)")
//            } else {
//                for document in querySnapshot!.documents {
//                    title = document.get("title") as! String
//                    id = document.get("id") as! String
//                    modifiable = document.get("modifiable") as! Bool
//                    associatedClassName = document.get("class") as! String
//                    if (id == pullFromFBID) {
//                        self.id = id
//                        self.title = title
//                        self.modifiable = modifiable
//                        self.associatedClass = AcademicClass(pullFromFBName: associatedClassName)
//                        break
//                    }
//                }
//            }
//        }
//    }
    
    //TODO add functions for setup and interaction in the structure file
}

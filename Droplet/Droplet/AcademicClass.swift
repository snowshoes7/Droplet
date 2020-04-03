//
//  AcademicClass.swift
//  Droplet
//
//  Created by Owen Thompson on 3/31/20.
//  Copyright © 2020 DropTeam. All rights reserved.
//

import Foundation
import Firebase

class AcademicClass {
    var assignmentURL: String = ""
    var droppers: [String] = []
    var name: String = ""
    var teacher: String = ""
    let db = Firestore.firestore()
    
    init(url: String, droppers: [String], name: String, teacher: String) {
        self.assignmentURL = url
        self.droppers = droppers
        self.name = name
        self.teacher = teacher
    }
    
    init(pullFromFBName: String) {
        var url : String = ""
        var droppers : [String] = []
        var name : String = ""
        var teacher : String = ""
        
        db.collection("classes").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("CRITICAL FIREBASE RETRIEVAL ERROR: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    name = document.get("name") as! String
                    url = document.get("assignmentURL") as! String
                    teacher = document.get("teacher") as! String
                    droppers = document.get("droppers") as! [String]
                    if (name == pullFromFBName) {
                        self.assignmentURL = url
                        self.droppers = droppers
                        self.name = name
                        self.teacher = teacher
                        break
                    }
                }
            }
        }
    }
}

//
//  AcademicClass.swift
//  Droplet
//
//  Created by Owen Thompson on 3/31/20.
//  Copyright © 2020 DropTeam. All rights reserved.
//

import Foundation
import Firebase

struct AcademicClass {
    var assignmentURL: String = ""
    var droppers: [String] = []
    var name: String = ""
    var teacher: String = ""
    var assignmentStr: String = ""
    let db = Firestore.firestore()
    
    init(url: String, droppers: [String], name: String, teacher: String, assignmentStr: String) {
        self.assignmentURL = url
        self.droppers = droppers
        self.name = name
        self.teacher = teacher
        self.assignmentStr = assignmentStr
    }
    
//    init(pullFromFBName: String) {
//        var remoteurl : String = ""
//        var remotedroppers : String = ""
//        var remotename : String = ""
//        var remoteteacher : String = ""
//
//        db.collection("classes").getDocuments() { (querySnapshot, err) in
//            if let err = err {
//                print("CRITICAL FIREBASE RETRIEVAL ERROR: \(err)")
//            } else {
//                for document in querySnapshot!.documents {
//                    remotename = document.get("name") as! String
//                    remoteurl = document.get("assignmentURL") as! String
//                    remoteteacher = document.get("teacher") as! String
//                    remotedroppers = document.get("droppers") as! String
//                    if (remotename == pullFromFBName) {
//                        self.assignmentURL = remoteurl
//                        self.name = remotename
//                        self.teacher = remoteteacher
//                        print(remotedroppers)
//                        print("These are the droppers of the academicclass \(self.name)")
//                        let arr = remotedroppers.split(separator: ";")
//                        print(arr)
//                        var newDroppers : [Dropper] = []
//                        for x in arr {
//                            print(String(x))
//                            let newDropper : Dropper = Dropper(pullFromFBID: String(x))
//                        }
//                        self.droppers = []
//                        break
//                    }
//                }
//            }
//        }
//    }
}

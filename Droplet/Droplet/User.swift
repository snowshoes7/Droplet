//
//  User.swift
//  Droplet
//
//  Created by Owen Thompson on 3/31/20.
//  Copyright © 2020 DropTeam. All rights reserved.
//

import Foundation

struct User {
    var myClasses: [AcademicClass] = []
    var isTeacher: Bool = false
    var password: String = ""
    var username: String = ""
    
    init(myClasses: [AcademicClass], isTeacher: Bool, username: String, password: String) {
        self.myClasses = myClasses
        self.isTeacher = isTeacher
        self.username = username
        self.password = password
    }
    
    mutating func addClass(classToAdd: AcademicClass) {
        myClasses.append(classToAdd)
    }
    
    mutating func removeClass(classToRemove: AcademicClass) {
        for x in myClasses {
            if (x.name == classToRemove.name) && (x.assignmentURL == classToRemove.assignmentURL) {
                //TODO for loop and removeAt
            }
        }
    }
}

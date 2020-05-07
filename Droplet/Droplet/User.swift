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
    var email: String = ""
    
    init(myClasses: [AcademicClass], isTeacher: Bool, username: String, password: String, email: String) {
        self.myClasses = myClasses
        self.isTeacher = isTeacher
        self.username = username
        self.password = password
        self.email = email
    }
    
    mutating func addClass(classToAdd: AcademicClass) {
        myClasses.append(classToAdd)
    }
    
    mutating func removeClass(classToRemove: AcademicClass) {
        var i = 0
        for x in myClasses {
            if (x.name == classToRemove.name) && (x.assignmentURL == classToRemove.assignmentURL) {
                myClasses.remove(at: i)
            }
            i += 1
        }
    }
}

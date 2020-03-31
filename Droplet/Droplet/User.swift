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
}

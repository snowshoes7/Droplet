//
//  AcademicClass.swift
//  Droplet
//
//  Created by Owen Thompson on 3/31/20.
//  Copyright © 2020 DropTeam. All rights reserved.
//

import Foundation

struct AcademicClass {
    var assignmentURL: String = ""
    var droppers: [Dropper] = []
    var name: String = ""
    var teacher: String = ""
    
    init(url: String, droppers: [Dropper], name: String, teacher: String) {
        assignmentURL = url
        self.droppers = droppers
        self.name = name
        self.teacher = teacher
    }
}

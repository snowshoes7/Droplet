//
//  Dropper.swift
//  Droplet
//
//  Created by Owen Thompson on 3/31/20.
//  Copyright © 2020 DropTeam. All rights reserved.
//

import Foundation
import CoreNFC

struct Dropper {
    var associatedClass: AcademicClass? = nil
    var id: String = ""
    var modifiable: Bool = false
    var title: String = ""
    
    init(associatedClass: AcademicClass, id: String, modifiable: Bool, title: String) {
        self.associatedClass = associatedClass
        self.id = id
        self.modifiable = modifiable
        self.title = title
    }
    
    //TODO add functions for setup and interaction in the structure file
}

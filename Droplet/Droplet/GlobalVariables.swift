//
//  GlobalVariables.swift
//  Droplet
//
//  Created by Owen Thompson on 4/2/20.
//  Copyright © 2020 DropTeam. All rights reserved.
//

import Foundation

struct GlobalVariables {
    static var loggedInUser : User? = nil
    
    static var localAcademicClasses : [AcademicClass] = []
    
    static var localDroppers : [Dropper] = []
    
    //static var localUsers : [User] = [] - was supposed to do a similar function to the above but it's not strictly necessary right now
}

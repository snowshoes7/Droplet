//
//  DropsTableViewCell.swift
//  Droplet
//
//  Created by Owen Thompson on 4/10/20.
//  Copyright © 2020 DropTeam. All rights reserved.
//

import Foundation
import UIKit

class DropsTableViewCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTeacher: UILabel!
    @IBOutlet weak var lblFileDetails: UILabel!
    @IBOutlet weak var lblTitleCheckIn: UILabel!
    @IBOutlet weak var lblTeacherCheckIn: UILabel!
    @IBOutlet weak var lblFileDetailsCheckIn: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setDropper(dropper: Dropper, isModifiable: Bool) {
        if (isModifiable) {
            lblTitle.text = dropper.title
            lblTeacher.text = dropper.associatedClass?.teacher.capitalized
            lblFileDetails.text = "This \(dropper.associatedClass!.name) dropper was last updated on \((dropper.associatedClass?.assignmentStr.split(separator: ";").last?.split(separator: ",")[3]) ?? "never")."
            //show last updated date based on the last assignment we got
        } else {
            lblTitleCheckIn.text = dropper.title
            lblTeacherCheckIn.text = dropper.associatedClass?.teacher.capitalized
            lblFileDetailsCheckIn.text = "This \(dropper.associatedClass!.name) dropper has had \(dropper.interactions) Check-Ins."
        }
    }
    //set linked outlets to the values we need
}

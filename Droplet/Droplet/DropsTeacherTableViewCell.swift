//
//  DropsTeacherTableViewCell.swift
//  Droplet
//
//  Created by Owen Thompson on 5/17/20.
//  Copyright © 2020 DropTeam. All rights reserved.
//

import Foundation
import UIKit

class DropsTeacherTableViewCell: UITableViewCell {
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
            lblFileDetails.text = "This \(dropper.associatedClass!.name) dropper has had \(dropper.interactions) Check-Ins."
        } else {
            lblTitleCheckIn.text = dropper.title
            lblTeacherCheckIn.text = dropper.associatedClass?.teacher.capitalized
            lblFileDetailsCheckIn.text = "This \(dropper.associatedClass!.name) dropper has had \(dropper.interactions) Check-Ins."
        }
    }
}

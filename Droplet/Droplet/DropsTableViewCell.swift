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
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setDropper(dropper: Dropper) {
        lblTitle.text = dropper.title
        lblTeacher.text = dropper.associatedClass?.teacher
        lblFileDetails.text = "Empty"
    }
}

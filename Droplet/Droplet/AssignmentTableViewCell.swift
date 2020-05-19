//
//  AssignmentTableViewCell.swift
//  Droplet
//
//  Created by Owen Thompson on 5/11/20.
//  Copyright © 2020 DropTeam. All rights reserved.
//

import UIKit

class AssignmentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgFile: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblFileDetails: UILabel!
    
    var assignmentURL: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setAssignment(fileImg: UIImage, titleName: String, time: String, details: String, url: String) {
        self.imgFile.image = fileImg
        self.lblTitle.text = titleName
        self.lblFileDetails.text = details
        self.lblTime.text = time
        self.assignmentURL = url
        //set linked outlets to the values we need
    }
}

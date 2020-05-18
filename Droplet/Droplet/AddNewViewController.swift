//
//  AddNewViewController.swift
//  Droplet
//
//  Created by Owen Thompson on 5/17/20.
//  Copyright © 2020 DropTeam. All rights reserved.
//

import UIKit

class AddNewViewController: UIViewController {
    
    @IBOutlet weak var navTitle: UINavigationItem!
    
    override func viewWillAppear(_ animated: Bool) {
        if (GlobalVariables.addMode == "Class") {
            navTitle.title = "Add New Class"
        } else if (GlobalVariables.addMode == "Dropper") {
            navTitle.title = "Add New Dropper"
        } else if (GlobalVariables.addMode == "Assignment") {
            navTitle.title = "Add New Assignment"
        } else {
            print("ERROR - GlobalVariables.addMode is not properly defined.")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func addAction(_ sender: Any) {
        if (GlobalVariables.addMode == "Class") {
            
        } else if (GlobalVariables.addMode == "Dropper") {
            
        } else if (GlobalVariables.addMode == "Assignment") {
            
        }
    }
    
    @IBAction func actionBack(_ sender: Any) {
        let backView = self.storyboard?.instantiateViewController(withIdentifier: "DropsTeacherViewController") as! DropsTeacherViewController
        backView.modalPresentationStyle = .fullScreen
        backView.modalTransitionStyle = .flipHorizontal
        self.present(backView, animated: true)
    }
    
}

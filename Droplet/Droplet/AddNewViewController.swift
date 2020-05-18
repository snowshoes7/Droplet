//
//  AddNewViewController.swift
//  Droplet
//
//  Created by Owen Thompson on 5/17/20.
//  Copyright © 2020 DropTeam. All rights reserved.
//

import UIKit

class AddNewViewController: UIViewController {
    
    @IBOutlet weak var lblClassWarning: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var lblURL: UILabel!
    @IBOutlet weak var txtURL: UITextField!
    @IBOutlet weak var navTitle: UINavigationItem!
    @IBOutlet weak var btnPickClass: UIButton!
    @IBOutlet weak var lblDropID: UILabel!
    @IBOutlet weak var txtID: UITextField!
    @IBOutlet weak var btnInfoID: UIButton!
    @IBOutlet weak var swtModifiable: UISwitch!
    @IBOutlet weak var lblModifiable: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var txtDesc: UITextField!
    @IBOutlet weak var btnFileType: UIButton!
    
    var setClass : AcademicClass? = nil
    var setFileType : String? = nil
    
    override func viewWillAppear(_ animated: Bool) {
        setClass = nil
        setFileType = nil
        
        if (GlobalVariables.addMode == "Class") {
            navTitle.title = "Add New Class"
            lblClassWarning.isHidden = false
            
            lblName.isHidden = false
            txtName.isHidden = false
            lblURL.isHidden = false
            txtURL.isHidden = false
            
            btnPickClass.isHidden = true
            
            lblDropID.isHidden = true
            txtID.isHidden = true
            btnInfoID.isHidden = true
            
            swtModifiable.isHidden = true
            lblModifiable.isHidden = true
            
            lblDesc.isHidden = true
            txtDesc.isHidden = true
        } else if (GlobalVariables.addMode == "Dropper") {
            navTitle.title = "Add New Dropper"
            lblClassWarning.isHidden = true
            
            lblName.isHidden = false
            txtName.isHidden = false
            lblURL.isHidden = true
            txtURL.isHidden = true
            
            btnPickClass.isHidden = false
            
            lblDropID.isHidden = false
            txtID.isHidden = false
            btnInfoID.isHidden = false
            
            swtModifiable.isHidden = false
            lblModifiable.isHidden = false
            
            lblDesc.isHidden = true
            txtDesc.isHidden = true
        } else if (GlobalVariables.addMode == "Assignment") {
            navTitle.title = "Add New Assignment"
            lblClassWarning.isHidden = true
            
            lblName.isHidden = true
            txtName.isHidden = true
            lblURL.isHidden = true
            txtURL.isHidden = true
            
            btnPickClass.isHidden = false
            
            lblDropID.isHidden = true
            txtID.isHidden = true
            btnInfoID.isHidden = true
            
            swtModifiable.isHidden = true
            lblModifiable.isHidden = true
            
            lblDesc.isHidden = false
            txtDesc.isHidden = false
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
    
    @IBAction func actionPickFileType(_ sender: Any) {
        let pickAlert = UIAlertController(title: "Choose A Class", message: nil, preferredStyle: .actionSheet)
        pickAlert.modalPresentationStyle = .formSheet
        pickAlert.addAction(UIAlertAction(title: ".docx", style: .default, handler: { (action: UIAlertAction!) in
            self.setFileType = "docx"
        }))
        pickAlert.addAction(UIAlertAction(title: ".jpeg", style: .default, handler: { (action: UIAlertAction!) in
            self.setFileType = "jpeg"
        }))
        pickAlert.addAction(UIAlertAction(title: ".jpg", style: .default, handler: { (action: UIAlertAction!) in
            self.setFileType = "jpg"
        }))
        pickAlert.addAction(UIAlertAction(title: ".png", style: .default, handler: { (action: UIAlertAction!) in
            self.setFileType = "png"
        }))
        pickAlert.addAction(UIAlertAction(title: ".pdf", style: .default, handler: { (action: UIAlertAction!) in
            self.setFileType = "pdf"
        }))
        pickAlert.addAction(UIAlertAction(title: "Other...", style: .default, handler: { (action: UIAlertAction!) in
            self.setFileType = "code"
        }))
        pickAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(pickAlert, animated: true, completion: nil)
    }
    
    @IBAction func actionBack(_ sender: Any) {
        let backView = self.storyboard?.instantiateViewController(withIdentifier: "DropsTeacherViewController") as! DropsTeacherViewController
        backView.modalPresentationStyle = .fullScreen
        backView.modalTransitionStyle = .flipHorizontal
        self.present(backView, animated: true)
    }
    
    @IBAction func actionInfo(_ sender: Any) {
        let infoAlert = UIAlertController(title: "Information", message: "This can be anything you want. It's a unique ID that will be associated with this Dropper. If you leave this blank, then a random one will be used.", preferredStyle: .alert)
        infoAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    }
    
    @IBAction func actionPickClass(_ sender: Any) {
        let pickAlert = UIAlertController(title: "Choose A Class", message: nil, preferredStyle: .actionSheet)
        pickAlert.modalPresentationStyle = .formSheet
        for x in (GlobalVariables.loggedInUser?.myClasses)! {
            let p = UIAlertAction(title: x.name, style: .default, handler: { (action: UIAlertAction!) in
                self.setClass = x
            })
            pickAlert.addAction(p)
        }
        
        pickAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(pickAlert, animated: true, completion: nil)
    }
}

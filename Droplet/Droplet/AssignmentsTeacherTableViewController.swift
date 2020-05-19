//
//  AssignmentsTeacherTableViewController.swift
//
//
//  Created by Owen Thompson on 5/11/20.
//

import UIKit
import Firebase

class AssignmentsTeacherTableViewController: UITableViewController {

    @IBOutlet weak var titleBar: UINavigationItem!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if !(GlobalVariables.clickedOnDropper == nil) {
            titleBar.title = "\((GlobalVariables.clickedOnDropper?.associatedClass!.name)!) Assignments"
        }
    }
    
    @IBAction func actionBack(_ sender: Any) {
        let backView = self.storyboard?.instantiateViewController(withIdentifier: "DropsTeacherViewController") as! DropsTeacherViewController
        backView.modalPresentationStyle = .fullScreen
        backView.modalTransitionStyle = .flipHorizontal
        self.present(backView, animated: true)
    }
    
    @IBAction func actionOpenClassPage(_ sender: Any) {
        let toGoURL = URL(string: GlobalVariables.clickedOnDropper?.associatedClass?.assignmentURL ?? "https://www.example.com")!
        UIApplication.shared.open(toGoURL, options: [:], completionHandler: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1 //I think 1 is fine. 0 might also work but this isn't terribly important overall.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (GlobalVariables.clickedOnDropper?.associatedClass?.assignmentStr.split(separator: ";").count) ?? 0
    }
    //above is boilerplate tableview stuff
    //below is where the fun begins
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AssignCell", for: indexPath) as! AssignmentTeacherTableViewCell
        
        var assignArray : [String] = []
        
        for x in (GlobalVariables.clickedOnDropper?.associatedClass?.assignmentStr.split(separator: ";"))! {
            assignArray.append(String(x))
        }
        
        var imageToUse : UIImage = UIImage(named: "code-doc")!
        
        if (assignArray[indexPath.row].split(separator: ",")[2] == "docx") {
            imageToUse = UIImage(named: "word-doc")!
        } else if (assignArray[indexPath.row].split(separator: ",")[2] == "jpg") {
            imageToUse = UIImage(named: "jpg-doc")!
        } else if (assignArray[indexPath.row].split(separator: ",")[2] == "jpeg") {
            imageToUse = UIImage(named: "jpeg-doc")!
        } else if (assignArray[indexPath.row].split(separator: ",")[2] == "pdf") {
            imageToUse = UIImage(named: "pdf-doc")!
        } else if (assignArray[indexPath.row].split(separator: ",")[2] == "png") {
            imageToUse = UIImage(named: "png-doc")!
        } else {
            imageToUse = UIImage(named: "code-doc")!
        }
        //Set up the image we are going to use based on what the dropper says.
        
        // Configure the cell...
        cell.setAssignment(fileImg: imageToUse, titleName: String(assignArray[indexPath.row].split(separator: ",")[0]), time: String(assignArray[indexPath.row].split(separator: ",")[3]), details: String(assignArray[indexPath.row].split(separator: ",")[1]), url: String(assignArray[indexPath.row].split(separator: ",")[4]))
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var assignArray : [String] = []
        
        for x in (GlobalVariables.clickedOnDropper?.associatedClass?.assignmentStr.split(separator: ";"))! {
            assignArray.append(String(x))
        }
        let toGoURL = URL(string: String(assignArray[indexPath.row].split(separator: ",")[4]))!
        UIApplication.shared.open(toGoURL, options: [:], completionHandler: nil)
        //Open link in safari.
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Delete Assignment"
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        var assignArray : [String] = []
        
        for x in (GlobalVariables.clickedOnDropper?.associatedClass?.assignmentStr.split(separator: ";"))! {
            assignArray.append(String(x))
        }
        
        let alertController = UIAlertController(
            title: "Are you sure?",
            message: "Do you really want to delete the assignment \(assignArray[indexPath.row].split(separator: ",")[0])?",
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action: UIAlertAction!) in
            
            let myAlert = UIAlertController(title: "Please wait...", message: "Updating data...", preferredStyle: .alert)
            
            let load: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 35, y: 15, width: 50, height: 50)) as UIActivityIndicatorView
            load.hidesWhenStopped = true
            load.style = UIActivityIndicatorView.Style.medium
            load.startAnimating()

            myAlert.view.addSubview(load)
            //Load animation from other VCs
            
            self.present(myAlert, animated: true, completion: {
                self.dismiss(animated: false, completion: {
                    assignArray.remove(at: indexPath.row)
                    var concatArray : String = ""
                    for x in assignArray {
                        concatArray.append("\(x);")
                    }
                    
                    self.db.collection("classes")
                        .whereField("name", isEqualTo: (GlobalVariables.clickedOnDropper?.associatedClass?.name)!)
                    .getDocuments() { (querySnapshot, err) in
                        if err != nil {
                            print("CRITICAL FIREBASE RETRIEVAL ERROR: \(String(describing: err))")
                        } else {
                            let document = querySnapshot!.documents.first
                            document!.reference.updateData([
                                "assignmentStr": concatArray
                            ])
                        }
                    }
                    
                    var b : Int = 0
                    for x in GlobalVariables.localAcademicClasses {
                        if (x.name == (GlobalVariables.clickedOnDropper?.associatedClass?.name)!) {
                            GlobalVariables.localAcademicClasses[b].assignmentStr = concatArray
                            break
                        }
                        b += 1
                    }
                    
                    var g : Int = 0
                    for m in GlobalVariables.localDroppers {
                        //var newClass : AcademicClass = AcademicClass(url: "", droppers: [], name: "ERROR", teacher: "", assignmentStr: "")
                        for n in GlobalVariables.localAcademicClasses {
                            if (m.associatedClass!.name == n.name) {
                                GlobalVariables.localDroppers[g].associatedClass = n
                            }
                        }
                        g += 1
                    }
                    
                    tableView.reloadData()
                    
                    let backView = self.storyboard?.instantiateViewController(withIdentifier: "DropsTeacherViewController") as! DropsTeacherViewController
                    backView.modalPresentationStyle = .fullScreen
                    backView.modalTransitionStyle = .flipHorizontal
                    self.present(backView, animated: true)
                    //Concatenate the assignment string, upload and propagate locally, and then back out.
                })
            })
        }))
        alertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
}

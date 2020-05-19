//
//  AssignmentsTableViewController.swift
//  
//
//  Created by Owen Thompson on 5/11/20.
//

import UIKit

class AssignmentsTableViewController: UITableViewController {

    @IBOutlet weak var titleBar: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        titleBar.title = "\((GlobalVariables.clickedOnDropper?.associatedClass!.name)!) Assignments"
    }
    
    @IBAction func actionBack(_ sender: Any) {
        let backView = self.storyboard?.instantiateViewController(withIdentifier: "DropsViewController") as! DropsViewController
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
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AssignCell", for: indexPath) as! AssignmentTableViewCell
        
        var assignArray : [String] = []
        
        for x in (GlobalVariables.clickedOnDropper?.associatedClass?.assignmentStr.split(separator: ";"))! {
            assignArray.append(String(x))
        }
        //Get assignment from assignSTR which is how we store assignments in FB
        
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
        
        //Assign image types
        
        // Configure the cell...
        cell.setAssignment(fileImg: imageToUse, titleName: String(assignArray[indexPath.row].split(separator: ",")[0]), time: String(assignArray[indexPath.row].split(separator: ",")[3]), details: String(assignArray[indexPath.row].split(separator: ",")[1]), url: String(assignArray[indexPath.row].split(separator: ",")[4]))
        
        //all corresponds to how we store the data in FB
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var assignArray : [String] = []
        
        for x in (GlobalVariables.clickedOnDropper?.associatedClass?.assignmentStr.split(separator: ";"))! {
            assignArray.append(String(x))
        }
        let toGoURL = URL(string: String(assignArray[indexPath.row].split(separator: ",")[4]))!
        UIApplication.shared.open(toGoURL, options: [:], completionHandler: nil)
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
}

//
//  TableViewController.swift
//  bigMother_iOS
//
//  Created by Curtis Bellamy on 2019-09-24.
//  Copyright © 2019 Curtis Bellamy. All rights reserved.
//

import UIKit
import FirebaseFirestore


class SettingsTableViewController: UITableViewController {
    
    var db:Firestore!
    
    var options = ["Enable Recurring Updates", "Recurring Settings", "Add New Subject"]
    var subjects : [String] = ["Curtis", "Aidan", "Bella", "Francis"]
    var sections = ["Options", "Manage Subjects"]
    
    var sizes: [Int] = []
    
    var nameText = ""
    
    var parentID : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
            
        
        tableView.tableFooterView = UIView()
        
        let optionSize: Int = options.count;
        let subjectSize: Int = subjects.count;
        
        sizes = [optionSize, subjectSize]
        
        buildArray()
        self.tableView.reloadData()


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }
    
    func buildArray() {
        let docRef = db.collection("parents").document(parentID)

          docRef.getDocument { (document, error) in
              if let document = document, document.exists {

                if let children = document.data()?["children"] {
                      self.subjects = children as! [String]

                  }
              } else {
                  print("Document does not exist")
              }
          }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        print("visited back")

        buildArray()
        let optionSize: Int = options.count;
        let subjectSize: Int = subjects.count;
               
        sizes = [optionSize, subjectSize]
        
        self.tableView.reloadData()
        
        viewDidLoad()


    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows: Int = 0

        if section < sizes.count {
            rows = sizes[section]
        }

        return rows
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)

        if (indexPath.section == 0) {
            
            if (indexPath.row == 0){
                
                //here is programatically switch make to the table view
                let switchView = UISwitch(frame: .zero)
                switchView.setOn(false, animated: true)
                switchView.tag = indexPath.row // for detect which row switch Changed
                switchView.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
                cell.accessoryView = switchView
                
            }
            
            if indexPath.row == 1 || indexPath.row == 2 {
                let img = UIImageView(image:UIImage(named:"arrow")!)
                img.frame = CGRect(x: 0, y: 0, width: 20, height: 20)

                cell.accessoryView = img

            }

            let option = options[indexPath.row]
            cell.textLabel?.text = option


        } else if (indexPath.section == 1) {
            cell.textLabel?.text = subjects[indexPath.row]
            let img = UIImageView(image:UIImage(named:"arrow")!)
                     img.frame = CGRect(x: 0, y: 0, width: 20, height: 20)

                     cell.accessoryView = img
        }

        return cell
    }
    
    @objc func switchChanged(_ sender : UISwitch!){

          print("table row switch Changed \(sender.tag)")
          print("The switch is \(sender.isOn ? "ON" : "OFF")")
    }
    
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
         // Ensure that this is a safe cast
           if let secNames = sections as? [String]
           {
               return secNames[section]
           }

           // This should never happen, but is a fail safe
           return "unknown"
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        if indexPath.section == 0 && indexPath.row == 2 {
            performSegue(withIdentifier: "scanQR", sender: self)

        }
        
        if indexPath.section == 1 {
            guard let optionsView = mainStoryBoard.instantiateViewController(withIdentifier: "SubjectOptionsViewController") as? SubjectOptionsViewController else {
                print("err")
                return
            }
            
            nameText = subjects[indexPath.row]
            
            optionsView.name = self.nameText
            optionsView.parentID = parentID
            navigationController?.pushViewController(optionsView, animated: true)

            
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


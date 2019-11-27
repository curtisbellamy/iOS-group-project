//
//  TableViewController.swift
//  bigMother_iOS
//
//  Created by Yuanyuan Zhang on 2019-09-24.
//  Copyright © 2019 Curtis Bellamy. All rights reserved.
//

import UIKit
import FirebaseFirestore


var myIndex = 0
class SubjectViewController: UITableViewController {
    
    var parentID : String = ""
        
    var db:Firestore!
    
    var subjects : [String] = []
    
    //var subjects : [String] = ["Curtis", "Aidan", "Bella", "Francis"]



    // MARK: - Table view data source
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        
        var docRef = db.collection("parents").document(parentID)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let children = document.data()!["children"]! as! [Any]
                for child in children {
                    self.subjects.append(child as! String)
                }
       
            } else {
                print("Document does not exist")
            }
        }
    
    
        
        
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subjects.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = subjects[indexPath.row]

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myIndex = indexPath.row
        performSegue(withIdentifier: "segue", sender: self)
    }

}

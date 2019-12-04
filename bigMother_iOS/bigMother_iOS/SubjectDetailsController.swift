//
//  ViewController.swift
//  bigMother_iOS
//
//  Created by Yuanyuan Zhang on 2019-09-24.
//  Copyright © 2019 Curtis Bellamy. All rights reserved.
//

import UIKit
import FirebaseFirestore

class SubjectDetailsViewController: UIViewController {
    
    var subjectName : String = ""
    
    var parentID : String = ""
    
    @IBOutlet weak var lastUpdateBtn: UIButton!
    
    @IBOutlet weak var updateHistoryBtn: UIButton!
    
    @IBOutlet weak var reqUpdateBtn: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var db:Firestore!

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        titleLabel.text = subjectName
        
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        
        lastUpdateBtn.isEnabled = false
        updateHistoryBtn.isEnabled = false
        
        
        
        
        
        // Do any additional setup after loading the view.
        
        //check if there has been any updates yet
        
        let docRef = self.db.collection("channels").document(parentID)

        docRef.getDocument { (document, error) in
            
                if let document = document, document.exists {
                    
                    let thread = document.data()![self.replace(str: self.subjectName)] as? [Any]
                    
                    var lastMsg = thread![thread!.endIndex - 1] as! NSDictionary
                    
                    let tempState = lastMsg.value(forKey: "state") as? String
                    
                    if tempState != "established" || thread!.count <= 2 {
                        self.updateHistoryBtn.isEnabled = true
                        self.lastUpdateBtn.isEnabled = true
                    }

            
                

            } else {
                print("Document does not exist")
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        let docRef = self.db.collection("channels").document(parentID)

        docRef.getDocument { (document, error) in
            
                if let document = document, document.exists {
                    
                    let thread = document.data()![self.replace(str: self.subjectName)] as? [Any]
                    
                    var lastMsg = thread![thread!.endIndex - 1] as! NSDictionary
                    
                    let tempState = lastMsg.value(forKey: "state") as? String
                    
                    if tempState != "established" && thread!.count <= 2 {
                        self.updateHistoryBtn.isEnabled = false
                        self.lastUpdateBtn.isEnabled = false
                    }
                    
                    if tempState == "established" {
                        self.reqUpdateBtn.isEnabled = true
                        self.updateHistoryBtn.isEnabled = false
                        self.lastUpdateBtn.isEnabled = false
                    }
                    
                    if tempState == "requested" {
                        self.reqUpdateBtn.isEnabled = false
                    }

            
                

            } else {
                print("Document does not exist")
            }
        }
    }
    
    private func replace(str: String) -> String{
        return str.replacingOccurrences(of: ".", with: "_")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "lastUpdate" {
            let destination = segue.destination as! LastUpdateViewController
            destination.subjectName = subjectName
            destination.parentID = parentID
        }
        
        if segue.identifier == "updateHistory" {
            
            //finish!!!!
            
            let docRef = self.db.collection("channels").document(parentID)

            docRef.getDocument { (document, error) in
                
                    if let document = document, document.exists {
                        
                        let thread = document.data()![self.replace(str: self.subjectName)] as? [Any]
                        
                        var lastMsg = thread![thread!.endIndex - 1] as! NSDictionary
                        
                        let tempState = lastMsg.value(forKey: "state") as? String
                        
                        if tempState != "established" || thread!.count <= 2 {
                            self.updateHistoryBtn.isEnabled = true
                            self.lastUpdateBtn.isEnabled = true
                        }

                
                    

                } else {
                    print("Document does not exist")
                }
            }
            
            
            
            let destination = segue.destination as! UpdateHistoryTableViewController
            destination.parentID = self.parentID
            destination.childID = self.subjectName
        }
    
    }
    
    @IBAction func lastUpdate(_ sender: Any) {
        performSegue(withIdentifier: "lastUpdate", sender: nil)
    }
    
    @IBAction func requestUpdate(_ sender: Any) {
        
        let state = ["state": "requested"] as? NSDictionary
        
        let document2 = db.collection("channels").document(parentID)
        
        document2.getDocument { (document2, error) in
          if let document2 = document2, document2.exists {
            var children = document2.data()![self.subjectName]! as! [Any]
            children.append(state!)
            
            self.setData(array: children)
            
            
          } else {
            print("Document does not exist")
          }
        }
        
//        document2.setData([
//            //replace(str: subjectName) : FieldValue.arrayUnion([state])
//
//        ], merge: true)
        
        
    }
    
    private func setData(array: [Any]) {
        let document2 = db.collection("channels").document(parentID)
        document2.setData([
            replace(str: subjectName) : array

        ], merge: true)
        
        let alert = UIAlertController(title: "Success!", message: "Request sent succesfully.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in

            self.navigationController?.popViewController(animated: true)

            self.dismiss(animated: true, completion: nil)
            


        }))
        self.present(alert, animated: true, completion: nil)

    }
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

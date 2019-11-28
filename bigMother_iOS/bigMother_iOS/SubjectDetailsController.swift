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
        
              let docRef = db.collection("parents").document(parentID)
                docRef.getDocument { (document, error) in
                    if let document = document, document.exists {
                        
                        let channel = document.get("channelIDs") as! NSDictionary
                        
                        for document in channel {
                            
                            print("\(document.key):\(document.value)")
                            
                            if document.key as? String == self.subjectName {
                                
                                let docRef = self.db.collection("channels").document((document.value as? String)!)

                                docRef.getDocument { (document2, error) in
                                        if let document2 = document2, document2.exists {
                                            
                                            let thread = document2.data()![self.subjectName] as? [Any]
                                            
                                            let lastMsg = thread![thread!.endIndex - 1] as! NSDictionary

                                            let state = lastMsg.value(forKey: "state") as? String
                                            
                                            if state != "established" {
                                                self.updateHistoryBtn.isEnabled = true
                                                self.lastUpdateBtn.isEnabled = true
                                            }

                                    } else {
                                        print("Document does not exist")
                                    }
                                }

                            }
                        }

                    } else {
                        print("Document does not exist")
                    }
                }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! LastUpdateViewController
        destination.subjectName = subjectName
        destination.parentID = parentID
    }
    
    @IBAction func lastUpdate(_ sender: Any) {
        performSegue(withIdentifier: "lastUpdate", sender: nil)
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

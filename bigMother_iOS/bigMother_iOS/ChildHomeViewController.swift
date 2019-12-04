//
//  ChildHomeViewController.swift
//  bigMother_iOS
//
//  Created by Curtis Bellamy on 2019-11-26.
//  Copyright © 2019 Curtis Bellamy. All rights reserved.
//

import UIKit
import FirebaseFirestore
import UserNotifications

class ChildHomeViewController: UIViewController {
    
    var db:Firestore!

    var parentID : String = ""
    
    var childID : String = ""

    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var reqLabel: UILabel!
    
    @IBOutlet weak var btn: UIButton!
    
    @IBOutlet weak var noReqLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        
        reqLabel.isHidden = true
        btn.isHidden = true
        image.isHidden = true
        noReqLabel.isHidden = false
        
        
        // set timer for 5 second interval to check db for pending requests
        // when request found, send notification
        
        
        // notifications
        
//        let center = UNUserNotificationCenter.current()
//
//        center.requestAuthorization(options: [.alert, .sound])
//        { (granted, error) in
//
//        }
//
//        let content = UNMutableNotificationContent()
//        content.title = "Hey"
//        content.body = "Look at me"
//
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10,
//        repeats: false)
//
//        let uuidString = UUID().uuidString
//        let request =  UNNotificationRequest(identifier: uuidString, content:
//            content, trigger: trigger)
//
//        center.add(request) { (error) in
//
//        }
        
        // end notifs

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reqLabel.isHidden = true
        btn.isHidden = true
        image.isHidden = true
        
        noReqLabel.isHidden = false
        
        determineParent()
        
        
    }
    
    
    private func replace(str: String) -> String{
           return str.replacingOccurrences(of: ".", with: "_")
    }
    
    
    
    private func determineParent() {
        
        
        let parentRef = db.collection("parents")

        let parent = parentRef.whereField("children", arrayContains: childID).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {

                    self.determineRequestStatus(parent: document.documentID)
                }
            }
        }
            
    }
    
    private func determineRequestStatus(parent: String) {
                let docRef = self.db.collection("channels").document(parent)
        
                    docRef.getDocument { (document, error) in
        
                            if let document = document, document.exists {
        
                                let thread = document.data()![self.replace(str: self.childID)] as? [Any]
        
                                var lastMsg = thread![thread!.endIndex - 1] as! NSDictionary
        
                                let tempState = lastMsg.value(forKey: "state") as? String
        
                                if tempState == "requested" {
                                    self.reqLabel.isHidden = false
                                    self.btn.isHidden = false
                                    self.image.isHidden = false
                                    self.noReqLabel.isHidden = true
                                }
        
                                self.setParent(ID: parent)
        
        
                        } else {
                            print("Document does not exist")
                        }
                    }
    }
    
    private func setParent(ID : String) {
        self.parentID = ID
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         let destinationVC = segue.destination as! SendUpdateViewController
         destinationVC.parentID = self.parentID
         destinationVC.childID = self.childID
    }
    
    
    @IBAction func sendUpdate(_ sender: Any) {
        performSegue(withIdentifier: "sendUpdate", sender: nil)
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

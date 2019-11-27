//
//  SubjectOptionsViewController.swift
//  bigMother_iOS
//
//  Created by Curtis Bellamy on 2019-09-25.
//  Copyright © 2019 Curtis Bellamy. All rights reserved.
//

import UIKit
import FirebaseFirestore

class SubjectOptionsViewController: UIViewController {
    
    var db:Firestore!
    
    var id = ""
    
    
    var name : String!
    
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = "Settings for " + name
        
        // Do any additional setup after loading the view.
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        
        
//        let doc = db.collection("children")
//            .addSnapshotListener { querySnapshot, error in
//                guard let documents = querySnapshot?.documents else {
//                    print("error")
//                    return
//                }
//                let docs = documents.map {$0["emotionalState"]!}
//                print("Current data: \(docs)")
//        }
        db.collection("children").document("child4@gmail.com")
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("error")
                    return
                }
                guard let data = document.data() else {
                    print("Document data was empty")
                    return
                }
                print("Current data: \(data)")
        }
        
        print("listener enabled....")
                
    }
    
    @IBAction func deleteTapped(_ sender: Any) {
        
//        db.collection("children").document("child4@gmail.com").setData([
//            "emotionalState": "Annoyed",
//            "password": "password123"
//        ]) { err in
//            if let err = err {
//                print("error adding child")
//            } else {
//                print("child added.")
//            }
//        }
        
        
//        db.collection("channels").document().setData([
//                "state": "Channel established.",
//                "date": Timestamp(date: Date()),
//                "xCoord": "49.223968",
//                "yCoord": "-122.619272",
//                "emotionalState": "",
//                "physicalActivity": ""
//            ]) { err in
//                if let err = err {
//                    print("error creating channel")
//                } else {
//                    print("channel created")
//
//                }
//            }
        
        var ref: DocumentReference? = nil
        ref = db.collection("channels").addDocument(data: [
            "state": "Channel established.",
            "date": Timestamp(date: Date()),
            "xCoord": "49.223968",
            "yCoord": "-122.619272",
            "emotionalState": "",
            "physicalActivity": ""
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
        
        id = String(ref!.documentID)
        
        print(id)
    
        
//        db.collection("children").getDocuments() { (querySnapshot, err) in
//              if let err = err {
//                  print("Error getting documents: \(err)")
//              } else {
//                  for document in querySnapshot!.documents {
//                    print(document.documentID)
//                  }
//              }
//          }
        
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

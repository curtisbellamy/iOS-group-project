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
    
    var parentID : String = ""
    
    var name : String!
    
    var childArray : [String] = []
    
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
        
        var ref: DocumentReference? = nil
        ref = db.collection("parents").document(parentID)
        
        ref!.updateData([
            "children": FieldValue.arrayRemove([name!])
        ])
        
        
        let docRef = db.collection("parents").document(parentID)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let property = document.get("fieldname")
                if let children = document.data()?["children"] {
                    self.childArray = children as! [String]

                }
            } else {
                print("Document does not exist")
            }
        }

        let alert = UIAlertController(title: "Alert", message: "Subject deleted.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
//              switch action.style{
//              case .default:
//                    print("default")
//
//              case .cancel:
//                    print("cancel")
//
//              case .destructive:
//                    print("destructive")
            if let navController = self.navigationController {
                navController.popViewController(animated: true)
            }
            


        }))
        self.present(alert, animated: true, completion: nil)
        
        print("Child succesfully removed.")
        
//        if let navController = self.navigationController {
//            navController.popViewController(animated: true)
//        }
        
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
        
        
        
//        var ref: DocumentReference? = nil
//        ref = db.collection("channels").addDocument(data: [
//            "state": "Channel established.",
//            "date": Timestamp(date: Date()),
//            "xCoord": "49.223968",
//            "yCoord": "-122.619272",
//            "emotionalState": "",
//            "physicalActivity": ""
//        ]) { err in
//            if let err = err {
//                print("Error adding document: \(err)")
//            } else {
//                print("Document added with ID: \(ref!.documentID)")
//            }
//        }
//
//        id = String(ref!.documentID)
//
//        print(id)
        
        
    
        
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

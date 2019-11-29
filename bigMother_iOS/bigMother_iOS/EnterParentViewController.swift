//
//  EnterParentViewController.swift
//  bigMother_iOS
//
//  Created by Curtis Bellamy on 2019-11-28.
//  Copyright © 2019 Curtis Bellamy. All rights reserved.
//

import UIKit
import FirebaseFirestore

class EnterParentViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    
    var childID : String = ""
    
    var db:Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func submitTapped(_ sender: Any) {
        
        let parentID = textField.text

        let document = db.collection("parents").document(parentID!)
        document.updateData([
            "children": FieldValue.arrayUnion([childID])
        ])
        
        print("child added.")
        
        let state = ["state": "established"] as? NSDictionary
        
        let document2 = db.collection("channels").document(parentID!)
        document2.setData([
            replace(str: childID) : FieldValue.arrayUnion([state])

        ], merge: true)
        
        
        let alert = UIAlertController(title: "Success!", message: "Parent added.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in

            self.navigationController?.popViewController(animated: true)

            self.dismiss(animated: true, completion: nil)
            


        }))
        self.present(alert, animated: true, completion: nil)

        
    }
    
    private func replace(str: String) -> String{
        return str.replacingOccurrences(of: ".", with: "_")
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

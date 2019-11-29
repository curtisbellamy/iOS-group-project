//
//  SendUpdateViewController.swift
//  bigMother_iOS
//
//  Created by Curtis Bellamy on 2019-11-28.
//  Copyright © 2019 Curtis Bellamy. All rights reserved.
//

import UIKit
import CoreLocation
import FirebaseFirestore

class SendUpdateViewController: UIViewController {
    
    @IBOutlet weak var emotionText: UITextField!
    
    @IBOutlet weak var activityText: UITextField!
    
    @IBOutlet weak var extraInfoText: UITextField!
    
    var latitude : Double = 0.0
    
    var longitude : Double = 0.0
    
    var locManager = CLLocationManager()
    
    var db:Firestore!
    
    var parentID : String = ""
    
    var childID : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        
        locManager.requestWhenInUseAuthorization()
        
        var currentLocation: CLLocation!

        if( CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
                CLLocationManager.authorizationStatus() ==  .authorizedAlways){

              currentLocation = locManager.location

        }
        
        latitude = currentLocation.coordinate.latitude
        longitude = currentLocation.coordinate.longitude
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func send(_ sender: Any) {
        
        let dict : [ String : String] = [
            "emotionalState" : emotionText.text!,
            "state" : "received",
            "lat" : String(latitude),
            "long" : String(longitude),
            "date" : ("\(Date())"),
            "activity" : String(activityText.text!)
        ]
        
        
        let document = db.collection("channels").document(parentID)
           document.setData([
               replace(str: childID) : FieldValue.arrayUnion([dict])

           ], merge: true)
        
        let alert = UIAlertController(title: "Success!", message: "Update sent succesfully.", preferredStyle: .alert)
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

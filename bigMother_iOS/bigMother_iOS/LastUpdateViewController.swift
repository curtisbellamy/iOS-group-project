//
//  LastUpdateViewController.swift
//  bigMother_iOS
//
//  Created by Student on 2019-09-26.
//  Copyright © 2019 Curtis Bellamy. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import FirebaseFirestore


class LastUpdateViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var subjectTitle: UILabel!
    
    @IBOutlet weak var myMapView: MKMapView!
    
    private let locationManager = CLLocationManager()
    
    @IBOutlet weak var emotionalState: UITextField!
    
    @IBOutlet weak var activity: UITextField!
    
    @IBOutlet weak var date: UILabel!
    
    var subjectName : String = ""
    
    var parentID : String = ""
    
    var channelID = ""

    
    var db:Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        
        subjectTitle.text = subjectName

        // Do any additional setup after loading the view.
//        subjectTitle.text = subjects[myIndex] + " Last Update"
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        myMapView.delegate = self
        myMapView.showsUserLocation = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let docRef = db.collection("parents").document(parentID)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let channel = document.get("channelIDs") as! NSDictionary
                for document in channel {
                    
                    print("\(document.key):\(document.value)")
                    
                    if document.key as? String == self.subjectName {
                        //self.channelID = (document.value as? String)!
                        
                        let channelRef = self.db.collection("channels").document((document.key as? String)!)
                        print(channelRef.documentID)

                        
                        
                        
                        
                        
                        
                    }
                }

            } else {
                print("Document does not exist")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let target:CLLocationCoordinate2D = manager.location!.coordinate
        
        myMapView.mapType = MKMapType.standard
        myMapView.setRegion(MKCoordinateRegion(center: target, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        print(status)
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

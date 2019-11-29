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
    
    @IBOutlet weak var activityLabel: UILabel!
    
    @IBOutlet weak var emotionLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
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
    
    private func replace(str: String) -> String{
        return str.replacingOccurrences(of: ".", with: "_")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
                    let docRef = self.db.collection("channels").document(parentID)

                    docRef.getDocument { (document, error) in
                            if let document = document, document.exists {
                                
                                let thread = document.data()![self.replace(str: self.subjectName)] as? [Any]
                                
                                var lastMsg = thread![thread!.endIndex - 1] as! NSDictionary
                                
                                let tempState = lastMsg.value(forKey: "state")
                                if (tempState as? String) == "requested" {
                                    lastMsg = thread![thread!.endIndex - 2] as! NSDictionary
                                }
                                

                                let dateVal = lastMsg.value(forKey: "date")

                                let activityVal = lastMsg.value(forKey: "activity")

                                let emotionVal = lastMsg.value(forKey: "emotionalState")

                                let xCoord = lastMsg.value(forKey: "lat")

                                let yCoord = lastMsg.value(forKey: "long")
                                
                                
                                
                                self.activityLabel.text = activityVal as? String
                                self.emotionLabel.text = emotionVal as? String
                                self.dateLabel.text = "\(dateVal!)"



                                if emotionVal as? String == "Happy" || emotionVal as? String == "Okay" {
                                    self.emotionLabel.textColor = .green
                                    
                                } else if emotionVal as? String == "Anxious" || emotionVal as? String == "Stressed" {
                                    self.emotionLabel.textColor = .orange

                                } else if emotionVal as? String == "Anxious" || emotionVal as? String == "Stressed" {
                                    self.emotionLabel.textColor = .red
                                }
                                
                                let activityStr = activityVal as? String
                                let activityNum = Int(activityStr!)
                                
                                if activityNum! < 1000 {
                                    self.activityLabel.textColor = .red

                                } else if activityNum! > 1000 && activityNum! < 7000 {
                                    self.activityLabel.textColor = .orange

                                } else if activityNum! > 7000{
                                    self.activityLabel.textColor = .green

                                }

                        
                            

                        } else {
                            print("Document does not exist")
                        }
                    }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
//        let target:CLLocationCoordinate2D = manager.location!.coordinate
        
        let center = CLLocationCoordinate2D(latitude: 49, longitude: -122)

        
        myMapView.mapType = MKMapType.standard
        myMapView.setRegion(MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true)
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

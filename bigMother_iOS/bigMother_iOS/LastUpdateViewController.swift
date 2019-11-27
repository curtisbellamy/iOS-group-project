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

class LastUpdateViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var subjectTitle: UILabel!
    @IBOutlet weak var myMapView: MKMapView!
    
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        subjectTitle.text = subjects[myIndex] + " Last Update"
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        myMapView.delegate = self
        myMapView.showsUserLocation = true
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

//
//  SecondViewController.swift
//  bigMother_iOS
//
//  Created by Curtis Bellamy on 2019-09-21.
//  Copyright © 2019 Curtis Bellamy. All rights reserved.
//


import UIKit
import MapKit

class SecondViewController: UIViewController {
    
    @IBOutlet weak var myMap: MKMapView!
    
    var points = [CustomLocation]() // collection of custom locations
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // locations to mark
//        points.append(CustomLocation(lat: 49.2500, long: -123.0000, title: "bcit"))
//        points.append(CustomLocation(lat: 49.279793, long: -123.115669)) // optional title
        myMap.addAnnotations(points) // mark all locations
        // centre map to first point coordinate
        if points.count != 0 {
            centreMap(coordinates: points[0].coordinate)
        }
        print(points)
    }
    

    /*
            centre point to view
            change latitudeDelta, longitudeDelta to adjust zoom
     */
    func centreMap(coordinates: CLLocationCoordinate2D) {
        myMap.setRegion(MKCoordinateRegion(
            center: coordinates,
            span: MKCoordinateSpan(latitudeDelta: 0.25, longitudeDelta: 0.25)), animated: true)
    }
}
class CustomLocation: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D // DECIMAL DEGREES
    init(lat : CLLocationDegrees, long: CLLocationDegrees, title: String = "") {
        self.title = title
        self.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
}

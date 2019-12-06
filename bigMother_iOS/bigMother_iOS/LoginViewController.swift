//
//  LoginViewController.swift
//  bigMother_iOS
//
//  Created by Aidan De Leon on 2019-09-25.
//  Copyright © 2019 Curtis Bellamy. All rights reserved.
//

import UIKit
import FirebaseFirestore
import MapKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginStatusLabel: UILabel!
    @IBOutlet weak var entryFailText: UILabel!
    var lastKnownCoordinates : [CustomLocation] = []
    
    var ID : String = ""
    
    var childArray : [String] = []

    
    var db:Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        
        /*
         Source: https://spin.atomicobject.com/2017/07/18/swift-interface-builder/
        */
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        let img = renderer.image { ctx in
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.green.cgColor)
            ctx.cgContext.setLineWidth(10)

            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512)
            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")

            view.addGestureRecognizer(tap)
        
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func login(_ sender: Any) {
        let username = usernameTextField.text!
        let password = passwordTextField.text!
        
        if (username == "" || password == "") {
            //indicate empty fields
            return
        }
        
       
        //simple login
        db.collection("parents").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    if (document.documentID == username) {
                        if (document["password"] as! String == password) {
                            
                            self.ID = username
                            if let children = document.data()["children"] {
                                self.childArray = children as! [String]

                            }

                            self.generateLastCoordinates()
                
                            
                        }
                    } else {
                        self.entryFailText.text = "user doesn't exist, please signup!"
                        print(self.entryFailText.text!)
                        
                    }
                }
            }
        }
        
        db.collection("children").getDocuments() { (querySnapshot, err) in
                  if let err = err {
                      print("Error getting documents: \(err)")
                  } else {
                      for document in querySnapshot!.documents {
                          //print("\(document.documentID) => \(document.data())")
                          if (document.documentID == username) {
                              if (document["password"] as! String == password) {
                                self.ID = username
                                self.performSegue(withIdentifier: "childRoute",sender: self)
                                  
                                self.loginStatusLabel.textColor = .green
                                self.loginStatusLabel.text = "Logged in successfully!"
                                  
                              }
                          }
                      }
                  }
              }
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "childRoute" {
            
            let barViewControllers = segue.destination as! UITabBarController
            let nav = barViewControllers.viewControllers![1] as! UINavigationController
            let destinationViewController2 = barViewControllers.viewControllers![0] as! ChildHomeViewController
            let destinationViewController = nav.viewControllers[0] as! ChildSettingsTableViewController
            destinationViewController.childID = ID
            destinationViewController2.childID = ID
            
        } else if segue.identifier == "loginSegue" {
                        
            let barViewControllers = segue.destination as! UITabBarController
            let nav = barViewControllers.viewControllers![0] as! UINavigationController
            let destinationViewController = nav.viewControllers[0] as! SubjectViewController
            let destinationViewController3 = barViewControllers.viewControllers![1] as! SecondViewController
            destinationViewController.parentID = ID
            destinationViewController.subjects = childArray
            destinationViewController3.points = lastKnownCoordinates
            
            let nav2 = barViewControllers.viewControllers![2] as! UINavigationController
            let destinationViewController2 = nav2.viewControllers[0] as! SettingsTableViewController
            destinationViewController2.subjects = childArray
            destinationViewController2.parentID = ID


        }

    }
    
    
    private func generateLastCoordinates() {
        
          let docRef = self.db.collection("channels").document(ID)
        
               docRef.getDocument { (document, error) in
                       
                   if let document = document, document.exists {
                       
                    for data in document.data()! {
                        
                        let tempArr = data.value as? Array<Any>
                        
                        if tempArr!.count >= 3 {
                            
                            var last = tempArr![tempArr!.endIndex - 1] as! NSDictionary
                        
                            
                            var tempState = last.value(forKey: "state")
                            
                            if tempState as? String == "requested" {
                                last = tempArr![tempArr!.endIndex - 2] as! NSDictionary
                                tempState = last.value(forKey: "state")


                            }
                            
                            if tempState as? String == "received" {
                                
                                let lat = Double(last.value(forKey: "lat") as! String)
                                let long = Double(last.value(forKey: "long") as! String)

                                self.lastKnownCoordinates.append(CustomLocation(lat: lat!, long: long!, title: data.key))

                            }
                        }

                    }
                    self.performSegue(withIdentifier: "loginSegue",sender: self)
                                       
                    self.loginStatusLabel.textColor = .green
                    self.loginStatusLabel.text = "Logged in successfully!"

                       } else {
                           print("Document does not exist")
                       }
                   }
        
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

/*
 Source: https://spin.atomicobject.com/2017/07/18/swift-interface-builder/
*/
extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }

    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}

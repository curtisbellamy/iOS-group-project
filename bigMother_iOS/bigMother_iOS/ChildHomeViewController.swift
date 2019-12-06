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
import NotificationView


class ChildHomeViewController: UIViewController {
    
    var db:Firestore!

    var parentID : String = ""
    
    var childID : String = ""

    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var reqLabel: UILabel!
    
    @IBOutlet weak var btn: UIButton!
    
    @IBOutlet weak var noReqLabel: UILabel!
    
    var timer = Timer()
    var backgroundTimer = Timer()
    
    var notified : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        
        reqLabel.isHidden = true
        btn.isHidden = true
        image.isHidden = true
        noReqLabel.isHidden = false
        
//        determineParent()
        
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIApplication.willResignActiveNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(willBecomeActive), name: UIApplication.didBecomeActiveNotification , object: nil)


        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reqLabel.isHidden = true
        btn.isHidden = true
        image.isHidden = true
        
        noReqLabel.isHidden = false
        
        determineParent()
//        startNotificationTimer()
        
        
    }
    
    private func startNotificationTimer() {
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector:  #selector(self.determineParent), userInfo: nil, repeats: true)

    }
    
    
    @objc func willResignActive(_ notification: Notification) {
        backgroundTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector:  #selector(self.determineParent), userInfo: nil, repeats: true)
        self.notified = false
    }
    
    @objc func willBecomeActive(_ notification: Notification) {
        self.backgroundTimer.invalidate()
           
    }
    
    
    private func replace(str: String) -> String{
           return str.replacingOccurrences(of: ".", with: "_")
    }
    
    
    
    @objc func determineParent() {
        
        print("searching in background...")
        
        let appState = UIApplication.shared.applicationState

               
        if notified && appState == .background{
           self.backgroundTimer.invalidate()
//           self.notified = false
           return
        }
       
//        if notified && appState == .active {
//           self.timer.invalidate()
////           self.notified = false
////           return
//        }
        
        
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
        
        self.parentID = parent
        
        let appState = UIApplication.shared.applicationState

        
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
                            
                            if appState == .background {

                                  let center = UNUserNotificationCenter.current()

                                  center.requestAuthorization(options: [.alert, .sound])
                                  { (granted, error) in

                                  }

                                  let content = UNMutableNotificationContent()
                                  content.title = "Attention"
                                  content.body = "\(parent) is requesting an update!"

                                  let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1,
                                  repeats: false)

                                  let uuidString = UUID().uuidString
                                  let request =  UNNotificationRequest(identifier: uuidString, content:
                                      content, trigger: trigger)

                                  center.add(request) { (error) in }

                                  self.notified = true
                                  self.timer.invalidate()
                                  return

                            }

                            if appState == .active {

                                  let notificationView = NotificationView.default
                                  notificationView.title = "Attention"
                                  notificationView.body = "\(parent) is requesting an update!"
                                  notificationView.image = UIImage(named: "120.png")
                                  notificationView.show()

                                  self.notified = true
                                  self.timer.invalidate()
                                  return



                            }
                            
                            
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

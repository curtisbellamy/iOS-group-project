//
//  ViewController.swift
//  bigMother_iOS
//
//  Created by Yuanyuan Zhang on 2019-09-24.
//  Copyright © 2019 Curtis Bellamy. All rights reserved.
//

import UIKit
import FirebaseFirestore
import UserNotifications
import NotificationView

class SubjectDetailsViewController: UIViewController {
    
    var timer = Timer()
    
    var notified : Bool = false
    
    var subjectName : String = ""
    
    var parentID : String = ""
    
    var history : [NSDictionary] = []
    
    @IBOutlet weak var lastUpdateBtn: UIButton!
    
    @IBOutlet weak var updateHistoryBtn: UIButton!
    
    @IBOutlet weak var reqUpdateBtn: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var db:Firestore!

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        titleLabel.text = subjectName
        
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        
        lastUpdateBtn.isEnabled = false
        updateHistoryBtn.isEnabled = false
        
        
        
        
        
        // Do any additional setup after loading the view.
        
        //check if there has been any updates yet
        
        let docRef = self.db.collection("channels").document(parentID)

        docRef.getDocument { (document, error) in
            
                if let document = document, document.exists {
                    
                    let thread = document.data()![self.replace(str: self.subjectName)] as? [Any]
                    
                    var lastMsg = thread![thread!.endIndex - 1] as! NSDictionary
                    
                    let tempState = lastMsg.value(forKey: "state") as? String
                    
                    if tempState != "established" || thread!.count <= 2 {
                        self.updateHistoryBtn.isEnabled = true
                        self.lastUpdateBtn.isEnabled = true
                    }

            
                

            } else {
                print("Document does not exist")
            }
        }
        
        generateHistory()
        
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIApplication.willResignActiveNotification, object: nil)

        
    }
    
    @IBAction func updateHistory(_ sender: Any) {
        performSegue(withIdentifier: "updateHistory", sender: nil)
    }
    
    private func generateHistory() {
        let docRef = self.db.collection("channels").document(parentID)
        docRef.getDocument { (document, error) in
                
            if let document = document, document.exists {
                
                let thread = document.data()![self.replace(str: self.subjectName)] as? [NSDictionary]
                                
                for update in thread! {
                    
                    if update.value(forKey: "state") as? String == "received" {
                        self.history.append(update)
                    }
                }

                
                    

                } else {
                    print("Document does not exist")
                }
            }

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        let docRef = self.db.collection("channels").document(parentID)

        docRef.getDocument { (document, error) in
            
                if let document = document, document.exists {
                    
                    let thread = document.data()![self.replace(str: self.subjectName)] as? [Any]
                    
                    var lastMsg = thread![thread!.endIndex - 1] as! NSDictionary
                    
                    let tempState = lastMsg.value(forKey: "state") as? String
                    
                    if tempState != "established" && thread!.count <= 2 {
                        self.updateHistoryBtn.isEnabled = false
                        self.lastUpdateBtn.isEnabled = false
                    }
                    
                    if tempState == "established" {
                        self.reqUpdateBtn.isEnabled = true
                        self.updateHistoryBtn.isEnabled = false
                        self.lastUpdateBtn.isEnabled = false
                    }
                    
                    if tempState == "requested" {
                        self.reqUpdateBtn.isEnabled = false
                    }

            
                

            } else {
                print("Document does not exist")
            }
        }
    }
    
    private func replace(str: String) -> String{
        return str.replacingOccurrences(of: ".", with: "_")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "lastUpdate" {
            let destination = segue.destination as! LastUpdateViewController
            destination.subjectName = subjectName
            destination.parentID = parentID
        }
        
        if segue.identifier == "updateHistory" {

            let destination = segue.destination as! UpdateHistoryTableViewController
            destination.parentID = self.parentID
            destination.childID = self.subjectName
            destination.data = self.history
        }
    
    }
    
    @IBAction func lastUpdate(_ sender: Any) {
        performSegue(withIdentifier: "lastUpdate", sender: nil)
    }
    
    @IBAction func requestUpdate(_ sender: Any) {
        
        let state = ["state": "requested"] as? NSDictionary
        
        let document2 = db.collection("channels").document(parentID)
        
        document2.getDocument { (document2, error) in
          if let document2 = document2, document2.exists {
            var children = document2.data()![self.subjectName]! as! [Any]
            children.append(state!)
            
            self.setData(array: children)
            
            
          } else {
            print("Document does not exist")
          }
        }
        
        
        
    }
    
    private func setData(array: [Any]) {
        let document2 = db.collection("channels").document(parentID)
        document2.setData([
            replace(str: subjectName) : array

        ], merge: true)
        
        let alert = UIAlertController(title: "Success!", message: "Request sent succesfully.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in

            self.navigationController?.popViewController(animated: true)

            self.dismiss(animated: true, completion: nil)
            


        }))
        self.present(alert, animated: true, completion: nil)
        
        startNotificationTimer()

    }
    
    private func startNotificationTimer() {
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector:  #selector(self.checkReceivedStatus), userInfo: nil, repeats: true)

    }
    
    
    @objc func willResignActive(_ notification: Notification) {
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector:  #selector(self.checkReceivedStatus), userInfo: nil, repeats: true)
        print("BACKGROUND")
    }
    
    @objc func checkReceivedStatus() {
        
        if notified {
            timer.invalidate()
            self.notified = false
        }
        
        var appState = UIApplication.shared.applicationState
        
        let docRef = self.db.collection("channels").document(parentID)
           docRef.getDocument { (document, error) in
                   
               if let document = document, document.exists {
                   
                for data in document.data()! {
                    print(data.key)
                    let tempArr = data.value as? Array<Any>
                    var last = tempArr![tempArr!.endIndex - 1] as! NSDictionary
                    let tempState = last.value(forKey: "state")
                    
                    if tempState as? String == "received" {
                        
                        if appState == .background {
                            
                            let center = UNUserNotificationCenter.current()
                    
                            center.requestAuthorization(options: [.alert, .sound])
                            { (granted, error) in
                    
                            }
                    
                            let content = UNMutableNotificationContent()
                            content.title = "Attention"
                            content.body = "You have received an update from \(data.key)!"
                    
                            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1,
                            repeats: false)
                    
                            let uuidString = UUID().uuidString
                            let request =  UNNotificationRequest(identifier: uuidString, content:
                                content, trigger: trigger)
                    
                            center.add(request) { (error) in }
                            
                            self.notified = true
                            
                        } else if appState == .active {
                            
                            let notificationView = NotificationView.default
                            notificationView.title = "Attention"
//                            notificationView.subtitle = "You have received an update from \(data.key)"
                            notificationView.body = "You have received an update from \(data.key)"
//                            notificationView.image = image
                            notificationView.show()
                            
                            self.notified = true
                            
                        }
                    }
                    print(last)

                }


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

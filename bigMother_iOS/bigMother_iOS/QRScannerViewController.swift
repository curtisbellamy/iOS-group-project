//
//  QRScannerViewController.swift
//  bigMother_iOS
//
//  Created by Curtis Bellamy on 2019-11-25.
//  Copyright © 2019 Curtis Bellamy. All rights reserved.
//

import UIKit
import AVFoundation
import FirebaseFirestore

class QRScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var video = AVCaptureVideoPreviewLayer()
    
    var db:Firestore!
    
    var childID : String = ""


    override func viewDidLoad() {
        super.viewDidLoad()
        
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        
        // Do any additional setup after loading the view.
        
        let session = AVCaptureSession()
        
        //use when testing on actual device
//        let captureDevice = AVCaptureDevice.default(for: .video)

        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return  }

        do
        {

            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            session.addInput(input)
        }
        catch
        {
            print("error")
        }
        
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        video = AVCaptureVideoPreviewLayer(session: session)
        video.frame = view.layer.bounds
        view.layer.addSublayer(video)
        
        session.startRunning()
    }
    
    private func replace(str: String) -> String{
        return str.replacingOccurrences(of: ".", with: "_")
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects != nil && metadataObjects.count != 0 {
            
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject {
                
                if object.type == AVMetadataObject.ObjectType.qr {
                    
                    
                        let parentID = object.stringValue

                                  
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
                      
                      
                      
                      
                        let alert = UIAlertController(title: "Success!", message: "\((object.stringValue)!) succesfully added!", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { (nil) in
                            UIPasteboard.general.string = object.stringValue
                          
                            self.navigationController?.popViewController(animated: true)

                            self.dismiss(animated: true, completion: nil)
                        }))
                                          
                        present(alert, animated: true, completion: nil)
                }
                
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

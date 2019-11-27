//
//  QRScannerViewController.swift
//  bigMother_iOS
//
//  Created by Curtis Bellamy on 2019-11-25.
//  Copyright © 2019 Curtis Bellamy. All rights reserved.
//

import UIKit
import AVFoundation

class QRScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var video = AVCaptureVideoPreviewLayer()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!){
        if metadataObjects != nil && metadataObjects.count != 0 {
            
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject {
                
                if object.type == AVMetadataObject.ObjectType.qr {
                    let alert = UIAlertController(title: "QR Code", message: object.stringValue, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Copy", style: .default, handler: { (nil) in
                        UIPasteboard.general.string = object.stringValue
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

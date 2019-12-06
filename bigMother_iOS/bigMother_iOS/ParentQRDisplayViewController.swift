//
//  ChildQRDisplayViewController.swift
//  bigMother_iOS
//
//  Created by Curtis Bellamy on 2019-11-26.
//  Copyright © 2019 Curtis Bellamy. All rights reserved.
//

import UIKit

class ParentQRDisplayViewController: UIViewController {
    
    var qrcodeImage : CIImage!
    
    @IBOutlet weak var imgQRcode : UIImageView!
    
    @IBOutlet weak var slider: UISlider!
    
    var dataString : String = ""
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        generateQRCode()
        slider.transform = slider.transform.scaledBy(x: 2, y: 2)
    }
    

    @IBAction func changeScale(_ sender: Any) {
        imgQRcode.transform = CGAffineTransform(scaleX: CGFloat(slider.value), y: CGFloat(slider.value))
    }
    
    func generateQRCode() {
        
        let data1 = dataString.data(using: .isoLatin1)
        
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setValue(data1, forKey: "inputMessage")
        filter?.setValue("Q", forKey: "inputCorrectionLevel")
        
        qrcodeImage = filter?.outputImage
        
        displayQRCodeImage()
        
//        imgQRcode.image = UIImage(ciImage: qrcodeImage)
        
    }
    
    func displayQRCodeImage() {
        let scaleX = imgQRcode.frame.size.height / qrcodeImage.extent.size.width
        let scaleY = imgQRcode.frame.size.height / qrcodeImage.extent.size.height
        
        let transformedImage = qrcodeImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
        
        imgQRcode.image = UIImage(ciImage: transformedImage)
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

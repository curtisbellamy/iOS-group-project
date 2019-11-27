//
//  ChildHomeViewController.swift
//  bigMother_iOS
//
//  Created by Curtis Bellamy on 2019-11-26.
//  Copyright © 2019 Curtis Bellamy. All rights reserved.
//

import UIKit

class ChildHomeViewController: UITabBarController {
    

    
    var childID : String = ""

    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var reqLabel: UILabel!
    
    @IBOutlet weak var btn: UIButton!
    
    @IBOutlet weak var noReqLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reqLabel.isHidden = true
        btn.isHidden = true
        image.isHidden = true
        
        

        // Do any additional setup after loading the view.
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

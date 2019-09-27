//
//  SubjectOptionsViewController.swift
//  bigMother_iOS
//
//  Created by Curtis Bellamy on 2019-09-25.
//  Copyright © 2019 Curtis Bellamy. All rights reserved.
//

import UIKit

class SubjectOptionsViewController: UIViewController {
    
    var name : String!
    
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = "Settings for " + name
        
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

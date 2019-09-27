//
//  LastUpdateViewController.swift
//  bigMother_iOS
//
//  Created by Student on 2019-09-26.
//  Copyright © 2019 Curtis Bellamy. All rights reserved.
//

import UIKit

class LastUpdateViewController: UIViewController {

    @IBOutlet weak var subjectTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        subjectTitle.text = subjects[myIndex] + " Last Update"
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

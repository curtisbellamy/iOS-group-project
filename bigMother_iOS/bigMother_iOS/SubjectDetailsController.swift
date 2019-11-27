//
//  ViewController.swift
//  bigMother_iOS
//
//  Created by Yuanyuan Zhang on 2019-09-24.
//  Copyright © 2019 Curtis Bellamy. All rights reserved.
//

import UIKit

class SubjectDetailsViewController: UIViewController {
    
    var subjectName : String = ""
    
    var parentID : String = ""
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = subjectName
        
        
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! LastUpdateViewController
        destination.subjectName = subjectName
        destination.parentID = parentID
    }
    
    @IBAction func lastUpdate(_ sender: Any) {
        performSegue(withIdentifier: "lastUpdate", sender: nil)
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

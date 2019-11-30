//
//  ConfirmEventViewController.swift
//  Tuta
//
//  Created by Zhen Duan on 11/29/19.
//  Copyright © 2019 Zhen Duan. All rights reserved.
//

import UIKit
import FirebaseAuth

class ConfirmEventViewController: UIViewController {

    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var AcceptButton: UIButton!
    
    @IBAction func AcceptButtonPressed(_ sender: UIButton) {
    }
    
    var event : Event = Event()
    var eventID : String!
    let userID = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
        // Do any additional setup after loading the view.
    }
    
    func setUpUI() {
        TitleLabel.text = "Accept Request?"
        AcceptButton.titleLabel?.text = "Accept"
    }
    
    // setter
    public func setEvent(event evt: Event) {
        self.event = evt
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

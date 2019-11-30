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
        let dc = DataController()
        dc.updateEventStatus(event: event) { (true) in
            self.parentVC.setUpSectionArray()
            self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    public var parentVC : EventListViewController = EventListViewController()
    var event : Event = Event()
    var eventID : String!
    let userID : String = Auth.auth().currentUser!.uid
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpUI()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        //setUpUI()
        // Do any additional setup after loading the view.
    }
    
    func setUpUI() {
        print("setUpUI")
        print(self.event.requesterID)
        
        self.TitleLabel.adjustsFontSizeToFitWidth = true

        if(event.requesterID != userID) {
            print(event.requesterID)
            print(userID)
            // legal to confirm
            print("legal to confirm request")
            self.TitleLabel.text = "Accept Request?"
            self.AcceptButton.setTitle("Accept", for: .normal)
        }
        else {
            // not legal to confirm
            // view request instead
            print("Can only view request")
            self.TitleLabel.text = "Session Requested!"
            self.AcceptButton.isHidden = true
        }
        
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

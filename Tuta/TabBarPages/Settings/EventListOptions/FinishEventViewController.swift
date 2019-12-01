//
//  FinishEventViewController.swift
//  Tuta
//
//  Created by Zhen Duan on 11/30/19.
//  Copyright © 2019 Zhen Duan. All rights reserved.
//

import UIKit
import FirebaseAuth

class FinishEventViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var finishButton: UIButton!
    
    public var parentVC : EventListViewController = EventListViewController()
    var event : Event = Event()
    var eventID : String!
    let userID : String = Auth.auth().currentUser!.uid
    
    @IBAction func finishButtonPressed(_ sender: UIButton) {
        let dc = DataController()
        dc.updateEventStatus(event: event) { (b) in
            self.parentVC.setUpSectionArray()
            self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        // Do any additional setup after loading the view.
    }
    
    func setUpUI() {
        
        finishButton.setTitle("Finished", for: .normal)
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

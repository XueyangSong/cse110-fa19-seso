//
//  ConfirmEventViewController.swift
//  Tuta
//
//  Created by Zhen Duan on 11/29/19.
//  Copyright © 2019 Zhen Duan. All rights reserved.
//

import UIKit
import FirebaseAuth

private let darkBlueColor = UIColor(red:0.24, green:0.44, blue:0.64, alpha:1.0)

class ConfirmEventViewController: UIViewController {

    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var AcceptButton: UIButton!
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBAction func viewOtherProfileButtonPressed(_ sender: UIButton) {
        print("button pressed")
        getPostCardAndPresentProfile()
    }
    @IBAction func AcceptButtonPressed(_ sender: UIButton) {
        let dc = DataController()
        dc.updateEventStatus(event: event, isStudent: Int(0)) { (b) in
            self.parentVC.setUpSectionArray()
            self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    public var titleString : String = ""
    public var otherPersonId : String = ""
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
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        otherPersonId = ""
    }
    
    func setUpUI() {
        print("setUpUI")
        print(self.event.requesterID)
        
        self.TitleLabel.adjustsFontSizeToFitWidth = true
        AcceptButton.backgroundColor = darkBlueColor

        if(event.requesterID != userID) {
            print(event.requesterID)
            print(userID)
            // legal to confirm
            print("legal to confirm request")
            self.TitleLabel.text = "New Request!"
            self.AcceptButton.setTitle("Accept", for: .normal)
            
            self.contentLabel.text = self.titleString
        }
        else {
            // not legal to confirm
            // view request instead
            print("Can only view request")
            self.TitleLabel.text = "Session Requested!"
            
            self.contentLabel.text = ""
            self.AcceptButton.isHidden = true
        }
        
    }
    
    func getPostCardAndPresentProfile() {
        // get other user info
        let dc = DataController()
        dc.getUserFromCloud(userID: otherPersonId) { (otherUser) in
            let card = [
                "cardID" : "",
                "description" : "",
                "date" : "",
                "time" : "",
                "creatorID" : self.otherPersonId,
                "creatorName": otherUser.name,
                "course" : "",
                "type" : "",
                "rating" : otherUser.rating,
                "numRate": otherUser.numRate,
                "creatorURL": otherUser.url

            ]
                as [String : Any]
            
            let sb : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(identifier: "ViewProfileViewController") as ViewProfileViewController
            vc.post = card
            vc.shouldShowRequest = false
            self.present(vc, animated: true, completion: nil)
        }
        
    }
    
    
    
    // setter
    public func setEvent(event evt: Event) {
        self.event = evt
    }
    
}

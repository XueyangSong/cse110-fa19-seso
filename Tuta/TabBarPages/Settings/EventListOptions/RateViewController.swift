//
//  RateViewController.swift
//  Tuta
//
//  Created by Yixing Wang on 11/26/19.
//  Copyright © 2019 Zhen Duan. All rights reserved.
//

import UIKit
import Cosmos
import FirebaseAuth

class RateViewController: UIViewController {

    @IBOutlet weak var RateTutorTitleLabel: UILabel!
    @IBOutlet weak var starRatingView: CosmosView!
    @IBOutlet weak var submitButton: UIButton!
    
    var event : Event = Event()
    var eventID : String!
    let userID = Auth.auth().currentUser?.uid
    var rating: Double! = 0.0
    let dc = DataController()

    
    /*init(eventID: String) {
        self.eventID = eventID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpStarRatingView()
        setUpUI()
    }
    
    func setUpUI() {
        submitButton.layer.cornerRadius = 10
        if(event.studentID == userID) {
            // user is a student, rate tutor
            RateTutorTitleLabel.text = "Give Your Tutor a Rating"
        }
        else {
            RateTutorTitleLabel.text = "Give Your Tutee a Rating"
        }
        
    }
    
    func setUpStarRatingView() {
        starRatingView.settings.fillMode = .half
        starRatingView.settings.starSize = 50
        starRatingView.didFinishTouchingCosmos = {value in
            self.rating = value
        }
        //let margins = view.layoutMarginsGuide
        //starRatingView.topAnchor.constraint(equalToSystemSpacingBelow: margins, multiplier: 2.0)
    }
    
    // setter
    public func setEvent(event evt: Event) {
        self.event = evt
    }
    
    @IBAction func onSubmit(_ sender: Any) {
        
        dc.getEventFromCloud(at: eventID) { (event) in
            if(event.studentID == self.userID) {
                print("Eligible to do the rating")
                self.dc.updateRating(uid: event.tutorID, rating: self.rating)
            }
        }

        print("The current rating: \(rating)")
        
        
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

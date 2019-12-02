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

private let darkBlueColor = UIColor(red:0.24, green:0.44, blue:0.64, alpha:1.0)

class RateViewController: UIViewController {

    @IBOutlet weak var RateTutorTitleLabel: UILabel!
    @IBOutlet weak var starRatingView: CosmosView!
    @IBOutlet weak var submitButton: UIButton!
    
    public var parentVC : EventListViewController = EventListViewController()
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
        submitButton.backgroundColor = darkBlueColor
        submitButton.layer.cornerRadius = 10
        if event.status == "finished" {
            setUpRatingUI()
        }
        else if event.status == "bothRated" {
            setUpViewSessionUI()
        }
        else if event.status == "studentRated" {
            if userID == event.studentID {
                setUpViewSessionUI()
            }
            else {
                setUpRatingUI()
            }
        }
        else {
            if userID == event.studentID {
                setUpRatingUI()
            }
            else {
                setUpViewSessionUI()
            }
        }
    }
    
    func setUpRatingUI() {
        if(event.studentID == userID) {
            // user is a student, rate tutor
            RateTutorTitleLabel.text = "Give Your Tutor a Rating"
            RateTutorTitleLabel.lineBreakMode = .byWordWrapping
            RateTutorTitleLabel.numberOfLines = 0
        }
        else {
            RateTutorTitleLabel.text = "Give Your Tutee a Rating"
        }
    }
    
    func setUpViewSessionUI() {
        starRatingView.isHidden = true
        submitButton.setTitle("Done", for: .normal)
        if(event.studentID == userID) {
            // user is a student, rate tutor
            RateTutorTitleLabel.text = "Thanks For Studying with " + event.tutorName
            RateTutorTitleLabel.lineBreakMode = .byWordWrapping
            RateTutorTitleLabel.numberOfLines = 0
        }
        else {
            RateTutorTitleLabel.text = "Thanks For Tutoring " + event.studentName
            RateTutorTitleLabel.lineBreakMode = .byWordWrapping
            RateTutorTitleLabel.numberOfLines = 0
        }
    }
    
    func setUpStarRatingView() {
        starRatingView.settings.fillMode = .half
        starRatingView.settings.starSize = 50
        starRatingView.rating = 5.0
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
        if event.status == "bothRated" {
            navigationController?.popViewController(animated: true)
            dismiss(animated: true, completion: nil)
            return
        }
        
        let dc = DataController()

        // get other user's ID
        var otherID : String
        var isStudent : Int
        if userID == event.studentID {
            otherID = event.tutorID
            isStudent = 1
            if event.status == "studentRated" {
                navigationController?.popViewController(animated: true)
                dismiss(animated: true, completion: nil)
                return
            }
        } else {
            otherID = event.studentID
            isStudent = 0
            if event.status == "tutorRated" {
                navigationController?.popViewController(animated: true)
                dismiss(animated: true, completion: nil)
                return
            }
        }
        
        // get other user
        dc.getUserFromCloud(userID: otherID) { (otherUser) in
            // update rating
            dc.updateRating(uid: otherID, rating: self.rating)
        }
        
        // update status
        dc.updateEventStatus(event: event, isStudent: isStudent) { (b) in
            print("The current rating: \(String(describing: self.rating))")
            self.parentVC.setUpSectionArray()
            self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
        }
        
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

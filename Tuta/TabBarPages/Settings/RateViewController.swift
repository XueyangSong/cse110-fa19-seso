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

    @IBOutlet weak var starRatingView: CosmosView!
    @IBOutlet weak var submitButton: UIButton!
    
    var eventID = "3TIH0Hlq18r2czfPfQla"
    let userID = "TP1MFf9K1rfyNBIvOLnxXG1wxPs1"
    var rating: Double! = 2.5
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
    
    @IBAction func onSubmit(_ sender: Any) {
        
        dc.getEventFromCloud(at: eventID) { (event) in
            if(event.studentID == self.userID) {
                print("Eligible to do the rating")
                self.dc.updateRate(uid: event.tutorID, rate: self.rating)
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

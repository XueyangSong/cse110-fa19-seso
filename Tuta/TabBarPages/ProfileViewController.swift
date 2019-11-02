//
//  ProfileViewController.swift
//  Tuta
//
//  Created by Zhen Duan on 11/2/19.
//  Copyright © 2019 Zhen Duan. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var genderButton: UIButton!
    @IBOutlet weak var nameButton: UIButton!
    @IBOutlet weak var rating: UILabel!
    
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var descriptionButton: UIButton!
    @IBOutlet weak var coursesTakenButton: UIButton!
    
    @IBAction func genderButtonPressed(_ sender: UIButton) {
    }
    @IBAction func nameButtonPressed(_ sender: UIButton) {
    }
    @IBAction func emailButtonPressed(_ sender: UIButton) {
    }
    @IBAction func descriptionButtonPressed(_ sender: UIButton) {
    }
    @IBAction func coursesTakenButtonPressed(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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

//
//  ViewController.swift
//  This Is Nothing
//
//  Created by Zhen Duan on 10/19/19.
//  Copyright © 2019 Zhen Duan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var logoImageView: UIImageView!
    
    @IBOutlet weak var introTextLabel: UILabel!
    
    @IBOutlet weak var haveAccountLabel: UILabel!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    var signUpViewController: SignUpViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpContrains()
        // Do any additional setup after loading the view.
        
        
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        print("Sign Up button pressed!")
        //introTextLabel.text = "Yes! we are the best!"
    }
    
    @IBAction func logInButtonPressed(_ sender: UIButton) {
        print("Log In button pressed!")
    }
    
    func setUpContrains() {
        // logo origin
        logoImageView.frame.origin.x = (self.view.frame.width - logoImageView.frame.width) / 2
        logoImageView.frame.origin.y = self.view.frame.height * 0.40 - logoImageView.frame.height / 2
        
        // logo text
        introTextLabel.frame.origin.x = logoImageView.frame.origin.x + logoImageView.frame.width - introTextLabel.frame.width
        introTextLabel.frame.origin.y = logoImageView.frame.origin.y + 160
        
        // have an account label
        
        
        
        
    }


}



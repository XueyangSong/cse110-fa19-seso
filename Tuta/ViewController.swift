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
    
    var signUpViewController: SignUpViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        print("Sign Up button pressed!")
        introTextLabel.text = "Yes! we are the best!"
    }
    


}



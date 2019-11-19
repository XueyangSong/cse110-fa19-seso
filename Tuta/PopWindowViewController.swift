//
//  PopWindowViewController.swift
//  Tuta
//
//  Created by JIAHE LIU on 11/18/19.
//  Copyright © 2019 Zhen Duan. All rights reserved.
//

import UIKit

class PopWindowViewController: UIViewController {

    @IBOutlet weak var Gender: UISegmentedControl!
    @IBOutlet weak var CourseName: UILabel!
    @IBOutlet weak var CourseNameInput: UITextField!
    @IBOutlet weak var Description: UILabel!
    @IBOutlet weak var DescriptionInput: UITextField!
    @IBOutlet weak var ConfirmButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ConfirmButton.applyButton()

    }
    

}

extension UIButton{
    func applyButton(){
        self.backgroundColor = UIColor.darkGray
        self.layer.cornerRadius = self.frame.height / 2
        self.setTitleColor(UIColor.white, for: .normal)
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowRadius = 4
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
}

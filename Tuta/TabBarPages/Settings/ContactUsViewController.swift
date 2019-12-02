//
//  ContactUsViewController.swift
//  Tuta
//
//  Created by Zhen Duan on 11/30/19.
//  Copyright © 2019 Zhen Duan. All rights reserved.
//

import UIKit

class ContactUsViewController: UIViewController {
    @IBOutlet weak var label1: UILabel!
    
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var label5: UILabel!
    @IBOutlet weak var label6: UILabel!
    @IBOutlet weak var label7: UILabel!
    @IBOutlet weak var label8: UILabel!
    @IBOutlet weak var label9: UILabel!
    @IBOutlet weak var label10: UILabel!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        label1.applyLabel()
        label2.applyLabel()
        label3.applyLabel()
        label4.applyLabel()
        label5.applyLabel()
        label6.applyLabel()
        label7.applyLabel()
        label8.applyLabel()
        label9.applyLabel()
        label10.applyLabel()
        // Do any additional setup after loading the view.
        
        self.view.addSubview(backButton)
        backButton.anchor(top: self.view.topAnchor, left: self.view.leftAnchor,
                          paddingTop: 48, paddingLeft: 16, width: 32, height: 32)

    }
    
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "backIcon").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(getBack), for: .touchUpInside)
        return button
    }()
    
    @objc func getBack() {
        let sb : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(identifier: "HomeTabBarController") as HomeTabBarController
        vc.indexOfVcToBeDisplay = 2
        vc.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        vc.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        self.present(vc, animated: true, completion: nil)
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
extension UILabel{
    func applyLabel(){

         self.layer.shadowRadius = 4
         self.layer.shadowOpacity = 0.5
         self.layer.shadowOffset = CGSize(width: 1, height: 1)
        
    }
}

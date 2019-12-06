//
//  HomeTabBarController.swift
//  Tuta
//
//  Created by Zhen Duan on 10/23/19.
//  Copyright © 2019 Zhen Duan. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

class HomeTabBarController : UITabBarController, UITabBarControllerDelegate {
    
    public var indexOfVcToBeDisplay : Int = 0

    var searchPageViewController: SearchPageViewController!
    var newPostcarViewController: PopWindowViewController!
    var profileViewController: MyProfileViewController!
    
    let userID = Auth.auth().currentUser?.uid
    var isFirstTime : Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        let sb : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        searchPageViewController = sb.instantiateViewController(identifier: "SearchPageViewController") as SearchPageViewController
        newPostcarViewController = sb.instantiateViewController(identifier: "PopWindowViewController") as PopWindowViewController
        profileViewController = sb.instantiateViewController(identifier: "MyProfileViewController") as MyProfileViewController
        
        loadDataFromCloud()
        
        self.viewControllers = [searchPageViewController, newPostcarViewController, profileViewController]
        
        self.selectedIndex = indexOfVcToBeDisplay
        
    }
    
    func loadDataFromCloud() {
        if isFirstTime {
            let dc = DataController()
            
            dc.getUserFromCloud(userID: self.userID!) { (user) in
                
                // pass user info to MyProfileViewController
                self.profileViewController.defaultURL = user.url
                self.profileViewController.defaultName = user.name
                self.profileViewController.defaultEmail = user.email
                self.isFirstTime = false
            }
        }
        
    }
    
}

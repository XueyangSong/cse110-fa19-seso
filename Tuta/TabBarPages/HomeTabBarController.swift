//
//  HomeTabBarController.swift
//  Tuta
//
//  Created by Zhen Duan on 10/23/19.
//  Copyright © 2019 Zhen Duan. All rights reserved.
//

import Foundation
import UIKit

class HomeTabBarController : UITabBarController, UITabBarControllerDelegate {
    
    public var indexOfVcToBeDisplay : Int = 0

    var searchPageViewController: SearchPageViewController!
    var newPostcarViewController: PopWindowViewController!
    var profileViewController: MyProfileViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        let sb : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        searchPageViewController = sb.instantiateViewController(identifier: "SearchPageViewController") as SearchPageViewController
        newPostcarViewController = sb.instantiateViewController(identifier: "PopWindowViewController") as PopWindowViewController
        profileViewController = sb.instantiateViewController(identifier: "MyProfileViewController") as MyProfileViewController
        
        self.viewControllers = [searchPageViewController, newPostcarViewController, profileViewController]
        
        self.selectedIndex = indexOfVcToBeDisplay
        
//        searchPageViewController = SearchPageViewController()
//        newPostcarViewController = PopWindowViewController()
//        profileViewController = MyProfileViewController()
//        self.viewControllers = [searchPageViewController, newPostcarViewController, profileViewController]
//
//        setUpTabBarItem()
        
    }
    
//    func setUpTabBarItem() {
//
//        eventViewController.tabBarItem.title = "Events"
//        eventViewController.tabBarItem.image = UIImage(named: "home")
//        eventViewController.tabBarItem.selectedImage = UIImage(named: "home-selected")
//
//        searchViewController.tabBarItem.title = "Search"
//        searchViewController.tabBarItem.image = UIImage(named: "search")
//        searchViewController.tabBarItem.selectedImage = UIImage(named: "home-search")
//
//        profileViewController.tabBarItem.title = "Profile"
//        profileViewController.tabBarItem.image = UIImage(named: "contact")
//        profileViewController.tabBarItem.selectedImage = UIImage(named: "home-contact")
//
//        for tabBarItem in tabBar.items! {
//            //tabBarItem.title = ""
//            tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
//        }
//    }
    
    
    
}

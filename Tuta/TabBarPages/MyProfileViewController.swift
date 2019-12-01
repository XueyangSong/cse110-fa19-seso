//
//  MyProfileViewController.swift
//  Tuta
//
//  Created by Jiahe Liu on 11/16/19.
//  Copyright © 2019 Zhen Duan. All rights reserved.
//

import UIKit
import Foundation
import FirebaseFirestore
import FirebaseAuth
import Firebase

private let reuseIdentifier = "MyProfileCell"


class MyProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Properties
    
    lazy var containerView: UIView = {
        let view = UIView()
        
        view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 300)

        
        view.backgroundColor = .mainBlue
        
        view.addSubview(profileImageView)
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.anchor(top: view.topAnchor, paddingTop: 88,
                                width: 120, height: 120)
        profileImageView.layer.cornerRadius = 120 / 2
        
        view.addSubview(backButton)
        backButton.anchor(top: view.topAnchor, left: view.leftAnchor,
                             paddingTop: 64, paddingLeft: 32, width: 32, height: 32)
        
//        view.addSubview(secondButton)
//        secondButton.anchor(top: view.topAnchor, right: view.rightAnchor,
//                             paddingTop: 64, paddingRight: 32, width: 32, height: 32)
        
        view.addSubview(nameLabel)
        nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameLabel.anchor(top: profileImageView.bottomAnchor, paddingTop: 12)
        
        view.addSubview(emailLabel)
        emailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailLabel.anchor(top: nameLabel.bottomAnchor, paddingTop: 4)
        

        return view
    }()
    
    var tableView : UITableView!
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "profilePic_1")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.borderWidth = 3
        iv.layer.borderColor = UIColor.white.cgColor
        return iv
    }()
    
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "backIcon").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(getBack), for: .touchUpInside)
        return button
    }()
    
    let secondButton: UIButton = {

        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "lightbulb").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleMessageUser), for: .touchUpInside)

        return button
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Jason Chen"
        label.font = UIFont.boldSystemFont(ofSize: 26)
        label.textColor = .white
        return label
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "xxxx@ucsd.edu"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .white
        return label
    }()
    
    @objc func getBack() {
        let sb : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(identifier: "MeViewController") as MeViewController
        vc.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        vc.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func handleMessageUser() {
        print("test test test")
        //self.present(vc, animated: true, completion: nil)
        
        
    }
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()

    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setUpUI() {
        view.backgroundColor = .white
        
        view.addSubview(containerView)
        containerView.anchor(top: view.topAnchor, left: view.leftAnchor,
                             right: view.rightAnchor, height: 300)
        configureTableView()
    }
    
    func configureTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 50
        
        tableView.isScrollEnabled = false
        
        tableView.register(EventListCell.self, forCellReuseIdentifier: reuseIdentifier)
        view.addSubview(tableView)
        tableView.frame = CGRect(x: 0,
                                 y: containerView.frame.height,
                                 width: view.frame.width,
                                 height:view.frame.height - containerView.frame.height)
        
        //tableView.tableFooterView = UIView()
    }
    
    // MARK: - Selectors
    
    
    // MARK: - tableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20.0
    }
    
    // set view for footer
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        if section == 2 {
            let footerView = UIView()
            footerView.backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0.94, alpha: 1.0)
            return footerView
//        }
        
    }

    // set height for footer
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 2 {
            let height : CGFloat = 300.0 - 50.0 * 5.0 - 20.0 * 3.0
            return self.view.frame.height - height
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        // build view
        let view = UIView()
        view.backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0.94, alpha: 1.0) // #f2f2f2


        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return 1
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Edit Profile"
                break
            case 1:
                cell.textLabel?.text = "Change Password"
                break
            case 2:
                cell.textLabel?.text = "My Event List"
                break
            default:
                ()
            }
        }
        
        if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Contact Us"
                break
            default:
                ()
            }
        }
        
        if indexPath.section == 2 {
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Log Out"
                break
            default:
                ()
            }
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                let cell = tableView.cellForRow(at: indexPath)
                cell?.isSelected = false
                let sb : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = sb.instantiateViewController(identifier: "ProfileViewController") as ProfileViewController
                vc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
                vc.modalPresentationStyle = UIModalPresentationStyle.automatic
                self.present(vc, animated: true, completion: nil)
            case 1:
                let cell = tableView.cellForRow(at: indexPath)
                cell?.isSelected = false
                let sb : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            case 2:
                let cell = tableView.cellForRow(at: indexPath)
                cell?.isSelected = false
                let sb : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = sb.instantiateViewController(identifier: "EventListViewController") as EventListViewController
                vc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
                vc.modalPresentationStyle = UIModalPresentationStyle.automatic
                self.present(vc, animated: true, completion: nil)
            default:
                ()
            }
        }
        
        else if indexPath.section == 1 {
            
        }
        
        else if indexPath.section == 2 {
            if indexPath.row == 0 {
                print("logging out")
                try! Auth.auth().signOut()
                let sb : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = sb.instantiateViewController(identifier: "logInViewController") as LogInViewController
                vc.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
                vc.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    
}


extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    static let mainBlue = UIColor.rgb(red: 0, green: 150, blue: 255)
}

extension UIView {
    
    func anchor(top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, paddingTop: CGFloat? = 0,
                paddingLeft: CGFloat? = 0, paddingBottom: CGFloat? = 0, paddingRight: CGFloat? = 0, width: CGFloat? = nil, height: CGFloat? = nil) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop!).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft!).isActive = true
        }
        
        if let bottom = bottom {
            if let paddingBottom = paddingBottom {
                bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
            }
        }
        
        if let right = right {
            if let paddingRight = paddingRight {
                rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
            }
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}


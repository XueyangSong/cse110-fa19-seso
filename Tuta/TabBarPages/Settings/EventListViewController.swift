//
//  EventListViewController.swift
//  Tuta
//
//  Created by Zhen Duan on 11/22/19.
//  Copyright © 2019 Zhen Duan. All rights reserved.
//

import UIKit
import Foundation

private let reuseIdentifier = "EventListCell"


class EventListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Properties
    
    // tableView
    var tableView: UITableView!
    // events arrays
    var requestedEventsArray = [Event]()
    var inProgressEventsArray = [Event]()
    var finishedEventsArray = [Event]()
    // 2-D array
    var SectionArray = [
        ExpandableEventsArray(isExpanded: true, events: ["CSE 130 --- with David", "HILD 7A --- with Charlie", "MATH 20C --- with Nguyen", "ECON 100A -- with Eugene", "ECE 100 --- with Hector", "CSE 110 --- with Mathew", "CSE 190 --- Marcus"]),
        ExpandableEventsArray(isExpanded: true, events: ["MATH 189 --- with Zhen", "MATH 191 --- with Gary", "CHEM 6C --- with Leomart", "BILD 10 --- with Snow"]),
        ExpandableEventsArray(isExpanded: true, events: ["EDS 124BR --- with Jamie", "COGS 108 --- with Cersei"]),
    ]
    
    
    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    func configureTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        
        tableView.register(EventListCell.self, forCellReuseIdentifier: reuseIdentifier)
        view.addSubview(tableView)
        tableView.frame = view.frame
        
        tableView.tableFooterView = UIView()
    }
    
    func setUpUI() {
        configureTableView()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.barTintColor = UIColor(red: 55/255, green: 120/255, blue: 250/255, alpha: 1)
        navigationItem.title = "Settings"
    }
    
    
    // MARK: - Fetch data from server
    func fetchEvents() {
        
    }

    
    // MARK: - TableView Configurations
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return EventListSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if !SectionArray[section].isExpanded {
            return 0
        }
        
        return SectionArray[section].events.count

        
//        guard let section = EventListSection(rawValue: section) else { return 0 }
//
//        switch section {
//        case .requested: return 5 //SocialOptions.allCases.count
//        case .inProgress: return 5 //CommunicationOptions.allCases.count
//        case .finished: return 5
//        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        // build view
        let view = UIView()
        view.backgroundColor = UIColor(red: 55/255, green: 120/255, blue: 250/255, alpha: 1)
        
        // build button
        let button = UIButton(type: .system)
        view.addSubview(button)
        button.setTitle("close", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 55/255, green: 120/255, blue: 250/255, alpha: 1)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.tag = section
        button.addTarget(self, action: #selector(handleExpandClose), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        let screenSize = UIScreen.main.bounds
        button.leftAnchor.constraint(equalTo: view.leftAnchor, constant: screenSize.width-50).isActive = true
        
        // build Label
        let title = UILabel()
        view.addSubview(title)
        title.font = UIFont.boldSystemFont(ofSize: 16)
        title.textColor = .white
        title.text = EventListSection(rawValue: section)?.description
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        title.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true

        return view
    }
    
    @objc func handleExpandClose(button: UIButton) {
        print("Trying to expand and close section...")
        
        let section = button.tag
        
        // we'll try to close the section first by deleting the rows
        var indexPaths = [IndexPath]()
        for row in SectionArray[section].events.indices {
            print(0, row)
            let indexPath = IndexPath(row: row, section: section)
            indexPaths.append(indexPath)
        }
        
        let isExpanded = SectionArray[section].isExpanded
        SectionArray[section].isExpanded = !isExpanded
        
        button.setTitle(isExpanded ? "open" : "close", for: .normal)
        
        if isExpanded {
            tableView.deleteRows(at: indexPaths, with: .fade)
        } else {
            tableView.insertRows(at: indexPaths, with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        let event = SectionArray[indexPath.section].events[indexPath.row]
        
        cell.textLabel?.text = event
        
        return cell
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! EventListCell
//        guard let section = EventListSection(rawValue: indexPath.section) else { return UITableViewCell() }
//
//        switch section {
//        case .requested:
//            let type = "requested"
//            print(type)
//            //get cells
//            // color
//        case .inProgress:
//            let type = "inProgress"
//            print(type)
//            // color
//        case .finished:
//            let type = "finished"
//            print(type)
//            // set color
//        }
//
//        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected row: ")
        print(indexPath)
//        guard let section = SettingsSection(rawValue: indexPath.section) else { return }
//
//        switch section {
//        case .Social:
//            print(SocialOptions(rawValue: indexPath.row)?.description)
//        case .Communications:
//            print(CommunicationOptions(rawValue: indexPath.row)?.description)
//        }
    }
}

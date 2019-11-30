//
//  EventListViewController.swift
//  Tuta
//
//  Created by Zhen Duan on 11/22/19.
//  Copyright © 2019 Zhen Duan. All rights reserved.
//

import UIKit
import Foundation
import FirebaseFirestore
import FirebaseAuth
import Firebase

private let reuseIdentifier = "EventListCell"


class EventListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var dc = DataController()
    let uid = Auth.auth().currentUser?.uid
    // MARK: - Properties
    
    // tableView
    var tableView: UITableView!
    var eventList = [Event]()
    // events arrays
    var requestedEventsArray = [String]()
    var inProgressEventsArray = [String]()
    var finishedEventsArray = [String]()

    
    // 2-D array
    
    var SectionArray = [
        ExpandableEventsArray(isExpanded: true, events: [String]()),
        ExpandableEventsArray(isExpanded: true, events: [String]()),
        ExpandableEventsArray(isExpanded: true, events: [String]()),
//        ExpandableEventsArray(isExpanded: true, events: []),
//        ExpandableEventsArray(isExpanded: true, events: []),
//        ExpandableEventsArray(isExpanded: true, events: []),
    ]
    
    // MARK: - Init
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //setUpSectionArray()

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSectionArray()
        setUpUI()
    }
    
    func setUpSectionArray(){
        self.dc.getEventsListFromCloud(userID: uid!){
            (e) in self.eventList = (e)
            for event in self.eventList{
                if event.status == "requested"{
                    self.requestedEventsArray.append(event.eventToString())
                }
                else if event.status == "inProgress"{
                    self.inProgressEventsArray.append(event.eventToString())
                }
                else{
                    self.finishedEventsArray.append(event.eventToString())
                }
            }
            print(self.requestedEventsArray)
            print(self.inProgressEventsArray)
            print(self.finishedEventsArray)
            let requestList = ExpandableEventsArray(isExpanded: true, events: self.requestedEventsArray)
            let inProgressList = ExpandableEventsArray(isExpanded: true, events: self.inProgressEventsArray)
            let finishedList = ExpandableEventsArray(isExpanded: true, events: self.finishedEventsArray)
            print(finishedList.events)
            self.SectionArray = [requestList, inProgressList, finishedList]
            
            // setup table view
            self.configureTableView()

        }
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
        //configureTableView()
        
        
    }
    
    
    func eventToString(event: Event) -> String {
        
        // properties
        let courseName = event.course
        let studentName = event.studentName
        let tutorName = event.tutorName
        
        return "\(courseName) --- tutor: \(tutorName), student: \(studentName)"
    }

    
    // MARK: - TableView Configurations
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return EventListSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if !SectionArray[section].isExpanded {
            return 0
        }
        
        if (section == 2) {
            print("section is: " + String(section))
            let c = SectionArray[2].events.count
            print("number of rows in this section: " + String(c))
            print(SectionArray[2].events)
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Deleted")

            // remove event from the array and the database
            //self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected row: ")
        print(indexPath)
        
        let cell = tableView.cellForRow(at: indexPath)
        
        let sb : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(identifier: "RateViewController") as RateViewController
        
//        vc.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
//        vc.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        self.present(vc, animated: true, completion: nil)
        //let rateViewController = RateViewController(eventID: "string")
        //navigationController?.pushViewController(UIViewController(), animated: true)
        // self.performSegue(withIdentifier: "navToRatePage", sender: cell)
    }
    
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Find the selected event
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!
        let event = finishedEventsArray[indexPath.row]
        let eventID = event.eventID
        print("Selected event ID is >>>>>>>>>>>>>>>>>>> " + eventID)
        
        // Pass the eventID to the rate view controller
        let rateViewController = segue.destination as! RateViewController
        rateViewController.eventID = eventID
    }*/
}

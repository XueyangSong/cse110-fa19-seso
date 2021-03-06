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
private let darkBlueColor = UIColor(red:0.24, green:0.44, blue:0.64, alpha:1.0)


class EventListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var dc = DataController()
    let uid = Auth.auth().currentUser?.uid
    // MARK: - Properties
    
    // tableView
    var tableView: UITableView!
    var eventList = [Event]()
    // events arrays
    var requestedEventsArray = [Event]()
    var inProgressEventsArray = [Event]()
    var finishedEventsArray = [Event]()
    var otherPersonId : String = ""

    
    // 2-D array
    
    var SectionArray = [
        ExpandableEventsArray(isExpanded: true, events: [Event]()),
        ExpandableEventsArray(isExpanded: true, events: [Event]()),
        ExpandableEventsArray(isExpanded: true, events: [Event]()),
//        ExpandableEventsArray(isExpanded: true, events: []),
//        ExpandableEventsArray(isExpanded: true, events: []),
//        ExpandableEventsArray(isExpanded: true, events: []),
    ]
    
    // MARK: - Init
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpSectionArray()
        setUpUI()

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSectionArray()

        
    }
    
    public func setUpSectionArray(){
        self.dc.getEventsListFromCloud(userID: uid!){
            (e) in self.eventList = (e)
            self.requestedEventsArray = []
            self.inProgressEventsArray = []
            self.finishedEventsArray = []
            
            for event in self.eventList{
                if event.status == "requested"{
                    self.requestedEventsArray.append(event)
                }
                else if event.status == "inProgress"{
                    self.inProgressEventsArray.append(event)
                }
                else{
                    self.finishedEventsArray.append(event)
                }
            }
            
            let requestList = ExpandableEventsArray(isExpanded: true, events: self.requestedEventsArray)
            let inProgressList = ExpandableEventsArray(isExpanded: true, events: self.inProgressEventsArray)
            let finishedList = ExpandableEventsArray(isExpanded: true, events: self.finishedEventsArray)
            
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

    
    // MARK: - TableView Configurations
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return EventListSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if !SectionArray[section].isExpanded {
            return 0
        }
        
        if (section == 2) {
//            print("section is: " + String(section))
            let c = SectionArray[2].events.count
//            print(SectionArray[2].events)
        }
        return SectionArray[section].events.count

    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        // build view
        let view = UIView()
        view.backgroundColor = darkBlueColor
        
        // build button
        let button = UIButton(type: .system)
        view.addSubview(button)
        button.setTitle("close", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = darkBlueColor
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
        
        cell.textLabel?.text = event.eventToString(uid: self.uid!)
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // get event
        let event = SectionArray[indexPath.section].events[indexPath.row]
        // remove event from sectionArray
        SectionArray[indexPath.section].events.remove(at: indexPath.row)
        
        if editingStyle == .delete {
            print("Delet event")
            let dc = DataController()
            dc.deleteEvent(event: event)
            setUpSectionArray()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected row: ")
        print(indexPath)
        
        if(indexPath.section == 0) {
            let sb : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(identifier: "ConfirmEventViewController") as ConfirmEventViewController
//            vc.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
//            vc.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                        
            // get event
            vc.titleString = String((tableView.cellForRow(at: indexPath)?.textLabel!.text)!)
            vc.otherPersonId = self.otherPersonId
            let event = SectionArray[indexPath.section].events[indexPath.row]
            // pass event ID into view controller
            vc.setEvent(event: event)
            // pass self to view controller
            vc.parentVC = self
            vc.otherPersonId = event.getOtherPersonId()

            self.present(vc, animated: true, completion: nil)
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        if(indexPath.section == 1) {
            let sb : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(identifier: "FinishEventViewController") as FinishEventViewController
            //            vc.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
            //            vc.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                                    
            // get event
            let event = SectionArray[indexPath.section].events[indexPath.row]
            // pass event ID into view controller
            vc.setEvent(event: event)
            // pass self to view controller
            vc.parentVC = self
                                    
            self.present(vc, animated: true, completion: nil)
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        if(indexPath.section == 2) {
            let sb : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(identifier: "RateViewController") as RateViewController
            
            // get event
            let event = SectionArray[indexPath.section].events[indexPath.row]
            // pass event ID into view controller
            vc.setEvent(event: event)
            
            self.present(vc, animated: true, completion: nil)
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
    }
}

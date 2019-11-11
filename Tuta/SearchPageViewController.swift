//
//  SearchPageViewController.swift
//  Tuta
//
//  Created by Yixing Wang on 11/8/19.
//  Copyright © 2019 Zhen Duan. All rights reserved.
//

import UIKit
import Firebase

class SearchPageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Properties
    @IBOutlet weak var postcardTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let db = Firestore.firestore()
    var posts = [[String:Any]]()
    var filteredPosts = [[String:Any]]()
    var searching = false
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        postcardTableView.delegate = self
        postcardTableView.dataSource = self
        
        getCollection()

    }
    
    
    // MARK: - Functions
    private func getCollection() {
        db.collection("postCards").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    // TODO: Maybe here you want to just give documents to posts, instead of appending data to posts.
                    self.posts.append(document.data())
                }
                // Very important, to reload data to the table view after the async call of getDocuments.
                self.postcardTableView.reloadData()
                print(self.posts)
            }
        }
    }
    
    private func convertTimestamp(serverTimestamp: Int64) -> String {
        let x = Double(serverTimestamp) / 1000
        let date = NSDate(timeIntervalSince1970: x)
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .medium

        return formatter.string(from: date as Date)
    }
    
    // MARK: - DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return filteredPosts.count
        } else{
            return posts.count
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = postcardTableView.dequeueReusableCell(withIdentifier: "PostcardTableViewCell", for: indexPath) as! PostcardTableViewCell
        
        var post:[String:Any]
        if searching {
            post = filteredPosts[indexPath.row]
        } else{
            post = posts[indexPath.row]
        }

        
        // TODO: Here we might want to create a post object.
        // TODO: if let maybe safer!
        let course = post["course"] as! String
        let username = post["username"] as! String
        let description = post["description"] as! String
        let timestamp = post["time"] as! Timestamp
        let time = convertTimestamp(serverTimestamp: timestamp.seconds)
        let rating = post["rating"] as! NSNumber
        let numOfRatings = post["numOfRatings"] as! NSNumber
        
        cell.courseLabel!.text = course
        cell.usernameLabel!.text = username
        cell.descriptionLabel!.text = description
        cell.timeLabel!.text = time
        cell.ratingLabel!.text = "Rating: \(rating)"
        cell.numRatingsLabel!.text = "\(numOfRatings) People rated"
        
        
        return cell
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

extension SearchPageViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        // TODO: Omit whitespace
        filteredPosts = posts.filter( {($0["course"] as! String).lowercased().prefix(searchText.count) == searchText.lowercased()} )
        //print(filteredPosts)
        searching = true
        postcardTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        view.endEditing(true)
        postcardTableView.reloadData()
    }
}

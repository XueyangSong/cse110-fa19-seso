//
//  SearchPageViewController.swift
//  Tuta
//
//  Created by Yixing Wang on 11/8/19.
//  Copyright © 2019 Zhen Duan. All rights reserved.
//

import UIKit

class SearchPageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Properties
    @IBOutlet weak var postcardTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchForSegment: UISegmentedControl!
    
    let dc = DataController()
    
    var posts = [[String:Any]]()
    var filteredPosts = [[String:Any]]()
    var searching = false
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        postcardTableView.delegate = self
        postcardTableView.dataSource = self
        
        searchForSegment.addTarget(self, action: #selector(onModeSwitch(sender:)), for: .valueChanged)
        
    }
    
    
    // MARK: - Functions
    
    private func convertTimestamp(serverTimestamp: Int64) -> String {
        let x = Double(serverTimestamp) / 1000
        let date = NSDate(timeIntervalSince1970: x)
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .medium

        return formatter.string(from: date as Date)
    }
    
    // MARK: - Tableview DataSource Configuration
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

        let postCardObj = PostCard(value:post)
        let postDic = postCardObj.getCardData()

        
        cell.courseLabel!.text = postDic["course"] as! String
        cell.usernameLabel!.text = postDic["creatorName"] as! String
        cell.descriptionLabel!.text = postDic["description"] as! String
        cell.timeLabel!.text = (postDic["time"] as! String) + "  " + (postDic["date"] as! String)
        cell.ratingLabel!.text = "Rating: " + String(postDic["rate"] as! Double)
        cell.numRatingsLabel!.text = String(postDic["numRate"] as! Int) + " People rated"
        
        cell.descriptionLabel.sizeToFit()
        
        return cell
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Find the select postCard
        let cell = sender as! UITableViewCell
        let indexPath = postcardTableView.indexPath(for: cell)!
        var post : [String:Any]!
        if searching {
            post = filteredPosts[indexPath.row]
        } else {
            post = posts[indexPath.row]
        }

        // Pass the selected postCard to other's profile page
        let othersProfileViewController = segue.destination as! ViewProfileViewController
        othersProfileViewController.post = post
    }
    

}

// MARK: - Search Bar Functions
extension SearchPageViewController: UISearchBarDelegate{
    /*func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        // TODO: Omit whitespace
        filteredPosts = posts.filter( {($0["course"] as! String).lowercased().prefix(searchText.count) == searchText.lowercased()} )
        //print(filteredPosts)
        searching = true
        postcardTableView.reloadData()
    }*/
    

    // Turn off the auto-correction, auto-capitalization and spell-checking of the search keyboard.

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.searchTextField.autocorrectionType = .no
        searchBar.searchTextField.autocapitalizationType = .none
        searchBar.searchTextField.spellCheckingType = .no
    }
    

    func search() {
        let index = self.searchForSegment.selectedSegmentIndex
        
        searching = true
        
        if(searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ){
            return;
        }
        
        let course = String(searchBar.text!.lowercased().filter{!$0.isNewline && !$0.isWhitespace})
        view.endEditing(true)
        var type = self.searchForSegment.titleForSegment(at: index) as! String
        type = type.lowercased()
        
        dc.getCardsCollection(type: type, course: course) { (postsFromCloud) in
            self.filteredPosts = postsFromCloud
            self.postcardTableView.reloadData()
        }
    }
    

    @objc func onModeSwitch(sender: UISegmentedControl){
        search()
    }
    


    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        search()
    }
    


    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        view.endEditing(true)
        postcardTableView.reloadData()
    }
}

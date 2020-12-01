//
//  FollowerListViewController.swift
//  Artwander
//
//  Created by Stefan Tanaskovic on 2020-11-27.
//  Copyright © 2020 Stefan Tanaskovic. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class FollowerListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate

    // Data model: These strings will be the data for the table view cells
    var followers: [SimpleUser] = []
    let firestoreDB = Firestore.firestore()
    var user : SimpleUser = SimpleUser()
    // cell reuse id (cells that scroll out of view can be reused)
    let cellReuseIdentifier = "cell"
    
    // don't forget to hook this up from the storyboard
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFollowers()
        // Register the table view cell class and its reuse id
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        // (optional) include this line if you want to remove the extra empty cell divider lines
        // self.tableView.tableFooterView = UIView()

        // This view controller itself will provide the delegate methods and row data for the table view.
        tableView.delegate = self
        tableView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        loadFollowers()
    }
    
    func loadFollowers(){
        for follower in mainDelegate.currentUserObj.followers{
            print(1)
            self.firestoreDB.collection("users").document(follower).getDocument { (document, err) in
                self.user = SimpleUser()
                self.user.name = document!.get("full_name") as! String
                self.user.profilePic = document!.get("profile_pic") as! String
                self.followers.append(self.user)
                print(self.followers)
            }
        }

    }
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.followers.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:UITableViewCell = (self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell?)!
        
        // set the text from the data model
        cell.textLabel?.text = self.followers[indexPath.row].name

        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
}

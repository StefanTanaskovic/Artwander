//
//  FollowingListViewController.swift
//  Artwander
//
//  Created by Stefan Tanaskovic on 2020-11-27.
//  Copyright © 2020 Stefan Tanaskovic. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class followTableViewCell: UITableViewCell {
    @IBOutlet weak var imgProfileCell: UIImageView!
    @IBOutlet weak var lblName: UILabel!
}

class FollowingListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    let cellReuseIdentifier = "cell"
    var db: Firestore!
    var followList: [String] = []
    

    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        db = mainDelegate.firestoreDB
        let cell = tableView.dequeueReusableCell(withIdentifier: "followCell", for: indexPath) as! followTableViewCell
        if followList != []{
            self.db.collection("users").document(followList[indexPath.row]).getDocument { (document, err) in
                cell.imgProfileCell.layer.cornerRadius = cell.imgProfileCell.frame.height/2
                cell.imgProfileCell.clipsToBounds = true
                cell.lblName!.text =  (document!.get("full_name") as! String)
                let url = URL(string: document!.get("profile_pic") as! String)
                cell.imgProfileCell.kf.setImage(with: url)
            }
        }
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
    

    
}

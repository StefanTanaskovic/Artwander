//
//  OtherUserProfileViewController.swift
//  Artwander
//
//  Created by Stefan Tanaskovic on 2020-11-29.
//  Copyright © 2020 Stefan Tanaskovic. All rights reserved.
//


import UIKit
import Firebase
import FirebaseFirestore
import Kingfisher

class OtherUserProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var btnFollower: UIButton!
    @IBOutlet weak var btnFollowing: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var profilePicView: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var btnFollowlbl: UIButton!
    var post_id_list : [String] = []
    var posts: [Post] = []
    var bounds = UIScreen.main.bounds
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    var poster : String = ""
    var db: Firestore!
    var follow : Bool = false
    var followerListPoster: [String] = []
    var followerCountPoster: Int = 0
    var followingListPoster: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUser {() -> () in
            self.refreshView()
        }
        btnFollowlbl.layer.cornerRadius = 20
        btnFollowlbl.layer.borderWidth = 2
        btnFollowlbl.layer.borderColor = UIColor(red: 0.75, green: 0.36, blue: 0.86, alpha: 1.00).cgColor
        profilePicView.layer.borderWidth = 2
        profilePicView.layer.masksToBounds = false
        profilePicView.layer.borderColor =  UIColor.black.cgColor
        profilePicView.layer.cornerRadius = profilePicView.frame.height/2
        profilePicView.clipsToBounds = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkFollow()
    }
    
    func checkFollow() {
        for name in mainDelegate.currentUserObj.following{
            if name == poster {
                self.follow = true
            }
        }
        if follow == true {
            btnFollowlbl.backgroundColor = UIColor(red: 0.75, green: 0.36, blue: 0.86, alpha: 1.00)
            btnFollowlbl.setTitleColor(UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00), for: .normal)
            btnFollowlbl.setTitle("Following", for: .normal)
        }
    }
    
    func updateUser(completion: @escaping () -> Void) {
        db = mainDelegate.firestoreDB
        let docRefUsers = db.collection("users").document(poster)
        let docRefPosts = db.collection("posts")
        docRefUsers.getDocument { (snapshot, err) in
        if let data = snapshot?.data() {
            self.profileName.text = data["full_name"] as? String
            self.btnFollower.setTitle(String(data["followerCount"] as! Int), for: .normal)
            self.btnFollowing.setTitle(String(data["followingCount"] as! Int), for: .normal)
            self.followerCountPoster = data["followerCount"] as! Int
            self.followerListPoster = data["followers"] as! [String]
            self.followingListPoster = data["following"] as! [String]
            let url = URL(string: data["profile_pic"] as! String)
            self.profilePicView.kf.setImage(with: url)
            self.post_id_list = data["posts"] as! [String]
            completion()
            for post in self.post_id_list {
                self.collectionView.delegate = self
                self.collectionView.dataSource = self
                docRefPosts.document(post).getDocument { (snapshot, err) in
                if let data1 = snapshot?.data() {
                    self.posts.append(Post(name: data1["name"] as! String, caption: data1["caption"] as! String, image: data1["image"] as! String,profilePic: data1["profile_pic"] as! String, likeAmount: data1["like_amount"] as! Int, poster: data1["poster"] as! String  ))
                        completion()
                    }
                }
            }}
        }
    }
    
    @IBAction func btnFollower(_ sender: Any) {
        performSegue(withIdentifier: "toFollower", sender: btnFollowing )
    }
    @IBAction func btnFollowing(_ sender: Any) {
        performSegue(withIdentifier: "toFollow", sender: btnFollowing )
    }
    @IBAction func btnFollow(_ sender: Any) {
        if follow == true {
            let alertController = UIAlertController(title: "Unfollow?", message: "Are you sure?", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive) {
                 UIAlertAction in
                
                //Update button
                self.btnFollowlbl.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
                self.btnFollowlbl.setTitleColor(UIColor(red: 0.75, green: 0.36, blue: 0.86, alpha: 1.00), for: .normal)
                self.btnFollowlbl.setTitle("Follow", for: .normal)
                self.follow = false
                
                //update current user
                self.mainDelegate.currentUserObj.following.removeAll(where: { $0 == self.poster })
                self.mainDelegate.currentUserObj.followingCount -= 1
                self.updateFollow(user: self.mainDelegate.currentUserId!, count: self.mainDelegate.currentUserObj.followingCount, list: self.mainDelegate.currentUserObj.following)
                
                //update other user
                self.followerListPoster.removeAll(where: { $0 == self.mainDelegate.currentUserId! })
                self.followerCountPoster -= 1
                self.updateFollow(user: self.poster, count: self.followerCountPoster, list: self.followerListPoster)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }else{
            //Update Button
            btnFollowlbl.backgroundColor = UIColor(red: 0.75, green: 0.36, blue: 0.86, alpha: 1.00)
            btnFollowlbl.setTitleColor(UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00), for: .normal)
            btnFollowlbl.setTitle("Following", for: .normal)
            follow = true
            
            //update user
            mainDelegate.currentUserObj.followingCount += 1
            mainDelegate.currentUserObj.following = mainDelegate.currentUserObj.following + [poster]
            updateFollow(user: mainDelegate.currentUserId!, count: mainDelegate.currentUserObj.followingCount, list: mainDelegate.currentUserObj.following)
            
            //update other user
            followerListPoster = followerListPoster + [mainDelegate.currentUserId!]
            followerCountPoster += 1
            updateFollow(user: self.poster, count: self.followerCountPoster, list: self.followerListPoster)
        }
    }
    
    func updateFollow(user: String, count : Int, list: [String]){
        let ref = db.collection("users").document(user)
        if user == mainDelegate.currentUserId {
            ref.updateData([
                "followingCount": count,
                "following" : list
            ])
        }else {
            ref.updateData([
                "followerCount": count,
                "followers" : list
            ])
        }
    }

    func refreshView() {
        collectionView.reloadData()
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "presentPopup" {
            let vc = segue.destination as? ProfileCellViewController
            vc?.text = String(format: "%@", sender! as! CVarArg)
            vc?.posts = posts
        }else if segue.identifier == "toFollow"{
            let vc = segue.destination as? FollowingListViewController
            vc?.followList = followingListPoster
        }else if segue.identifier == "toFollower"{
            let vc = segue.destination as? FollowerListViewController
            vc?.followerList = followerListPoster
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "presentPopup", sender: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let noOfCellsInRow = 3

        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout

        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
        return CGSize(width: size, height: size)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let post = posts[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! CollectionViewCell
        let url = URL(string: post.image)
        cell.imageCell.kf.setImage(with: url)
        return cell
    }
    

}


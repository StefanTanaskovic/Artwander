//
//  ProfileViewController.swift
//  Artwander
//
//  Created by Stefan Tanaskovic on 2020-11-21.
//  Copyright © 2020 Stefan Tanaskovic. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import Kingfisher

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var btnFollower: UIButton!
    @IBOutlet weak var btnFollowing: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profilePicView: UIImageView!
    @IBOutlet weak var editProfileBtn: UIButton!
    var bounds = UIScreen.main.bounds
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        editProfileBtn.layer.cornerRadius = 20
        editProfileBtn.layer.borderWidth = 2
        editProfileBtn.layer.borderColor =  UIColor.gray.cgColor
        
        profilePicView.layer.borderWidth = 2
        profilePicView.layer.masksToBounds = false
        profilePicView.layer.borderColor =  UIColor.black.cgColor
        profilePicView.layer.cornerRadius = profilePicView.frame.height/2
        profilePicView.clipsToBounds = true
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
        profileName.text =  mainDelegate.currentUserObj.name
        btnFollower.setTitle(String(mainDelegate.currentUserObj.followerCount), for: .normal)
        btnFollowing.setTitle(String(mainDelegate.currentUserObj.followingCount), for: .normal)
        let url = URL(string: mainDelegate.currentUserObj.profilePic)
        profilePicView.kf.setImage(with: url)
    }
    
    
    @IBAction func btnEditProfile(_ sender: Any) {
        performSegue(withIdentifier: "toEditProfile", sender: editProfileBtn )
    }
    
    @IBAction func btnFollower(_ sender: UIButton) {
        performSegue(withIdentifier: "toFollower", sender: btnFollow )
    }
    @IBAction func btnFollow(_ sender: Any) {
        performSegue(withIdentifier: "toFollow", sender: btnFollow )
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "presentPopup" {
            let vc = segue.destination as? ProfileCellViewController
            vc?.text = String(format: "%@", sender! as! CVarArg)
            vc?.posts = mainDelegate.currentUserObj.Posts
        }else if segue.identifier == "toEditProfile"{
            let vc = segue.destination as? EditProfileViewController
            vc?.profilePic = profilePicView.image!
            vc?.name = profileName.text!
        }else if segue.identifier == "toFollow"{
            let vc = segue.destination as? FollowingListViewController
            vc?.followList = mainDelegate.currentUserObj.following
        }
        else if segue.identifier == "toFollower"{
            let vc = segue.destination as? FollowerListViewController
            vc?.followerList = mainDelegate.currentUserObj.followers
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return mainDelegate.currentUserObj.Posts.count 
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
        let post = mainDelegate.currentUserObj.Posts[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! CollectionViewCell
        let url = URL(string: post.image)
        cell.imageCell.kf.setImage(with: url)
        return cell
    }
}

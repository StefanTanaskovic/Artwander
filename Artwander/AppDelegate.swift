//
//  AppDelegate.swift
//  Artwander
//
//  Created by Stefan Tanaskovic on 2020-11-18.
//  Copyright © 2020 Stefan Tanaskovic. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var firestoreDB : Firestore?
    var currentUserId : String?
    var currentUserObj : ArtUser = ArtUser()
    var post : Post = Post()
    var post_id_list : [String] = []
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        firestoreDB = Firestore.firestore()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func updateCurrentUser() {
        self.firestoreDB?.collection("users").document(self.currentUserId!).getDocument { (document, err) in
            self.currentUserObj = ArtUser()
            self.currentUserObj.name = document!.get("full_name") as! String
            self.currentUserObj.email = document!.get("email") as! String
            self.currentUserObj.followerCount = document!.get("followerCount") as! Int
            self.currentUserObj.followingCount = document!.get("followingCount") as! Int
            self.currentUserObj.followers = document!.get("followers") as! [String]
            self.currentUserObj.following = document!.get("following") as! [String]
            self.currentUserObj.profilePic = document!.get("profile_pic") as! String
            self.post_id_list = (document!.get("posts") as? [String])!
            for post in self.post_id_list {
                self.firestoreDB?.collection("posts").document(post).getDocument { (document1, err) in
                    self.post = Post()
                    self.post.name = document1!.get("name") as! String
                    self.post.caption = document1!.get("caption") as! String
                    self.post.image =  document1!.get("image") as! String
                    self.post.profilePic = document1!.get("profile_pic") as! String
                    self.post.likeAmount =  document1!.get("like_amount") as! Int
                    self.post.poster =  document1!.get("poster") as! String
                    self.currentUserObj.Posts.append(self.post)
                }
                
            }
        }
    }


}


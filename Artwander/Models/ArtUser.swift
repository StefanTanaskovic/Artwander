//
//  ArtUser.swift
//  Artwander
//
//  Created by Stefan Tanaskovic on 2020-11-19.
//  Copyright © 2020 Stefan Tanaskovic. All rights reserved.
//

import Foundation

class ArtUser: NSObject {
    
    var name : String
    var email : String
    var Posts : [Post]
    var followers : [String]
    var following : [String]
    var profilePic: String
    var followerCount : Int
    var followingCount : Int

    override init() {
        self.name = ""
        self.email = ""
        self.Posts = []
        self.followers = []
        self.following = []
        self.followerCount = 0
        self.followingCount = 0
        self.profilePic = "https://firebasestorage.googleapis.com/v0/b/artwander.appspot.com/o/noimage_person.png?alt=media&token=158900fc-1532-491a-ab68-e201687fdfc8"
    }

    init(id: String,name: String, email: String, post: [Post], followers: [String],following: [String], profilePic: String, followerCount: Int,followingCount: Int) {
        self.name = name
        self.email = email
        self.Posts = post
        self.followers = followers
        self.following = following
        self.profilePic = profilePic
        self.followerCount = followerCount
        self.followingCount = followingCount
    }
}

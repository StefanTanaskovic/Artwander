//
//  Post.swift
//  Artwander
//
//  Created by Stefan Tanaskovic on 2020-11-20.
//  Copyright © 2020 Stefan Tanaskovic. All rights reserved.
//

import Foundation
import UIKit

class Post : NSObject {
    var name: String
    var caption: String
    var image: String
    var profilePic: String
    var likeAmount: Int
    var poster: String
    
    override init() {
        self.name = ""
        self.caption = ""
        self.image = ""
        self.likeAmount = 0
        self.poster = ""
        self.profilePic = ""
    }
    
    init(name: String, caption: String, image: String, profilePic: String, likeAmount: Int, poster: String) {
        self.name = name
        self.caption = caption
        self.image = image
        self.likeAmount = likeAmount
        self.poster = poster
        self.profilePic = profilePic
    }
}


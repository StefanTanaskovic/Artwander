//
//  Post.swift
//  Artwander
//
//  Created by Stefan Tanaskovic on 2020-11-20.
//  Copyright © 2020 Stefan Tanaskovic. All rights reserved.
//

import Foundation
import UIKit

class Post {
    let name: String!
    let caption: String!
    let image: UIImage
    let profilePic: UIImage
    var likeState: Bool
    var likeAmount: Int
    let poster: String

    init(name: String, caption: String, image: UIImage, profilePic: UIImage, likeState: Bool, likeAmount: Int, poster: String) {
        self.name = name
        self.caption = caption
        self.image = image
        self.profilePic = profilePic
        self.likeState = likeState
        self.likeAmount = likeAmount
        self.poster = poster
        
    }
}


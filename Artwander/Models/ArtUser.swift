//
//  ArtUser.swift
//  Artwander
//
//  Created by Stefan Tanaskovic on 2020-11-19.
//  Copyright © 2020 Stefan Tanaskovic. All rights reserved.
//

import Foundation

class ArtUser : NSObject {
    
    var id : String?
    var name : String
    var email : String
    var Posts : [Post]?
    
    override init() {
        self.name = ""
        self.email = ""
    }

    init(name: String, email: String, post: [Post]) {
        self.name = name
        self.email = email
        self.Posts = post
    }
}

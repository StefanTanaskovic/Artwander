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

    /**
        Initialize an empty/default object of this class.
    */
    override init() {
        self.name = ""
        self.email = ""
    }

    /**
        Initialize an object of this class with data.
        - Parameter name: The full name of the user.
        - Parameter email: The email address of the user.
        - Parameter campus: The campus of the user.
        - Parameter program: The program the user is taking at Sheridan.
    */
    init(name: String, email: String) {
        self.name = name
        self.email = email
    }
}

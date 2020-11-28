//
//  SimpleUser.swift
//  Artwander
//
//  Created by Stefan Tanaskovic on 2020-11-27.
//  Copyright © 2020 Stefan Tanaskovic. All rights reserved.
//
import Foundation
import UIKit

class SimpleUser: NSObject {
    
    var name : String
    var profilePic: String

    override init() {
        self.name = ""
        self.profilePic = "https://firebasestorage.googleapis.com/v0/b/artwander.appspot.com/o/noimage_person.png?alt=media&token=158900fc-1532-491a-ab68-e201687fdfc8"
    }

    init(name: String, profilePic: String) {
        self.name = name
        self.profilePic = profilePic
    }
}

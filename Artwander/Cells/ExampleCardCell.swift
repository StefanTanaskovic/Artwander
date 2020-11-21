//
//  ExampleCardCell.swift
//  Artwander
//
//  Created by Stefan Tanaskovic on 2020-11-20.
//  Copyright © 2020 Stefan Tanaskovic. All rights reserved.
//

import Foundation
import UIKit
import VerticalCardSwiper


class ExampleCardCell: CardCell, UIGestureRecognizerDelegate {
    

    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var ageLbl: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var profilePicView: UIImageView!
    

    public func setBackgroundColor() {
        imageView.layer.cornerRadius = 10
        ageLbl.numberOfLines = 3
        ageLbl.sizeToFit()

        profilePicView.layer.borderWidth = 2
        profilePicView.layer.masksToBounds = false
        profilePicView.layer.borderColor = (UIColor(red: 187/255, green: 134/255, blue: 252/255, alpha: 1)).cgColor
        profilePicView.layer.cornerRadius = profilePicView.frame.height/2
        profilePicView.clipsToBounds = true
        self.backgroundColor =  UIColor(red: 29/255, green: 29/255, blue: 29/255, alpha: 1)
    }
    
    

    override func prepareForReuse() {
        super.prepareForReuse()

    }

    override func layoutSubviews() {

        self.layer.cornerRadius = 12
        super.layoutSubviews()
    }
    

}

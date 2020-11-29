import Foundation
import UIKit
import VerticalCardSwiper


class ExampleCardCell: CardCell, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var ageLbl: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var profilePicView: UIImageView!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var profileBtn: UIButton!
    @IBOutlet weak var purchaseBtn: UIButton!
    
    public func setBackgroundColor() {
        likeBtn.imageView?.contentMode = .scaleAspectFit
        commentBtn.imageView?.contentMode = .scaleAspectFit
        profileBtn.imageView?.contentMode = .scaleAspectFit
        purchaseBtn.imageView?.contentMode = .scaleAspectFit
        
        likeBtn.imageEdgeInsets = UIEdgeInsets(top: 25, left: 25, bottom: 25, right: 25)
        commentBtn.imageEdgeInsets = UIEdgeInsets(top: 25, left: 25, bottom: 25, right: 25)
        profileBtn.imageEdgeInsets = UIEdgeInsets(top: 25, left: 25, bottom: 25, right: 25)
        purchaseBtn.imageEdgeInsets = UIEdgeInsets(top: 25, left: 25, bottom: 25, right: 25)
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

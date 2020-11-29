import Foundation
import UIKit
import VerticalCardSwiper


class ExampleCardCell: CardCell, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCaption: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var profilePicView: UIImageView!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnComment: UIButton!
    @IBOutlet weak var btnProfile: UIButton!
    @IBOutlet weak var btnPurchase: UIButton!
    var onClickCallBackProfile: (() -> Void)?
    var onClickCallBackComment: (() -> Void)?
    var onClickCallBackLike: (() -> Void)?
    var onClickCallBackPurchase: (() -> Void)?

    public func setBackgroundColor() {
        btnLike.imageView?.contentMode = .scaleAspectFit
        btnComment.imageView?.contentMode = .scaleAspectFit
        btnProfile.imageView?.contentMode = .scaleAspectFit
        btnPurchase.imageView?.contentMode = .scaleAspectFit
        
        btnLike.imageEdgeInsets = UIEdgeInsets(top: 25, left: 25, bottom: 25, right: 25)
        btnComment.imageEdgeInsets = UIEdgeInsets(top: 25, left: 25, bottom: 25, right: 25)
        btnProfile.imageEdgeInsets = UIEdgeInsets(top: 25, left: 25, bottom: 25, right: 25)
        btnPurchase.imageEdgeInsets = UIEdgeInsets(top: 25, left: 25, bottom: 25, right: 25)
        imageView.layer.cornerRadius = 10
        lblCaption.numberOfLines = 3
        lblCaption.sizeToFit()

        profilePicView.layer.borderWidth = 2
        profilePicView.layer.masksToBounds = false
        profilePicView.layer.borderColor = (UIColor(red: 187/255, green: 134/255, blue: 252/255, alpha: 1)).cgColor
        profilePicView.layer.cornerRadius = profilePicView.frame.height/2
        profilePicView.clipsToBounds = true
        self.backgroundColor =  UIColor(red: 29/255, green: 29/255, blue: 29/255, alpha: 1)
    }

    @IBAction func btnProfile(_ sender: Any) {
        onClickCallBackProfile?()
    }

    @IBAction func btnComment(_ sender: Any) {
        onClickCallBackComment?()

    }
    @IBAction func btnLike(_ sender: Any) {
        onClickCallBackLike?()

    }
    @IBAction func btnPurchase(_ sender: Any) {
        onClickCallBackPurchase?()

    }
    override func prepareForReuse() {
        super.prepareForReuse()

    }

    override func layoutSubviews() {

        self.layer.cornerRadius = 12
        super.layoutSubviews()
    }
    

}

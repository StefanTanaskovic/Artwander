//
//  HomeViewController.swift
//  Artwander
//
//  Created by Stefan Tanaskovic on 2020-11-20.
//  Copyright © 2020 Stefan Tanaskovic. All rights reserved.
//

import UIKit
import VerticalCardSwiper
import Kingfisher
import Firebase

class HomeViewController: UIViewController, VerticalCardSwiperDelegate, VerticalCardSwiperDatasource, UIGestureRecognizerDelegate {
    
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var msgBtn: UIButton!
    var db: Firestore!
    @IBOutlet weak var profileBtn: UIButton!
    @IBOutlet weak var purchaseBtn: UIButton!
    var selectedSegnment = 1
    @IBOutlet var cardSwiper: VerticalCardSwiper!
    var poster : String = ""
    var user : ArtUser = ArtUser()
    var post : Post = Post()
    var post_id_list : [String] = []
    var contactsDemoData: [Post] = [
        Post(name: "John Doe", caption: "This water color painting took me 10 hours but finally finished", image: "art2.jpg",profilePic: "profile1", likeAmount: 0, poster: "ritF6fmPgQZylfHFpFQcDBwd1913"  ),
        Post(name: "John Doe", caption: "This water color painting took me 10 hours but finally finishedThis water color painting took me 10 hours but finally finishedThis water color painting took me 10 hours but finally finished", image: "art2.jpg",profilePic: "profile1", likeAmount: 0, poster: "QG5AUgn3MNWQpp1fRUTOj9t6EPs1"  ),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        let rect = CGRect(origin: CGPoint(x: 0,y :125), size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 210))
        self.cardSwiper.frame = rect

        self.view.insertSubview(self.cardSwiper, at: 0)
        cardSwiper.delegate = self
        cardSwiper.datasource = self

        // register cardcell for storyboard use
        cardSwiper.register(nib: UINib(nibName: "ExampleCell", bundle: nil), forCellWithReuseIdentifier: "ExampleCell")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toProfile" {
            let vc = segue.destination as? OtherUserProfileViewController
            vc?.poster = poster
        }
    }
    

    func cardForItemAt(verticalCardSwiperView: VerticalCardSwiperView, cardForItemAt index: Int) -> CardCell {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.imageTapped(sender:)))
        tapGesture.delegate = self
        
        if let cardCell = verticalCardSwiperView.dequeueReusableCell(withReuseIdentifier: "ExampleCell", for: index) as? ExampleCardCell {
            var likeState : Bool = false
            let post = contactsDemoData[index]
            cardCell.setBackgroundColor()
            
            cardCell.onClickCallBackProfile = {
                self.poster = post.poster
                self.performSegue(withIdentifier: "toProfile", sender: self)
            }
            
            cardCell.onClickCallBackLike = {
                let state = self.activateLike(bool: likeState)
                if state == true{
                    likeState = true
                    cardCell.btnLike.setImage(UIImage(systemName: "heart.fill", withConfiguration: .none), for: .normal)
                }else{
                    likeState = false
                    cardCell.btnLike.setImage(UIImage(systemName: "heart", withConfiguration: .none), for: .normal)
                }
            }
            
            cardCell.onClickCallBackComment = {
//                self.performSegue(withIdentifier: "toComments", sender: self)
            }
            
            cardCell.onClickCallBackPurchase = {
//                self.performSegue(withIdentifier: "toPurchase", sender: self)
            }
            
            cardCell.lblName.text = post.name
            cardCell.lblCaption.text = post.caption
            cardCell.imageView.image = UIImage(named: "art2.jpg")
            cardCell.profilePicView.image = UIImage(named: "art2.jpg")
            
            cardCell.imageView.addGestureRecognizer(tapGesture)
            cardCell.imageView.isUserInteractionEnabled = true
            
            return cardCell
            
        }

        return CardCell()
    }
    
    func activateLike(bool: Bool) -> Bool{
        if bool == false{
            return true
        }else{
            return false

        }
    }
    

    @objc func imageTapped(sender: UITapGestureRecognizer) {
        print(sender)
        let imageView = sender.view as! UIImageView
            let newImageView = UIImageView(image: imageView.image)
            newImageView.frame = UIScreen.main.bounds
            newImageView.backgroundColor = .black
            newImageView.contentMode = .scaleAspectFit
            newImageView.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
            newImageView.addGestureRecognizer(tap)
            self.view.addSubview(newImageView)
            self.navigationController?.isNavigationBarHidden = true
            self.tabBarController?.tabBar.isHidden = true
        }

    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
            self.navigationController?.isNavigationBarHidden = false
            self.tabBarController?.tabBar.isHidden = false
            sender.view?.removeFromSuperview()
        }



    func numberOfCards(verticalCardSwiperView: VerticalCardSwiperView) -> Int {
            return contactsDemoData.count
    }

    func willSwipeCardAway(card: CardCell, index: Int, swipeDirection: SwipeDirection) {
        // called right before the card animates off the screen.
    
            
            print(swipeDirection.rawValue)
            if index < contactsDemoData.count {
                contactsDemoData.remove(at: index)
            }
        

    }

    func didScroll(verticalCardSwiperView: VerticalCardSwiperView) {
            let currentCard = contactsDemoData[cardSwiper.focussedCardIndex!]
    }

    func didSwipeCardAway(card: CardCell, index: Int, swipeDirection: SwipeDirection) {
        // called when a card has animated off screen entirely.
    }
}

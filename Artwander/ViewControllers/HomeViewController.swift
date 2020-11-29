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
class HomeViewController: UIViewController, VerticalCardSwiperDelegate, VerticalCardSwiperDatasource, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var msgBtn: UIButton!
    
    @IBOutlet weak var profileBtn: UIButton!
    @IBOutlet weak var purchaseBtn: UIButton!
    var selectedSegnment = 1
    @IBOutlet var cardSwiper: VerticalCardSwiper!

    var contactsDemoData: [Post] = [
        Post(name: "John Doe", caption: "This water color painting took me 10 hours but finally finished", image: "art2.jpg",profilePic: "profile1", likeAmount: 0, poster: "String"  ),
        Post(name: "John Doe", caption: "This water color painting took me 10 hours but finally finishedThis water color painting took me 10 hours but finally finishedThis water color painting took me 10 hours but finally finished", image: "art2.jpg",profilePic: "profile1", likeAmount: 0, poster: "String"  ),
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
    

    


    @IBAction func toProfile(_ sender: Any) {
            performSegue(withIdentifier: "toProfile", sender: self)
    }
    



    @IBAction func pressScrollDown(_ sender: UIBarButtonItem) {
        if let currentIndex = cardSwiper.focussedCardIndex {
            _ = cardSwiper.scrollToCard(at: currentIndex + 1, animated: true)
        }
    }
    

    func cardForItemAt(verticalCardSwiperView: VerticalCardSwiperView, cardForItemAt index: Int) -> CardCell {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.imageTapped(sender:)))
        
        tapGesture.delegate = self
        
        
        if let cardCell = verticalCardSwiperView.dequeueReusableCell(withReuseIdentifier: "ExampleCell", for: index) as? ExampleCardCell {
            print(index)
            let post = contactsDemoData[index]
            cardCell.setBackgroundColor()
            cardCell.nameLbl.text = post.name
            cardCell.ageLbl.text = post.caption
            cardCell.imageView.image = UIImage(named: "art2.jpg")
            cardCell.profilePicView.image = UIImage(named: "art2.jpg")
            
            cardCell.imageView.addGestureRecognizer(tapGesture)
            cardCell.imageView.isUserInteractionEnabled = true
            if selectedSegnment == 1 {
                return cardCell
            }
        }

        return CardCell()
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

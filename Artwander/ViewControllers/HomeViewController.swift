//
//  HomeViewController.swift
//  Artwander
//
//  Created by Stefan Tanaskovic on 2020-11-20.
//  Copyright © 2020 Stefan Tanaskovic. All rights reserved.
//

import UIKit
import VerticalCardSwiper

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
        Post(name: "John Doe", caption: "This fffff", image: UIImage(named: "art1")!, profilePic: UIImage(named: "profile")!, likeState: false, likeAmount: 5, poster: "blach"),
        Post(name: "John Doe", caption: "This water color painting took me 10 hours but finally finished", image: UIImage(named: "art2.jpg")!,profilePic: UIImage(named: "profile1")!, likeState: false, likeAmount: 5, poster: "blach"),
        Post(name: "John Doe", caption: "This water color painting took me 10 hours but finally finished", image: UIImage(named: "art3.jpg")!,profilePic: UIImage(named: "profile2")!, likeState: false, likeAmount: 5, poster: "blach"),
        Post(name: "John Doe", caption: "This water color painting took me 10 hours but finally finished", image: UIImage(named: "art2.jpg")!,profilePic: UIImage(named: "profile")!, likeState: false, likeAmount: 5, poster: "blach"),
    ]
    
    var contactsDemoData2: [Post] = [
        Post(name: "John Doe", caption: "This fffff", image: UIImage(named: "art2")!, profilePic: UIImage(named: "profile2")!, likeState: false, likeAmount: 5, poster: "blach"),
        Post(name: "John Doe", caption: "This water color painting took me 10 hours but finally finished", image: UIImage(named: "art1.jpg")!,profilePic: UIImage(named: "profile1")!, likeState: false, likeAmount: 5, poster: "blach"),
        Post(name: "John Doe", caption: "This water color painting took me 10 hours but finally finished", image: UIImage(named: "art3.jpg")!,profilePic: UIImage(named: "profile")!, likeState: false, likeAmount: 5, poster: "blach"),
        Post(name: "John Doe", caption: "This water color painting took me 10 hours but finally finished", image: UIImage(named: "art2.jpg")!,profilePic: UIImage(named: "profile2")!, likeState: false, likeAmount: 5, poster: "blach"),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        cardSwiper.delegate = self
        cardSwiper.datasource = self

        // register cardcell for storyboard use
        cardSwiper.register(nib: UINib(nibName: "ExampleCell", bundle: nil), forCellWithReuseIdentifier: "ExampleCell")
    }
    

    @IBAction func indexChanged(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            selectedSegnment = 1
            cardSwiper.scrollToCard(at: 0, animated: false)
            let currentCard = contactsDemoData[cardSwiper.focussedCardIndex!]
            if currentCard.likeState == false {
                let homeImage = UIImage(systemName: "heart", withConfiguration: .none)
                likeBtn.setImage(homeImage, for: .normal)
            }else{
                let homeImage = UIImage(systemName: "heart.fill", withConfiguration: .none)
                likeBtn.setImage(homeImage, for: .normal)
            }
        case 1:
            selectedSegnment = 2
            self.view.layoutIfNeeded()
            cardSwiper.scrollToCard(at: 0, animated: false)
            let currentCard = contactsDemoData2[cardSwiper.focussedCardIndex!]
            if currentCard.likeState == false {
                let homeImage = UIImage(systemName: "heart", withConfiguration: .none)
                likeBtn.setImage(homeImage, for: .normal)
            }else{
                let homeImage = UIImage(systemName: "heart.fill", withConfiguration: .none)
                likeBtn.setImage(homeImage, for: .normal)
            }
        default:
            break
        }
        self.cardSwiper.reloadData()
    }
    


    @IBAction func toProfile(_ sender: Any) {
            performSegue(withIdentifier: "toProfile", sender: self)
    }
    

    @IBAction func pressScrollUp(_ sender: UIBarButtonItem) {
        if let currentIndex = cardSwiper.focussedCardIndex {
            _ = cardSwiper.scrollToCard(at: currentIndex - 1, animated: true)
        }
    }


    @IBAction func pressRightButton() {
        if selectedSegnment == 1 {
            let currentCard = contactsDemoData[cardSwiper.focussedCardIndex!]
            activateLike(bool: !currentCard.likeState)
        }else{
            let currentCard = contactsDemoData2[cardSwiper.focussedCardIndex!]
            activateLike(bool: !currentCard.likeState)
        }
    }
    
    func activateLike(bool: Bool){
        if selectedSegnment == 1 {
            contactsDemoData[cardSwiper.focussedCardIndex!].likeState = bool
            let homeImage = bool ? UIImage(systemName: "heart.fill", withConfiguration: .none) : UIImage(systemName: "heart", withConfiguration: .none)
            likeBtn.setImage(homeImage, for: .normal)
        }else{
            contactsDemoData2[cardSwiper.focussedCardIndex!].likeState = bool
            let homeImage = bool ? UIImage(systemName: "heart.fill", withConfiguration: .none) : UIImage(systemName: "heart", withConfiguration: .none)
            likeBtn.setImage(homeImage, for: .normal)
        }


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
            cardCell.imageView.image = post.image
            cardCell.profilePicView.image = post.profilePic
            
            cardCell.imageView.addGestureRecognizer(tapGesture)
            cardCell.imageView.isUserInteractionEnabled = true
            if selectedSegnment == 1 {
                return cardCell
            }
        }
        
        if let cardCell2 = verticalCardSwiperView.dequeueReusableCell(withReuseIdentifier: "ExampleCell", for: index) as? ExampleCardCell {

            let post = contactsDemoData2[index]
            cardCell2.setBackgroundColor()
            cardCell2.nameLbl.text = post.name
            cardCell2.ageLbl.text = post.caption
            cardCell2.imageView.image = post.image
            cardCell2.profilePicView.image = post.profilePic
            cardCell2.imageView.addGestureRecognizer(tapGesture)
            cardCell2.imageView.isUserInteractionEnabled = true
            if selectedSegnment == 2 {
                return cardCell2
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
        if selectedSegnment == 1 {
            return contactsDemoData.count
        }else{
            return contactsDemoData2.count
        }
    }

    func willSwipeCardAway(card: CardCell, index: Int, swipeDirection: SwipeDirection) {
        // called right before the card animates off the screen.
        
        if selectedSegnment == 1 {
            
            print(swipeDirection.rawValue)
            if index < contactsDemoData.count {
                contactsDemoData.remove(at: index)
            }
        }else{
            if index < contactsDemoData2.count {
                contactsDemoData2.remove(at: index)
            }
        }

    }


    func didSwipeCardAway(card: CardCell, index: Int, swipeDirection: SwipeDirection) {
        // called when a card has animated off screen entirely.
    }
}


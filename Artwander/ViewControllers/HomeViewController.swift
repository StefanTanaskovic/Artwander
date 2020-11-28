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
    
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var msgBtn: UIButton!
    
    @IBOutlet weak var profileBtn: UIButton!
    @IBOutlet weak var purchaseBtn: UIButton!
    var selectedSegnment = 1
    @IBOutlet var cardSwiper: VerticalCardSwiper!


    override func viewDidLoad() {
        super.viewDidLoad()

        cardSwiper.delegate = self
        cardSwiper.datasource = self

        // register cardcell for storyboard use
        cardSwiper.register(nib: UINib(nibName: "ExampleCell", bundle: nil), forCellWithReuseIdentifier: "ExampleCell")
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
            let post = mainDelegate.currentUserObj.Posts[index]
            let urlImage = URL(string: post.image )
            let urlProfilePic = URL(string: post.profilePic )
            cardCell.setBackgroundColor()
            cardCell.nameLbl.text = post.name
            cardCell.ageLbl.text = post.caption
            cardCell.imageView.kf.setImage(with: urlImage)
            cardCell.profilePicView.kf.setImage(with: urlProfilePic)
            cardCell.imageView.addGestureRecognizer(tapGesture)
            cardCell.imageView.isUserInteractionEnabled = true

            ;return cardCell
            
        }

        return CardCell()
    }
    

    @objc func imageTapped(sender: UITapGestureRecognizer) {
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
        return mainDelegate.currentUserObj.Posts.count 
    }

    func willSwipeCardAway(card: CardCell, index: Int, swipeDirection: SwipeDirection) {
        // called right before the card animates off the screen.
        if index < mainDelegate.currentUserObj.Posts.count {
            mainDelegate.currentUserObj.Posts.remove(at: index)
        }
    }


    func didSwipeCardAway(card: CardCell, index: Int, swipeDirection: SwipeDirection) {
        // called when a card has animated off screen entirely.
    }
}


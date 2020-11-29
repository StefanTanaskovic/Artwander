//
//  ProfileCellViewController.swift
//  Artwander
//
//  Created by Stefan Tanaskovic on 2020-11-21.
//  Copyright © 2020 Stefan Tanaskovic. All rights reserved.
//


import UIKit
import VerticalCardSwiper

class ProfileCellViewController: UIViewController,VerticalCardSwiperDelegate, VerticalCardSwiperDatasource, UIGestureRecognizerDelegate {
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    var text:String = ""
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var msgBtn: UIButton!
    @IBOutlet weak var profileBtn: UIButton!
    @IBOutlet weak var purchaseBtn: UIButton!

 
    @IBOutlet weak var cardSwiper: VerticalCardSwiper!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = mainDelegate.currentUserObj.name + " Page"
        buttonView.layer.cornerRadius = 20
        likeBtn.imageView?.contentMode = .scaleAspectFit
        msgBtn.imageView?.contentMode = .scaleAspectFit
        profileBtn.imageView?.contentMode = .scaleAspectFit
        purchaseBtn.imageView?.contentMode = .scaleAspectFit
        
        likeBtn.imageEdgeInsets = UIEdgeInsets(top: 25, left: 25, bottom: 25, right: 25)
        msgBtn.imageEdgeInsets = UIEdgeInsets(top: 25, left: 25, bottom: 25, right: 25)
        profileBtn.imageEdgeInsets = UIEdgeInsets(top: 25, left: 25, bottom: 25, right: 25)
        purchaseBtn.imageEdgeInsets = UIEdgeInsets(top: 25, left: 25, bottom: 25, right: 25)

        cardSwiper.isStackingEnabled = false
        cardSwiper.visibleNextCardHeight = 0
        cardSwiper.topInset = 0
        
        self.view.insertSubview(self.cardSwiper, at: 0)

        cardSwiper.delegate = self
        cardSwiper.datasource = self

        // register cardcell for storyboard use
        cardSwiper.register(nib: UINib(nibName: "ExampleCell", bundle: nil), forCellWithReuseIdentifier: "ExampleCell")
        
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLoad()
    }

    
    @IBAction func profileBtn(_ sender: Any) {
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "toProfile" {
//            let vc = segue.destination as? ProfileCellViewController
//            vc?.text = String(format: "%@", sender! as! CVarArg)
//        }
    }
    

    func cardForItemAt(verticalCardSwiperView: VerticalCardSwiperView, cardForItemAt index: Int) -> CardCell {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.imageTapped(sender:)))
        
        tapGesture.delegate = self
        
        
        if let cardCell = verticalCardSwiperView.dequeueReusableCell(withReuseIdentifier: "ExampleCell", for: index) as? ExampleCardCell {
            let post = mainDelegate.currentUserObj.Posts[index]
            let urlImage = URL(string: post.image )
            let urlProfilePic = URL(string: post.profilePic )
            cardCell.setBackgroundColor()
            cardCell.lblName.text = post.name
            cardCell.lblCaption.text = post.caption
            cardCell.imageView.kf.setImage(with: urlImage)
            cardCell.profilePicView.kf.setImage(with: urlProfilePic)
            cardCell.imageView.addGestureRecognizer(tapGesture)
            cardCell.imageView.isUserInteractionEnabled = true

            return cardCell
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
        return mainDelegate.currentUserObj.Posts.count
    }

    func willSwipeCardAway(card: CardCell, index: Int, swipeDirection: SwipeDirection) {
        if index < mainDelegate.currentUserObj.Posts.count  {
            mainDelegate.currentUserObj.Posts.remove(at: index)
        }
    }

    func didSwipeCardAway(card: CardCell, index: Int, swipeDirection: SwipeDirection) {
        // called when a card has animated off screen entirely.
    }
}

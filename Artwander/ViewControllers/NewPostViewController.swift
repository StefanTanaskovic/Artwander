//
//  NewPostViewController.swift
//  Artwander
//
//  Created by Stefan Tanaskovic on 2020-11-20.
//  Copyright © 2020 Stefan Tanaskovic. All rights reserved.
//

// CODE BY BRIAN MULHALL

import Foundation
import UIKit
import FirebaseAuth
import FirebaseStorage

class NewPostViewController: UIViewController {
    
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    var imagePicker: ImagePicker!
    
    @IBOutlet weak var postPicView: UIImageView!
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtDesc: UITextView!
    @IBOutlet weak var txtPrice: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postPicView.image = nil
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
    }
    
    
    @IBAction func btnSelectImage(_ sender: Any) {
        self.imagePicker.present(from: sender as! UIView)
    }
    
    
    @IBAction func btnCompletePost() {
        
        if (txtDesc.text != "" && postPicView.image != nil) {
        
            uploadMedia() { url in
                guard let url = url else { return }
                
                // UPDATE APP DELEGATE LIST OF POSTS FOR USER
                let post = Post()
                post.name = self.mainDelegate.currentUserObj.name
                post.caption = self.txtDesc.text!
                post.image =  url
                post.profilePic = self.mainDelegate.currentUserObj.profilePic
                post.likeAmount =  0
                post.poster =  self.mainDelegate.currentUserId!
                
                self.mainDelegate.currentUserObj.Posts.append(post)
                
                // CREATE THE NEW POST DOCUMENT TO UPLOAD TO FIRESTORE
                let ref = self.mainDelegate.firestoreDB!.collection("posts").document()
                let docData: [String: Any] = [
                    "caption": self.txtDesc.text!,
                    "image": url,
                    "name":self.mainDelegate.currentUserObj.name,
                    "poster":self.mainDelegate.currentUserId!,
                    "profile_pic": self.mainDelegate.currentUserObj.profilePic,
                    "like_amount": 0
                 ]
                 ref.setData(docData) { err in
                     if let err = err {
                         print("Error writing document: \(err)")
                     }
                 }
                
                // UPDATE THE LIST OF POSTS IN THE USER DOCUMENT ON FIRESTORE.
                // ADDS THE NEW POST TO THE ARRAY
                let userRef = self.mainDelegate.firestoreDB!.collection("users").document(self.mainDelegate.currentUserId!)
                
                userRef.getDocument { (document, error) in
                    if let document = document, document.exists {
                        
                        var postArray = document.get("posts") as! Array<Any>
                        print(postArray)
                        
                        postArray.append(ref.documentID as String)
                        
                        userRef.updateData([
                            "posts":  postArray
                        ]) { err in
                            if let err = err {
                                print("Error updating array: \(err)")
                            } else {
                                print("Array successfully updated")
                            }
                        }
                        
                    } else {
                        print("Document does not exist")
                    }
                }
            }
            
            // ALLERT THE USER THAT THE POST WAS SUCCESFULL
            // BRINGS THEM TO THEIR PROFILE WHEN FINISHED
            let alertController = UIAlertController(title: "Success", message: "Post has been made.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                UIAlertAction in
                self.tabBarController?.selectedIndex = 2
            }
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
        
            // ALLERT THE USER THAT THEY ARE MISSING FEILDS
            let alertError = UIAlertController(title: "Error", message: "Please Fill in Everything.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        
            alertError.addAction(okAction)
            self.present(alertError, animated: true, completion: nil)
        }
    }
    
    // FUNCTION FOR UPLOADING THE POST IMAGE TO FIREBASE STORAGE AND RETURNING URL
    func uploadMedia(completion: @escaping (_ url: String?) -> Void) {
        let storageRef = Storage.storage().reference().child("\(Auth.auth().currentUser?.uid ?? "").png")
        if let uploadData = self.postPicView.image?.jpegData(compressionQuality: 0.1) {
            storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                if error != nil {
                    print("error uploading image to storage")
                    completion(nil)
                } else {
                    storageRef.downloadURL(completion: { (url, error) in
                        completion(url?.absoluteString)
                    })
                }
            }
        }
    }
}

extension NewPostViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        self.postPicView.image = image
    }
}

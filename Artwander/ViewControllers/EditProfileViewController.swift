//
//  EditProfileViewController.swift
//  Artwander
//
//  Created by Stefan Tanaskovic on 2020-11-21.
//  Copyright © 2020 Stefan Tanaskovic. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage

class EditProfileViewController: UIViewController {
    
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    var name: String = ""
    var profilePic: UIImage? = nil
    var imagePicker: ImagePicker!
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var txtName: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profilePicture.image = profilePic
        txtName.text = name
         self.imagePicker = ImagePicker(presentationController: self, delegate: self)
    }
    
     func uploadMedia(completion: @escaping (_ url: String?) -> Void) {
        let storageRef = Storage.storage().reference().child("\(Auth.auth().currentUser?.uid ?? "").png")
        if let uploadData = self.profilePicture.image?.jpegData(compressionQuality: 0.1) {
            storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                if error != nil {
                    print("error")
                    completion(nil)
                } else {
                    storageRef.downloadURL(completion: { (url, error) in
                        completion(url?.absoluteString)
                    })
                }
            }
        }
    }
    
    @IBAction func btnSave(_ sender: Any) {
        
        if (txtName.text != "") {
            uploadMedia() { url in
                 guard let url = url else { return }
                 let ref = self.mainDelegate.firestoreDB!.collection("users").document(self.mainDelegate.currentUserId!)
                 let docData: [String: Any] = [
                    "full_name": self.txtName.text!,
                    "email": self.mainDelegate.currentUserObj.email,
                    "posts": self.mainDelegate.post_id_list,
                    "following":self.mainDelegate.currentUserObj.following ,
                    "folllowers":self.mainDelegate.currentUserObj.followers ,
                    "followingCount": self.mainDelegate.currentUserObj.followingCount,
                    "followerCount": self.mainDelegate.currentUserObj.followerCount,
                     "profile_pic": url
                 ]
                 ref.setData(docData) { err in
                     if let err = err {
                         print("Error writing document: \(err)")
                     }
                 }
                self.mainDelegate.currentUserObj.profilePic = url
                self.mainDelegate.currentUserObj.name = self.txtName.text!
                self.mainDelegate.updateCurrentUser()
            }
            let alertController = UIAlertController(title: "Success", message: "Profile has been updated", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                 UIAlertAction in
                self.navigationController?.popViewController(animated: true)
             }
             alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Error", message: "Please make sure name is filled out", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnEdtProfilePicture(_ sender: Any) {
        self.imagePicker.present(from: sender as! UIView)
    }
}

extension EditProfileViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        self.profilePicture.image = image
    }
}

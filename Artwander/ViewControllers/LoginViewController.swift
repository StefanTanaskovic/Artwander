//
//  LoginViewController.swift
//  Artwander
//
//  Created by Stefan Tanaskovic on 2020-11-19.
//  Copyright © 2020 Stefan Tanaskovic. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    var mainDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet var Email_tf : UITextField!
    @IBOutlet var Password_tf : UITextField!

    @IBAction func unwindToLogin(sender: UIStoryboardSegue) {}
    @IBAction func completeLogin() {
        self.doFirebaseLogin(username: Email_tf.text!, password: Password_tf.text!)
    }
    
    // MARK: ViewController Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
//        if Auth.auth().currentUser != nil {
//    
//            performSegue(withIdentifier: "main", sender: nil)
//        }
    }

    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {

    }

    func doFirebaseLogin(username: String, password: String) {
        Auth.auth().signIn(withEmail: username, password: password) { [weak self] authResult, error in
            if error != nil {
                self!.presentAlert(title: "Login Error", message: error!.localizedDescription, preferredStyle: .alert)
            } else {
                self!.mainDelegate.currentUserId = authResult?.user.uid
                self!.mainDelegate.updateCurrentUser()
                self!.performSegue(withIdentifier: "main", sender: nil)
            }
        }
    }
    
    
    func presentAlert(title: String, message: String, preferredStyle: UIAlertController.Style) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        let okayAction = UIAlertAction(title: "Okay", style: .default, handler: { (alert: UIAlertAction!) in
            self.dismiss(animated: true, completion: nil)
        })

        alertController.addAction(okayAction)
        present(alertController, animated: true)
    }
}


//
//  LoginViewController.swift
//  EZBook
//
//  Created by Paing Zay on 28/11/23.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        emailTextField.backgroundColor = .clear
        emailTextField.layer.borderWidth = 1.0
        emailTextField.layer.borderColor = UIColor.gray.cgColor
        emailTextField.layer.cornerRadius = 5.0
        
        passwordTextField.backgroundColor = .clear
        passwordTextField.layer.borderWidth = 1.0
        passwordTextField.layer.borderColor = UIColor.gray.cgColor
        passwordTextField.layer.cornerRadius = 5.0
    }
    
//    @IBAction func loginPressed(_ sender: Any) {
//
//        if let email = emailTextField.text , let password = passwordTextField.text {
//            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
//                if let e = error {
//                    print(e)
//                }
//                self.performSegue(withIdentifier: "LoginToHome", sender: self)
//            }
//        }
//    }
    
    @IBAction func loginPressed(_ sender: Any) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            
            // Validate email format
            if !email.isValidEmail {
                print("Please enter a valid email address.")
                return
            }

            // Validate password length
            if password.count < 8 {
                print("Password must be at least 8 characters long.")
                return
            }

//             Validate password complexity (optional)
//            if !password.containsSpecialCharacter() || !password.containsNumber() {
//                print("Password must contain at least one special character and one number.")
//                return
//            }

            // Sign in with email and password
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                guard let self = self else { return }

                if let error = error as NSError? {
                    if error.code == AuthErrorCode.wrongPassword.rawValue {
                        print("Incorrect password. Please try again.")
                    } else {
                        print("Error: \(error.localizedDescription)")
                    }
                } else {
                    // Login successful, perform segue or further actions
                    self.performSegue(withIdentifier: "LoginToHome", sender: self)
                }
            }
        }
    }

    
    @IBAction func signUpPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "LoginToRegister", sender: self)
    }
}

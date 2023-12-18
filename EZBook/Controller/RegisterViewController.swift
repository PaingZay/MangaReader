//
//  RegisterViewController.swift
//  EZBook
//
//  Created by Paing Zay on 28/11/23.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func registerPressed(_ sender: Any) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error as NSError? {
                    switch error.code {
                    case AuthErrorCode.emailAlreadyInUse.rawValue:
                        print("Email is already in use.")
//                        self.emailTextField.showErrorState()
                        
                    case AuthErrorCode.invalidEmail.rawValue:
//                        self.emailTextField.showErrorState()
                        print("Invalid email format.")
                        
                    case AuthErrorCode.missingEmail.rawValue:
//                        self.emailTextField.showErrorState()
                        print("An email address must be provided.")
                        
                    case AuthErrorCode.weakPassword.rawValue:
//                        self.passwordTextField.showErrorState()
                        print("Weak password.")
                        
                    default:
                        print("Error: \(error.localizedDescription)")
                        
                    }
                } else {
                    self.performSegue(withIdentifier: "RegisterToHome", sender: self)
                }
            }
        }
    }
    
    @IBAction func signInPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "RegisterToLogin", sender: self)
    }
    

}

extension UITextField {
    func showErrorState() {
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.red.cgColor
        
        let animation = CABasicAnimation(keyPath: "borderColor")
        animation.fromValue = UIColor.red.cgColor
        animation.toValue = UIColor.clear.cgColor
        animation.duration = 0.5
        animation.autoreverses = true
        animation.repeatCount = 3
        layer.add(animation, forKey: nil)
    }
}

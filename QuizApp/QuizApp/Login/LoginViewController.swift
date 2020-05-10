//
//  LoginViewController.swift
//  QuizApp
//
//  Created by five on 04/05/2020.
//  Copyright © 2020 Nina Kolarec. All rights reserved.
//

import UIKit

final class LoginViewController: UIViewController {
    
    //MARK: - Properties
    private let userDefaults = UserDefaults.standard
    private let token = "token"
    private let user_id = "user_id"
    private var user : User!
    
    
    //MARK: - Private UI
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    
    
    
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = 5
        
        if _isUserLoggedIn() {
            _switchScreen()
        }
    }
    
    //MARK: - Actions
    @IBAction func login(_ sender: UIButton) {
        guard
            let username = usernameTextField.text,
            let password = passwordTextField.text,
            !username.isEmpty,
            !password.isEmpty
        else {
            _showAlert(title: "Login", message: "Fields must not be empty")
            return
        }
        _loginUser(username: username, password: password)
    }
}

//MARK: - Login user session
extension LoginViewController {
    private func _isUserLoggedIn() -> Bool {
        let tokenExists = userDefaults.object(forKey: token) as? String
        return  tokenExists == nil ? false : true
    }
    
    private func _loginUser(username: String, password: String) {
        let userService = UserService()
        userService.loginUser(username: username, password: password) { (result) in
            DispatchQueue.main.async {
                if result != nil {
                    self.user = result
                    self.userDefaults.set(self.user.user_id, forKey: self.user_id)
                    self.userDefaults.set(self.user.token, forKey: self.token)
                    self._switchScreen()
                } else {
                    self._showAlert(title: "Login Error", message: "Failed to login.")
                }
            }
        }
    }
}

//MARK: - Navigation
extension LoginViewController {
    private func _switchScreen() {
        let storyboard = UIStoryboard(name: "QuizList", bundle: nil)
        let viewController = storyboard.instantiateViewController(
            withIdentifier: "QuizListViewController"
        ) as! QuizListViewController
        self.navigationController?.setViewControllers([viewController],animated:true)
    }
}

//MARK: - Custom alert dialog
extension UIViewController {
    func _showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
}

//MARK: - Animation
extension LoginViewController {
    private func _animate() {
    }
}

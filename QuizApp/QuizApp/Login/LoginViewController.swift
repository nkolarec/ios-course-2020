//
//  LoginViewController.swift
//  QuizApp
//
//  Created by five on 04/05/2020.
//  Copyright © 2020 Nina Kolarec. All rights reserved.
//

import UIKit

final class LoginViewController: UIViewController {
    
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    
    private let userDefaults = UserDefaults.standard
    private weak var user : User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = 5
        if _isUserLoggedIn() {
            _switchScreen()
        }
    }
    
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
        let token = userDefaults.object(forKey: "token") as? String
        return  token == nil ? false : true
    }
    
    private func _loginUser(username: String, password: String) {
        let userService = UserService()
        userService.loginUser(username: username, password: password) { (result) in
            DispatchQueue.main.async {
                self.user = result
                if self.user != nil {
                    self.userDefaults.set(self.user.token, forKey: "token")
                    print(self.user.token)
                    self._switchScreen()
                } else {
                    self._showAlert(title: "Login Error", message: "Failed to login.")
                }
            }
        }
    }
}

//MARK: - Transition to a new screen
extension LoginViewController {
    private func _switchScreen() {
        let bundle = Bundle.main
        let storyboard = UIStoryboard(name: "QuizList", bundle: bundle)
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

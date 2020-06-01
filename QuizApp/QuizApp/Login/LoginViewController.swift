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
    @IBOutlet weak var quizTitleLabel: UILabel!
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        if _isUserLoggedIn() {
            _switchScreen()
        }
        else {
            loginButton.layer.cornerRadius = 5
            _animate()
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
        let bundle = Bundle.main
        let storyboard = UIStoryboard(name: "QuizList", bundle: bundle)
        let viewController = storyboard.instantiateViewController(
            withIdentifier: "QuizListViewController"
        ) as! QuizListViewController
        self.navigationController?.setViewControllers([viewController],animated:true)
    }
}

//MARK: - Animation
extension LoginViewController {
    private func _animate() {
        self.quizTitleLabel.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
        self.usernameTextField.center = CGPoint(x: -300, y: 80)
        self.passwordTextField.center = CGPoint(x: -400, y: 128)
        self.loginButton.center = CGPoint(x: -500, y: 189)
        UIView.animate(withDuration: 3.0,
            delay: 0.0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 0,
            options: .curveEaseOut,
            animations: ({
                self.quizTitleLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.usernameTextField.center = CGPoint(x: 0, y: 80)
                self.passwordTextField.center = CGPoint(x: 0, y: 128)
                self.loginButton.center = CGPoint(x: 0, y: 189)
            }), completion: nil)}
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


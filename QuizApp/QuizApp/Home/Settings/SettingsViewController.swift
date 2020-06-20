//
//  SettingsViewController.swift
//  QuizApp
//
//  Created by five on 02/06/2020.
//  Copyright © 2020 Nina Kolarec. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    //MARK: - Properties
    private let token = "token"
    private let user_id = "user_id"
    private let username = "username"
    private let userDefaults = UserDefaults.standard
    
    //MARK: - Private UI
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        logoutButton.layer.cornerRadius = 5
        usernameLabel.text = userDefaults.string(forKey: username)
    }
    
    //MARK: - Actions
    @IBAction func logout(_ sender: UIButton) {
        userDefaults.removeObject(forKey: user_id)
        userDefaults.removeObject(forKey: token)
        userDefaults.removeObject(forKey: username)
        print("User has been logged out.")
        _switchScreenLogin()
    }

}

//MARK: - Navigation
extension SettingsViewController {
    private func _switchScreenLogin() {
        let bundle = Bundle.main
        let storyboard = UIStoryboard(name: "Login", bundle: bundle)
        let viewController = storyboard.instantiateViewController(
            withIdentifier: "LoginViewController"
        ) as! LoginViewController
        navigationController?.setViewControllers([viewController], animated:true)
    }
}

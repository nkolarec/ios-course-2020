//
//  QuizListViewController.swift
//  QuizApp
//
//  Created by five on 04/05/2020.
//  Copyright © 2020 Nina Kolarec. All rights reserved.
//

import UIKit

final class QuizListViewController: UIViewController {

    //MARK: - Properties
    private let token = "token"
    private let user_id = "user_id"
    private let userDefaults = UserDefaults.standard
    private var quizzes: [Quiz] = []
    
    //MARK: - Private UI
    @IBOutlet private weak var quizListTableView: UITableView!
    @IBOutlet weak var funFactLabel: UILabel!
    
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    //MARK: - Actions
    @IBAction func load(_ sender: UIButton) {
        _loadQuizList()
    }
    
    @IBAction func logout(_ sender: UIButton) {
        userDefaults.removeObject(forKey: user_id)
        userDefaults.removeObject(forKey: token)
        print("User has been logged out.")
        _switchScreen()
    }
}

// MARK: - Quiz list table view
extension QuizListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        quizListTableView.deselectRow(at: indexPath, animated: true)
        let quiz = quizzes[indexPath.row]
        print("Selected quiz: \(quiz)")
    }
}

extension QuizListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizzes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("CURRENT INDEX PATH BEING CONFIGURED: \(indexPath)")
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: QuizTableViewCell.self), for: indexPath) as! QuizTableViewCell
        cell.configure(quiz: quizzes[indexPath.row])
        return cell
    }
}

extension QuizListViewController {
    private func setupTableView() {
        quizListTableView.estimatedRowHeight = 51
        quizListTableView.rowHeight = UITableView.automaticDimension
        quizListTableView.tableFooterView = UIView()
        quizListTableView.separatorStyle = .none
        quizListTableView.delegate = self
        quizListTableView.dataSource = self
    }
}

//MARK: - Load quizzes session
extension QuizListViewController {
    private func _loadQuizList() {
        let quizService = QuizService()
        quizService.loadQuizList() { (result) in
            DispatchQueue.main.async {
                if result != nil {
                    self.quizzes = result!
                    self.quizListTableView.reloadData()
                } else {
                    self._showAlert(title: "Loading Error", message: "Failed to load quizzes.")
                }
            }
        }
    }
}

//MARK: - Navigation
extension QuizListViewController {
    private func _switchScreen() {
        let bundle = Bundle.main
        let storyboard = UIStoryboard(name: "Login", bundle: bundle)
        let viewController = storyboard.instantiateViewController(
            withIdentifier: "LoginViewController"
        ) as! LoginViewController
        self.navigationController?.setViewControllers([viewController],animated:true)
    }
}


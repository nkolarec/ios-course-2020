//
//  SearchViewController.swift
//  QuizApp
//
//  Created by five on 22/06/2020.
//  Copyright © 2020 Nina Kolarec. All rights reserved.
//

import UIKit

final class SearchViewController: UIViewController {

    //MARK: - Properties
    private var quizzes: [Quiz] = []
    private var searchData: [Quiz] = []
    
    //MARK: Private UI
    @IBOutlet private weak var quizListTableView: UITableView!
    @IBOutlet private weak var searchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _setupView()
        _loadQuizList()
    }

    @IBAction func search(_ sender: UIButton) {
        guard let searchText = searchTextField.text
        else { return }
        searchData = quizzes.filter { (quiz: Quiz) -> Bool in
          return quiz.title.lowercased().contains(searchText.lowercased()) || quiz.description.lowercased().contains(searchText.lowercased())
        }
        quizListTableView.reloadData()
    }
}

// MARK: - UI Table View
extension SearchViewController {
    private func _setupView() {
        quizListTableView.estimatedRowHeight = 51
        quizListTableView.rowHeight = UITableView.automaticDimension
        quizListTableView.separatorStyle = .none
        quizListTableView.delegate = self
        quizListTableView.dataSource = self
    }
}
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        quizListTableView.deselectRow(at: indexPath, animated: true)
        let quiz = quizzes[indexPath.row]
        print("Selected quiz: \(quiz)")
        _switchScreenQuiz(quiz: quiz)
    }
}
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return searchData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("CURRENT INDEX PATH BEING CONFIGURED: \(indexPath)")
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: QuizTableViewCell.self), for: indexPath) as! QuizTableViewCell
        cell.configure(quiz: searchData[indexPath.row], last: searchData.count == indexPath.row + 1)
        return cell
    }
}

//MARK: - GET quizzes session
extension SearchViewController {
    private func _loadQuizList() {
        let quizService = QuizService()
        quizService.loadQuizList() { (result) in
            DispatchQueue.main.async { [weak self] in
                guard let self = self
                else { return }
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

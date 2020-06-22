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
    private var mapByCategory: [String : [Quiz]] = [:]
    private var categories: [String] = []
    
    //MARK: - Private UI
    @IBOutlet private weak var quizListTableView: UITableView!
    @IBOutlet weak var funFactLabel: UILabel!
    
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        _setupTableView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: - Actions
    @IBAction func load(_ sender: UIButton) {
        _loadQuizList()
    }
}

// MARK: - UI Table View
extension QuizListViewController {
    private func _setupTableView() {
        quizListTableView.estimatedRowHeight = 51
        quizListTableView.rowHeight = UITableView.automaticDimension
        quizListTableView.separatorStyle = .none
        quizListTableView.delegate = self
        quizListTableView.dataSource = self
    }
}
extension QuizListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        quizListTableView.deselectRow(at: indexPath, animated: true)
        let quiz = mapByCategory[categories[indexPath.section]]![indexPath.row]
        print("Selected quiz: \(quiz)")
        _switchScreenQuiz(quiz: quiz)
    }
}
extension QuizListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mapByCategory[categories[section]]?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("CURRENT INDEX PATH BEING CONFIGURED: \(indexPath)")
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: QuizTableViewCell.self), for: indexPath) as! QuizTableViewCell
        cell.configure(quiz: mapByCategory[categories[indexPath.section]]![indexPath.row], last: mapByCategory[categories[indexPath.section]]?.count == indexPath.row + 1)
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
        let title: UILabel = UILabel(frame: CGRect(x:0, y:0, width: headerView.frame.width, height: 30))
        title.text = "  " + categories[section]
        title.baselineAdjustment = .alignCenters
        headerView.addSubview(title)
        if (categories[section] == "SPORTS") {
            headerView.backgroundColor = UIColor.lightGray
        } else {
            headerView.backgroundColor = UIColor.gray
        }
        return headerView
    }
}

//MARK: - GET quizzes session
extension QuizListViewController {
    private func _loadQuizList() {
        let quizService = QuizService()
        quizService.loadQuizList() { (result) in
            DispatchQueue.main.async { [weak self] in
            guard let self = self
            else { return }
                if result != nil {
                    self.quizzes = result!
                    self._makeSectionsByCategory()
                    self.funFactLabel.text = "NBA: " + self._countNBA()
                    self.quizListTableView.reloadData()
                } else {
                    self._showAlert(title: "Loading Error", message: "Failed to load quizzes.")
                }
            }
        }
    }
    private func _countNBA() -> String {
        var counter = 0
        for quiz in quizzes {
            for question in quiz.questions {
                counter += question.question.components(separatedBy: "NBA").count - 1
                for answer in question.answers {
                    counter += answer.components(separatedBy: "NBA").count - 1
                }
            }
        }
        return String(counter)
    }
    private func _makeSectionsByCategory() {
        mapByCategory.removeAll()
        for quiz in quizzes {
            print(quiz.category)
            if (self.mapByCategory[quiz.category] == nil) {
                self.mapByCategory.updateValue([quiz], forKey: quiz.category)
            }
            else {
                var values = self.mapByCategory.removeValue(forKey: quiz.category)
                values!.append(quiz)
                self.mapByCategory.updateValue(values!, forKey: quiz.category)
            }
            if !self.categories.contains(quiz.category) { self.categories.append(quiz.category)
            }
        }
    }
}

//MARK: - Navigation
extension UIViewController {
    func _switchScreenQuiz(quiz: Quiz) {
        let bundle = Bundle.main
        let storyboard = UIStoryboard(name: "Quiz", bundle: bundle)
        let viewController = storyboard.instantiateViewController(
            withIdentifier: "QuizViewController"
        ) as! QuizViewController
        viewController.quiz = quiz
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}


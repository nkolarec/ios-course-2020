//
//  QuizViewController.swift
//  QuizApp
//
//  Created by five on 05/05/2020.
//  Copyright © 2020 Nina Kolarec. All rights reserved.
//

import UIKit

final class QuizViewController: UIViewController, QuizViewDelegate {
    
    //MARK: - Properties
    var quiz: Quiz!
    var questions: [Question] = []
    private var seconds = 0.00
    private var no_of_correct = 0
    private var timer = Timer()
    private let token = "token"
    private let user_id = "user_id"
    private let userDefaults = UserDefaults.standard
    
    //MARK: - Private UI
    @IBOutlet private weak var quizTitle: UILabel!
    @IBOutlet private weak var quizImage: UIImageView!
    @IBOutlet private weak var hiddenImageView: UIView!
    @IBOutlet private weak var questionsView: UICollectionView!
    @IBOutlet private weak var startQuizButton: UIButton!
    @IBOutlet private weak var timerLabel: UILabel!
    
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        quizTitle.text = quiz?.title
        _loadImage(url: quiz?.imageURL)
        _setupCollectionView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "list.bullet"),
            style: .plain,
            target: self,
            action: #selector(viewLeaderboard))
        navigationController?.navigationBar.isHidden = false
    }
    
    //MARK: - Actions
    @objc func viewLeaderboard() {
        let bundle = Bundle.main
        let storyboard = UIStoryboard(name: "Leaderboard", bundle: bundle)
        let viewController = storyboard.instantiateViewController(identifier: "LeaderboardViewController") as! LeaderboardViewController
        viewController.quiz_id = quiz.quiz_id
        navigationController?.pushViewController(viewController, animated: true)
    }
    @IBAction func startQuiz(_ sender: UIButton) {
        questionsView.isHidden = false
        startQuizButton.isHidden = true
        timerLabel.text = String(format: "%.1f", seconds)
        timerLabel.isHidden = false
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
    }
    @objc func updateTimer() {
        seconds += 0.01
        timerLabel.text = String(format: "%.1f", seconds)
    }
    func _answerPressed(button: UIButton, indexPath: IndexPath) {
        
        let correctAnswerIndex = questions[indexPath.row].correct_answer
        let correctAnswer = questions[indexPath.row].answers[correctAnswerIndex]
        
        if correctAnswer == button.titleLabel!.text {
            button.backgroundColor = UIColor.green
            no_of_correct += 1
        }
        else {
            button.backgroundColor = UIColor.red
        }
        
        if indexPath.row < questions.count - 1 {
            let nextCell = IndexPath(item: indexPath.row + 1, section: 0);
            questionsView.scrollToItem(at: nextCell, at: .centeredHorizontally, animated: true)
        }
        else {
            timer.invalidate()
            _postResults()
        }
    }
}

//MARK: - GET image session
extension QuizViewController {
    private func _loadImage(url: URL?) {
        if url != nil {
            let quizService = QuizService()
            quizService.loadImage(url: url!) { (result) in
                DispatchQueue.main.async { [weak self] in
                    guard let self = self
                    else { return }
                    if result != nil {
                        self.quizImage.image = result!
                        self.quizImage.isHidden = false
                        self.hiddenImageView.isHidden = true
                    }
                }
            }
        }
    }
}

//MARK: - UI Collection View
extension QuizViewController {
    private func _setupCollectionView() {
        questionsView.delegate = self
        questionsView.dataSource = self
        questions = quiz.questions
        questionsView.allowsSelection = false
        questionsView.isHidden = true
    }
}
extension QuizViewController: UICollectionViewDelegate, UICollectionViewDataSource {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return questions.count
        }
        func collectionView(_ tableView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            print("CURRENT INDEX PATH BEING CONFIGURED: \(indexPath)")
            let cell = questionsView.dequeueReusableCell(withReuseIdentifier: String(describing: QuestionViewCell.self), for: indexPath) as! QuestionViewCell
            cell.configure(question: questions[indexPath.row])
            cell.indexPath = indexPath
            cell.delegate = self
            return cell
        }
}

//MARK: - POST results session
extension QuizViewController {
    func _postResults() {
        let quizService = QuizService()
        let newResult = Result(
            quiz_id: quiz.quiz_id,
            user_id: userDefaults.integer(forKey: user_id),
            time: round(seconds * 100) / 100,
            no_of_correct: no_of_correct)
        print(newResult)
        quizService.postResult(result: newResult, token: userDefaults.string(forKey: token)!) { (result) in
            DispatchQueue.main.async { [weak self] in
                guard let self = self
                else { return }
                if result != nil {
                    print(result!)
                    self.navigationController?.popViewController(animated: true)
                } else {
                    self._showAlertResults(title: "Sending results", message: "Error sending results. Send again?")
                }
            }
        }
    }
}

//MARK: - Custom alert dialog
extension QuizViewController {
    func _showAlertResults(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        // Create the actions
        let sendAgainAction = UIAlertAction(title: "Send again", style: UIAlertAction.Style.default) {
            UIAlertAction in
            NSLog("Send again pressed")
            self._postResults()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }

        // Add the actions
        alertController.addAction(sendAgainAction)
        alertController.addAction(cancelAction)

        // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }
}

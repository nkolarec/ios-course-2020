//
//  QuizViewController.swift
//  QuizApp
//
//  Created by five on 05/05/2020.
//  Copyright © 2020 Nina Kolarec. All rights reserved.
//

import UIKit

final class QuizViewController: UIViewController {
    
    //MARK: - Properties
    var quiz: Quiz!
    var questions: [Question] = []
    
    //MARK: - Private UI
    @IBOutlet private weak var quizTitle: UILabel!
    @IBOutlet private weak var quizImage: UIImageView!
    @IBOutlet private weak var hiddenImageView: UIView!
    @IBOutlet weak var questionsView: UICollectionView!
    @IBOutlet weak var startQuizButton: UIButton!
    
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        quizTitle.text = quiz?.title
        _loadImage(url: quiz?.imageURL)
        _setupCollectionView()
        
    }
    
    //MARK: - Actions
    @IBAction func startQuiz(_ sender: UIButton) {
        questionsView.isHidden = false
        startQuizButton.isHidden = true
    } 
}

//MARK: - Load image session
extension QuizViewController {
    private func _loadImage(url: URL?) {
        if url != nil {
            let quizService = QuizService()
            quizService.loadImage(url: url!) { (result) in
                DispatchQueue.main.async {
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
extension QuizViewController: UICollectionViewDelegate {}
extension QuizViewController: UICollectionViewDataSource {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return questions.count
        }
        func collectionView(_ tableView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            print("CURRENT INDEX PATH BEING CONFIGURED: \(indexPath)")
            let cell = questionsView.dequeueReusableCell(withReuseIdentifier: String(describing: QuestionViewCell.self), for: indexPath) as! QuestionViewCell
            cell.configure(question: questions[indexPath.row])
            return cell
        }
}

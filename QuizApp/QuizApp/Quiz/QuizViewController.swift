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
    
    //MARK: - Private UI
    @IBOutlet private weak var quizTitle: UILabel!
    @IBOutlet private weak var quizImage: UIImageView!
    @IBOutlet private weak var hiddenImageView: UIView!
    
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        quizTitle.text = quiz?.title
        _loadImage(url: quiz?.imageURL)
        
    }
    
    //MARK: - Actions
    @IBAction func startQuiz(_ sender: UIButton) {
    }
}

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

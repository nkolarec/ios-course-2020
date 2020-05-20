//
//  QuestionTableViewCell.swift
//  QuizApp
//
//  Created by five on 16/05/2020.
//  Copyright © 2020 Nina Kolarec. All rights reserved.
//

import UIKit

class QuestionViewCell: UICollectionViewCell {

    //MARK: - Private UI
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerButton1: UIButton!
    @IBOutlet weak var answerButton2: UIButton!
    @IBOutlet weak var answerButton3: UIButton!
    @IBOutlet weak var answerButton4: UIButton!
    
    //MARK: - Lifecycle methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

//MARK: - Configure cell
extension QuestionViewCell {
    func configure(question: Question) {
        questionLabel.text = question.question
        answerButton1.setTitle(question.answers[0], for: .normal)
        answerButton2.setTitle(question.answers[1], for: .normal)
        answerButton3.setTitle(question.answers[2], for: .normal)
        answerButton4.setTitle(question.answers[3], for: .normal)
        
        
    }
}

//
//  QuizTableViewCell.swift
//  QuizApp
//
//  Created by five on 08/05/2020.
//  Copyright © 2020 Nina Kolarec. All rights reserved.
//

import UIKit

final class QuizTableViewCell: UITableViewCell {

    //MARK: - Private UI
    @IBOutlet private weak var quizImage: UIImageView!
    @IBOutlet private weak var quizTitle: UILabel!
    @IBOutlet private weak var hideQuizImage: UIView!
    @IBOutlet private weak var quizDescription: UITextView!
    @IBOutlet private weak var quizLevel: UILabel!
    @IBOutlet private weak var separatorView: UIView!
    
    //MARK: - Lifecycle methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        quizImage.image = nil
        quizImage.isHidden = true
        hideQuizImage.isHidden = false
        quizTitle.text = nil
        quizDescription.text = nil
        quizLevel.text = nil
    }

}

//MARK: - Configure cell
extension QuizTableViewCell {
    func configure(quiz: Quiz, last: Bool) {
        quizTitle.text = quiz.title
        quizDescription.text = quiz.description
        var stars = ""
        for _ in Range(uncheckedBounds: (0, quiz.level)) {
            stars += "* "
        }
        stars.removeLast()
        quizLevel.text = stars
        _loadImage(url: quiz.imageURL)
        if last { separatorView.backgroundColor = .systemBackground }
    }
}

//MARK: - Load image session
extension QuizTableViewCell {
    private func _loadImage(url: URL) {
        let quizService = QuizService()
        quizService.loadImage(url: url) { (result) in
            DispatchQueue.main.async {
                if result != nil {
                    self.quizImage.image = result!
                    self.quizImage.isHidden = false
                    self.hideQuizImage.isHidden = true
                }
            }
        }
    }
}

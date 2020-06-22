//
//  ScoreTableViewCell.swift
//  QuizApp
//
//  Created by five on 20/06/2020.
//  Copyright © 2020 Nina Kolarec. All rights reserved.
//

import UIKit

final class ScoreTableViewCell: UITableViewCell {
    
    //MARK: - Private UI
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var numberLabel: UILabel!
    
    //MARK: - Lifecycle methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
//MARK: - Configure cell
extension ScoreTableViewCell {
    func configure(score: Score, number: Int) {
        usernameLabel.text = score.username
        guard let scoreTotal = Double(score.score)
            else { return }
        scoreLabel.text = String(format: "%.2f", scoreTotal)
        numberLabel.text = "\(number)" + "."
    }
}

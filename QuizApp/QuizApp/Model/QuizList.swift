//
//  QuizList.swift
//  QuizApp
//
//  Created by five on 09/05/2020.
//  Copyright © 2020 Nina Kolarec. All rights reserved.
//

import Foundation

struct QuizList: Codable {
    let quizList: [Quiz]
    
    enum CodingKeys: String, CodingKey {
        case quizList = "quizzes"
    }
}

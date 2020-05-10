//
//  Question.swift
//  QuizApp
//
//  Created by five on 08/05/2020.
//  Copyright © 2020 Nina Kolarec. All rights reserved.
//

import Foundation

struct Question: Codable {
    let question_id: Int
    let question: String
    let answers: [String]
    let correct_answer: Int
    
    enum CodingKeys: String, CodingKey {
        case question_id = "id"
        case question
        case answers
        case correct_answer
    }
}

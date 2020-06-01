//
//  Result.swift
//  QuizApp
//
//  Created by five on 23/05/2020.
//  Copyright © 2020 Nina Kolarec. All rights reserved.
//

import Foundation

struct Result: Codable {
    let quiz_id: Int
    let user_id: Int
    let time: Double
    let no_of_correct: Int
    
    enum CodingKeys: String, CodingKey {
        case quiz_id
        case user_id
        case time
        case no_of_correct
    }
}

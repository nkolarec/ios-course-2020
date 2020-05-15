//
//  Quiz.swift
//  QuizApp
//
//  Created by five on 08/05/2020.
//  Copyright © 2020 Nina Kolarec. All rights reserved.
//

import Foundation
import UIKit

struct Quiz: Codable {
    let quiz_id: Int
    let title: String
    let imageURL: URL
    let description: String
    let category: String
    let level: Int
    let questions: [Question]
    
    enum CodingKeys: String, CodingKey {
        case quiz_id = "id"
        case title
        case imageURL = "image"
        case description
        case category
        case level
        case questions
    }
}

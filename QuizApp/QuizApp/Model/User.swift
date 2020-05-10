//
//  User.swift
//  QuizApp
//
//  Created by five on 07/05/2020.
//  Copyright © 2020 Nina Kolarec. All rights reserved.
//

import Foundation

struct User : Codable {
    let user_id : Int
    let token : String

    enum CodingKeys: String, CodingKey {
        case user_id
        case token
    }
}

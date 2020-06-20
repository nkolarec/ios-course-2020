//
//  Score.swift
//  QuizApp
//
//  Created by five on 19/06/2020.
//  Copyright © 2020 Nina Kolarec. All rights reserved.
//

import Foundation

struct Score : Codable {
    let score : String
    let username : String
    enum CodingKeys: String, CodingKey {
        case score
        case username
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.score = try values.decodeIfPresent(String.self, forKey: .score)
            ?? "0.00" //Default value
        self.username = try values.decodeIfPresent(String.self, forKey: .username) ?? ""
    }
}

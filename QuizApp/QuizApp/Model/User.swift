//
//  User.swift
//  QuizApp
//
//  Created by five on 07/05/2020.
//  Copyright © 2020 Nina Kolarec. All rights reserved.
//

import Foundation

class User {
    let user_id: Int
    let token: String
    
    init?(json: Any) {
        print(json)
        if let jsonDict = json as? [String: Any],
            let user_id = jsonDict["user_id"] as? Int,
            let token = jsonDict["token"] as? String {
            self.user_id = user_id
            self.token = token
        }
        else { return nil }
    }
}

//
//  UserService.swift
//  QuizApp
//
//  Created by five on 07/05/2020.
//  Copyright © 2020 Nina Kolarec. All rights reserved.
//

import Foundation

class UserService {
    func loginUser(username: String, password: String, completion: @escaping ((User?) -> Void)) {
        
        guard let loginURL = URL(string: "https://iosquiz.herokuapp.com/api/session")
        else { return completion(nil) }
        
        let parameters: [String : String] = ["username": username, "password": password]
        var request = URLRequest(url: loginURL)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        do {
        request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            return completion(nil)
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data,
                let response = response as? HTTPURLResponse,
                error == nil else {
                // check for fundamental networking error
                print("error", error ?? "Unknown error")
                return completion(nil)
            }
            guard (200 ... 299) ~= response.statusCode else {
                // check for http errors
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                return completion(nil)
            }
            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    let user = User(json: json)
                    return completion(user)
                }
            } catch let error {
                print(error.localizedDescription)
                return completion(nil)
            }
        }
        task.resume()
    }
}

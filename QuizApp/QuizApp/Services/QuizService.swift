//
//  QuizService.swift
//  QuizApp
//
//  Created by five on 08/05/2020.
//  Copyright © 2020 Nina Kolarec. All rights reserved.
//

import Foundation

final class QuizService {
    func loadQuizList(completion: @escaping (([Quiz]?) -> Void)) {
        
        guard let quizzesURL = URL(string: "https://iosquiz.herokuapp.com/api/quizzes")
        else { return completion(nil) }
        
        var request = URLRequest(url: quizzesURL)
        request.httpMethod = "GET"
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
                let quizzes = try JSONDecoder().decode(QuizList.self, from: data)
                print(quizzes.quizList)
                return completion(quizzes.quizList)
            } catch {
                print(error.localizedDescription)
                return completion(nil)
            }
        }
        task.resume()
    }
}

//
//  QuizService.swift
//  QuizApp
//
//  Created by five on 08/05/2020.
//  Copyright © 2020 Nina Kolarec. All rights reserved.
//

import Foundation
import UIKit

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
    func loadImage(url: URL, completion: @escaping ((UIImage?) -> Void)) {
        var request = URLRequest(url: url)
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
            let image =  UIImage(data: data)
            return completion(image)
        }
        task.resume()
    }
    func postResult(result: Result, token: String, completion: @escaping ((String?) -> Void)) {
        
        guard let url = URL(string: "https://iosquiz.herokuapp.com/api/result")
        else { return completion(nil) }
        let parameters = [
            "quiz_id": result.quiz_id,
            "user_id": result.user_id,
            "time": result.time,
            "no_of_correct": result.no_of_correct] as [String : Any]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(token, forHTTPHeaderField: "Authorization")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        else { return completion(nil) }
        request.httpBody = httpBody
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let response = response as? HTTPURLResponse,
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
            return completion("\(response.statusCode) OK - success")
        }
        task.resume()
    }
}


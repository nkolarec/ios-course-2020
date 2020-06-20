//
//  LeaderboardService.swift
//  QuizApp
//
//  Created by five on 19/06/2020.
//  Copyright © 2020 Nina Kolarec. All rights reserved.
//

import Foundation
final class LeaderboardService {
    func loadLeaderboard(quiz_id: Int, token: String, completion: @escaping (([Score]?) -> Void)) {
        let queryItem = URLQueryItem(name: "quiz_id", value: "\(quiz_id)")
        var leaderboardURLComponents = URLComponents(string: "https://iosquiz.herokuapp.com/api/score")
        leaderboardURLComponents?.queryItems = [queryItem]
        guard let leaderboardURL = leaderboardURLComponents?.url?.absoluteURL
        else { return completion(nil) }
        var request = URLRequest(url: leaderboardURL)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(token, forHTTPHeaderField: "Authorization")
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
                let leaderboard = try JSONDecoder().decode([Score].self, from: data)
                print(leaderboard)
                return completion(leaderboard)
            } catch {
                print(error.localizedDescription)
                return completion(nil)
            }
        }
        task.resume()
    }
}

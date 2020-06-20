//
//  ScoreboardViewController.swift
//  QuizApp
//
//  Created by five on 02/06/2020.
//  Copyright © 2020 Nina Kolarec. All rights reserved.
//

import UIKit

final class LeaderboardViewController: UIViewController {
    
    //MARK: - Properties
    var quiz_id: Int = -1
    private var leaderboard : [Score] = []
    private let tokenKey = "token"
    private let userDefaults = UserDefaults.standard
    
    //MARK: - Private UI
    @IBOutlet private weak var leaderboardTableView: UITableView!
    
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        _setupTableView()
        _loadLeaderboard()
    }
}
extension LeaderboardViewController {
    private func _setupTableView() {
        leaderboardTableView.estimatedRowHeight = 51
        leaderboardTableView.rowHeight = UITableView.automaticDimension
        leaderboardTableView.separatorStyle = .none
        leaderboardTableView.delegate = self
        leaderboardTableView.dataSource = self
    }
}
extension LeaderboardViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leaderboard.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("CURRENT INDEX PATH BEING CONFIGURED: \(indexPath)")
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ScoreTableViewCell.self), for: indexPath) as! ScoreTableViewCell
        cell.configure(score: leaderboard[indexPath.row], number: indexPath.row + 1)
        return cell
    }
}
//MARK: - GET Leaderboard
extension LeaderboardViewController {
    func _loadLeaderboard() {
        guard let token = userDefaults.string(forKey: tokenKey)
        else { return }
        let leaderboardService = LeaderboardService()
        leaderboardService.loadLeaderboard(quiz_id: quiz_id, token: token) { (result) in
            DispatchQueue.main.async {
                if result != nil {
                    self.leaderboard = result!
                    self.leaderboard.sort{ (score1, score2) -> Bool in
                        guard let s1 = Double(score1.score), let s2 = Double(score2.score)
                        else {
                            return score1.username < score2.username
                        }
                        if s1 != s2 { return s1 > s2 }
                        return score1.username < score2.username
                    }
                    self.removeDuplicates()
                    while self.leaderboard.count > 20 {
                        self.leaderboard.removeLast()
                    }
                    self.leaderboardTableView.reloadData()
                } else {
                    self._showAlert(title: "Loading Error", message: "Failed to load quizzes.")
                }
            }
        }
    }
    private func removeDuplicates() {
        var new_leaderboard: [Score] = []
        var usernames: [String] = []
        for score in leaderboard {
            if !usernames.contains(score.username){
                new_leaderboard.append(score)
                usernames.append(score.username)
            }
        }
        leaderboard = new_leaderboard
    }
}


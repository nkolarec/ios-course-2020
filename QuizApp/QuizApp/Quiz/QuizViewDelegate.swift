//
//  QuizViewDelegate.swift
//  QuizApp
//
//  Created by five on 23/05/2020.
//  Copyright © 2020 Nina Kolarec. All rights reserved.
//

import Foundation
import UIKit

protocol QuizViewDelegate: class {
    func _answerPressed(button: UIButton, indexPath: IndexPath)
}

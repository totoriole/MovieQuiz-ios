//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Toto Tsipun on 15.03.2023.
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    func showQuestion(quiz step: QuizStepViewModel)
    func show(model: QuizResultsViewModel)
    func presentAlert(model: AlertModel)
    
    func highlightImageBorder(isCorrect: Bool)
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func showNetworkError(message: String)
}

//
//  PresenterTest.swift
//  MovieQuizTests
//
//  Created by Toto Tsipun on 15.03.2023.
//

import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    func showQuestion(quiz step: QuizStepViewModel) {
        
    }
    
    func show(model: QuizResultsViewModel) {
        
    }
    
    func highlightImageBorder(isCorrect: Bool) {
        
    }
    
    func showLoadingIndicator() {
        
    }
    
    func hideLoadingIndicator() {
        
    }
    
    func showNetworkError(message: String) {
        
    }
    
}

final class PresenterTest: XCTestCase {

    func testPresenterConvertModel() throws{
        let viewControllerMock = MovieQuizViewControllerMock()
        let sut = MovieQuizPresenter(viewController: viewControllerMock)
        
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Quiez Question", correctAnswer: true)
        
        let viewModel = sut.convert(model: question)
        
        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Quiez Question")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}

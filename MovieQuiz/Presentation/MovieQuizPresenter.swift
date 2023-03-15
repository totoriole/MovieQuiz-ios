//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Toto Tsipun on 14.03.2023.
//

import UIKit

final class MovieQuizPresenter {
    let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewController?
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        // преобразовываем данные модели вопроса в те, что нужно показать на экране
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1 // - 1 потому что индекс начинается с 0, а длинна массива — с 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1 // увеличиваем индекс текущего вопроса на 1; таким образом мы сможем получить следующий вопрос
    }
    
    func yesButtonClicked() {
        // проверка ответа
        let userAnswer = true
        guard let currentQuestion = currentQuestion else { return }
        viewController?.showAnswerResult(isCorrect: userAnswer == currentQuestion.correctAnswer)
    }
    
    func noButtonClicked() {
        // проверка ответа
        let userAnswer = false
        guard let currentQuestion = currentQuestion else { return }
        viewController?.showAnswerResult(isCorrect: userAnswer == currentQuestion.correctAnswer)
    }
}

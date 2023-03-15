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
    var questionFactory: QuestionFactoryProtocol?
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewController?
    var statisticService: StatisticService = StatisticServiceImplementation()
    var alertPresenter: AlertPresenterProtocol?
    var correctAnswers: Int = 0
    
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
        didAnswer(isYes: true)
    }
    
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    
    func didAnswer(isYes: Bool) {
        // проверка ответа
        guard let currentQuestion = currentQuestion else { return }
        let userAnswer = isYes
        viewController?.showAnswerResult(isCorrect: userAnswer == currentQuestion.correctAnswer)
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.showQuestion(quiz: viewModel)
        }
    }
    
    func showQuestionOrResult() {
        
        if self.isLastQuestion() {
            // показать результат квизa
            statisticService.store(correct: correctAnswers, total: self.questionsAmount)
            let text = """
            Ваш результат: \(correctAnswers) из 10
            Количество сыграных квизов: \(statisticService.gamesCount)
            Рекорд: \(statisticService.bestGame.correct ) /\(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString))
            Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
            """
            let alertModel: AlertModel = AlertModel(
                title: "Этот раунд окончен!",
                message: text,
                buttonText: "Сыграть еще раз") { [weak self] in
                    guard let self = self  else { return nil }
                    return self.restartGame()
                }
            viewController?.presentAlert(model: alertModel)
            correctAnswers = 0
        } else {
            self.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
}

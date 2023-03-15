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
    private var questionFactory: QuestionFactoryProtocol?
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
    
    private func didAnswer(isYes: Bool) {
        // проверка ответа
        let userAnswer = isYes
        guard let currentQuestion = currentQuestion else { return }
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
    
    private func showQuestionOrResult() {
        
        if self.isLastQuestion() {
            // показать результат квизa
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            let textMessage =
            """
            Ваш результат: \(correctAnswers) из 10,
            Количество сыгранных квизов: \(statisticService.gamesCount)
            Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString))
            Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
            """
            let alert = AlertModel(title: "Этот раунд окончен!", message: textMessage, buttonText: "Cыграть еще раз") { [weak self] in
                guard let self = self else { return }
                self.resetQuestionIndex()
                guard let currentQuestion = self.currentQuestion else { return }
                let firstQuestionModel = self.convert(model: currentQuestion)
                self.viewController?.showQuestion(quiz: firstQuestionModel)
            }
            alertPresenter?.presentAlert(model: alert)
            correctAnswers = 0
            questionFactory?.requestNextQuestion()
        } else {
            self.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
}

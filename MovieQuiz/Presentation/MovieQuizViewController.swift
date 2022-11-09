import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    // MARK: - Lifecycle
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var yesButton: UIButton!
    
    private var currentQuestionIndex = 0
    private var correctAnswer = 0
    
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?

    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        // преобразовываем данные модели вопроса в те, что нужно показать на экране
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    private func show(quiz step: QuizStepViewModel) {
        // здесь мы заполняем нашу картинку, текст и счётчик данными
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        // здесь мы показываем результат прохождения квиза
        let alert = UIAlertController(title: result.title, message: result.text, preferredStyle: .alert)
        let action = UIAlertAction(title: result.buttonText, style: .default, handler: { _ in
            self.currentQuestionIndex = 0
            self.correctAnswer = 0
        })
        func didReceiveNextQuestion(question: QuizQuestion?) {
                guard let question = question else {
                    return
                }
                
                currentQuestion = question
                let viewModel = convert(model: question)
                DispatchQueue.main.async { [weak self] in
                    self?.show(quiz: viewModel)
                }
            }
        alert.addAction(action)
        self.present(alert, animated: true)
        questionFactory?.requestNextQuestion()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionFactory = QuestionFactory(delegate: self)
        questionFactory?.requestNextQuestion()
    }
    
    // MARK: - QuestionFactoryDelegate

    func didRecieveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        show(quiz: viewModel)
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        // отображаем результат ответа (выделяем рамкой верный или неверный ответ)
        if isCorrect {
            correctAnswer += 1
        }
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen?.cgColor : UIColor.ypRed?.cgColor
        noButton.isEnabled = false
        yesButton.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showQuestionOrResult()
            self.imageView.layer.borderWidth = 0
            self.noButton.isEnabled = true
            self.yesButton.isEnabled = true
        }
    }
    
    private func showQuestionOrResult() {
        if currentQuestionIndex == questionsAmount - 1 { // - 1 потому что индекс начинается с 0, а длинна массива — с 1
            // показать результат квиза
            let title = "Игра окончена"
            let text = correctAnswer == questionsAmount ? "Отличная работа! \nВы ответили на 10 из 10 вопросов!" : "Вы ответили на \(correctAnswer) из \(questionsAmount) вопросов"
            let buttonText = "Cыграть еще раз"
            let viewModel = QuizResultsViewModel(title: title, text: text, buttonText: buttonText)
            show(quiz: viewModel)
        } else {
            currentQuestionIndex += 1 // увеличиваем индекс текущего урока на 1; таким образом мы сможем получить следующий вопрос
            // показать следующий вопрос
            questionFactory?.requestNextQuestion()
        }
    }
    
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        // проверка ответа
        guard let currentQuestion = currentQuestion else {
            return
        }
        let userAnswer = false
        showAnswerResult(isCorrect: userAnswer == currentQuestion.correctAnswer)
        
    }
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        // проверка ответа
        guard let currentQuestion = currentQuestion else {
            return
        }
        let userAnswer = true
        showAnswerResult(isCorrect: userAnswer == currentQuestion.correctAnswer)
    }
    
    
}

/*
 Mock-данные
 
 
 Картинка: The Godfather
 Настоящий рейтинг: 9,2
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Dark Knight
 Настоящий рейтинг: 9
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Kill Bill
 Настоящий рейтинг: 8,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Avengers
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Deadpool
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Green Knight
 Настоящий рейтинг: 6,6
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Old
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: The Ice Age Adventures of Buck Wild
 Настоящий рейтинг: 4,3
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: Tesla
 Настоящий рейтинг: 5,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: Vivarium
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 */

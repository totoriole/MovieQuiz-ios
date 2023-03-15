import UIKit



final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {    
    
    // MARK: - Lifecycle
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    private var correctAnswers: Int = 0
    private var currentQuestion: QuizQuestion?
    private var questionFactory: QuestionFactoryProtocol?
    private var alertPresenter: AlertPresenterProtocol?
    private var statisticService: StatisticService = StatisticServiceImplementation()
    private let presenter = MovieQuizPresenter()
    
    // скрываем индикатор и показываем новый экран
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true // скрываем индикатор загрузки
        questionFactory?.requestNextQuestion()
    }
    
    // переводим экран в состояние ошибки
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription) // возьмём в качестве сообщения описание ошибки
    }
    
    // отображение индикатора загрузки
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false // говорим, что индикатор загрузки не скрыт
        activityIndicator.startAnimating() // включаем анимацию
    }
    
    // скрытие индикатора загрузки
    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true // говорим, что индикатор загрузки скрыт
        activityIndicator.stopAnimating() // анимация отключена
    }
    
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let model = AlertModel(title: "Ошибка", message: message, buttonText: "Попробуйте еще раз"){ [weak self] in
        guard let self = self else { return }
            self.questionFactory?.loadData()
        }
        alertPresenter?.present(model: model)
    }
    
    private func showQuestion(quiz step: QuizStepViewModel) {
        // здесь мы заполняем нашу картинку, текст и счётчик данными
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertPresenter = AlertPresenter(viewController: self)
        questionFactory = QuestionFactory(delegate: self, moviesLoader: MoviesLoader())
        statisticService = StatisticServiceImplementation()
        questionFactory?.loadData()
        showLoadingIndicator()
        presenter.viewController = self
    }
    
    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        currentQuestion = question
        let viewModel = presenter.convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.showQuestion(quiz: viewModel)
        }
    }
    
    func showAnswerResult(isCorrect: Bool) {
        // отображаем результат ответа (выделяем рамкой верный или неверный ответ)
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen?.cgColor : UIColor.ypRed?.cgColor
        noButton.isEnabled = false
        yesButton.isEnabled = false
        if isCorrect {
            correctAnswers += 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.imageView.layer.borderWidth = 0
            self.noButton.isEnabled = true
            self.yesButton.isEnabled = true
            self.showQuestionOrResult()
        }
    }
    
    private func showQuestionOrResult() {
        
        if presenter.isLastQuestion() {
            // показать результат квизa
            statisticService.store(correct: correctAnswers, total: presenter.questionsAmount)
            let textMessage =
            """
            Ваш результат: \(correctAnswers) из 10,
            Количество сыгранных квизов: \(statisticService.gamesCount)
            Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString))
            Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
            """
            let alert = AlertModel(title: "Этот раунд окончен!", message: textMessage, buttonText: "Cыграть еще раз") { [weak self] in
                guard let self = self else { return }
                self.presenter.resetQuestionIndex()
                guard let currentQuestion = self.currentQuestion else { return }
                let firstQuestionModel = self.presenter.convert(model: currentQuestion)
                self.showQuestion(quiz: firstQuestionModel)
            }
            alertPresenter?.present(model: alert)
            correctAnswers = 0
            questionFactory?.requestNextQuestion()
        } else {
            presenter.switchToNextQuestion()
            // показать следующий вопрос
            questionFactory?.requestNextQuestion()
        }
    }
    
    // MARK: - Actions
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        // проверка ответа
        presenter.currentQuestion = currentQuestion
        presenter.noButtonClicked()
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        // проверка ответа
        presenter.currentQuestion = currentQuestion
        presenter.yesButtonClicked()
    }
}

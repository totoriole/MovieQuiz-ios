import UIKit



final class MovieQuizViewController: UIViewController {
    
    // MARK: - Lifecycle
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    private var alertPresenter: AlertPresenterProtocol?
//    private var statisticService: StatisticService = StatisticServiceImplementation()
    private var presenter: MovieQuizPresenter!
    
    // отображение индикатора загрузки
    func showLoadingIndicator() {
        activityIndicator.isHidden = false // говорим, что индикатор загрузки не скрыт
        activityIndicator.startAnimating() // включаем анимацию
    }
    
    // скрытие индикатора загрузки
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true // говорим, что индикатор загрузки скрыт
        activityIndicator.stopAnimating() // анимация отключена
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let model = AlertModel(title: "Ошибка", message: message, buttonText: "Попробуйте еще раз"){ [weak self] in
        guard let self = self else { return }
            self.presenter.restartGame()
        }
        alertPresenter?.presentAlert(model: model)
    }
    
    func presentAlert(model: AlertModel) {
        alertPresenter?.presentAlert(model: model)
    }
    
    func showQuestion(quiz step: QuizStepViewModel) {
        // здесь мы заполняем нашу картинку, текст и счётчик данными
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MovieQuizPresenter(viewController: self)
        alertPresenter = AlertPresenter(viewController: self)
//        statisticService = StatisticServiceImplementation()
        showLoadingIndicator()
    }
    
    func showAnswerResult(isCorrect: Bool) {
        // отображаем результат ответа (выделяем рамкой верный или неверный ответ)
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen?.cgColor : UIColor.ypRed?.cgColor
        presenter.didAnswer(isCorrect: isCorrect)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.presenter.showQuestionOrResult()
        }
    }
    
    // MARK: - Actions
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        // проверка ответа
        presenter.noButtonClicked()
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        // проверка ответа
        presenter.yesButtonClicked()
    }
}

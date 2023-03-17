import UIKit



final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    
    // MARK: - Lifecycle
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    private var presenter: MovieQuizPresenter!
    private var alertPresenter: AlertPresenterProtocol?
    
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
        
        let model = UIAlertController(title: "Ошибка",
                                      message: message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "Попробовать ещё раз", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.presenter.restartGame()
        }
        model.addAction(action)
    }
    
    func show(model: QuizResultsViewModel) {
        let message = presenter.makeResultsMessage()
        
        let alert = UIAlertController(title: model.title,
                                      message: message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: model.buttonText, style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.presenter.restartGame()
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showQuestion(quiz step: QuizStepViewModel) {
        // здесь мы заполняем нашу картинку, текст и счётчик данными
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        imageView.layer.borderWidth = 0
    }
    
    func presentAlert(model: AlertModel) {
        alertPresenter?.presentAlert(model: model)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MovieQuizPresenter(viewController: self)
        showLoadingIndicator()
        alertPresenter = AlertPresenter(viewController: self)
    }
    
    func highlightImageBorder(isCorrect: Bool) {
        // отображаем результат ответа (выделяем рамкой верный или неверный ответ)
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen?.cgColor : UIColor.ypRed?.cgColor
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

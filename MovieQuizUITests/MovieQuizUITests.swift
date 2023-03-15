//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Toto Tsipun on 13.03.2023.
//

import XCTest

final class MovieQuizUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        app = XCUIApplication() //разворачиваем неявно развернутый опционал
        app.launch()
        // In UI tests it is usually best to stop immediately when a failure occurs.
        //это специальная настройка для тестов: если один тест не прошёл, то следующие тесты запускаться не будут.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        try super.tearDownWithError()
        app.terminate()
        app = nil
    }
    
    func testYesButton() {
        sleep(3)
        let firstPoster = app.images["Poster"] //находим первый постер
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        let indexLabel = app.staticTexts["Index"]
        app.buttons["Yes"].tap() //находим и нажимаем кнопку "ДА"
        
        sleep(3)
        let secondPoster = app.images["Poster"] //снова находим постер
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        XCTAssertNotEqual(firstPosterData, secondPosterData) //сравниваем, что первый и второй постер разные
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
    func testNoButton() {
        sleep(3)
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation

        let indexLabel = app.staticTexts["Index"]
        app.buttons["No"].tap()
        sleep(3)
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        XCTAssertNotEqual(firstPosterData, secondPosterData) //сравниваем, что первый и второй постер разные
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
    func testScreenCast() throws {
        app.buttons["Yes"].tap()
    }
    
    func testAlert() {
        sleep(3)
        for _ in 1...10 {
            app.buttons["Yes"].tap()
            sleep(3)
        }
        let alert = app.alerts["id"]
        
        XCTAssertTrue(alert.exists)
        XCTAssertEqual(alert.label, "Этот раунд окончен!")
        XCTAssertEqual(alert.buttons.firstMatch.label, "Cыграть еще раз")
    }
    
    func testAlertDismiss() {
        sleep(3)
        for _ in 1...10 {
            app.buttons["Yes"].tap()
            sleep(3)
        }
        
        let alert = app.alerts["id"]
        alert.buttons["Cыграть еще раз"].tap()
        
        sleep(3)
        XCTAssertFalse(alert.exists)
        let indexLabel = app.staticTexts["Index"]
        XCTAssertEqual(indexLabel.label, "1/10")
    }
}

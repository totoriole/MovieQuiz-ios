//
//  MovieQuizTests.swift
//  MovieQuizTests
//
//  Created by Toto Tsipun on 09.03.2023.
//

//import XCTest
//
//struct ArithmeticOperations {
//    func addition(num1: Int, num2: Int, handler: @escaping (Int) -> Void) {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//            handler(num1 + num2)
//        }
//    }
//    func subtraction(num1: Int, num2: Int, handler: @escaping(Int) -> Void) {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//            handler(num1 - num2)
//        }
//    }
//    func multiplication(num1: Int, num2: Int, handler: @escaping(Int) -> Void) {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//            handler(num1 * num2)
//        }
//    }
//}
//
//final class MovieQuizTests: XCTestCase {
//
//    func testAddition() throws {
//        //Given
//        let arithmeticOperations = ArithmeticOperations()
//        let num1 = 1
//        let num2 = 2
//        //When
//        let expectation = expectation(description: "Addiction function expectation")
//
//        arithmeticOperations.addition(num1: num1, num2: num2) { result in
//            //Then
//            XCTAssertEqual(result, 3) // сравниваем результат выполнения функции и наши ожидания
//            expectation.fulfill()
//        }
//        waitForExpectations(timeout: 2)
//    }
//
//    func testLaunchPerformance() throws {
//        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
//            // This measures how long it takes to launch your application.
//            measure(metrics: [XCTApplicationLaunchMetric()]) {
//                XCUIApplication().launch()
//            }
//        }
//    }
//}

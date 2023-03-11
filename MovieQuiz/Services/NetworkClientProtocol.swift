//
//  NetworkClientProtocol.swift
//  MovieQuiz
//
//  Created by Toto Tsipun on 10.03.2023.
//

import UIKit

protocol NetworkRouting {
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void)
}

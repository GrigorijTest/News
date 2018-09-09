//
//  NetworkClient.swift
//  TinkoffNews
//
//  Created by Gregory Oberemkov on 09.09.2018.
//  Copyright © 2018 Gregory Oberemkov. All rights reserved.
//

import Foundation

enum ErrorDescription: Error {
    case error(message: String?)
    case connectionError
    
    var description: String {
        
        switch self {
        case .error(let message): return message ?? "Что-то пошло не так"
        case .connectionError: return "Произошла ошибка!"
        }
        
    }
}

enum ApiResult<T> {
    case succes(T)
    case failure(ErrorDescription)
}

final class NetworkClient {
    
    // MARK: - Properties
    
    private var session: URLSession
    private let baseURLString: String = "https://api.tinkoff.ru/v1/"
    
    
    // MARK: - Initilize
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = TimeInterval(15)
        self.session = URLSession(configuration: configuration)
    }
    
    
    // MARK: - Method interface
    
    func request<T: Decodable>(endPoint: String, completion: @escaping (ApiResult<T>) -> Void) {
        let urlString = baseURLString + endPoint
        
        guard let apiURL = URL(string: urlString) else {
            fatalError("incorrect URL")
        }
        
        let request = URLRequest(url: apiURL)
        
        task(with: request, completion: completion)
    }
    
    
    // MARK: - Private methods
    
    private func task<T: Decodable>(with request: URLRequest, completion: @escaping (ApiResult<T>) -> Void) {
        let task = session.dataTask(with: request) { (data, response, error) in
            let result: ApiResult<T>
            
            defer {
                DispatchQueue.main.async {
                    completion(result)
                }
            }
            
            guard let HTTPResponse = response as? HTTPURLResponse else {
                result = .failure(ErrorDescription.connectionError)
                return
            }
            
            if let data = data {
                switch HTTPResponse.statusCode {
                case 200:
                    do {
                        let resultData = try JSONDecoder().decode(T.self, from: data)
                        result = .succes(resultData)
                    } catch {
                        result = .failure(ErrorDescription.error(message: error.localizedDescription))
                    }
                default:
                    result = .failure(ErrorDescription.error(message: error?.localizedDescription))
                }
            } else {
                result = .failure(ErrorDescription.error(message: error?.localizedDescription))
            }
            
        }
        task.resume()
    }
}

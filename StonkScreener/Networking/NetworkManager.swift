//
//  NetworkManager.swift
//  StonkScreener
//
//  Created by Luka on 19.2.22.
//

import Foundation

enum RequestResult<Success, Failure> where Failure: Error {
    case success(Success)
    case failure(Failure)
}

enum RequestLoadingError: Error {
    case networkFailure(Error)
    case invalidData
}

class NetworkManager {
    typealias StonksHandler = (RequestResult<StockArray, RequestLoadingError>) -> Void
    typealias SearchResultsHandler = (RequestResult<StockArray, RequestLoadingError>) -> Void

    let urlString = "https://financialmodelingprep.com/api/v3/stock-screener?marketCapMoreThan=1000000000&volumeMoreThan=10000&sector=Technology&exchange=NASDAQ&limit=100&apikey=d64d179adb2bcbf73edd76abd7e9e477"
    
    func getStocks(completionHandler: @escaping StonksHandler) {
        if let endpointUrl = URL(string:urlString) {
            let task = URLSession.shared.dataTask(with: endpointUrl) { result in
                switch result {
                case .success(let data):
                    if let stocksResponse = try? JSONDecoder().decode(StockArray.self, from: data) {
                        completionHandler(.success(stocksResponse))
                    } else {
                        completionHandler(.failure(.invalidData))
                    }
                case .failure(let error):
                    completionHandler(.failure(.networkFailure(error)))
                }
            }
            task.resume()
        }
    }
}

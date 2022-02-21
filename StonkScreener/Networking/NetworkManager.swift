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
    typealias StocksHandler = (RequestResult<StockArray, RequestLoadingError>) -> Void
    typealias SearchResultsHandler = (RequestResult<StockArray, RequestLoadingError>) -> Void
    typealias NewsHandler = (RequestResult<StockNewsArray, RequestLoadingError>) -> Void

    let urlString = "https://financialmodelingprep.com/api/v3/stock-screener?marketCapMoreThan=1000000000&volumeMoreThan=10000&sector=Technology&exchange=NASDAQ&limit=100&apikey=d64d179adb2bcbf73edd76abd7e9e477"
    
    func getStocks(completionHandler: @escaping StocksHandler) {
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
    
    func getNewsForStock(withSymbol symbol: String, completionHandler: @escaping NewsHandler) {
        if let endpointUrl = URL(string:"https://financialmodelingprep.com/api/v3/stock_news?tickers=\(symbol)&limit=1000&apikey=d64d179adb2bcbf73edd76abd7e9e477") {
            let task = URLSession.shared.dataTask(with: endpointUrl) { result in
                switch result {
                case .success(let data):
                    if let pageResults = try? JSONDecoder().decode(StockNewsArray.self, from: data) {
                        completionHandler(.success(pageResults))
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
    
    func getNewsForStock(withSymbol symbol: String, andPage page: Int, completionHandler: @escaping NewsHandler) {
        if let endpointUrl = URL(string:"https://financialmodelingprep.com/api/v3/stock_news?tickers=\(symbol)&page=\(page)&apikey=d64d179adb2bcbf73edd76abd7e9e477") {
            let task = URLSession.shared.dataTask(with: endpointUrl) { result in
                switch result {
                case .success(let data):
                    if let pageResults = try? JSONDecoder().decode(StockNewsArray.self, from: data) {
                        completionHandler(.success(pageResults))
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

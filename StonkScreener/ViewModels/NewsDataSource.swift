//
//  NewsDataSource.swift
//  StonkScreener
//
//  Created by Luka on 21.2.22.
//

import Foundation

class NewsDataSource {
    let networkManager = NetworkManager()
    private var fetchedNews = StockNewsArray()
    private var newsLoadingError = String()

    func getNewsForStockWithSymbol(symbol: String, isSuccessfull: @escaping (Bool) -> ()) {
        networkManager.getNewsForStock(withSymbol: symbol, completionHandler: { [weak self] result in
            switch result {
            case .success(let newsResponse):
                self?.fetchedNews = newsResponse
                isSuccessfull(true)
                break
            case .failure(.invalidData):
                isSuccessfull(false)
                self?.newsLoadingError = "Invalid data"
                break
            case .failure(.networkFailure(let error)):
                self?.newsLoadingError = error.localizedDescription
                isSuccessfull(false)
                break
            }
        })
    }
    
    func getNewsForStockWithSymbol(symbol: String, page: Int, isSuccessfull: @escaping (Bool) -> ()) {
        networkManager.getNewsForStock(withSymbol: symbol, andPage: page, completionHandler: { [weak self] result in
            switch result {
            case .success(let newsResponse):
                self?.fetchedNews.append(contentsOf: newsResponse)
                isSuccessfull(true)
                break
            case .failure(.invalidData):
                isSuccessfull(false)
                self?.newsLoadingError = "Invalid data"
                break
            case .failure(.networkFailure(let error)):
                self?.newsLoadingError = error.localizedDescription
                isSuccessfull(false)
                break
            }
        })
    }
    
    func getNewsArray() -> StockNewsArray {
        return fetchedNews
    }
}

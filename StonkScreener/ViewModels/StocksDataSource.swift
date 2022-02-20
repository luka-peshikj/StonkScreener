//
//  StocksViewModel.swift
//  StonkScreener
//
//  Created by Luka on 19.2.22.
//

import Foundation

enum SortBy: Int {
    case none
    case alphabetical
    case marketCap
}

class StocksDataSource {
    let networkManager = NetworkManager()
    private var fetchedStocks = StockArray()
    private var stocksLoadingError = String()
    private var searchLoadingError = String()
    var filterPredicate = String()
    var tabBarIndex = 0
    var sortByOption = SortBy.none
    
    func getStocks(isSuccessfull: @escaping (Bool) -> ()) {
        networkManager.getStocks() { [weak self] result in
            switch result {
            case .success(let stocksResponse):
                self?.fetchedStocks = stocksResponse
                isSuccessfull(true)
                break
            case .failure(.invalidData):
                isSuccessfull(false)
                self?.stocksLoadingError = "Invalid data"
                break
            case .failure(.networkFailure(let error)):
                self?.stocksLoadingError = error.localizedDescription
                isSuccessfull(false)
                break
            }
        }
    }
    
    func filterStocksWithPredicate() -> StockArray {
        if filterPredicate.isEmpty {
            return fetchedStocks
        } else {
            return fetchedStocks.filter { $0.symbol.localizedCaseInsensitiveContains(filterPredicate) || $0.companyName.localizedCaseInsensitiveContains(filterPredicate) }
        }
    }
    
    func saveLocalStock(stock: Stock) {
        LocalStorage.saveStockToLocalStorage(stock: stock)
    }
    
    func deleteLocalStock(stock: Stock) {
        LocalStorage.deleteStockFromLocalStorage(stock: stock)
    }
    
    func getLocallySavedStock() -> StockArray {
        return LocalStorage.getLocallySavedFavorites()
    }
    
    func getFetchedStocks() -> StockArray {
        return fetchedStocks
    }
    
    func sortStocks(stocks: StockArray) -> StockArray {
        switch sortByOption {
        case SortBy.none:
            return stocks
        case SortBy.alphabetical:
            return stocks.sorted(by: { $0.symbol < $1.symbol })
        case SortBy.marketCap:
            return stocks.sorted(by: { $0.marketCap > $1.marketCap })
        }
    }
    
    func getStocksForCurrentSettings() -> StockArray {
        return sortStocks(stocks: filterStocksWithPredicate())
    }
    
    func getStocksArray() -> StockArray {
        if tabBarIndex == 0 {
            return getStocksForCurrentSettings()
        } else if tabBarIndex == 1 {
            return getLocallySavedStock()
        } else {
            return []
        }
    }
    
    func addToFavorites(stock: Stock) {
        
    }
}

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
    
    private let networkManager = NetworkManager()
    private var fetchedStocks = StockArray()
    private var stocksLoadingError = String()
    private var searchLoadingError = String()
    var filterPredicate = String()
    var tabBarIndex = 0
    var sortByOption = SortBy.none
    var countriesFilterArray = Array<String>()
    
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
    
    private func filterStocksWithPredicate(stocks: StockArray) -> StockArray {
        if filterPredicate.isEmpty {
            return stocks
        } else {
            return stocks.filter { $0.symbol.localizedCaseInsensitiveContains(filterPredicate) || $0.companyName.localizedCaseInsensitiveContains(filterPredicate) }
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
    
    private func sortStocks(stocks: StockArray) -> StockArray {
        switch sortByOption {
        case SortBy.none:
            return stocks
        case SortBy.alphabetical:
            return stocks.sorted(by: { $0.symbol < $1.symbol })
        case SortBy.marketCap:
            return stocks.sorted(by: { $0.marketCap > $1.marketCap })
        }
    }
    
    private func getStocksForCurrentSettings(stocks: StockArray) -> StockArray {
        return filterStocksArrayWithCountries(forArray:sortStocks(stocks: filterStocksWithPredicate(stocks: stocks)))
    }
    
    func getStocksArray() -> StockArray {
        if tabBarIndex == 0 {
            return getStocksForCurrentSettings(stocks: fetchedStocks)
        } else if tabBarIndex == 1 {
            return getStocksForCurrentSettings(stocks: getLocallySavedStock())
        } else {
            return []
        }
    }
    
    func addToFavorites(stock: Stock) -> Bool {
        if (getLocallySavedStock().contains(where: { $0.symbol == stock.symbol })) {
            deleteLocalStock(stock: stock)
            return false
        } else {
            saveLocalStock(stock: stock)
            return true
        }
    }
    
    private func filterStocksArrayWithCountries(forArray array: StockArray) -> StockArray {
        if countriesFilterArray.isEmpty {
            return array
        } else {
            return array.filter( { countriesFilterArray.contains($0.country)} )
        }
    }
}

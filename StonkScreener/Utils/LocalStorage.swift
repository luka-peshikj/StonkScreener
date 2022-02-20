//
//  LocalStorage.swift
//  StonkScreener
//
//  Created by Luka on 19.2.22.
//

import Foundation

class LocalStorage {
    static func getLocallySavedFavorites() -> StockArray {
        if let stocksData = UserDefaults.standard.data(forKey: "FavoritesStocksKey"),
            let stocksArray = try? JSONDecoder().decode(StockArray.self, from: stocksData) {
            return stocksArray
        }
        return[]
    }
    
    static func saveStockToLocalStorage(stock: Stock) {
        var stocksArray = getLocallySavedFavorites()
        stocksArray.append(stock)
        saveStockArrayToLocalStorage(array: stocksArray)
    }
    
    static func deleteStockFromLocalStorage(stock: Stock) {
        let stockArray = getLocallySavedFavorites().filter {$0.symbol != stock.symbol}
        saveStockArrayToLocalStorage(array: stockArray)
    }
    
    private static func saveStockArrayToLocalStorage(array: StockArray) {
        if let encoded = try? JSONEncoder().encode(array) {
            UserDefaults.standard.set(encoded, forKey: "FavoritesStocksKey")
        }
    }
}

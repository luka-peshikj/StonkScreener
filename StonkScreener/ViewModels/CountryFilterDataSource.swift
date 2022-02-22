//
//  CountryFilterDataSource.swift
//  StonkScreener
//
//  Created by Luka on 22.2.22.
//

import Foundation


class CountryFilterDataSource {
    
    private var stocksArray = StockArray()
    private var countrySet = Set<String>()
    private var selectedCountrisToFilter = Set<String>()
    
    func configureDataSource(withStocks stocks: StockArray) {
        countrySet = Set(stocks.map {$0.country} )
    }
    
    func getCountryArray() -> Array<String> {
        return Array(countrySet)
    }
    
    func addCountryToFilter(country: String) {
        selectedCountrisToFilter.update(with: country)
    }

    func deleteCountryFromFilter(country: String) {
        selectedCountrisToFilter.remove(country)
    }
    
    func getActiveCountrySet() -> Set<String> {
        return selectedCountrisToFilter
    }
}

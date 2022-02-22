//
//  Stonk.swift
//  StonkScreener
//
//  Created by Luka on 19.2.22.
//

struct Stock: Codable {
    let symbol, companyName: String
    let marketCap: Int
    let sector: Sector
    let industry: String
    let beta, price, lastAnnualDividend: Double
    let volume: Int
    let exchange: Exchange
    let exchangeShortName: ExchangeShortName
    let country: String
    let isEtf, isActivelyTrading: Bool
}

enum Exchange: String, Codable {
    case nasdaqCapitalMarket = "Nasdaq Capital Market"
    case nasdaqGS = "NasdaqGS"
    case nasdaqGlobalMarket = "Nasdaq Global Market"
    case nasdaqGlobalSelect = "Nasdaq Global Select"
}

enum ExchangeShortName: String, Codable {
    case nasdaq = "NASDAQ"
}

enum Sector: String, Codable {
    case technology = "Technology"
}

typealias StockArray = [Stock]

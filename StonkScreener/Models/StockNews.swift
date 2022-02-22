//
//  StockNews.swift
//  StonkScreener
//
//  Created by Luka on 19.2.22.
//

struct StockNews: Codable {
    let symbol, publishedDate, title: String
    let image: String?
    let site, text: String
    let url: String
}

typealias StockNewsArray = [StockNews]

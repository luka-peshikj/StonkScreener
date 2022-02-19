//
//  Extensions.swift
//  StonkScreener
//
//  Created by Luka on 19.2.22.
//

import Foundation

extension URLSession {
    func dataTask(with url: URL, handler: @escaping (RequestResult<Data, Error>) -> Void) -> URLSessionDataTask {
        dataTask(with: url) { data, _, error in
            if let error = error {
                handler(.failure(error))
            } else {
                handler(.success(data ?? Data()))
            }
        }
    }
}

//
//  Extensions.swift
//  StonkScreener
//
//  Created by Luka on 19.2.22.
//

import Foundation
import UIKit

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

//This is a simple way of loading images asynchronously. However, I decided to go with a 3rd party option in this project.
extension UIImageView {
    func imageFromServerURL(_ URLString: String, placeHolder: UIImage?) {
        let imageServerUrl = URLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        if let url = URL(string: imageServerUrl) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if error != nil {
                    DispatchQueue.main.async {
                        self.image = placeHolder
                    }
                    return
                }
                DispatchQueue.main.async {
                    if let data = data {
                        if let downloadedImage = UIImage(data: data) {
                            self.image = downloadedImage
                        }
                    }
                }
            }).resume()
        }
    }
}

//
//  ApiService.swift
//  CurrencyApp
//
//  Created by Aleksandra Generowicz on 10/12/2021.
//

import Foundation

class ApiService: NSObject {
    
    private let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
    private let baseUrl = "https://api.nbp.pl/api/exchangerates/tables/"

    func sendRequest(endpoint: String, completion: @escaping (_ data: Data?) -> Void) {
        
        let finalUrl = URL(string: "\(baseUrl)\(endpoint)/?format=json")
        
        guard let url = finalUrl else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            
            if error != nil {
                print(error!)
                return
            } else {
                completion(data)
            }
        })
        task.resume()
    }
    
}

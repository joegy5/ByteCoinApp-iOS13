//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didFailWithError(error: Error)
    func didUpdateCurrency(_ coinManager: CoinManager, coinModel: CoinModel)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "F36E1F6D-7FDF-49B6-A697-EE7CC12BD7CD"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    
    var delegate: CoinManagerDelegate?
    
    func fetchPrice(for currency : String) {
        let urlString = baseURL + "/\(currency)?apikey=\(apiKey)"
        performRequest(with: urlString)
    }

    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) {data, response, error in
                
                if error != nil { // Handle the error so that it does not end up crashing the app
                    self.delegate?.didFailWithError(error: error!)
                
                }
                
                if let safeData = data {
                    if let coinModel = self.parseJSON(safeData) {
                        self.delegate?.didUpdateCurrency(self, coinModel: coinModel)
                    }
                }
            }
            task.resume()
        }
        
    }

    func parseJSON(_ coinData: Data) -> CoinModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            
            let currencyRate = decodedData.rate
            let currencyName = decodedData.asset_id_quote
            
            let coinModel = CoinModel(currencyName: currencyName, bitcoinPrice: currencyRate)
            return coinModel
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}

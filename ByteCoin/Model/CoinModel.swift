//
//  CoinModel.swift
//  ByteCoin
//
//  Created by Suren Gurivireddy on 8/1/22.
//  Copyright © 2022 The App Brewery. All rights reserved.
//

import Foundation

struct CoinModel {
    let currencyName: String
    let bitcoinPrice: Double
    
    var bitcoinPriceString: String {
        return String(format: "%.2f", bitcoinPrice)
    }
}

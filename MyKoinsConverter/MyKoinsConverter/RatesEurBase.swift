//
//  RatesEurBase.swift
//  MyKoinsConverter
//
//  Created by Antoine Proux on 29/05/2019.
//  Copyright © 2019 Antoine Proux. All rights reserved.
//

import UIKit

struct Rates: Codable {
    let base: String
    let rates: Dictionary<String, Double>
}

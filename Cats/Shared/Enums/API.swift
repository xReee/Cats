//
//  API.swift
//  Cats
//
//  Created by Renata Faria on 16/06/20.
//  Copyright © 2020 renatafaria. All rights reserved.
//

import Foundation

enum APIError: Error {
    case badURL
    case taskError
    case badResponse
    case invalidStatusCode(Int)
    case noData
    case invalidJSON
}

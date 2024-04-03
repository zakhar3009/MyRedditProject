//
//  Errors.swift
//  MyRedditProject
//
//  Created by Zakhar Litvinchuk on 03.04.2024.
//

import Foundation



enum NetworkingErrors : Error {
    case invalidURL
    case invalidResponse
    case invalidData
}

//
//  APIError.swift
//  MovieApp
//
//  Created by Aisana Ondassyn on 16.12.2025.
//


import Foundation

enum APIError: Error, LocalizedError {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
    case apiError(String)
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "URL-адрес недействителен."
        case .networkError(let error): return "Ошибка сети: \(error.localizedDescription)"
        case .decodingError(_): return "Ошибка декодирования данных."
        case .apiError(let msg): return "Ошибка API: \(msg)"
        case .unknown: return "Неизвестная ошибка."
        }
    }
}

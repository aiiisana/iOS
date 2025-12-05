//
//  NetworkError.swift
//  lab10
//
//  Created by Aisana Ondassyn on 05.12.2025.
//


import Foundation
import Alamofire

enum NetworkError: Error {
    case invalidURL
    case requestFailed(AFError)
    case noData
    case decodingFailed(Error)
}

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}

    private let allHeroesURL = "https://akabab.github.io/superhero-api/api/all.json"

    func fetchAllHeroes(completion: @escaping (Result<[Superhero], NetworkError>) -> Void) {
        AF.request(allHeroesURL).validate().responseData(queue: .global(qos: .utility)) { resp in
            switch resp.result {
            case .failure(let afError):
                completion(.failure(.requestFailed(afError)))
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let heroes = try decoder.decode([Superhero].self, from: data)
                    completion(.success(heroes))
                } catch {
                    completion(.failure(.decodingFailed(error)))
                }
            }
        }
    }
}

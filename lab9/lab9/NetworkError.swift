import Foundation

enum NetworkError: Error {
    case invalidURL
    case requestFailed
    case decodingFailed
}

class NetworkManager {

    static let shared = NetworkManager()
    private init() {}

    private let urlString = "https://akabab.github.io/superhero-api/api/all.json"

    func fetchHeroes(completion: @escaping (Result<[Superhero], NetworkError>) -> Void) {

        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in

            if error != nil {
                completion(.failure(.requestFailed))
                return
            }

            guard let data = data else { return }

            do {
                let heroes = try JSONDecoder().decode([Superhero].self, from: data)
                completion(.success(heroes))
            } catch {
                completion(.failure(.decodingFailed))
            }

        }.resume()
    }
}

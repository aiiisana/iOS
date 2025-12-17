import Foundation
import Alamofire

// MARK: - API Error Handling
class APIService {
    
    static let shared = APIService()
    
    private let apiKey = "a88bb2b5"
    private let baseURL = "https://www.omdbapi.com/"
    
    private init() {}

    // MARK: - Generic Request
    func request<T: Decodable>(parameters: Parameters, completion: @escaping (Result<T, APIError>) -> Void) {
        
        var fullParameters = parameters
        fullParameters["apikey"] = apiKey

        AF.request(baseURL, parameters: fullParameters)
            .validate()
            .responseDecodable(of: T.self) { response in
                
                DispatchQueue.main.async {
                    
                    switch response.result {
                    case .success(let decodedObject):
                        completion(.success(decodedObject))
                        
                    case .failure(let error):
                        if let afError = error.asAFError, afError.isSessionTaskError {
                            completion(.failure(.networkError(error)))
                            return
                        }
                        completion(.failure(.decodingError(error)))
                    }
                }
            }
    }
    
    // MARK: - Specific API Calls
    
    func searchMovies(query: String, completion: @escaping (Result<[OMDbMovieStub], APIError>) -> Void) {
        let params: Parameters = [
            "s": query,
            "type": "movie"
        ]
        
        request(parameters: params) { (result: Result<OMDbSearchResponse, APIError>) in
            switch result {
            case .success(let response):
                if response.Response == "True", let movies = response.Search {
                    completion(.success(movies))
                } else if response.Response == "False" {
                    completion(.failure(.apiError("No movies found for '\(query)'.")))
                } else {
                    completion(.failure(.unknown))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchMovieDetails(imdbID: String, completion: @escaping (Result<OMDbMovieDetail, APIError>) -> Void) {
        let params: Parameters = ["i": imdbID]
        
        request(parameters: params) { (result: Result<OMDbMovieDetail, APIError>) in
            switch result {
            case .success(let detail):
                completion(.success(detail))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

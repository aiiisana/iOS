import Foundation

struct OMDbSearchResponse: Decodable {
    let Search: [OMDbMovieStub]?
    let totalResults: String?
    let Response: String
}

struct OMDbMovieStub: Decodable {
    let Title: String?
    let Year: String?
    let imdbID: String?
    let Poster: String?
}

struct OMDbMovieDetail: Decodable {
    let Title: String?
    let Year: String?
    let imdbID: String?
    let Poster: String?
    let Plot: String?
    let imdbRating: String?
    let Runtime: String?
    let Genre: String?
    let Released: String?
    let Response: String?
}


import Foundation

class WatchlistManager {
    
    static let shared = WatchlistManager()
    
    // MARK: - Properties
    private let defaults = UserDefaults.standard
    private let watchlistKey = "savedMovieImdbIDs"
    
    private init() {}
    
    // MARK: - Core Logic
    func getWatchlistImdbIDs() -> [String] {
        return defaults.array(forKey: watchlistKey) as? [String] ?? []
    }
    
    private func saveWatchlistImdbIDs(ids: [String]) {
        defaults.set(ids, forKey: watchlistKey)
    }
    
    // MARK: - Public Actions

    func isMovieInWatchlist(imdbID: String) -> Bool {
        return getWatchlistImdbIDs().contains(imdbID)
    }

    func addMovie(imdbID: String) {
        var ids = getWatchlistImdbIDs()
        if !ids.contains(imdbID) {
            ids.append(imdbID)
            saveWatchlistImdbIDs(ids: ids)
            print("WatchlistManager: Added movie ID: \(imdbID)")
        }
    }
    
    func removeMovie(imdbID: String) {
        var ids = getWatchlistImdbIDs()
        if let index = ids.firstIndex(of: imdbID) {
            ids.remove(at: index)
            saveWatchlistImdbIDs(ids: ids)
            print("WatchlistManager: Removed movie ID: \(imdbID)")
        }
    }

    @discardableResult
    func toggleWatchlist(imdbID: String) -> Bool {
        if isMovieInWatchlist(imdbID: imdbID) {
            removeMovie(imdbID: imdbID)
            return false // Удален
        } else {
            addMovie(imdbID: imdbID)
            return true // Добавлен
        }
    }

    func clearWatchlist() {
        defaults.removeObject(forKey: watchlistKey)
        print("WatchlistManager: Watchlist successfully cleared from UserDefaults.")
    }
}

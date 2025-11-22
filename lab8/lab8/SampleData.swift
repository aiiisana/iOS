import UIKit

struct SampleData {
    static let movies: [FavoriteItem] = (1...10).map {
        FavoriteItem(category: .movie, title: "Movie \($0)", subtitle: "Director \($0)", description: "This is a description of Movie \($0). It is interesting and entertaining.", review: "My review for Movie \($0).", image: UIImage(systemName: "film"))
    }
    
    static let music: [FavoriteItem] = (1...10).map {
        FavoriteItem(category: .music, title: "Song \($0)", subtitle: "Artist \($0)", description: "This is a description of Song \($0). It has great melody.", review: "My review for Song \($0).", image: UIImage(systemName: "music.note"))
    }
    
    static let books: [FavoriteItem] = (1...10).map {
        FavoriteItem(category: .book, title: "Book \($0)", subtitle: "Author \($0)", description: "This is a description of Book \($0). It is very engaging.", review: "My review for Book \($0).", image: UIImage(systemName: "book"))
    }
    
    static let courses: [FavoriteItem] = (1...10).map {
        FavoriteItem(category: .course, title: "Course \($0)", subtitle: "Lecturer \($0)", description: "This is a description of Course \($0). You will learn many things.", review: "My review for Course \($0).", image: UIImage(systemName: "graduationcap"))
    }
}

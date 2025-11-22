import UIKit

enum Category {
    case movie, music, book, course
}

struct FavoriteItem {
    let category: Category
    let title: String
    let subtitle: String
    let description: String
    let review: String
    let image: UIImage?
}

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let moviesVC = CategoryViewController()
        moviesVC.category = .movie
        moviesVC.items = SampleData.movies
        moviesVC.tabBarItem = UITabBarItem(title: "Movies", image: UIImage(systemName: "film"), tag: 0)
        
        let musicVC = CategoryViewController()
        musicVC.category = .music
        musicVC.items = SampleData.music
        musicVC.tabBarItem = UITabBarItem(title: "Music", image: UIImage(systemName: "music.note"), tag: 1)
        
        let booksVC = CategoryViewController()
        booksVC.category = .book
        booksVC.items = SampleData.books
        booksVC.tabBarItem = UITabBarItem(title: "Books", image: UIImage(systemName: "book"), tag: 2)
        
        let coursesVC = CategoryViewController()
        coursesVC.category = .course
        coursesVC.items = SampleData.courses
        coursesVC.tabBarItem = UITabBarItem(title: "Courses", image: UIImage(systemName: "graduationcap"), tag: 3)
        
        viewControllers = [
            UINavigationController(rootViewController: moviesVC),
            UINavigationController(rootViewController: musicVC),
            UINavigationController(rootViewController: booksVC),
            UINavigationController(rootViewController: coursesVC)
        ]
    }
}

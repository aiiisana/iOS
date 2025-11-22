import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var table: UITableView!

    let sectionTitles = ["Favorite Movies", "Favorite Music", "Favorite Books", "Favorite Courses"]
    
    var data: [[FavoriteItem]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Favorites"
        setupTableView()
        loadData()
    }

    func setupTableView() {
        table.delegate = self
        table.dataSource = self
        
        table.register(FavoriteTableViewCell.self, forCellReuseIdentifier: FavoriteTableViewCell.identifier)
        
        table.estimatedRowHeight = 200
        table.rowHeight = UITableView.automaticDimension
    }

    func loadData() {
        let movies = [
            FavoriteItem(image: UIImage(systemName: "film"), title: "Inception", subtitle: "Christopher Nolan, 2010", review: "Amazing sci-fi with mind-bending plot twists."),
            FavoriteItem(image: UIImage(systemName: "film"), title: "The Matrix", subtitle: "The Wachowskis, 1999", review: "Classic action and philosophy mixed perfectly."),
            FavoriteItem(image: UIImage(systemName: "film"), title: "Interstellar", subtitle: "Christopher Nolan, 2014", review: "Epic space adventure with emotional story."),
            FavoriteItem(image: UIImage(systemName: "film"), title: "The Dark Knight", subtitle: "Christopher Nolan, 2008", review: "Best superhero movie ever."),
            FavoriteItem(image: UIImage(systemName: "film"), title: "Pulp Fiction", subtitle: "Quentin Tarantino, 1994", review: "Iconic storytelling and characters.")
        ]
        
        let music = [
            FavoriteItem(image: UIImage(systemName: "music.note"), title: "Imagine Dragons", subtitle: "Album: Evolve", review: "Energetic and uplifting songs."),
            FavoriteItem(image: UIImage(systemName: "music.note"), title: "Coldplay", subtitle: "Album: Parachutes", review: "Melodic and emotional."),
            FavoriteItem(image: UIImage(systemName: "music.note"), title: "Adele", subtitle: "Album: 30", review: "Powerful vocals and emotion."),
            FavoriteItem(image: UIImage(systemName: "music.note"), title: "Ed Sheeran", subtitle: "Album: Divide", review: "Catchy pop songs with heart."),
            FavoriteItem(image: UIImage(systemName: "music.note"), title: "Taylor Swift", subtitle: "Album: Red", review: "Storytelling through music.")
        ]
        
        let books = [
            FavoriteItem(image: UIImage(systemName: "book"), title: "1984", subtitle: "George Orwell", review: "Dystopian masterpiece about totalitarianism."),
            FavoriteItem(image: UIImage(systemName: "book"), title: "The Hobbit", subtitle: "J.R.R. Tolkien", review: "Classic adventure fantasy."),
            FavoriteItem(image: UIImage(systemName: "book"), title: "To Kill a Mockingbird", subtitle: "Harper Lee", review: "Powerful social commentary."),
            FavoriteItem(image: UIImage(systemName: "book"), title: "Harry Potter", subtitle: "J.K. Rowling", review: "Magical and captivating."),
            FavoriteItem(image: UIImage(systemName: "book"), title: "The Great Gatsby", subtitle: "F. Scott Fitzgerald", review: "Classic tale of love and tragedy.")
        ]
        
        let courses = [
            FavoriteItem(image: UIImage(systemName: "graduationcap"), title: "Algorithms", subtitle: "CS Department", review: "Fundamental course for problem-solving."),
            FavoriteItem(image: UIImage(systemName: "graduationcap"), title: "iOS Development", subtitle: "Mobile Apps", review: "Learned UIKit and Swift basics."),
            FavoriteItem(image: UIImage(systemName: "graduationcap"), title: "Databases", subtitle: "CS Department", review: "Understanding relational databases."),
            FavoriteItem(image: UIImage(systemName: "graduationcap"), title: "Computer Networks", subtitle: "CS Department", review: "Basics of networking."),
            FavoriteItem(image: UIImage(systemName: "graduationcap"), title: "Software Engineering", subtitle: "CS Department", review: "Project management and design patterns.")
        ]
        
        data = [movies, music, books, courses]
        table.reloadData()
    }

    // MARK: - TableView DataSource & Delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteTableViewCell.identifier, for: indexPath) as! FavoriteTableViewCell
        let item = data[indexPath.section][indexPath.row]
        cell.configure(with: item)
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

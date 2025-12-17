import UIKit
import Kingfisher

class WatchlistViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private let watchlistManager = WatchlistManager.shared
    private let apiService = APIService.shared
    
    private var watchlistMovies: [OMDbMovieDetail] = []
    
    private let customDarkBlue = UIColor(red: 5/255, green: 10/255, blue: 35/255, alpha: 1.0)

    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.rowHeight = 160
        tv.register(MovieCell.self, forCellReuseIdentifier: "MovieCell")
        tv.dataSource = self
        tv.delegate = self
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    // MARK: - Empty State UI
    private lazy var emptyStateView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 15
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.isHidden = true
        return stack
    }()

    private let starImageView: UIImageView = {
        let iv = UIImageView()
        let config = UIImage.SymbolConfiguration(pointSize: 60, weight: .light)
        iv.image = UIImage(systemName: "star", withConfiguration: config)
        iv.tintColor = .systemGray.withAlphaComponent(0.4)
        iv.contentMode = .center
        iv.layer.cornerRadius = 50
        iv.layer.borderWidth = 2
        iv.layer.borderColor = UIColor.systemGray.withAlphaComponent(0.3).cgColor
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.widthAnchor.constraint(equalToConstant: 100).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 100).isActive = true
        return iv
    }()

    private let emptyTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Your Watchlist is Empty"
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.textColor = .white
        return label
    }()

    private let emptySubtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Browse movies and add them to your watchlist"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .systemGray
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadWatchlistMovies()
    }

    private func setupUI() {
        view.backgroundColor = customDarkBlue
        navigationItem.title = "Watchlist"
        navigationController?.navigationBar.prefersLargeTitles = false
        
        view.addSubview(tableView)
        view.addSubview(emptyStateView)
        
        emptyStateView.addArrangedSubview(starImageView)
        emptyStateView.addArrangedSubview(emptyTitleLabel)
        emptyStateView.addArrangedSubview(emptySubtitleLabel)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
    
    // MARK: - Data Loading
    private func loadWatchlistMovies() {
        let movieIDsString = watchlistManager.getWatchlistImdbIDs()
            
        guard !movieIDsString.isEmpty else {
            self.watchlistMovies = []
            self.tableView.reloadData()
            self.emptyStateView.isHidden = false
            return
        }
            
        var loadedMovies: [OMDbMovieDetail] = []
        let dispatchGroup = DispatchGroup()
        
        for imdbID in movieIDsString {
            dispatchGroup.enter()
            apiService.fetchMovieDetails(imdbID: imdbID) { result in
                defer { dispatchGroup.leave() }
                if case .success(let movie) = result {
                    loadedMovies.append(movie)
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.watchlistMovies = movieIDsString.compactMap { id in
                loadedMovies.first { $0.imdbID == id }
            }
            self.emptyStateView.isHidden = !self.watchlistMovies.isEmpty
            self.tableView.reloadData()
        }
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return watchlistMovies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movie = watchlistMovies[indexPath.row]
        cell.configure(with: movie)
        
        cell.onDelete = { [weak self] in
            self?.deleteMovie(at: indexPath)
        }
        return cell
    }
    
    private func deleteMovie(at indexPath: IndexPath) {
        let movieToDelete = watchlistMovies[indexPath.row]
        guard let id = movieToDelete.imdbID else { return }
        
        watchlistManager.removeMovie(imdbID: id)
        watchlistMovies.remove(at: indexPath.row)
        
        tableView.performBatchUpdates({
            tableView.deleteRows(at: [indexPath], with: .fade)
        }, completion: { _ in
            self.tableView.reloadSections(IndexSet(integer: 0), with: .none)
            if self.watchlistMovies.isEmpty {
                self.emptyStateView.isHidden = false
            }
        })
    }

    // MARK: - Header Setup
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard !watchlistMovies.isEmpty else { return nil }
        
        let headerView = UIView()
        let titleLabel = UILabel()
        titleLabel.text = "Watchlist"
        titleLabel.font = .systemFont(ofSize: 34, weight: .bold)
        titleLabel.textColor = .white
        
        let countLabel = UILabel()
        let count = watchlistMovies.count
        countLabel.text = "\(count) movie\(count == 1 ? "" : "s")"
        countLabel.font = .systemFont(ofSize: 18)
        countLabel.textColor = .lightGray
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, countLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            stack.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -12)
        ])
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return watchlistMovies.isEmpty ? 0 : 100
    }

    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMovie = watchlistMovies[indexPath.row]
        guard let id = selectedMovie.imdbID else { return }
        let detailVC = DetailViewController(imdbID: id)
        navigationController?.pushViewController(detailVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

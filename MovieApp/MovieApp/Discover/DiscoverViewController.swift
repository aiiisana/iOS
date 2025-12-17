import UIKit
import Kingfisher

class DiscoverViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchResultsUpdating, UISearchBarDelegate {

    // MARK: - Properties
    private let apiService = APIService.shared
    
    private var trendingMovies: [OMDbMovieStub] = []
    private var nowPlayingMovies: [OMDbMovieStub] = []
    private var comingSoonMovies: [OMDbMovieStub] = []
    
    private var searchResults: [OMDbMovieStub] = []
    private var isSearchActive: Bool = false
    
    private let sections = ["Trending", "Now Playing", "Coming Soon"]
    private let customDarkBlue = UIColor(red: 5/255, green: 10/255, blue: 35/255, alpha: 1.0)
    
    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        cv.backgroundColor = .clear
        cv.register(DiscoverMovieCell.self, forCellWithReuseIdentifier: DiscoverMovieCell.reuseIdentifier)
        cv.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeader")
        cv.dataSource = self
        cv.delegate = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()

    private lazy var searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.searchResultsUpdater = self
        sc.searchBar.delegate = self
        sc.searchBar.barStyle = .black
        sc.obscuresBackgroundDuringPresentation = false
        sc.searchBar.placeholder = "Search movies..."
        sc.searchBar.searchTextField.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        return sc
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadAllCategories()
    }

    private func setupUI() {
        view.backgroundColor = customDarkBlue
        navigationItem.title = "Discover"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // MARK: - Compositional Layout
    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let self = self else { return nil }
            return self.isSearchActive ? self.createGridLayout() : self.createHorizontalSectionLayout()
        }
    }
    
    private func createHorizontalSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(150), heightDimension: .absolute(250))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 15
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 16, bottom: 30, trailing: 16)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    private func createGridLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .absolute(280))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(280))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8)
        return section
    }

    // MARK: - Data Loading
    private func loadAllCategories() {
        let queries = ["2025", "Love", "Batman"]
        let dispatchGroup = DispatchGroup()
        
        for (index, query) in queries.enumerated() {
            dispatchGroup.enter()
            apiService.searchMovies(query: query) { result in
                if case .success(let fetched) = result {
                    DispatchQueue.main.async {
                        if index == 0 { self.trendingMovies = fetched }
                        else if index == 1 { self.nowPlayingMovies = fetched }
                        else { self.comingSoonMovies = fetched }
                    }
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.collectionView.reloadData()
        }
    }

    // MARK: - UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return isSearchActive ? 1 : sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSearchActive { return searchResults.count }
        
        switch section {
        case 0: return trendingMovies.count
        case 1: return nowPlayingMovies.count
        case 2: return comingSoonMovies.count
        default: return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DiscoverMovieCell.reuseIdentifier, for: indexPath) as! DiscoverMovieCell
        
        let movie: OMDbMovieStub
        if isSearchActive {
            movie = searchResults[indexPath.item]
        } else {
            switch indexPath.section {
            case 0: movie = trendingMovies[indexPath.item]
            case 1: movie = nowPlayingMovies[indexPath.item]
            default: movie = comingSoonMovies[indexPath.item]
            }
        }
        
        cell.configure(with: movie)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as! SectionHeader
        
        if isSearchActive {
            header.titleLabel.text = "Search Results"
            header.isHidden = false
        } else {
            header.titleLabel.text = sections[indexPath.section]
            header.isHidden = false
        }
        return header
    }
    
    // MARK: - UICollectionViewDelegate (Переход на детали)
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie: OMDbMovieStub
        if isSearchActive {
            movie = searchResults[indexPath.item]
        } else {
            switch indexPath.section {
            case 0: movie = trendingMovies[indexPath.item]
            case 1: movie = nowPlayingMovies[indexPath.item]
            default: movie = comingSoonMovies[indexPath.item]
            }
        }
        
        guard let id = movie.imdbID else { return }
        let detailVC = DetailViewController(imdbID: id)
        navigationController?.pushViewController(detailVC, animated: true)
    }

    // MARK: - UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text, query.count > 2 else {
            if isSearchActive {
                isSearchActive = false
                collectionView.reloadData()
                collectionView.setCollectionViewLayout(createLayout(), animated: true)
            }
            return
        }
        
        isSearchActive = true
        apiService.searchMovies(query: query) { [weak self] result in
            if case .success(let fetched) = result {
                DispatchQueue.main.async {
                    self?.searchResults = fetched
                    self?.collectionView.reloadData()
                    self?.collectionView.setCollectionViewLayout(self?.createLayout() ?? UICollectionViewFlowLayout(), animated: true)
                }
            }
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearchActive = false
        collectionView.reloadData()
        collectionView.setCollectionViewLayout(createLayout(), animated: true)
    }
}

// MARK: - Section Header View
class SectionHeader: UICollectionReusableView {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

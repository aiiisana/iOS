import UIKit
import Kingfisher

class DetailViewController: UIViewController {

    // MARK: - Properties
    private let imdbID: String
    private let apiService = APIService.shared
    private let watchlistManager = WatchlistManager.shared
    private let customDarkBlue = UIColor(red: 5/255, green: 10/255, blue: 35/255, alpha: 1.0)
    private let cardColor = UIColor(red: 25/255, green: 30/255, blue: 60/255, alpha: 1.0)

    // MARK: - UI Components
    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.contentInsetAdjustmentBehavior = .never
        sv.showsVerticalScrollIndicator = false
        sv.backgroundColor = customDarkBlue
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let backdropImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let smallPosterImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 8
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let infoLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let genreStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 8
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    private let overviewTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Overview"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let statusCard: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 25/255, green: 30/255, blue: 60/255, alpha: 1.0)
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let backButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = .black.withAlphaComponent(0.5)
        btn.layer.cornerRadius = 20
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private let watchlistButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "bookmark"), for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = .black.withAlphaComponent(0.5)
        btn.layer.cornerRadius = 20
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    // MARK: - Init
    init(imdbID: String) {
        self.imdbID = imdbID
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadMovieDetails()
    }

    private func setupUI() {
        view.backgroundColor = customDarkBlue
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [backdropImageView, smallPosterImageView, titleLabel, infoLabel, genreStackView, overviewTitleLabel, overviewLabel, statusCard, backButton, watchlistButton].forEach {
            contentView.addSubview($0)
        }
        
        setupConstraints()
        
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        watchlistButton.addTarget(self, action: #selector(didTapWatchlist), for: .touchUpInside)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            backdropImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backdropImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backdropImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backdropImageView.heightAnchor.constraint(equalToConstant: 250),

            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backButton.widthAnchor.constraint(equalToConstant: 40),
            backButton.heightAnchor.constraint(equalToConstant: 40),

            watchlistButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            watchlistButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            watchlistButton.widthAnchor.constraint(equalToConstant: 40),
            watchlistButton.heightAnchor.constraint(equalToConstant: 40),

            smallPosterImageView.topAnchor.constraint(equalTo: backdropImageView.bottomAnchor, constant: -60),
            smallPosterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            smallPosterImageView.widthAnchor.constraint(equalToConstant: 110),
            smallPosterImageView.heightAnchor.constraint(equalToConstant: 160),

            titleLabel.topAnchor.constraint(equalTo: backdropImageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: smallPosterImageView.trailingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            infoLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            infoLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            infoLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            genreStackView.topAnchor.constraint(equalTo: smallPosterImageView.bottomAnchor, constant: 20),
            genreStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),

            overviewTitleLabel.topAnchor.constraint(equalTo: genreStackView.bottomAnchor, constant: 30),
            overviewTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),

            overviewLabel.topAnchor.constraint(equalTo: overviewTitleLabel.bottomAnchor, constant: 10),
            overviewLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            overviewLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            statusCard.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 30),
            statusCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            statusCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            statusCard.heightAnchor.constraint(equalToConstant: 80),
            statusCard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
    }

    private func loadMovieDetails() {
        apiService.fetchMovieDetails(imdbID: imdbID) { [weak self] result in
            switch result {
            case .success(let detail):
                DispatchQueue.main.async { self?.configure(with: detail) }
            case .failure(let error):
                print(error)
            }
        }
    }

    private func configure(with detail: OMDbMovieDetail) {
        titleLabel.text = detail.Title
        overviewLabel.text = detail.Plot
        
        let rating = detail.imdbRating ?? "N/A"
        let runtime = detail.Runtime ?? "N/A"
        let year = detail.Year ?? "N/A"
        infoLabel.text = "★ \(rating)  •  \(runtime)  •  \(year)"
        
        if let poster = detail.Poster, let url = URL(string: poster), poster != "N/A" {
            backdropImageView.kf.setImage(with: url)
            smallPosterImageView.kf.setImage(with: url)
            addBlurToBackdrop()
        }
        
        detail.Genre?.split(separator: ",").forEach { genre in
            let label = createPaddingLabel(text: String(genre).trimmingCharacters(in: .whitespaces))
            genreStackView.addArrangedSubview(label)
        }
        
        setupStatusCard(released: detail.Released ?? "N/A")
        updateWatchlistButtonState()
    }

    private func createPaddingLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textColor = .systemTeal
        label.backgroundColor = UIColor.systemTeal.withAlphaComponent(0.15)
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.widthAnchor.constraint(equalToConstant: CGFloat(text.count * 8 + 20)).isActive = true
        label.heightAnchor.constraint(equalToConstant: 26).isActive = true
        return label
    }

    private func setupStatusCard(released: String) {
        let statusTitle = UILabel()
        statusTitle.text = "Status"; statusTitle.textColor = .gray; statusTitle.font = .systemFont(ofSize: 12)
        
        let statusValue = UILabel()
        statusValue.text = "Released"; statusValue.textColor = .white; statusValue.font = .systemFont(ofSize: 16, weight: .medium)
        
        let dateTitle = UILabel()
        dateTitle.text = "Release Date"; dateTitle.textColor = .gray; dateTitle.font = .systemFont(ofSize: 12)
        
        let dateValue = UILabel()
        dateValue.text = released; dateValue.textColor = .white; dateValue.font = .systemFont(ofSize: 16, weight: .medium)
        
        let leftStack = UIStackView(arrangedSubviews: [statusTitle, statusValue]); leftStack.axis = .vertical; leftStack.spacing = 4
        let rightStack = UIStackView(arrangedSubviews: [dateTitle, dateValue]); rightStack.axis = .vertical; rightStack.spacing = 4
        
        let mainStack = UIStackView(arrangedSubviews: [leftStack, rightStack]); mainStack.axis = .horizontal; mainStack.distribution = .fillEqually
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        statusCard.addSubview(mainStack)
        NSLayoutConstraint.activate([
            mainStack.centerYAnchor.constraint(equalTo: statusCard.centerYAnchor),
            mainStack.leadingAnchor.constraint(equalTo: statusCard.leadingAnchor, constant: 20),
            mainStack.trailingAnchor.constraint(equalTo: statusCard.trailingAnchor, constant: -20)
        ])
    }

    private func addBlurToBackdrop() {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = backdropImageView.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    private func updateWatchlistButtonState() {
        let isInWatchlist = watchlistManager.isMovieInWatchlist(imdbID: imdbID)
        let icon = isInWatchlist ? "bookmark.fill" : "bookmark"
        watchlistButton.setImage(UIImage(systemName: icon), for: .normal)
        watchlistButton.tintColor = isInWatchlist ? .systemYellow : .white
    }

    @objc private func didTapBack() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func didTapWatchlist() {
        _ = watchlistManager.toggleWatchlist(imdbID: imdbID)
        updateWatchlistButtonState()
    }
}

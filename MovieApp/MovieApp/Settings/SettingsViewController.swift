import UIKit
import Kingfisher

class SettingsViewController: UIViewController {
    
    private let watchlistManager = WatchlistManager.shared
    private let customDarkBlue = UIColor(red: 5/255, green: 10/255, blue: 35/255, alpha: 1.0)
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.alwaysBounceVertical = true
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 25
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        createSettingsContent()
    }
    
    private func setupUI() {
        view.backgroundColor = customDarkBlue
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(scrollView)
        scrollView.addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            mainStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            mainStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20)
        ])
    }
    
    private func createSettingsContent() {
        let appearanceCard = SettingsCardView(title: "Appearance")
        let darkThemeRow = createSwitchRow(icon: "moon.fill", title: "Dark Theme", subtitle: "Use dark mode interface", isOn: true)
        appearanceCard.stackView.addArrangedSubview(darkThemeRow)
        mainStackView.addArrangedSubview(appearanceCard)
        
        let contentCard = SettingsCardView(title: "Content")
        let regionRow = createRegionRow()
        let clearWatchlistRow = createButtonRow(icon: "trash", title: "Watchlist", subtitle: "Clear all saved movies", action: #selector(handleClearWatchlist))
        contentCard.stackView.addArrangedSubview(regionRow)
        contentCard.stackView.addArrangedSubview(clearWatchlistRow)
        mainStackView.addArrangedSubview(contentCard)
        
        let storageCard = SettingsCardView(title: "Storage")
        let cacheRow = createCacheRow()
        storageCard.stackView.addArrangedSubview(cacheRow)
        mainStackView.addArrangedSubview(storageCard)
        
        let aboutCard = SettingsCardView(title: "About")
        let infoLabel = UILabel()
        infoLabel.text = "Movie Scout help you discover and track movies. Powered by OMDb API."
        infoLabel.textColor = .lightGray
        infoLabel.font = .systemFont(ofSize: 14)
        infoLabel.numberOfLines = 0
        aboutCard.stackView.addArrangedSubview(infoLabel)
        mainStackView.addArrangedSubview(aboutCard)
    }
    
    // MARK: - Row Builders
    private func createIconView(name: String, color: UIColor = .systemBlue) -> UIView {
        let container = UIView()
        container.backgroundColor = color.withAlphaComponent(0.1)
        container.layer.cornerRadius = 10
        container.translatesAutoresizingMaskIntoConstraints = false
        container.widthAnchor.constraint(equalToConstant: 40).isActive = true
        container.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let iv = UIImageView(image: UIImage(systemName: name))
        iv.tintColor = color
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(iv)
        
        NSLayoutConstraint.activate([
            iv.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            iv.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            iv.widthAnchor.constraint(equalToConstant: 20),
            iv.heightAnchor.constraint(equalToConstant: 20)
        ])
        return container
    }
    
    private func createSwitchRow(icon: String, title: String, subtitle: String, isOn: Bool) -> UIView {
        let row = UIStackView()
        row.spacing = 15
        row.alignment = .center
        
        let textStack = UIStackView()
        textStack.axis = .vertical
        let tLabel = UILabel(); tLabel.text = title; tLabel.textColor = .white; tLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        let sLabel = UILabel(); sLabel.text = subtitle; sLabel.textColor = .gray; sLabel.font = .systemFont(ofSize: 12)
        textStack.addArrangedSubview(tLabel); textStack.addArrangedSubview(sLabel)
        
        let toggle = UISwitch()
        toggle.isOn = isOn
        toggle.onTintColor = .systemBlue
        
        row.addArrangedSubview(createIconView(name: icon))
        row.addArrangedSubview(textStack)
        row.addArrangedSubview(toggle)
        return row
    }

    private func createRegionRow() -> UIView {
        let verticalStack = UIStackView()
        verticalStack.axis = .vertical
        verticalStack.spacing = 15
        
        let headerRow = UIStackView()
        headerRow.spacing = 15
        headerRow.alignment = .center
        
        let textStack = UIStackView()
        textStack.axis = .vertical
        let tLabel = UILabel(); tLabel.text = "Region"; tLabel.textColor = .white; tLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        let sLabel = UILabel(); sLabel.text = "Content language and region"; sLabel.textColor = .gray; sLabel.font = .systemFont(ofSize: 12)
        textStack.addArrangedSubview(tLabel); textStack.addArrangedSubview(sLabel)
        
        headerRow.addArrangedSubview(createIconView(name: "globe", color: .systemCyan))
        headerRow.addArrangedSubview(textStack)
        
        let segment = UISegmentedControl(items: ["EN", "RU", "Global"])
        segment.selectedSegmentIndex = 0
        segment.selectedSegmentTintColor = .systemBlue
        segment.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        segment.setTitleTextAttributes([.foregroundColor: UIColor.lightGray], for: .normal)
        
        verticalStack.addArrangedSubview(headerRow)
        verticalStack.addArrangedSubview(segment)
        return verticalStack
    }
    
    private func createCacheRow() -> UIView {
        let verticalStack = UIStackView()
        verticalStack.axis = .vertical
        verticalStack.spacing = 15
        
        let headerRow = UIStackView()
        headerRow.spacing = 15
        headerRow.alignment = .center
        
        let textStack = UIStackView()
        textStack.axis = .vertical
        let tLabel = UILabel(); tLabel.text = "Cache Size"; tLabel.textColor = .white; tLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        let sLabel = UILabel(); sLabel.text = "2.4 MB of data stored"; sLabel.textColor = .gray; sLabel.font = .systemFont(ofSize: 12)
        textStack.addArrangedSubview(tLabel); textStack.addArrangedSubview(sLabel)
        
        headerRow.addArrangedSubview(createIconView(name: "trash.fill", color: .systemRed))
        headerRow.addArrangedSubview(textStack)
        
        let clearBtn = UIButton(type: .system)
        clearBtn.setTitle("Clear Cache", for: .normal)
        clearBtn.backgroundColor = UIColor.systemRed.withAlphaComponent(0.1)
        clearBtn.setTitleColor(.systemRed, for: .normal)
        clearBtn.layer.cornerRadius = 10
        clearBtn.heightAnchor.constraint(equalToConstant: 44).isActive = true
        clearBtn.addTarget(self, action: #selector(handleClearCache), for: .touchUpInside)
        
        verticalStack.addArrangedSubview(headerRow)
        verticalStack.addArrangedSubview(clearBtn)
        return verticalStack
    }

    private func createButtonRow(icon: String, title: String, subtitle: String, action: Selector) -> UIView {
        let row = UIButton()
        row.addTarget(self, action: action, for: .touchUpInside)
        
        let stack = UIStackView()
        stack.isUserInteractionEnabled = false
        stack.spacing = 15
        stack.alignment = .center
        
        let textStack = UIStackView()
        textStack.axis = .vertical
        let tLabel = UILabel(); tLabel.text = title; tLabel.textColor = .white; tLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        let sLabel = UILabel(); sLabel.text = subtitle; sLabel.textColor = .gray; sLabel.font = .systemFont(ofSize: 12)
        textStack.addArrangedSubview(tLabel); textStack.addArrangedSubview(sLabel)
        
        let arrow = UIImageView(image: UIImage(systemName: "chevron.right"))
        arrow.tintColor = .gray
        
        stack.addArrangedSubview(createIconView(name: icon, color: .systemOrange))
        stack.addArrangedSubview(textStack)
        stack.addArrangedSubview(UIView()) // spacer
        stack.addArrangedSubview(arrow)
        
        row.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: row.topAnchor),
            stack.leadingAnchor.constraint(equalTo: row.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: row.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: row.bottomAnchor)
        ])
        return row
    }
    
    // MARK: - Handlers
    
    @objc private func handleClearWatchlist() {
        confirmClearWatchlist()
    }
    
    @objc private func handleClearCache() {
        confirmClearCache()
    }

    private func confirmClearWatchlist() {
        let alert = UIAlertController(title: "Confirm Clear", message: "Are you sure you want to remove ALL movies?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Clear", style: .destructive) { [weak self] _ in
            self?.watchlistManager.clearWatchlist()
        })
        present(alert, animated: true)
    }
    
    private func confirmClearCache() {
        KingfisherManager.shared.cache.clearMemoryCache()
        KingfisherManager.shared.cache.clearDiskCache()
        let alert = UIAlertController(title: "Success", message: "Cache cleared", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

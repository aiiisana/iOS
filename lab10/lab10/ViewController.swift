import UIKit
import Kingfisher

class ViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private var heroImageView = UIImageView()
    private var nameLabel = UILabel()
    private var fullNameLabel = UILabel()
    private var publisherLabel = UILabel()
    private var alignmentLabel = UILabel()

    private var intelligenceLabel = UILabel()
    private var strengthLabel = UILabel()
    private var speedLabel = UILabel()
    private var durabilityLabel = UILabel()
    private var powerLabel = UILabel()
    private var combatLabel = UILabel()

    private var genderRaceLabel = UILabel()
    private var heightWeightLabel = UILabel()
    private var placeOfBirthLabel = UILabel()
    private var workLabel = UILabel()
    private var connectionsLabel = UILabel()

    private let randomizeButton = UIButton(type: .system)
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let errorLabel = UILabel()

    private var heroes: [Superhero] = []
    private var currentHero: Superhero?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Superhero Randomizer"

        setupUI()
        loadHeroes()
    }

    private func setupUI() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)


        heroImageView.translatesAutoresizingMaskIntoConstraints = false
        heroImageView.contentMode = .scaleAspectFit
        heroImageView.clipsToBounds = true
        heroImageView.layer.cornerRadius = 12
        heroImageView.backgroundColor = .secondarySystemBackground

        func makeLabel(fontSize: CGFloat, weight: UIFont.Weight = .regular) -> UILabel {
            let lbl = UILabel()
            lbl.font = UIFont.systemFont(ofSize: fontSize, weight: weight)
            lbl.numberOfLines = 0
            lbl.translatesAutoresizingMaskIntoConstraints = false
            return lbl
        }

        nameLabel.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        fullNameLabel = makeLabel(fontSize: 16, weight: .medium)
        publisherLabel = makeLabel(fontSize: 14)
        alignmentLabel = makeLabel(fontSize: 14)

        intelligenceLabel = makeLabel(fontSize: 15)
        strengthLabel = makeLabel(fontSize: 15)
        speedLabel = makeLabel(fontSize: 15)
        durabilityLabel = makeLabel(fontSize: 15)
        powerLabel = makeLabel(fontSize: 15)
        combatLabel = makeLabel(fontSize: 15)

        genderRaceLabel = makeLabel(fontSize: 14)
        heightWeightLabel = makeLabel(fontSize: 14)
        placeOfBirthLabel = makeLabel(fontSize: 14)
        workLabel = makeLabel(fontSize: 14)
        connectionsLabel = makeLabel(fontSize: 14)

        randomizeButton.translatesAutoresizingMaskIntoConstraints = false

        var config = UIButton.Configuration.filled()
        config.title = "Randomize"
        config.baseBackgroundColor = .systemBlue
        config.baseForegroundColor = .white
        config.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 18, bottom: 12, trailing: 18)
        config.cornerStyle = .medium

        randomizeButton.configuration = config
        randomizeButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        randomizeButton.addTarget(self, action: #selector(randomizeTapped), for: .touchUpInside)

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true

        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.textColor = .systemRed
        errorLabel.numberOfLines = 0
        errorLabel.textAlignment = .center
        errorLabel.isHidden = true

        let statsStack = UIStackView(arrangedSubviews: [
            intelligenceLabel, strengthLabel, speedLabel,
            durabilityLabel, powerLabel, combatLabel
        ])
        statsStack.axis = .vertical
        statsStack.spacing = 6
        statsStack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(heroImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(fullNameLabel)
        contentView.addSubview(publisherLabel)
        contentView.addSubview(alignmentLabel)
        contentView.addSubview(statsStack)
        contentView.addSubview(genderRaceLabel)
        contentView.addSubview(heightWeightLabel)
        contentView.addSubview(placeOfBirthLabel)
        contentView.addSubview(workLabel)
        contentView.addSubview(connectionsLabel)
        contentView.addSubview(randomizeButton)
        contentView.addSubview(activityIndicator)
        contentView.addSubview(errorLabel)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            heroImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            heroImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            heroImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            heroImageView.heightAnchor.constraint(equalTo: heroImageView.widthAnchor, multiplier: 9/16),

            nameLabel.topAnchor.constraint(equalTo: heroImageView.bottomAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            fullNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            fullNameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            fullNameLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),

            publisherLabel.topAnchor.constraint(equalTo: fullNameLabel.bottomAnchor, constant: 6),
            publisherLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            publisherLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),

            alignmentLabel.topAnchor.constraint(equalTo: publisherLabel.bottomAnchor, constant: 6),
            alignmentLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            alignmentLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),

            statsStack.topAnchor.constraint(equalTo: alignmentLabel.bottomAnchor, constant: 12),
            statsStack.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            statsStack.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),

            genderRaceLabel.topAnchor.constraint(equalTo: statsStack.bottomAnchor, constant: 12),
            genderRaceLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            genderRaceLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),

            heightWeightLabel.topAnchor.constraint(equalTo: genderRaceLabel.bottomAnchor, constant: 8),
            heightWeightLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            heightWeightLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),

            placeOfBirthLabel.topAnchor.constraint(equalTo: heightWeightLabel.bottomAnchor, constant: 8),
            placeOfBirthLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            placeOfBirthLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),

            workLabel.topAnchor.constraint(equalTo: placeOfBirthLabel.bottomAnchor, constant: 8),
            workLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            workLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),

            connectionsLabel.topAnchor.constraint(equalTo: workLabel.bottomAnchor, constant: 8),
            connectionsLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            connectionsLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),

            randomizeButton.topAnchor.constraint(equalTo: connectionsLabel.bottomAnchor, constant: 18),
            randomizeButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            randomizeButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),

            activityIndicator.centerYAnchor.constraint(equalTo: randomizeButton.centerYAnchor),
            activityIndicator.leadingAnchor.constraint(equalTo: randomizeButton.trailingAnchor, constant: 12),

            errorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            errorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            errorLabel.bottomAnchor.constraint(equalTo: randomizeButton.topAnchor, constant: -8)
        ])
    }

    private func setLoading(_ loading: Bool) {
        DispatchQueue.main.async {
            if loading {
                self.activityIndicator.startAnimating()
                self.randomizeButton.isEnabled = false
                self.randomizeButton.alpha = 0.6
            } else {
                self.activityIndicator.stopAnimating()
                self.randomizeButton.isEnabled = true
                self.randomizeButton.alpha = 1.0
            }
        }
    }

    private func loadHeroes() {
        setLoading(true)
        errorLabel.isHidden = true

        NetworkManager.shared.fetchAllHeroes { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.setLoading(false)

                switch result {
                case .success(let list):
                    self.heroes = list
                    // If there is saved last hero ID — show it
                    if let lastID = Persistence.loadLastHeroID(),
                       let hero = self.heroes.first(where: { $0.id == lastID }) {
                        self.displayHero(hero, animated: false)
                    } else {
                        self.randomizeAndDisplay(animated: false)
                    }
                case .failure(let err):
                    self.errorLabel.text = "Failed loading heroes: \(err.localizedDescription)"
                    self.errorLabel.isHidden = false
                }
            }
        }
    }

    @objc private func randomizeTapped() {
        if heroes.isEmpty {
            loadHeroes()
            return
        }
        randomizeAndDisplay(animated: true)
    }

    private func randomizeAndDisplay(animated: Bool) {
        guard !heroes.isEmpty else { return }
        let idx = Int.random(in: 0..<heroes.count)
        let hero = heroes[idx]
        displayHero(hero, animated: animated)
    }

    private func displayHero(_ hero: Superhero, animated: Bool) {
        currentHero = hero
        Persistence.saveLastHeroID(hero.id)

        nameLabel.text = hero.name
        fullNameLabel.text = "Full name: \(hero.biography.fullName ?? "—")"
        publisherLabel.text = "Publisher: \(hero.biography.publisher ?? "—")"
        alignmentLabel.text = "Alignment: \(hero.biography.alignment ?? "—")"

        intelligenceLabel.text = "Intelligence: \(hero.powerstats.intelligence.map(String.init) ?? "—")"
        strengthLabel.text = "Strength: \(hero.powerstats.strength.map(String.init) ?? "—")"
        speedLabel.text = "Speed: \(hero.powerstats.speed.map(String.init) ?? "—")"
        durabilityLabel.text = "Durability: \(hero.powerstats.durability.map(String.init) ?? "—")"
        powerLabel.text = "Power: \(hero.powerstats.power.map(String.init) ?? "—")"
        combatLabel.text = "Combat: \(hero.powerstats.combat.map(String.init) ?? "—")"

        genderRaceLabel.text = "Gender: \(hero.appearance.gender ?? "—") • Race: \(hero.appearance.race ?? "—")"
        let h = hero.appearance.height?.joined(separator: ", ") ?? "—"
        let w = hero.appearance.weight?.joined(separator: ", ") ?? "—"
        heightWeightLabel.text = "Height: \(h) • Weight: \(w)"
        placeOfBirthLabel.text = "Place of birth: \(hero.biography.placeOfBirth ?? "—")"

        workLabel.text = "Work: \(hero.work.occupation ?? "—") • Base: \(hero.work.base ?? "—")"
        connectionsLabel.text = "Connections: \(hero.connections.groupAffiliation ?? "—") • \(hero.connections.relatives ?? "—")"

        heroImageView.alpha = 0
        if let urlString = hero.images.lg, let url = URL(string: urlString) {
            heroImageView.kf.setImage(with: url, placeholder: UIImage(systemName: "person.fill")) { [weak self] _ in
                guard let self = self else { return }
                if animated {
                    UIView.animate(withDuration: 0.35) {
                        self.heroImageView.alpha = 1.0
                    }
                } else {
                    self.heroImageView.alpha = 1.0
                }
            }
        } else {
            heroImageView.image = UIImage(systemName: "person.fill")
            heroImageView.alpha = 1
        }

        if animated {
            let labels: [UILabel] = [
                nameLabel, fullNameLabel, publisherLabel, alignmentLabel,
                intelligenceLabel, strengthLabel, speedLabel, durabilityLabel, powerLabel, combatLabel,
                genderRaceLabel, heightWeightLabel, placeOfBirthLabel, workLabel, connectionsLabel
            ]
            labels.forEach { $0.alpha = 0 }
            UIView.animate(withDuration: 0.4) {
                labels.forEach { $0.alpha = 1.0 }
            }
        }
    }
}

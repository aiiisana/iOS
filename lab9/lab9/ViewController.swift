import UIKit

class ViewController: UIViewController {

    var heroes: [Superhero] = []

    let heroImage = UIImageView()
    let nameLabel = UILabel()
    let statsLabel = UILabel()
    let randomButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Superhero Randomizer"

        setupUI()
        loadHeroes()
    }

    func setupUI() {

        heroImage.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        statsLabel.translatesAutoresizingMaskIntoConstraints = false
        randomButton.translatesAutoresizingMaskIntoConstraints = false

        heroImage.contentMode = .scaleAspectFit
        nameLabel.font = .boldSystemFont(ofSize: 22)
        nameLabel.textAlignment = .center
        statsLabel.numberOfLines = 0
        statsLabel.textAlignment = .center

        randomButton.setTitle("Randomize", for: .normal)
        randomButton.backgroundColor = .systemBlue
        randomButton.setTitleColor(.white, for: .normal)
        randomButton.layer.cornerRadius = 10
        randomButton.addTarget(self, action: #selector(randomHero), for: .touchUpInside)

        view.addSubview(heroImage)
        view.addSubview(nameLabel)
        view.addSubview(statsLabel)
        view.addSubview(randomButton)

        NSLayoutConstraint.activate([
            heroImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            heroImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            heroImage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            heroImage.heightAnchor.constraint(equalToConstant: 250),

            nameLabel.topAnchor.constraint(equalTo: heroImage.bottomAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            statsLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            statsLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            statsLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),

            randomButton.topAnchor.constraint(equalTo: statsLabel.bottomAnchor, constant: 20),
            randomButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            randomButton.widthAnchor.constraint(equalToConstant: 140),
            randomButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    func loadHeroes() {
        NetworkManager.shared.fetchHeroes { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let list):
                    self.heroes = list
                    self.showRandomHero()
                case .failure:
                    self.showError()
                }
            }
        }
    }

    @objc func randomHero() {
        showRandomHero()
    }

    func showRandomHero() {
        guard let hero = heroes.randomElement() else { return }

        nameLabel.text = hero.name

        statsLabel.text = """
        Intelligence: \(hero.powerstats.intelligence ?? 0)
        Strength: \(hero.powerstats.strength ?? 0)
        Speed: \(hero.powerstats.speed ?? 0)
        Power: \(hero.powerstats.power ?? 0)
        Combat: \(hero.powerstats.combat ?? 0)
        Publisher: \(hero.biography.publisher ?? "")
        Alignment: \(hero.biography.alignment ?? "")
        """

        ImageCache.shared.load(urlString: hero.images.lg) { image in
            self.heroImage.image = image
        }
    }

    func showError() {
        let alert = UIAlertController(title: "Error", message: "Failed to load data", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

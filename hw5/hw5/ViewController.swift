import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var flowerImageView: UIImageView!
    @IBOutlet weak var flowerLabel: UILabel!
    @IBOutlet weak var randomizeButton: UIButton!

    let flowers = [
        ("Chrysanthemum", UIImage(named: "Chrysanthemum")),
        ("Dahlia", UIImage(named: "Dahlia")),
        ("Freesia", UIImage(named: "Freesia")),
        ("Gardenias", UIImage(named: "Gardenias")),
        ("Hydrangea", UIImage(named: "Hydrangea")),
        ("Orchid", UIImage(named: "Orchid")),
        ("Peony", UIImage(named: "Peony")),
        ("Poppies", UIImage(named: "Poppies")),
        ("Rose", UIImage(named: "Rose")),
        ("Spikenard", UIImage(named: "Spikenard"))
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        randomizeButton.layer.cornerRadius = 16
        randomizeButton.backgroundColor = .systemPink
        showRandomFlower()
    }

    @IBAction func randomizeButtonTapped(_ sender: UIButton) {
        showRandomFlower()
    }

    func showRandomFlower() {
        let randomFlower = flowers.randomElement()!
        flowerLabel.text = randomFlower.0
        flowerImageView.image = randomFlower.1 ?? UIImage(systemName: "questionmark.circle")
    }
}

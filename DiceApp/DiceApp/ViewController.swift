import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var leftDiceImageView: UIImageView!
    @IBOutlet weak var rightDiceImageView: UIImageView!
    @IBOutlet weak var rollButton: UIButton!

    let diceImages: [UIImage] = [#imageLiteral(resourceName: "DiceOne"), #imageLiteral(resourceName: "DiceTwo"), #imageLiteral(resourceName: "DiceThree"), #imageLiteral(resourceName: "DiceFour"), #imageLiteral(resourceName: "DiceFive"), #imageLiteral(resourceName: "DiceSix")]

    override func viewDidLoad() {
        super.viewDidLoad()
        leftDiceImageView.image = .diceThree
        rightDiceImageView.image = .diceFour
        rollButton.layer.cornerRadius = 16
        rollButton.backgroundColor = .systemTeal
    }

    @IBAction func rollButtonDidTap(_ sender: UIButton) {
        rollDice()
    }

    func rollDice() {
        let randomIndex1 = Int.random(in: 0..<diceImages.count)
        let randomIndex2 = Int.random(in: 0..<diceImages.count)
        leftDiceImageView.image = diceImages[randomIndex1]
        rightDiceImageView.image = diceImages[randomIndex2]
    }

    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            rollDice()
        }
    }
}

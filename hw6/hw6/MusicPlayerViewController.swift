import UIKit
import AVFoundation

class MusicPlayerViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!

    // MARK: - Player properties
    var player: AVAudioPlayer?
    var currentIndex = 0

    let tracks: [Track] = [
        Track(title: "Lost Stars", artist: "Adam Levine", coverImageName: "track1", fileName: "audio1"),
        Track(title: "Perfect", artist: "Ed Sheeran", coverImageName: "track2", fileName: "audio2"),
        Track(title: "Believer", artist: "Imagine Dragons", coverImageName: "track3", fileName: "audio3"),
        Track(title: "Blinding Lights", artist: "The Weeknd", coverImageName: "track4", fileName: "audio4"),
        Track(title: "Someone Like You", artist: "Adele", coverImageName: "track5", fileName: "audio5")
    ]

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    // MARK: - UI Update
    func updateUI() {
        let track = tracks[currentIndex]

        titleLabel.text = track.title
        artistLabel.text = track.artist
        trackImageView.image = UIImage(named: track.coverImageName)

        loadTrack(named: track.fileName)
        playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
    }

    // MARK: - Audio loading
    func loadTrack(named name: String) {
        guard let path = Bundle.main.path(forResource: name, ofType: "mp3") else {
            print("❌ Audio not found")
            return
        }
        let url = URL(fileURLWithPath: path)
        player = try? AVAudioPlayer(contentsOf: url)
        player?.prepareToPlay()
    }

    // MARK: - Controls
    @IBAction func playPauseTapped(_ sender: UIButton) {
        guard let player = player else { return }

        if player.isPlaying {
            player.pause()
            playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        } else {
            player.play()
            playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
    }

    @IBAction func nextTapped(_ sender: UIButton) {
        currentIndex = (currentIndex + 1) % tracks.count
        updateUI()
        player?.play()
        playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
    }

    @IBAction func previousTapped(_ sender: UIButton) {
        currentIndex = (currentIndex - 1 + tracks.count) % tracks.count
        updateUI()
        player?.play()
        playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
    }
}

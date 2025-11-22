import UIKit
import AVFoundation

struct Track {
    let title: String
    let artist: String
    let fileName: String
    let coverName: String
}

class ViewController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!

    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!

    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!

    var player: AVAudioPlayer?
    var timer: Timer?

    var tracks: [Track] = [
        Track(title: "Where Have You Been", artist: "Rihanna", fileName: "Rihanna - Where Have You Been", coverName: "cover1"),
        Track(title: "Umbrella", artist: "Rihanna ft. JAY-Z", fileName: "Rihanna - Umbrella (Orange Version) (Official Music Video) ft. JAY-Z", coverName: "cover2"),
        Track(title: "Take A Bow", artist: "Rihanna", fileName: "Rihanna - Take A Bow", coverName: "cover3"),
        Track(title: "Love On The Brain", artist: "Rihanna", fileName: "Rihanna - Love On The Brain", coverName: "cover4"),
        Track(title: "Don't Stop The Music", artist: "Rihanna", fileName: "Rihanna - Don't Stop The Music", coverName: "cover5")
    ]

    var currentIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        loadTrack(index: currentIndex)
        progressSlider.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)
    }


    func loadTrack(index: Int) {
        let track = tracks[index]

        titleLabel.text = track.title
        artistLabel.text = track.artist
        coverImageView.image = UIImage(named: track.coverName)

        if let url = Bundle.main.url(forResource: track.fileName, withExtension: "mp3") {
            player = try? AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
        }

        durationLabel.text = formatTime(player?.duration ?? 0)
        currentTimeLabel.text = "0:00"
        progressSlider.value = 0

        startTimer()
    }

    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { [weak self] _ in
            guard let self = self, let player = self.player else { return }

            self.progressSlider.value = Float(player.currentTime / player.duration)
            self.currentTimeLabel.text = self.formatTime(player.currentTime)

            if player.currentTime >= player.duration {
                self.nextTapped(self)
            }
        }
    }

    func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

    @objc func sliderChanged() {
        guard let player = player else { return }
        player.currentTime = TimeInterval(progressSlider.value) * player.duration
        currentTimeLabel.text = formatTime(player.currentTime)
    }

    @IBAction func playPauseTapped(_ sender: Any) {
        guard let player = player else { return }

        if player.isPlaying {
            player.pause()
            playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        } else {
            player.play()
            playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
    }

    @IBAction func nextTapped(_ sender: Any) {
        currentIndex = (currentIndex + 1) % tracks.count
        loadTrack(index: currentIndex)
        playPauseTapped(self)
    }

    @IBAction func previousTapped(_ sender: Any) {
        currentIndex = (currentIndex - 1 + tracks.count) % tracks.count
        loadTrack(index: currentIndex)
        playPauseTapped(self)
    }
}

import UIKit
import AVFoundation

enum RepeatMode {
    case off
    case all
    case one
}

class ViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!

    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!

    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!

    private var player: AVAudioPlayer?
    private var timer: Timer?

    private var tracks: [Track] = []
    private var currentIndex: Int = 0 {
        didSet {
            if currentIndex < 0 { currentIndex = 0 }
            if currentIndex >= tracks.count { currentIndex = tracks.count - 1 }
        }
    }

    private var isPlaying: Bool = false {
        didSet {
            updatePlayPauseButton()
        }
    }

    private var isShuffleOn: Bool = false
    private var repeatMode: RepeatMode = .off

    private var shuffleOrder: [Int] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        loadTracks()
        prepareToPlay(index: currentIndex)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopTimer()
        player?.stop()
    }
    private func configureUI() {
        progressSlider.minimumValue = 0
        progressSlider.maximumValue = 1
        progressSlider.value = 0
        currentTimeLabel.text = "0:00"
        durationLabel.text = "0:00"

        coverImageView.layer.cornerRadius = 12
        coverImageView.clipsToBounds = true

        prevButton.setImage(UIImage(systemName: "backward.fill"), for: .normal)
        playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        nextButton.setImage(UIImage(systemName: "forward.fill"), for: .normal)
    }

    private func loadTracks() {
        tracks = [
            Track(
                title: "Where Have You Been",
                artist: "Rihanna",
                coverImageName: "cover1",
                audioFileName: "Rihanna - Where Have You Been.mp3"
            ),
            Track(
                title: "Umbrella (Orange Version)",
                artist: "Rihanna ft. JAY-Z",
                coverImageName: "cover2",
                audioFileName: "Rihanna - Umbrella (Orange Version) (Official Music Video) ft. JAY-Z.mp3"
            ),
            Track(
                title: "Take A Bow",
                artist: "Rihanna",
                coverImageName: "cover3",
                audioFileName: "Rihanna - Take A Bow.mp3"
            ),
            Track(
                title: "Love On The Brain",
                artist: "Rihanna",
                coverImageName: "cover4",
                audioFileName: "Rihanna - Love On The Brain.mp3"
            ),
            Track(
                title: "Don't Stop The Music",
                artist: "Rihanna",
                coverImageName: "cover5",
                audioFileName: "Rihanna - Don't Stop The Music.mp3"
            )
        ]

        shuffleOrder = Array(0..<tracks.count)
        currentIndex = 0
    }

    private func prepareToPlay(index: Int) {
        guard tracks.indices.contains(index) else { return }
        let track = tracks[index]

        titleLabel.text = track.title
        artistLabel.text = track.artist
        coverImageView.image = UIImage(named: track.coverImageName)


        if let url = Bundle.main.url(forResource: track.fileNameWithoutExtension, withExtension: track.fileExtension) {
            do {
                player = try AVAudioPlayer(contentsOf: url)
                player?.delegate = self
                player?.prepareToPlay()


                let duration = player?.duration ?? 0
                durationLabel.text = formatTime(duration)
                progressSlider.minimumValue = 0
                progressSlider.maximumValue = Float(duration)
                progressSlider.value = 0
                currentTimeLabel.text = "0:00"
            } catch {
                print("Audio player error: \(error)")
                player = nil
                durationLabel.text = "0:00"
            }
        } else {
            print("Audio file not found: \(track.audioFileName)")
            player = nil
            durationLabel.text = "0:00"
        }

        // update play/pause UI
        isPlaying = false
        stopTimer()
    }

    private func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            self?.updateProgress()
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func updateProgress() {
        guard let player = player else { return }
        progressSlider.value = Float(player.currentTime)
        currentTimeLabel.text = formatTime(player.currentTime)
    }

    private func formatTime(_ time: TimeInterval) -> String {
        let totalSeconds = Int(round(time))
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

    // MARK: - Actions
    @IBAction func prevTapped(_ sender: UIButton) {
        navigateToPrevious()
    }

    @IBAction func playPauseTapped(_ sender: UIButton) {
        togglePlayPause()
    }

    @IBAction func nextTapped(_ sender: UIButton) {
        navigateToNext()
    }

    @IBAction func sliderValueChanged(_ sender: UISlider) {
        guard let player = player else { return }
        player.currentTime = TimeInterval(sender.value)
        currentTimeLabel.text = formatTime(player.currentTime)
    }

    @IBAction func sliderTouchUp(_ sender: UISlider) {
        // if we moved slider, continue playing if was playing
        if isPlaying {
            player?.play()
        }
    }

    // MARK: - Playback controls
    private func togglePlayPause() {
        guard let player = player else {
            // If no player loaded, try to prepare current track
            prepareToPlay(index: currentIndex)
            return
        }

        if player.isPlaying {
            player.pause()
            isPlaying = false
            stopTimer()
        } else {
            player.play()
            isPlaying = true
            startTimer()
        }
    }

    private func updatePlayPauseButton() {
        let imageName = isPlaying ? "pause.fill" : "play.fill"
        playPauseButton.setImage(UIImage(systemName: imageName), for: .normal)
    }

    private func navigateToPrevious() {
        // if repeat one -> restart
        if repeatMode == .one {
            player?.currentTime = 0
            player?.play()
            isPlaying = true
            startTimer()
            return
        }

        if isShuffleOn {
            // pick previous in shuffleOrder (find current index pos)
            if let pos = shuffleOrder.firstIndex(of: currentIndex), pos > 0 {
                currentIndex = shuffleOrder[pos - 1]
            } else {
                currentIndex = shuffleOrder.last ?? currentIndex
            }
        } else {
            let prev = currentIndex - 1
            if prev < 0 {
                if repeatMode == .all {
                    currentIndex = tracks.count - 1
                } else {
                    currentIndex = 0
                    // restart current track
                }
            } else {
                currentIndex = prev
            }
        }

        prepareToPlay(index: currentIndex)
        player?.play()
        isPlaying = true
        startTimer()
    }

    private func navigateToNext() {
        // if repeat one -> restart same
        if repeatMode == .one {
            player?.currentTime = 0
            player?.play()
            isPlaying = true
            startTimer()
            return
        }

        if isShuffleOn {
            if let pos = shuffleOrder.firstIndex(of: currentIndex) {
                let nextPos = (pos + 1) % shuffleOrder.count
                currentIndex = shuffleOrder[nextPos]
            } else {
                currentIndex = shuffleOrder.first ?? currentIndex
            }
        } else {
            let next = currentIndex + 1
            if next >= tracks.count {
                if repeatMode == .all {
                    currentIndex = 0
                } else {
                    // reached end, stop playback
                    currentIndex = tracks.count - 1
                    player?.stop()
                    isPlaying = false
                    stopTimer()
                    updatePlayPauseButton()
                    return
                }
            } else {
                currentIndex = next
            }
        }

        prepareToPlay(index: currentIndex)
        player?.play()
        isPlaying = true
        startTimer()
    }

    // MARK: - Shuffle & Repeat helpers (can be wired to UI if desired)
    private func toggleShuffle() {
        isShuffleOn.toggle()
        if isShuffleOn {
            shuffleOrder = Array(0..<tracks.count).shuffled()
            // ensure currentIndex stays consistent
            if !shuffleOrder.contains(currentIndex) {
                shuffleOrder[0] = currentIndex
            }
        } else {
            shuffleOrder = Array(0..<tracks.count)
        }
    }

    private func cycleRepeatMode() {
        switch repeatMode {
        case .off:
            repeatMode = .all
        case .all:
            repeatMode = .one
        case .one:
            repeatMode = .off
        }
    }
}

// MARK: - AVAudioPlayerDelegate
extension ViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        // when track finishes, go to next (respecting repeat/shuffle)
        if repeatMode == .one {
            player.currentTime = 0
            player.play()
            isPlaying = true
            startTimer()
            return
        }

        // auto-next
        if isShuffleOn {
            navigateToNext()
        } else {
            if currentIndex + 1 < tracks.count {
                currentIndex += 1
                prepareToPlay(index: currentIndex)
                self.player?.play()
                isPlaying = true
                startTimer()
            } else {
                // end of playlist
                if repeatMode == .all {
                    currentIndex = 0
                    prepareToPlay(index: currentIndex)
                    self.player?.play()
                    isPlaying = true
                    startTimer()
                } else {
                    isPlaying = false
                    stopTimer()
                    updatePlayPauseButton()
                }
            }
        }
    }
}

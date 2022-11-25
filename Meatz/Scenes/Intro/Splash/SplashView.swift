//
//  SplashView.swift
//  Meatz
//
//

import UIKit
import AVKit
import AVFoundation

class SplashView: UIViewController {

    @IBOutlet weak var videoView: UIView!
    var player: AVPlayer?
    weak var coordinator : IntroCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupVideo()
        NotificationCenter.default.addObserver(self, selector: #selector(playerEndPlay), name: .AVPlayerItemDidPlayToEndTime, object: nil)

    }
    
    private func setupVideo(){
        player = AVPlayer()
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.videoView.bounds
        playerLayer.videoGravity = .resizeAspectFill
        videoView.layer.addSublayer(playerLayer)
        guard let filePath = Bundle.main.path(forResource: "splash", ofType: ".mp4") else { return }
        let videoURL = URL(fileURLWithPath: filePath)
        let playerItem = AVPlayerItem(url: videoURL)
        player?.replaceCurrentItem(with: playerItem)
        player?.play()
    }
    
    @objc func playerEndPlay() {
        let isFirstTime = CachingManager.shared.isFirstTime
        if isFirstTime{
            coordinator?.navigateTo(IntroDestination.lang)
        }else{
            coordinator?.navigateTo(IntroDestination.ads)
        }
       }
}

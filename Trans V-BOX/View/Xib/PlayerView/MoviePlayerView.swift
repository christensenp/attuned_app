
//
//  MoviePlayerView.swift
//  Trans V-BOX
//
//  Created by Gourav on 25/05/20.
//  Copyright © 2020 Trans V-BOX. All rights reserved.
//

import UIKit
import AVKit

protocol MoviePlayerViewDelegate: class {
    func moviePlayer(player: MoviePlayerView, clickFillScreen: Bool)
    func reset(player: MoviePlayerView)
}

class MoviePlayerView: UIView {
    
    @IBOutlet weak var videoControls: UIView!
    @IBOutlet weak var videoCurrentTimeLabel: UILabel!
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var fullScreenButton: UIButton!
    @IBOutlet weak var videoEndTimeLabel: UILabel!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var backwardButton: UIButton!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var tabGestrueView: UIView!
    @IBOutlet weak var playButtonControl: UIControl!
    
    @IBOutlet weak var playLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    var videoTime: Double = 47
    var timer: Timer?
    var videoURL: URL!
    var lessonContent: LessonContent!
    var videoStatus: VideoStatus = .finished
    var isFeedback: Bool = false
    weak var delegate: MoviePlayerViewDelegate?
    class func instanceFromNib() -> MoviePlayerView {
        return UINib(nibName: "MoviePlayerView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MoviePlayerView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        closeButton.isHidden = true
        activityIndicatorView.isHidden = true
        tabGestrueView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(videoViewTapGesture(_:))))
        slider.setThumbImage(UIImage(named: "Oval"), for: .normal)
        videoCurrentTimeLabel.text = Double(0).format()
        slider.maximumValue = Float(videoTime)
    }
    
    override func layoutSubviews() {
        if self.playerLayer != nil {
            self.playerLayer.frame = self.layer.bounds
        }
    }
    
    func setUp() {
        player = AVPlayer(url: videoURL!)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = videoView.bounds
        playerLayer.videoGravity = .resizeAspectFill
        videoView.layer.addSublayer(playerLayer)
        videoControls.alpha = 0.0
        self.setUpVideoControls()
        self.videoEndTimeLabel.text = String(format:"-%@", self.videoTime.format())
        self.slider.maximumValue = Float(self.videoTime)
        if UserDefaults.standard.bool(forKey: "\(lessonContent.id)_finished") || isFeedback {
            self.resetState()
        }
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        if !UserDefaults.standard.bool(forKey: "\(lessonContent.id)_finished") {
            let value = UserDefaults.standard.float(forKey: lessonContent.id)
            if sender.value <= value {
                self.seekToTime(value: sender.value)
            }
        }  else {
            self.seekToTime(value: sender.value)
        }
    }
    
    func seekToTime(value: Float) {
        if let _ = player.currentItem?.duration {
            let value = Float64(value)
            let seekTime = CMTime(value: Int64(value), timescale: 1)
            player.seek(to: seekTime)
            slider.value = Float(value)
        }
    }
    
    @objc func videoViewTapGesture(_ sender: UITapGestureRecognizer) {
        if playButtonControl.isHidden {
            if self.videoControls.alpha == 0 {
                self.hideAndShowView()
            } else {
                self.videoControls.fadeOut()
            }
        }
    }
    
    @IBAction func backwardButtonAction(_ sender: Any) {
        var newValue = slider.value - 15
        newValue = newValue < 0 ? 0 : newValue
        self.seekToTime(value: newValue)
    }
    
    @IBAction func playPauseButtonAction(_ sender: Any) {
        if playPauseButton.isSelected {
            player.pause()
            videoStatus = .pause
            playPauseButton.isSelected = false
        } else {
            if let isFinished = self.lessonContent.isFinished, isFinished {
                player.seek(to: CMTime.zero)
            }
            self.lessonContent.isFinished = false
            if !UserDefaults.standard.bool(forKey: "\(lessonContent.id)_finished") {
                let value = UserDefaults.standard.float(forKey: lessonContent.id)
                self.seekToTime(value: value)
            }
            playPauseButton.isSelected = true
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback)
            } catch(let error) {
                print(error.localizedDescription)
            }
            player.play()
            videoStatus = .playing
            playButtonControl.isHidden = true
            self.hideAndShowView()
        }
    }
    
    @IBAction func forwardButtonAction(_ sender: Any) {
        var newValue = slider.value + 15
        //newValue = newValue > Float(videoTime) ? Float(videoTime) : newValue
        if !UserDefaults.standard.bool(forKey: "\(lessonContent.id)_finished") {
            let value = UserDefaults.standard.float(forKey: lessonContent.id)
            if newValue <= value {
                self.seekToTime(value: newValue)
            }
        } else if newValue <= Float(videoTime) {
            self.seekToTime(value: newValue)
        }
    }
    
    @IBAction func fullScreenButtonAction(_ sender: Any) {
        closeButton.isHidden = false
        fullScreenButton.isHidden = true
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.landscapeLeft, andRotateTo: UIInterfaceOrientation.landscapeRight)
        self.delegate?.moviePlayer(player: self, clickFillScreen: true)
        playerLayer.videoGravity = .resize
    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
        closeButton.isHidden = true
        fullScreenButton.isHidden = false
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
        self.delegate?.moviePlayer(player: self, clickFillScreen: false)
        playerLayer.videoGravity = .resize
    }
    
    func setUpVideoControls() {
        self.player.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main, using: { [weak self] (time) in
            guard let self = self else {return}
            if self.player!.currentItem?.status == .readyToPlay {
                let currentTime = CMTimeGetSeconds(self.player!.currentTime())
                self.slider.value = Float(currentTime)
                let value = UserDefaults.standard.float(forKey: self.lessonContent.id)
                if Float(currentTime) >= value {
                    UserDefaults.standard.set(Float(currentTime), forKey: self.lessonContent.id)
                }
                let secs = Double(currentTime)
                self.videoCurrentTimeLabel.text = secs.format()
                let leftTime = self.videoTime - secs
                self.videoEndTimeLabel.text = String(format:"-%@", leftTime.format())
            }
        })
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player.currentItem, queue: .main) { [weak self] _ in
            guard let self = self else {return}
            self.resetState()
        }
        
        self.player?.addObserver(self, forKeyPath: "timeControlStatus", options: [.old, .new], context: nil)
    }
    
    func resetState() {
        self.playButtonControl.isHidden = false
        self.playButton.setImage(UIImage(named: "replay"), for: .normal)
        self.playLabel.text = StringConstants.replay
        self.playPauseButton.isSelected = false
        self.lessonContent.isFinished = true
        UserDefaults.standard.set(true, forKey: "\(lessonContent.id)_finished")
        delegate?.reset(player: self)
    }
    
    func hideAndShowView() {
        videoControls.fadeIn()
        timer?.invalidate()
        timer = nil
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false, block: {[weak self] (t) in
            guard let self = self else {return}
            self.videoControls.fadeOut()
        })
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "timeControlStatus", let change = change, let newValue = change[NSKeyValueChangeKey.newKey] as? Int, let oldValue = change[NSKeyValueChangeKey.oldKey] as? Int {
            let oldStatus = AVPlayer.TimeControlStatus(rawValue: oldValue)
            let newStatus = AVPlayer.TimeControlStatus(rawValue: newValue)
            if newStatus != oldStatus {
                DispatchQueue.main.async {[weak self] in
                    guard let self = self else {return}
                    if newStatus == .playing || newStatus == .paused {
                        self.activityIndicatorView.isHidden = true
                        self.activityIndicatorView.stopAnimating()
                    } else {
                        self.activityIndicatorView.isHidden = false
                        self.activityIndicatorView.startAnimating()
                    }
                }
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("delloc VideoExerciseViewController")
    }
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}

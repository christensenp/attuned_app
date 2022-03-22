//
//  FullScreenVideoViewController.swift
//  Trans V-BOX
//
//  Created by Gourav on 26/03/20.
//  Copyright © 2020 Trans V-BOX. All rights reserved.
//

import UIKit
import AVKit

class FullScreenVideoViewController: BaseViewController {
    
    static var storyBoardId: String = ViewIdentifiers.FullScreenVideoViewController
    static var storyBoardName: String = Storyboard.lessions
    
    @IBOutlet weak var tapGestureView: UIView!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var videoControlsView: UIView!
    @IBOutlet weak var videoProgressSlider: UISlider!
    @IBOutlet weak var videoCurrentTimeLabel: UILabel!
    @IBOutlet weak var videoEndTimeLabel: UILabel!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var playPauseButtonAction: UIButton!
    @IBOutlet weak var backWardButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var dismissHandler: VideoStatusClosure!
    var progressClosure: ProgressClosure!
    var player: AVPlayer?
    var videoTime: Double = 0
    var contentId: String!
    var timer: Timer?
    var videoURL: URL!
    var seekTime: Float!
    var isFinished: Bool = false
    var playerLayer: AVPlayerLayer!
    var videoStatus: VideoStatus = .playing
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.isHidden = true
        videoControlsView.alpha = 0.0
        tapGestureView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(videoViewTapGesture(_:))))
        self.videoEndTimeLabel.text = String(format:"-%@", videoTime.format())
        videoCurrentTimeLabel.text = Double(0).format()
        videoProgressSlider.maximumValue = Float(videoTime)
        videoProgressSlider.setThumbImage(UIImage(named: "Oval"), for: .normal)
        videoView.updateConstraintsIfNeeded()
        self.view.layoutIfNeeded()
        player = AVPlayer(url: videoURL)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = videoView.bounds
        videoView.layer.addSublayer(playerLayer)
        playPauseButtonAction.isSelected = false
        if videoStatus == . playing {
            playPauseButtonAction.isSelected = true
            player?.play()
        }
        self.setUpVideoControls()
        self.seekToTime(value: self.seekTime)
        
        // Do any additional setup after loading the view.
    }
    
    //    override func viewWillAppear(_ animated: Bool) {
    //
    //        super.viewWillAppear(animated)
    //        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.all, andRotateTo: UIInterfaceOrientation.portrait)
    //    }
    //
    //    override func viewWillDisappear(_ animated : Bool) {
    //        super.viewWillDisappear(animated)
    //        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
    //    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: {[weak self] in
            guard let self = self else {return}
            self.dismissHandler(self.videoStatus)
        })
    }
    
    func closure(progerss: @escaping ProgressClosure, dismiss: @escaping VideoStatusClosure) {
        self.progressClosure = progerss
        self.dismissHandler = dismiss
    }
    
    @IBAction func backWardButtonAction(_ sender: Any) {
        var newValue = videoProgressSlider.value - 15
        newValue = newValue < 0 ? 0 : newValue
        self.seekToTime(value: newValue)
    }

    @IBAction func playControlAction(_ sender: Any) {
        if playPauseButtonAction.isSelected {
            player?.pause()
            videoStatus = .pause
            playPauseButtonAction.isSelected = false
        } else {
            if isFinished {
                player?.seek(to: CMTime.zero)
            }
            player?.play()
            videoStatus = .playing
            playPauseButtonAction.isSelected = true
            self.hideAndShowView()
        }
    }
    
    @IBAction func forwardButtonAction(_ sender: Any) {
        var newValue = videoProgressSlider.value + 15
        newValue = newValue > Float(videoTime) ? Float(videoTime) : newValue
        if !UserDefaults.standard.bool(forKey: "\(String(describing: contentId))_finished") {
            let value = UserDefaults.standard.float(forKey: contentId)
            if newValue <= value {
                self.seekToTime(value: newValue)
            }
        } else {
            self.seekToTime(value: newValue)
        }
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        if !UserDefaults.standard.bool(forKey: "\(String(describing: contentId))_finished") {
            let value = UserDefaults.standard.float(forKey:contentId)
            if sender.value <= value {
                self.seekToTime(value: sender.value)
            }
        } else {
            self.seekToTime(value: sender.value)
        }
    }
    
    func seekToTime(value: Float) {
        if let _ = player?.currentItem?.duration {
            let value = Float64(value)
            let seekTime = CMTime(value: Int64(value), timescale: 1)
            player?.seek(to: seekTime)
        }
    }
    
    @objc func videoViewTapGesture(_ sender: UITapGestureRecognizer) {
        if self.videoControlsView.alpha == 0 {
            self.hideAndShowView()
        } else {
            self.videoControlsView.fadeOut()
        }
    }
    
    func setUpVideoControls() {
        self.player?.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main, using: { [weak self] (time) in
            guard let self = self else {return}
            if self.player!.currentItem?.status == .readyToPlay {
                let currentTime = CMTimeGetSeconds(self.player!.currentTime())
                self.videoProgressSlider.value = Float(currentTime)
                let secs = Double(currentTime)
                self.progressClosure(Float(currentTime))
                self.videoCurrentTimeLabel.text = secs.format()
                let leftTime = self.videoTime - secs
                UserDefaults.standard.set(Float(currentTime), forKey: self.contentId)
                self.videoEndTimeLabel.text =  String(format:"-%@", leftTime.format())
                self.isFinished = (leftTime == self.videoTime)
            }
        })
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem, queue: .main) { [weak self] _ in
            guard let self = self else {return}
            self.videoStatus = .finished
            self.playPauseButtonAction.isSelected = false
        }
        self.player?.addObserver(self, forKeyPath: "timeControlStatus", options: [.old, .new], context: nil)
        
    }
    
    func hideAndShowView() {
        videoControlsView.fadeIn()
        closeButton.fadeIn()
        timer?.invalidate()
        timer = nil
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false, block: {[weak self] (t) in
            guard let self = self else {return}
            self.videoControlsView.fadeOut()
            self.closeButton.fadeOut()
        })
    }
    
    //    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    //       super.viewWillTransition(to: size, with: coordinator)
    //        coordinator.animate(alongsideTransition: { (context) in
    //        }) { (context) in
    //            self.playerLayer.frame = self.videoView.bounds
    //        }
    //    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "timeControlStatus", let change = change, let newValue = change[NSKeyValueChangeKey.newKey] as? Int, let oldValue = change[NSKeyValueChangeKey.oldKey] as? Int {
            let oldStatus = AVPlayer.TimeControlStatus(rawValue: oldValue)
            let newStatus = AVPlayer.TimeControlStatus(rawValue: newValue)
            if newStatus != oldStatus {
                DispatchQueue.main.async {[weak self] in
                    guard let self = self else {return}
                    if newStatus == .playing || newStatus == .paused {
                        self.activityIndicator.isHidden = true
                        self.activityIndicator.stopAnimating()
                    } else {
                        self.activityIndicator.isHidden = false
                        self.activityIndicator.startAnimating()
                    }
                }
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("Oval")
    }
    
}

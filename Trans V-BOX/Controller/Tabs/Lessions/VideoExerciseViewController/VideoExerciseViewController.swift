//
//  VideoExerciseViewController.swift
//  Trans V-BOX
//
//  Created by Gourav on 25/03/20.
//  Copyright © 2020 Trans V-BOX. All rights reserved.
//

import UIKit
import AVKit

class VideoExerciseViewController: BaseViewController {
    
    static var storyBoardId: String = ViewIdentifiers.VideoExerciseViewController
    static var storyBoardName: String = Storyboard.lessions
    @IBOutlet weak var swipeToContinueLabel: UILabel!
    @IBOutlet weak var videoView: UIView!
    var isFeedback: Bool = false
    var handler: EmptyAction!
    var lessonContent: LessonContent!
    var videoURL: URL!
    var playerView =  MoviePlayerView.instanceFromNib()
    var pageViewController: ExercisePageViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        videoView.updateConstraintsIfNeeded()
        self.view.layoutIfNeeded()
        guard  let contentURL = lessonContent.contentURL, let url = URL(string: contentURL) else { return }
        self.videoURL = url
        playerView.videoURL = videoURL
        if let duration = lessonContent.duration?.value {
            playerView.videoTime = Double("\(duration)") ?? 0
        }
        playerView.isFeedback = isFeedback
        playerView.lessonContent = lessonContent
        playerView.delegate = self
        playerView.frame = videoView.bounds
        self.videoView.clipsToBounds = true
        self.videoView.addSubview(playerView)
        self.playerView.setUp()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.pauseVideo()
    }

    func pauseVideo() {
        playerView.playPauseButton.isSelected = false
        playerView.player.pause()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("delloc VideoExerciseViewController")
    }
    
}

extension VideoExerciseViewController: MoviePlayerViewDelegate {

    func moviePlayer(player: MoviePlayerView, clickFillScreen: Bool) {

        if clickFillScreen {
            let size = UIScreen.main.bounds.size
            player.removeFromSuperview()
            player.frame = CGRect.init(x: 0,
                                       y: 0,
                                       width: max(size.width, size.height),
                                       height: min(size.width, size.height))
            player.setNeedsLayout()
            pageViewController?.view.addSubview(player)
            pageViewController?.view.bringSubviewToFront(player)
        } else {
            player.removeFromSuperview()
            player.frame = videoView.bounds
            self.videoView.addSubview(player)
            player.setNeedsLayout()
        }
        (AppDelegate.sharedDelegate().window?.rootViewController as? TabBarViewController)?.tabBar.alpha = clickFillScreen ? 0.0 : 1.0
    }

    func reset(player: MoviePlayerView) {
        swipeToContinueLabel.isHidden = false
        self.handler()
    }

}

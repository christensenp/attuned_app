//
//  SplashViewController.swift
//  Trans V-BOX
//
//  Created by Mobikasa on 28/09/20.
//  Copyright © 2020 Trans V-BOX. All rights reserved.
//

import UIKit
import AVKit

class SplashViewController: BaseViewController {
    static var storyBoardId: String = ViewIdentifiers.splashViewController
    static var storyBoardName: String = Storyboard.main

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(videoDidEnd), name:
        NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)

        // Do any additional setup after loading the view.
        playVideo(from: "Splash.mp4")
    }
    
    private func playVideo(from file:String) {
        let file = file.components(separatedBy: ".")

        guard let path = Bundle.main.path(forResource: file[0], ofType:file[1]) else {
            debugPrint( "\(file.joined(separator: ".")) not found")
            return
        }
        let player = AVPlayer(url: URL(fileURLWithPath: path))

        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.bounds
        playerLayer.videoGravity = .resizeAspectFill
        self.view.layer.addSublayer(playerLayer)
        player.play()
    }
    
    @objc func videoDidEnd(notification: NSNotification) {
       print("video ended")
        AppRouter.shared.setInitials()
//        self.performSegue(withIdentifier: SegueIdentifiers.pushToAccessCodeScreen, sender: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

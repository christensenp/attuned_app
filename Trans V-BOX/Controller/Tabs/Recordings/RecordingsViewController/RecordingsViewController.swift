//
//  RecordingsViewController.swift
//  Trans V-BOX
//
//  Created by Mobikasa  on 19/03/20.
//  Copyright © 2020 Trans V-BOX. All rights reserved.
//

import UIKit
import SCLAlertView
import AVKit

class RecordingsViewController: BaseViewController {
    
    static var storyBoardId: String = ViewIdentifiers.RecordingsViewController
    static var storyBoardName: String = Storyboard.recordings
    
    var shouldShowSearchResults = false
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    let refreshControl = UIRefreshControl()
    var recordings = [Recordings]()
    var data = [Recordings]()
    var player: AVPlayer?
    @IBOutlet weak var warningLabel: UILabel!
    var playerItem: AVPlayerItem?
    var playItemIndex: Int = -1
    override func viewDidLoad() {
        super.viewDidLoad()
        warningLabel.isHidden = true
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.topItem?.title = NavigationTitle.myRecordings
        searchBar.delegate = self
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
        tableView.registerCell(RecordingsTableViewCell.cellIdentifier)
        self.showLoading()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getRecordings(isShowLoader: false)
        self.setUpNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        self.playItemIndex = -1
        self.deselectPreviousRecordings(playItemIndex: playItemIndex)
    }
    
    @objc func pullToRefresh() {
        self.refreshControl.endRefreshing()
        self.getRecordings()
    }
    
    func getRecordings(isShowLoader: Bool = true) {
        if isShowLoader {
            self.showLoading()
        }
        APIManager.shared.getRecordings { [weak self](response, status, error) -> (Void) in
            guard let self = self else {return}
            self.stopLoading()
            if let response = response as? UserRecordingsModel {
                self.data = response.data ?? []
                self.recordings = self.data
            } else {
                self.showWarningAlert(title: StringConstants.appName, message: error ?? "Main")
            }
            self.warningLabel.isHidden = !(self.recordings.count == 0)
            self.tableView.reloadData()
        }
    }
    
}

//MARK: - UITableView Delegate and DataSource Methods
extension RecordingsViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.RecordingsTableViewCell) as! RecordingsTableViewCell
        cell.setUp(model: recordings[indexPath.row], menuHandler: {[weak self] in
            guard let self = self else {return}
            self.openActionSheet(index: indexPath.row)
            }, playAudioHandler: { [weak self] in
                guard let self = self else {return}
                if !(self.recordings[indexPath.row].isPlaying ?? false) {
                    cell.playButton.isSelected = true
                    if self.playItemIndex != indexPath.row {
                        self.deselectPreviousRecordings(playItemIndex: indexPath.row)
                    }
                    self.playItemIndex = indexPath.row
                    self.recordings[indexPath.row].isPlaying = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: { [weak self] in
                        guard let self = self else { return }
                        self.playRecording(recordingURL: self.recordings[indexPath.row].recordingURL)
                    })
                } else {
                    cell.playButton.isSelected = false
                    self.recordings[indexPath.row].isPlaying = false
                    self.player?.pause()
                }
        })
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 100
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.pushRecordController(index: indexPath.row)
    }
    
    func openActionSheet(index: Int) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: StringConstants.rename, style: .default, handler: { [weak self](a) in
            guard let self = self else {return}
            self.updateRecordingName(index: index)
        }))
        actionSheet.addAction(UIAlertAction(title: StringConstants.share, style: .default, handler: { [weak self](a) in
            guard let self = self else {return}
            self.shareAudio(index: index)
        }))
        actionSheet.addAction(UIAlertAction(title: StringConstants.delete, style: .default, handler: { [weak self](a) in
            guard let self = self else {return}
            self.deleteUserRecording(index: index)
        }))
        actionSheet.addAction(UIAlertAction(title: StringConstants.cancel, style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }

    func shareAudio(index: Int) {
       self.showLoading()
        APIManager.shared.downloadAudioFile(audioURL: self.recordings[index].recordingURL ?? "") { [weak self] (response, status, error) -> (Void) in
            guard let self = self else {return}
            self.stopLoading()
            if let response = response as? URL {
                DispatchQueue.main.async {
                    let activityItems = [response as AnyObject]
                    let activityController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
                    activityController.popoverPresentationController?.sourceView = self.view
                    activityController.popoverPresentationController?.sourceRect = self.view.frame
                    self.present(activityController, animated: true, completion: nil)
                }
            }
        }
    }

    func pushRecordController(index: Int) {
        self.showLoading()
        APIManager.shared.downloadAudioFile(audioURL: self.recordings[index].recordingURL ?? "") { [weak self] (response, status, error) -> (Void) in
            guard let self = self else {return}
            self.stopLoading()
            if let response = response as? URL {
                DispatchQueue.main.async {
                    let controller = RecordVoiceViewController.instantiateFromStoryBoard()
                    controller.audioTask = self.recordings[index]
                    controller.recordingURL = response
                    controller.isPlayAudio = true
                    let root = UINavigationController(rootViewController: controller)
                    root.modalPresentationStyle = .fullScreen
                    self.present(root, animated: true , completion: nil)
                }
            }
        }
    }

    func deselectPreviousRecordings(playItemIndex: Int) {
        recordings.enumerated().forEach { (index, item) in
            item.isPlaying = false
            if index == playItemIndex {
                item.isPlaying = true
            }
        }
        player?.pause()
        playerItem = nil
        player = nil
        tableView.reloadData()
    }

    func playRecording(recordingURL: String?) {
        guard let recordingURL = recordingURL, let url = URL(string: recordingURL) else { return }
        if playerItem == nil {
            playerItem = AVPlayerItem(url: url)
            player = AVPlayer(playerItem: playerItem)
        }
        player?.volume = 1.0
        player?.play()
    }

    func setUpNotifications() {
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem, queue: .main) { [weak self] _ in
            guard let self = self else {return}
            self.playerItem = nil
            self.player = nil
            if self.playItemIndex != -1 {
                self.recordings[self.playItemIndex].isPlaying = false
            }
            self.playItemIndex = -1
            self.tableView.reloadData()
        }
    }
}

//MARK: - SearchBar Delegate Methods
extension RecordingsViewController:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.trim().isEmpty {
            self.recordings = self.data
        } else {
            let filteredArray = self.data.filter { $0.recordingName!.localizedCaseInsensitiveContains(searchText.trim()) }
            self.recordings = filteredArray
        }
        tableView.reloadData()
    }
}


extension RecordingsViewController {
    func updateRecordingName(index: Int) {
        self.showAlert(isUpdate: true, text: self.recordings[index].recordingName ?? "") { [weak self] (text, alert) in
            guard let self = self else {return}
            self.showLoading()
            let param = [APIKeys.recordingListId: self.recordings[index].id ?? "", APIKeys.recordingName: text]
            APIManager.shared.updateRecordingName(param: param) { [unowned self] (response, status, error) -> (Void) in
                self.stopLoading()
                if let response = response as? UserModel {
                    if String(describing: response.code.value) == StringConstants.successCode {
                        self.recordings[index].recordingName = text
                        self.tableView.reloadData()
                        (alert as? SaveRecordingViewController)?.dismiss(animated: true, completion: nil)
                    } else {
                        self.showWarningAlert(title: StringConstants.appName, message: response.message)
                    }
                } else {
                    self.showWarningAlert(title: StringConstants.appName, message: error ?? "")
                }
            }
        }
    }
    
    
    func deleteUserRecording(index: Int) {
        let message = "\(StringConstants.deleteMessage) \(self.recordings[index].recordingName ?? "")"
        self.showAlertYesOrNo(title: StringConstants.delete, message: message, completion: { [weak self] in
            guard let self = self else {return}
            self.showLoading()
            APIManager.shared.deleteUserRecording(recordListId: self.recordings[index].id ?? "") { [unowned self] (response, status, error) -> (Void) in
                self.stopLoading()
                if let response = response as? UserModel {
                    if String(describing: response.code.value) == StringConstants.successCode {
                        self.getRecordings(isShowLoader: false)
                    } else {
                        self.showWarningAlert(title: StringConstants.appName, message: response.message)
                    }
                } else {
                    self.showWarningAlert(title: StringConstants.appName, message: error ?? "")
                }
            }
        })
    }
    
}

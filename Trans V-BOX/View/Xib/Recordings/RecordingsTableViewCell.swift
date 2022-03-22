//
//  RecordingsTableViewCell.swift
//  Trans V-BOX
//
//  Created by Suraj on 4/2/20.
//  Copyright © 2020 Trans V-BOX. All rights reserved.
//

import UIKit

class RecordingsTableViewCell: UITableViewCell {

    static let cellIdentifier = CellIdentifiers.RecordingsTableViewCell
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var operationButton: UIButton!
    @IBOutlet weak var minFrequencyLabel: UILabel!
    @IBOutlet weak var maxFrequencyLabel: UILabel!
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var averageFrequencyLabel: UILabel!
    var menuHandler: EmptyAction!
    var playAudioHandler: EmptyAction!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUp(model: Recordings, menuHandler: @escaping EmptyAction, playAudioHandler: @escaping EmptyAction) {
        self.menuHandler = menuHandler
        self.playAudioHandler = playAudioHandler
        recordingLabel.text = model.recordingName ?? ""
        self.playButton.isSelected = model.isPlaying ?? false
        self.activityIndicatorView.isHidden = true
        self.activityIndicatorView.stopAnimating()
        if let isLoading = model.isLoading, isLoading {
            self.activityIndicatorView.isHidden = false
            self.activityIndicatorView.startAnimating()
        }
        if let frequency = model.avgFrequency?.value {
            averageFrequencyLabel.text = "\(String(describing: frequency)) Hz"
        }
        if let recordingURL = model.recordingURL, let audioURL = URL(string: recordingURL)  {
            let audioFileName = String(audioURL.lastPathComponent) as NSString
            var fileName = audioFileName.replacingOccurrences(of: ".wav", with: "")
            fileName = fileName.replacingOccurrences(of: ".aac", with: "")
            daysLabel.text = fileName.getAgoTime()
        }
       
        if let minFrequency = model.minFrequency?.value, let maxFrequency = model.maxFrequency?.value {
            minFrequencyLabel.text = "Min \(String(describing: minFrequency)) Hz"
            maxFrequencyLabel.text = "Max \(String(describing: maxFrequency)) Hz"
        } else {
            minFrequencyLabel.text = "Min 0 Hz"
            maxFrequencyLabel.text = "Max 0 Hz"
        }
        
    }
    
    @IBAction func menuButtonAction(_ sender: Any) {
        self.menuHandler()
    }
    @IBAction func playButtonAction(_ sender: Any) {
        playAudioHandler()
    }
    
}

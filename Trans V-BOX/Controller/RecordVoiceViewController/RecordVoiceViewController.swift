//
//  RecordVoiceViewController.swift
//  Trans V-BOX
//
//  Created by Suraj on 4/2/20.
//  Copyright © 2020 Trans V-BOX. All rights reserved.
//

import UIKit
import Accelerate
import AVFoundation
import AudioKit
import AudioKitUI
import Pitchy
protocol RecorderViewControllerDelegate: class {
    func didStartRecording()
    func didFinishRecording()
}

let keyID = "key"

class RecordVoiceViewController: BaseViewController {
    
    static var storyBoardId: String = ViewIdentifiers.RecordVoiceViewController
    static var storyBoardName: String = Storyboard.voiceTracker
    
    @IBOutlet weak var textViewHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var audioViewheightConstant: NSLayoutConstraint!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var painoView: UIView!
    var audioView = AudioVisualizerView()
    @IBOutlet weak var recordButton: RecordButton!
    var recordingTask: RecordingTask!
    var audioTask: Recordings!
    private var renderTs: Double = 0
    private var recordingTs: Double = 0
    
    @IBOutlet weak var textView: UITextView!
    var trackedFrequency = [Double]()
    var samplesBufferSize: Int = 1024
    var tape: AKAudioFile?
    var isRecordingStart: Bool = false
    var handler: EmptyAction!
    var frequecys: [Double] = [87.307, 92.99, 97.999, 103, 110.00, 116.54, 123.47, 130.81, 138.59, 146.83, 155.56, 164.81, 174.61, 185.00, 196.00, 207.65, 220.00, 233.18, 246.94, 261.63, 277.18, 293.67, 311.13, 329.63, 616.295]
    let paino = PainoView.instanceFromNib()
    //Play Audio
    var isPlayAudio: Bool = false
    var recordingURL: URL?
    var isRecordingHandler: CompletionWithStatus?
    weak var delegate: PainoViewDelegate?
    var pitchEngine: PitchEngine?
    override func viewDidLoad() {
        super.viewDidLoad()
        if isPlayAudio {
            textView.attributedText = self.getText(text: audioTask.recordingContent ?? "")
            self.setUpPaino(genderFrequencyData: audioTask?.genderFrequencyData, gender: audioTask?.gender)
            timeLabel.text = StringConstants.tapToPlayRecording
        } else {
            timeLabel.text = StringConstants.tapToStartRecording
            textView.attributedText = self.getText(text: recordingTask.content ?? "")
            self.setUpPaino(genderFrequencyData: recordingTask?.genderFrequencyData, gender: recordingTask?.gender)
        }
        textView.flashScrollIndicators()
        self.painoView.updateConstraints()
        self.painoView.layoutIfNeeded()
        paino.frame = self.painoView.bounds
        paino.freqs = frequecys
        paino.delegate = self
        self.painoView.addSubview(paino)
        self.paino.setKeysWidth()
        self.setupAudioView()
        self.setRightBarButtonItem(imageName: "wrong")
    }

    func setUpPaino(genderFrequencyData: [GenderFrequencyData]?, gender: String?) {
        guard let genderFrequencyData = genderFrequencyData, let gender = gender else { return }
        if genderFrequencyData.count > 0 {
            var genderIndex = 0
            if let index = genderFrequencyData.firstIndex(where: {$0.gender == gender}) {
                genderIndex = index
            }
            if let idealMinFrequency = genderFrequencyData[genderIndex].idealMinFrequency?.value, let idealMaxFrequency = genderFrequencyData[genderIndex].idealMaxFrequency?.value {
                paino.idealMinFrequency = Double("\(idealMinFrequency)") ?? 0
                paino.idealMaxFrequency = Double("\(idealMaxFrequency)") ?? 0
            }
        }
    }
    
    func getText(text: String) -> NSAttributedString {
        let attributedStr = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1
        paragraphStyle.lineHeightMultiple = 1
        paragraphStyle.alignment = .center
        attributedStr.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range:NSMakeRange(0, attributedStr.length))
        attributedStr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.colorWithRGB(r: 40, g: 50, b: 68), range:NSMakeRange(0, attributedStr.length))
        attributedStr.addAttribute(NSAttributedString.Key.font, value: UIFont(name:Font.YuGothicMedium , size: 20)!, range: NSMakeRange(0, attributedStr.length))
        return attributedStr
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.paino.audioEngine.start()
//        let notificationName = AVAudioSession.interruptionNotification
//        NotificationCenter.default.addObserver(self, selector: #selector(handleRecording(_:)), name: notificationName, object: nil)
    }

    
    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.persistantScrollBar()
    }

    func persistantScrollBar() {
        textView.setNeedsLayout()
        textView.layoutIfNeeded()
        if self.textView.contentSize.height > self.textView.frame.size.height + 10 {
            textView.enableCustomScrollIndicators(with: .classic, positions: .verticalScrollIndicatorPositionRight, color: UIColor.colorWithRGB(r: 205, g: 218, b: 235))
            textView.refreshCustomScrollIndicators(withAlpha: 1.0)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.stopRecording(true)
        //self.paino.audioEngine.stop()
        NotificationCenter.default.removeObserver(self)
    }
    
    override func rightButtonAction(_ sender: Any) {
        self.stopRecording()
        self.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func setupAudioView() {
        audioView.frame = CGRect(x: 0, y: 24, width: view.frame.width, height: 80)
        view.addSubview(audioView)
        audioView.clipsToBounds = true
        audioView.layer.masksToBounds = true
        audioView.translatesAutoresizingMaskIntoConstraints = false
        audioView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -4).isActive = true
        audioView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 4).isActive = true
        audioView.heightAnchor.constraint(equalToConstant: 85).isActive = true
        audioView.bottomAnchor.constraint(equalTo: self.timeLabel.topAnchor , constant: -10).isActive = true
        audioView.isHidden = true
    }
    
    //MARK:- Actions
    @IBAction func handleRecording(_ sender: RecordButton) {
        if recordButton.isRecording {
            self.audioView.isHidden = false
            recordButton.isEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.recordButton.isEnabled = true
            }
            self.checkPermissionAndRecord()
        } else {
            self.audioView.isHidden = true
            self.stopRecording()
        }
        lineView.isHidden = !audioView.isHidden
    }
    
    //MARK:- Update User Interface
    private func updateUI(_ recorderState: RecorderState) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            switch recorderState {
            case .recording:
                UIApplication.shared.isIdleTimerDisabled = true
                self.audioView.isHidden = false
                break
            case .stopped:
                UIApplication.shared.isIdleTimerDisabled = false
                self.audioView.isHidden = true
                self.timeLabel.text = (self.isPlayAudio ? StringConstants.tapToPlayRecording : StringConstants.tapToStartRecording)
                break
            case .denied:
                UIApplication.shared.isIdleTimerDisabled = false
                self.recordButton.isHidden = true
                self.audioView.isHidden = true
                self.timeLabel.text = (self.isPlayAudio ? StringConstants.tapToPlayRecording : StringConstants.tapToStartRecording)
                break
            }
            self.lineView.isHidden = !self.audioView.isHidden
        }

    }
    
    
    func start() {
        self.recordingTs = NSDate().timeIntervalSince1970
        if !isPlayAudio {
            let config = Config(estimationStrategy: .yin)
            pitchEngine = PitchEngine(config: config, delegate: self)
            pitchEngine?.levelThreshold = -145.223
            paino.isRecording = true
            if let active = pitchEngine?.active, !active {
                pitchEngine?.start()
            }
            self.updateUI(.recording)
        } else {
            if let recordingURL = recordingURL {
                let config = Config(estimationStrategy: .yin, audioUrl: recordingURL)
                pitchEngine = PitchEngine(config: config, delegate: self)
                pitchEngine?.levelThreshold = -145.223
                paino.isRecording = true
                if let active = pitchEngine?.active, !active {
                    pitchEngine?.start()
                }
            }
        }
    }

    func signalTracker(freq: Double){
        var frequency = freq
        if audioView.active {
            while (frequency > frequecys[frequecys.count-1]) {
                frequency = frequency / 2.0
            }
            while(frequency < frequecys[0]) {
                frequency = frequency * 2.0
            }
            var minDistance : Float = 10000.0
            var index = 0
            for i in 0..<frequecys.count {
                let distance = fabsf(Float(frequecys[i]) - Float(frequency))
                if (distance < minDistance) {
                    index = i
                    minDistance = distance
                }
            }
            DispatchQueue.main.async {
                // self.trackedFrequency.append(frequency)
                self.paino.reloadData(index: index)
            }
            print(frequecys[index])
        }
    }
    
    private func stopRecording(_ isViewWillDisAppear: Bool = false) {
        if isPlayAudio {
            pitchEngine?.stop()
            pitchEngine = nil
        } else {
            if !isViewWillDisAppear {
                self.createPaino()
                handler()
            }
            pitchEngine?.stop()
            pitchEngine = nil
            if let isRecordingHandler = isRecordingHandler {
                isRecordingHandler(false)
            }
        }
        paino.isRecording = false
        DispatchQueue.main.async {
            self.paino.reloadData(index: -1)
        }
        recordButton.isRecording = false
        self.updateUI(.stopped)
    }
    
    private func checkPermissionAndRecord() {
        let permission = AVAudioSession.sharedInstance().recordPermission
        switch permission {
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission({ (result) in
                DispatchQueue.main.async {
                    if result {
                        self.start()
                    }
                    else {
                        self.updateUI(.denied)
                    }
                }
            })
            break
        case .granted:
            self.start()
            break
        case .denied:
            self.updateUI(.denied)
            break
        default:
            break
        }
    }
    
    private func isRecording() -> Bool {
        if let isRunning = self.pitchEngine?.active, isRunning {
            return true
        }
        return false
    }
    
    // MARK:- Handle interruption
    @objc func handleInterruption(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let key = userInfo[AVAudioSessionInterruptionTypeKey] as? NSNumber
            else { return }
        if key.intValue == 1 {
            DispatchQueue.main.async {
                if self.isRecording() {
                    self.stopRecording()
                }
            }
        }
    }
}

extension RecordVoiceViewController: PainoViewDelegate {
    func createPaino() {
        self.delegate?.createPaino()
    }

    func noteOn(note: UInt8, frequeny: Double) {
        self.delegate?.noteOn(note: note, frequeny: frequeny)
    }

    func noteOff(note: UInt8, frequeny: Double) {
        self.delegate?.noteOff(note: note, frequeny: frequeny)
    }

    func stopPaino() {
        self.delegate?.stopPaino()
    }
}

extension RecordVoiceViewController: PitchEngineDelegate {

    func pitchEngineDidFinished(audioFile: URL?) {
        if let audioFile = audioFile, let tape = try? AKAudioFile(forReading: audioFile) {
            self.tape = tape
        }
        if isPlayAudio {
            DispatchQueue.main.async {
                 self.stopRecording()
            }
        }
    }

    func pitchEngine(_ pitchEngine: PitchEngine, buffer: AVAudioPCMBuffer, time: AVAudioTime, didReceivePitch pitch: Pitch) {
        let offsetPercentage = pitch.closestOffset.percentage
        let absOffsetPercentage = abs(offsetPercentage)
        let level: Float = -50
        let length: UInt32 = UInt32(self.samplesBufferSize)
        buffer.frameLength = length
        let channels = UnsafeBufferPointer(start: buffer.floatChannelData, count: Int(buffer.format.channelCount))
        var value: Float = 0
        vDSP_meamgv(channels[0], 1, &value, vDSP_Length(length))
        var average: Float = ((value == 0) ? -100 : 20.0 * log10f(value))
        if average > 0 {
            average = 0
        } else if average < -100 {
            average = -100
        }
        let silent = average < level
        let ts = NSDate().timeIntervalSince1970
        if ts - self.renderTs > 0.1 {
            let floats = UnsafeBufferPointer(start: channels[0], count: Int(buffer.frameLength))
            let frame = floats.map({ (f) -> Int in
                return Int(f * Float(Int16.max))
            })
            DispatchQueue.main.async {
                let seconds = (ts - self.recordingTs)
                self.timeLabel.text = seconds.toTimeString
                self.renderTs = ts
                let len = self.audioView.waveforms.count
                for i in 0 ..< len {
                    let idx = ((frame.count - 1) * i) / len
                    let f: Float = sqrt(1.5 * abs(Float(frame[idx])) / Float(Int16.max))
                    self.audioView.waveforms[i] = min(49, Int(f * 50))
                }
                self.audioView.active = !silent
                self.audioView.setNeedsDisplay()
                if !self.isPlayAudio {
                    if let value = self.recordingTask.duration, Int(seconds) >= value {
                        self.stopRecording()
                    }
                }
            }
        }

        guard absOffsetPercentage > 1.0 else {
            return
        }
        if self.audioView.active {
            self.signalTracker(freq: pitch.frequency)
            print("pitch : \(pitch.note.string) - percentage : \(offsetPercentage)- frequency = \(pitch.frequency)")
            if pitch.frequency > 70 && pitch.frequency < 500 {
                trackedFrequency.append(pitch.frequency)
            }
        }
    }

    func pitchEngine(_ pitchEngine: PitchEngine, didReceiveError error: Error) {
        print(error)
    }

    public func pitchEngineWentBelowLevelThreshold(_ pitchEngine: PitchEngine) {
        print("Below level threshold")
    }
}
